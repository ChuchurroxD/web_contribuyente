USE [SG_Rentable]
GO
/****** Object:  StoredProcedure [dbo].[_Reci_Recibos]    Script Date: 10/12/2016 11:59:59 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[_Reci_Recibos]
	@persona varchar(9) = null,
	@junta varchar(6) = null,
	@via varchar(9) = null,
	@anio int = null,
	@mes1 tinyint = null,
	@mes2 tinyint = null,	
	@delete bit = 0, 
	@recibo int = null,
	@start int = null,
  @limi int = null,
	-- mensajes
	@mes tinyint = null,
	@TipoGrupo int =null,
		
	@tipoconsulta tinyint
as
set nocount on
begin
	declare @nro int
	-- listado de contribuyentes y emitidos por junta
	if @tipoconsulta = 1
		begin
				
				if object_id( 'tempdb..#contri') is not null drop table #contri;
				if object_id( 'tempdb..#rec') is not null drop table #rec;	
				if object_id( 'tempdb..#temp') is not null drop table #temp;	
				if object_id( 'tempdb..#ctacorr') is not null drop table #ctacorr;	
				
				select * into #ctacorr from CuentaCorriente where anio = @anio and mes between @mes1 and @mes2 and activo='1'

				select j.Sector_id, j.descripcion as junta, c.persona_id, sum(cargo-abono) as deuda, cc.anio, cc.mes into #contri
				from contribuyente c inner join #ctacorr cc on c.persona_id = cc.persona_id
				inner join tributos t on cc.tributo_id = t.tributos_id
				inner join junta_via jv on c.junta_via_id = jv.junta_via_id
				inner join Sector j on jv.junta_id = j.Sector_id 
				inner join GrupoImpresion gi on cc.tributo_ID=gi.tributo_ID and cc.anio=gi.periodo_ID
				where (jv.junta_id = @junta or @junta = '0'  )	and t.tipo_tributo in ('1','2') and cc.estado in ('p')
				and gi.grupoTipoImpresion=@TipoGrupo
				group  by j.Sector_id, j.descripcion, c.persona_id, cc.anio, cc.mes
				having sum(cargo-abono) > 0			
				
				select recibo_id, persona_id, anio, mes, monto into #rec
				from recibo where  anio = @anio and mes between @mes1 and @mes2 and estado <> 'a'
				
				select Sector_id, junta, c.persona_id, deuda, c.anio, c.mes, recibo_id, monto into #temp 
				from ( #contri c left join #rec r on ( c.persona_id = r.persona_id and c.anio = c.anio and c.mes = r.mes ) )		
			
				select Sector_id, junta, anio, mes, count(*) as total, sum(case when recibo_id is null then 0 else 1 end ) as emitidos,
				 (count(*)-sum(case when recibo_id is null then 0 else 1 end ) )as pendientes
				from #temp group by Sector_id, junta, anio, mes order by junta, anio, mes	
			
		end
	
	-- generar valores	 por junta
	if @tipoconsulta = 2
		begin		
				-- eliminar generados anteriormente
				if @delete = 1
				begin
					update recibo set estado = 'a' 
					from recibo r inner join contribuyente c on c.persona_id = r.persona_id 
					inner join junta_via jv on c.junta_via_id = jv.junta_via_id 
					inner join Sector j on j.Sector_id = jv.junta_id
					where ( j.Sector_id = @junta or @junta = '0' ) and r.anio = @anio and r.mes between @mes1 and @mes2				
				end
				-- numero correlativo de los recibos
				select @nro = isnull(max(nroRecibo),0) from recibo where anio = @anio
				
				-- temporal de recibos a generar
				select  (row_number() over  ( order by Sector_id, via, c_num, c_interior, c_mz, c_lote, c_edificio, 
				c_piso, c_dpto, c_tienda ))+@nro as numero,  Sector_id,  t.persona_id, deuda, t.anio, t.mes, nrorecibo, monto,grupoTipoImpresion,t.grupoImpresion_ID  into #temp2		
				from (
					select j.Sector_id, c.persona_id, sum(cargo-abono) as deuda, cc.anio, cc.mes, v.descripcion as via, c_num, c_interior,
					c_mz, c_lote, c_edificio, c_piso, c_dpto, c_tienda,GI.grupoTipoImpresion,gi.grupoImpresion_ID
					from contribuyente c inner join CuentaCorriente cc on c.persona_id = cc.persona_id
					inner join tributos t on cc.tributo_ID = t.tributos_id
					inner join junta_via jv on c.junta_via_id = jv.junta_via_id
					inner join Sector j on jv.junta_id = j.Sector_id 
					inner join via v on jv.via_id = v.via_id
					INNER JOIN GrupoImpresion GI ON CC.tributo_ID=GI.tributo_ID AND CC.anio=GI.periodo_ID
					where (jv.junta_id = @junta or @junta = '0' )	and cc.anio = @anio and cc.mes between @mes1 and 
					@mes2 and t.tipo_tributo in (1,2) and cc.estado in ('p') and cc.activo = '1'
					group  by j.Sector_id, c.persona_id, cc.anio, cc.mes, v.descripcion, c_num, c_interior,
					c_mz, c_lote, c_edificio, c_piso, c_dpto, c_tienda,GI.grupoTipoImpresion,gi.grupoImpresion_ID
					having sum(cargo-abono) > 0	
				) as t left join recibo r on ( t.persona_id = r.persona_id and t.anio = r.anio and t.mes = r.mes and r.estado <> 'a' )
				where nrorecibo is null


				--select * from tablas where descripcion like '%grupo%'
				--select * from tablas where dep_id=77
				--select * from GrupoImpresion

				
				--select * from #temp2
				 --insertar los recibos en batch
				insert into recibo ( nrorecibo, anio, mes, persona_id, monto, fecha_genera, fecha_vence, estado, mensaje_id,grupoImpresion_ID )
				select numero, t.anio, t.mes, t.persona_id, t.deuda, getdate() as fgenera, p.fecha_vence, 'p' as estado, mensaje_id ,t.grupoImpresion_ID
				from  #temp2 t  inner join parametro_mes p on (t.anio = p.periodo_id and t.mes = p.mes  and T.grupoTipoImpresion=p.tipo )
				left join mensajes m on ( t.anio = m.anio and t.mes = m.mes and m.estado = 1 )

			
				-- insertando los detalles de recibos
				insert into det_recibo (cuenta_corriente_id, recibo_id )
				select cuenta_corriente_id, recibo_id 
				from #temp2 t inner join recibo r on ( t.persona_id = r.persona_id and t.anio = r.anio and t.mes = r.mes )
				inner join CuentaCorriente c on ( t.persona_id = c.persona_id and t.anio = c.anio and t.mes = c.mes ) 
				INNER JOIN GrupoImpresion GI ON C.tributo_ID=GI.tributo_ID AND T.anio=GI.periodo_ID AND T.grupoTipoImpresion=GI.grupoTipoImpresion
				where c.estado in ('p') and c.activo = 1 
		
		end
	
	--delete det_recibo
	--delete recibo
	-- listado por contribuyente
	if @tipoconsulta = 3
		begin
			select c.persona_id, rtrim( paterno+' '+materno+' '+nombres) as nombres,  sum(cargo-abono) as deuda, anio, mes into #con
			from contribuyente c inner join CuentaCorriente cc on c.persona_id = cc.persona_id
			inner join persona p on c.persona_id = p.persona_id
			inner join tributos t on cc.tributo_id = t.tributos_id
			where c.persona_id = @persona  and cc.anio = @anio and cc.mes between @mes1 and @mes2
			and cc.estado in ('p') and cc.activo = '1'
			group by c.persona_id, anio, mes, paterno, materno, nombres
			having sum(cargo-abono) > 0	

			select c.persona_id, nombres, c.anio, c.mes, deuda, recibo_id, nrorecibo, monto,cast(nroRecibo as varchar)+'-'+cast(r.anio as varchar)as recibo
			from #con c inner join (
				select recibo_id, nrorecibo, persona_id, anio, mes, monto from recibo
				where persona_id = @persona and anio = @anio and mes between @mes1 and @mes2 and estado <> 'a'
			) as r on c.persona_id = r.persona_id and c.anio = r.anio  and c.mes = r.mes
		end
		
	-- anular un recibo
	if @tipoconsulta = 4
		begin
			update recibo set estado = 'a' where recibo_id = @recibo
		end
	
	-- generar recibo por contribuyente		
	if @tipoconsulta = 5
		begin		
				-- eliminar generados anteriormente
				if @delete = 1
				begin
					update recibo set estado = 'a'  	from recibo r where  r.persona_id = @persona  and r.anio = @anio and r.mes between @mes1 and @mes2				
					--delete recibo  where persona_id = @persona  and anio = @anio and mes between @mes1 and @mes2				
				end
				
				-- numero correlativo de los recibos
				select @nro = isnull(max(nroRecibo),0) from recibo where anio = @anio
				
				-- temporal de recibos a generar
				select  (row_number() over  ( order by t.persona_id, t.anio, t.mes ))+@nro as numero,  t.persona_id, deuda,
				 t.anio, t.mes, nrorecibo, monto, grupoTipoImpresion  into #temp3		
				from (
					select c.persona_id, sum(cargo-abono) as deuda, cc.anio, cc.mes,grupoTipoImpresion
					from contribuyente c inner join CuentaCorriente cc on c.persona_id = cc.persona_id
					INNER JOIN GrupoImpresion GI ON CC.tributo_ID=GI.tributo_ID AND CC.anio=GI.periodo_ID
					where c.persona_id = @persona and cc.anio = @anio and cc.mes between @mes1 and @mes2 
					 and cc.estado in ('p') and cc.activo = '1'
					group  by c.persona_id, anio, mes, grupoTipoImpresion
					having sum(cargo-abono) > 0	
				) as t left join recibo r on ( t.persona_id = r.persona_id and t.anio = r.anio and t.mes = r.mes and r.estado <> 'a' )
				where nrorecibo is null
				
				-- insertar los recibos en batch
				insert into recibo ( nrorecibo, anio, mes, persona_id, monto, fecha_genera, fecha_vence, estado, mensaje_id )
				select numero, t.anio, t.mes, t.persona_id, t.deuda, getdate() as fgenera, p.fecha_vence, 'p' as estado, mensaje_id
				from  #temp3 t  inner join parametro_mes p on (t.anio = p.periodo_id and t.mes = p.mes  and p.tipo = T.grupoTipoImpresion )
				left join mensajes m on ( t.anio = m.anio and t.mes = m.mes and m.estado = 1 )
						

				-- insertando los detalles de recibos
				insert into det_recibo (cuenta_corriente_id, recibo_id )
				select cuenta_corriente_id, recibo_id 
				from #temp3 t inner join recibo r on ( t.persona_id = r.persona_id and t.anio = r.anio and t.mes = r.mes )
				inner join CuentaCorriente c on ( t.persona_id = c.persona_id and t.anio = c.anio and t.mes = c.mes ) 
				INNER JOIN GrupoImpresion GI ON C.tributo_ID=GI.tributo_ID AND T.anio=GI.periodo_ID AND T.grupoTipoImpresion=GI.grupoTipoImpresion
				where c.estado in ('p') and c.activo = '1'
		end
	
		
	-- listar recibos a imprimir
	if @tipoconsulta = 8	
		begin
			select recibo_id, nrorecibo, anio, mes , monto, r.persona_id, convert( char(10), fecha_vence, 103) as vence
			from recibo r inner join contribuyente c on r.persona_id = c.persona_id
			inner join junta_via jv on c.junta_via_id = jv.junta_via_id
			inner join Sector j on jv.junta_id = j.Sector_id
			inner join via v on jv.via_id = v.via_id
			where (j.Sector_id = @junta or @junta = '!!' ) and ( v.via_id = @via or @via = '!!' )
			 and ( r.persona_id = @persona or @persona = '!!' ) and r.anio = @anio and r.mes between @mes1 
			 and @mes2 and r.estado ='p'
			--order by j.junta_id, v.descripcion, c_num, c_interior, c_mz, c_lote, c_edificio, anio, mes
			order by  v.via_id, c_num, c_mz,c_lote, c_interior, c_edificio
			--order by  jv.via_id,c_mz, c_interior, c_num, c_lote, c_edificio asc

		end	
		

	if @tipoconsulta = 9
		begin
			
		select recibo_id,nrorecibo,convert( char(10), fecha_vence, 103) as vence,anio,mes,persona_id,monto,
		estado= CASE estado
         WHEN 'p' THEN 'Generado'
         WHEN 'c' THEN 'Cancelado'
		 WHEN 'a' THEN 'Anulado'
		 ELSE 'No Hay'
      END	
		from recibo where persona_id=@persona and mes between @mes1 and @mes2 and anio=@anio

		end	

	if @tipoconsulta=10
	begin

	select sum(cargo) as carg,monto,r.recibo_id,r.anio,r.mes,r.estado into #vall
	from recibo r inner join  det_recibo d on d.recibo_id=r.recibo_id
	inner join CuentaCorriente c 
	on c.cuenta_corriente_id=d.cuenta_corriente_id
	where r.estado!='c' 
	group by monto,r.recibo_id,r.anio,r.mes,r.estado having monto!= sum(cargo)
	update recibo set estado='a' from #vall v inner join recibo r on r.recibo_id=v.recibo_id
	end
	if @tipoconsulta = 11
		begin			
		select rtrim(razon_social)as razon_social,(case when sum(cargo-abono)>0 then '1'else '0'end)as deuda from Contribuyente c 
		inner join CuentaCorriente cc on c.persona_id=cc.persona_ID
		where c.persona_id=@persona and cc.estado='P' and anio=@anio and mes between @mes1 and @mes2
		group by razon_social
	end	
	if @tipoconsulta = 12
		begin			
		select recibo_id as codigo,p.razon_social as persona,monto   from recibo r 
		inner join contribuyente p on r.persona_id=p.persona_id
		where recibo_id=@recibo
	end
	if @tipoconsulta = 13
		select recibo_id,convert(varchar(10),nrorecibo) + '-'+ convert(varchar(5),anio) as Recibos ,anio,
		mes = case mes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo'
		when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
		when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre'
		when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
		,estado= CASE estado
         WHEN 'p' THEN 'Generado'
         WHEN 'c' THEN 'Cancelado'
		 WHEN 'a' THEN 'Anulado'
		 ELSE 'No Hay' end
		from recibo where persona_id=@persona and mes between @mes1 and @mes2 and anio=@anio
	if @tipoconsulta = 14
		begin
			select recibo_id, nrorecibo, anio, cast(mes as int)as mes , monto, r.persona_id, convert( char(10), fecha_vence, 103) as vence
			from recibo r inner join contribuyente c on r.persona_id = c.persona_id
			inner join junta_via jv on c.junta_via_id = jv.junta_via_id
			inner join Sector j on jv.junta_id = j.Sector_id
			inner join GrupoImpresion gi on r.grupoImpresion_ID=gi.grupoImpresion_ID
			where (j.Sector_id = @junta or @junta = '0' ) 
			 and r.anio = @anio and r.mes between @mes1 and @mes2 and r.estado ='p'
			 and gi.grupoTipoImpresion=@TipoGrupo 
			--order by j.junta_id, v.descripcion, c_num, c_interior, c_mz, c_lote, c_edificio, anio, mes
			order by  c_num, c_mz,c_lote, c_interior, c_edificio
			--order by  jv.via_id,c_mz, c_interior, c_num, c_lote, c_edificio asc

		end	
		if @tipoconsulta = 15
		begin
			select anio from recibo 
			where persona_id=@persona and estado='p' 
			group by anio
		end	
		if @tipoconsulta = 16
		begin
			select r.recibo_id as cod,r.nroRecibo as numero from recibo r
			where persona_id=@persona and estado='p' and anio=@anio
		end	
		if @tipoconsulta = 17
		begin
			select TOP 5 recibo_id, nrorecibo, anio, cast(mes as int)as mes , monto, r.persona_id, convert( char(10), fecha_vence, 103) as vence
			from recibo r inner join contribuyente c on r.persona_id = c.persona_id
			inner join junta_via jv on c.junta_via_id = jv.junta_via_id
			inner join Sector j on jv.junta_id = j.Sector_id
			inner join GrupoImpresion gi on r.grupoImpresion_ID=gi.grupoImpresion_ID
			where r.anio = @anio and r.mes = @mes1 and r.estado ='p'
			--order by j.junta_id, v.descripcion, c_num, c_interior, c_mz, c_lote, c_edificio, anio, mes
			order by  c_num, c_mz,c_lote, c_interior, c_edificio
			--order by  jv.via_id,c_mz, c_interior, c_num, c_lote, c_edificio asc

		end	
		if @tipoconsulta = 18
		begin
			select recibo_id,convert(varchar(10),nrorecibo) + '-'+ convert(varchar(5),anio) as Recibos ,anio,
			mes = case mes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo'
			when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
			when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre'
			when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
			,estado= CASE estado
				WHEN 'p' THEN 'Generado'
				WHEN 'c' THEN 'Cancelado'
				WHEN 'a' THEN 'Anulado'
				ELSE 'No Hay' end , mes as mesParam, nrorecibo as numeroRecibo
			from recibo where persona_id=@persona

		end	
end
--exec _Reci_Recibos @tipoconsulta=5,@anio=2016,@mes1=1,@mes2=12,@persona='11122'



--delete det_recibo
--delete recibo
--select * from recibo
--select * from CuentaCorriente where persona_ID=11060     and anio=2016
--select * from recibo where recibo_id=1518
--select * from recibo
--select * from Contribuyente
--where razon_social=''
--select * from Persona where persona_ID='2648     '
---exec _Reci_Recibos @tipoconsulta=11,@persona=1
--exec _Reci_Recibos @tipoconsulta=2,@junta='0',@anio=2000,@mes1=1,@mes2=12
--select * from recibo
--delete det_recibo
--delete recibo