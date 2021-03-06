USE [SG_Rentable]
GO
/****** Object:  StoredProcedure [dbo].[_frac_Fraccionamiento_Proceso]    Script Date: 27/11/2016 10:17:17 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[_frac_Fraccionamiento_Proceso]
@fraccionamiento_ID int=null
,@tipo int
,@persona_ID char(9)=null
,@anio_ini int=null
,@anio_fin int=null
,@mes_ini int=null
,@mes_fin int=null
,@tributo_ID int=null
,@idPeriodo int=null
,@Numero int=null
,@Deuda_Total decimal(12,2)=null
,@Inicial decimal(12,2)=null
,@Saldo decimal(12,2)=null
,@Descuento decimal(12,2)=null
,@Interes decimal(12,2)=null
,@Cuotas int =null
,@ValorCuota decimal(12,2)=null
,@Estado char(1)=null
,@tipo_fraccionamiento_ID int=null
,@NroCuota int=null
,@importe decimal(12,2)=null
,@amortizacion decimal(12,2)=null
,@periodo_ID int=null
,@nrConvenio int=null
,@fecha_inicio datetime = null
,@fecha_fin datetime = null
,@razon_social nvarchar(200) = null
,@cuotasVencidas int=null
,@via char(6)=null
,@sector int=null
,@nroConvenio int=null
as begin
DECLARE @tipo_trib char(03)
	if @tipo=1 
	begin
		select cc.persona_ID,cc.anio,
		sum(case when t.tipo_tributo='1' then cc.cargo-cc.abono else 0 end)as predial,
		sum(case when t.tipo_tributo='1' then (cast(round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)as decimal(12,2))) else 0 end)as predialI,
		sum(case when t.tipo_tributo='2' then cc.cargo-cc.abono else 0 end)as arbitrios,
		sum(case when t.tipo_tributo='2' then (cast(round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)as decimal(12,2))) else 0 end)as arbitriosI,
		sum(case when t.tipo_tributo='3' then cc.cargo-cc.abono else 0 end)as alcabala,
		sum(case when t.tipo_tributo='3' then (cast(round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)as decimal(12,2))) else 0 end)as alcabalaI,
		sum(case when t.tipo_tributo='4' then cc.cargo-cc.abono else 0 end)as multas,
		sum(case when t.tipo_tributo='4' then (cast(round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)as decimal(12,2))) else 0 end)as multasI,
		sum(case when t.tipo_tributo='5' then cc.cargo-cc.abono else 0 end)as fincas,
		sum(case when t.tipo_tributo='5' then (cast(round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)as decimal(12,2))) else 0 end)as fincasI,
		sum(case when t.tipo_tributo='6' then cc.cargo-cc.abono else 0 end)as alquileres,
		sum(case when t.tipo_tributo='6' then (cast(round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)as decimal(12,2))) else 0 end)as alquileresI,
		sum(case when t.tipo_tributo='7' then cc.cargo-cc.abono else 0 end)as tasas,
		sum(case when t.tipo_tributo='7' then (cast(round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)as decimal(12,2))) else 0 end)as tasasI,
		sum(cc.cargo-cc.abono+
		cast(round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)as decimal(12,2))
		)as total
		from CuentaCorriente cc inner join Tributos t on cc.tributo_ID=t.tributos_ID
		where persona_ID=@persona_ID and fecha_vence<getdate() and estado='P'and cc.activo=1
		group by cc.persona_ID,cc.anio
	end
	else if @tipo=2
	begin
		select tf.tipo_fraccionamiento_ID,tf.base_legal from TipoFraccionamiento tf
		where GETDATE() between tf.fecha_inicio and tf.fecha_fin
	end
	else if @tipo=3
	begin 
		SELECT isnull(sum(cargo-abono+(cast(round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)as decimal(12,2)))),0)as monto FROM CuentaCorriente CC
		inner join Tributos t on cc.tributo_ID=t.tributos_ID
		WHERE CC.persona_ID =@persona_ID AND CC.ESTADO='p'
		AND  CC.anio*100+CC.mes BETWEEN (@anio_ini*100+@mes_ini) AND (@anio_fin*100+@mes_fin)
		and t.tributos_ID=@tributo_ID
	end
	else if @tipo=4
	begin
		insert into fraccionamiento(idPeriodo,Numero,Fecha_Acogida,idPeriodoInicio,idPeriodoFin,anio_inicio,anio_fin,
		Deuda_Total,Inicial,Saldo,Descuento,Interes,Cuotas,ValorCuota,Estado,tipo_fraccionamiento_ID,
		Persona_id,registro_fecha_add,registro_user_add,registro_pc_add)
		values(datepart(yy,GETDATE()),(select isnull(max(numero),0)+1 from fraccionamiento fra where fra.idPeriodo=
		datepart(yy,getdate())),getdate(),@mes_ini,@mes_fin,@anio_ini,@anio_fin,@Deuda_Total,@Inicial,@Saldo,@Descuento,
		@Interes,@Cuotas,@ValorCuota,@Estado,@tipo_fraccionamiento_ID,@persona_ID,GETDATE(),'0','SGR-PC');
		select cast(@@IDENTITY as int)as ultimo		
	end
	else if @tipo=5
	begin
		insert into crono_fraccionamiento(Fraccionamiento_id,NroCuota,Importe,amortizacion,Interes,FechaVence)
		values(@fraccionamiento_ID,@NroCuota,@importe,@amortizacion,@Interes,GETDATE()+(30*@NroCuota))
		select cast(@@IDENTITY as int)as ultimo	
		
		select * from crono_fraccionamiento	
	end
	else if @tipo=6
	begin
		insert into det_fraccionamiento(Fraccionamiento_id,Monto,Interes,Cuenta_Corriente_id,tasa_interes,cobro_interes)
		(SELECT @fraccionamiento_ID,(cc.cargo-cc.abono),
		isnull((cast(round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)as decimal(12,2))),0)as monto,
		cc.cuenta_corriente_ID,isnull(dbo.interesLiquidacion(t.tipo_tributo),0),cobro_interes FROM CuentaCorriente CC
		inner join Tributos t on cc.tributo_ID=t.tributos_ID
		WHERE CC.persona_ID =@persona_ID AND CC.ESTADO='p'
		AND  CC.anio*100+CC.mes BETWEEN (@anio_ini*100+@mes_ini) AND (@anio_fin*100+@mes_fin)
		and t.tributos_ID=@tributo_ID)
	end
	else if @tipo=7
	begin
		select f.fraccionamiento_id, cast(f.Numero as varchar)+' - '+cast(f.idPeriodo as varchar)as codigo,tf.base_legal,
		cast(f.Fecha_Acogida as date)as fecha_acogida,
		f.Cuotas,f.Saldo,ta.descripcion as estado from fraccionamiento f
		inner join TipoFraccionamiento tf on f.tipo_fraccionamiento_ID=tf.tipo_fraccionamiento_ID
		inner join tablas ta on f.Estado=ta.valor
		where dep_id='39' and f.Persona_id=@persona_ID
	end
	else if @tipo=8
	begin
		select * from fraccionamiento where fraccionamiento_id=@fraccionamiento_ID
	end
	else if @tipo=9
	begin
		select Crono_Fraccionamiento_id,Fraccionamiento_id,NroCuota,Importe,amortizacion,Interes,
		cast(FechaVence as date)as FechaVence,cast(FechaPago as date)as FechaPago from crono_fraccionamiento where Fraccionamiento_id=@fraccionamiento_ID
	end
	else if @tipo=10
	begin
		select cc.anio,cc.mes,t.abrev as tributo,df.Monto+df.Interes as impuesto from  det_fraccionamiento df
		inner join CuentaCorriente cc on df.Cuenta_Corriente_id=cc.cuenta_corriente_ID
		inner join Tributos t on cc.tributo_ID=t.tributos_ID
		where df.Fraccionamiento_id=@fraccionamiento_ID 
	end
	else if @tipo=11
	begin
		select (cf.Importe + tfr.monto_derecho) as total,p.razon_social as persona,f.fraccionamiento_ID from fraccionamiento F
		inner join TipoFraccionamiento tfr on f.tipo_fraccionamiento_ID=tfr.tipo_fraccionamiento_ID
		INNER JOIN Contribuyente P ON F.Persona_id=P.persona_ID 
		INNER JOIN crono_fraccionamiento CF ON F.fraccionamiento_id=CF.Fraccionamiento_id
		where idperiodo=@periodo_ID AND Numero=@nrConvenio AND CF.NroCuota=@nroCuota
	end
	else if @tipo = 12
	select f.fraccionamiento_id,f.idPeriodo,f.Numero,f.Fecha_Acogida,f.idPeriodoInicio,f.idPeriodoFin,f.Deuda_Total,f.Inicial,f.Saldo,f.Descuento,f.Interes,
	f.Cuotas,f.ValorCuota,f.Estado,f.tipo_fraccionamiento_ID,f.Persona_id,tf.base_legal,p.razon_social,p.dniRepresentante,t.dep_id,t.descripcion,t.valor
	from fraccionamiento f inner join TipoFraccionamiento tf on f.tipo_fraccionamiento_ID = tf.tipo_fraccionamiento_ID
	inner join Contribuyente p on f.Persona_id = p.persona_ID
	cross join tablas t
	where t.dep_id = 48 and p.razon_social like '%'+@razon_social+'%' and f.tipo_fraccionamiento_ID = @tipo_fraccionamiento_ID and t.valor = @Estado and f.Fecha_Acogida between @fecha_inicio and @fecha_fin 
	else if @tipo=13 
		select f.fraccionamiento_id,(cast(f.idPeriodo as varchar)+'-'+cast(f.numero as varchar))as convenio,
		f.Persona_id,rtrim(c.razon_social)as razon_social,rtrim(s.Descripcion) as junta,rtrim(v.Descripcion) as via,
		cast(f.Fecha_Acogida as date)AS fecha_acogida,f.Saldo,f.Cuotas,f.ValorCuota,
		(select count(*)from crono_fraccionamiento cf where cf.fraccionamiento_id=f.fraccionamiento_id
		and cf.FechaVence<getdate())as cuotasVencidas,
		t.descripcion as estado from fraccionamiento f
		inner join Contribuyente c on f.Persona_id=c.persona_id
		inner join Junta_Via jv on c.junta_via_ID=jv.junta_via_ID
		inner join Sector s on jv.junta_ID=s.Sector_id
		inner join Via v on jv.via_ID=v.Via_id
		inner join tablas t on f.Estado=t.valor
		where t.dep_id='48' 
		and (f.Cuotas=@NroCuota or @NroCuota is null)
		and ((select count(*)from crono_fraccionamiento cf where cf.fraccionamiento_id=f.fraccionamiento_id
				and cf.FechaVence<getdate())=@cuotasVencidas or @cuotasVencidas is null)
		and (v.Via_id=@via or @via is null) 
		and (s.Sector_id=@sector or @sector is null)
		and razon_social like '%'+@razon_social+'%'
		and (f.Estado=@Estado or @Estado is null)
		and (f.tipo_fraccionamiento_ID =@tipo_fraccionamiento_ID or @tipo_fraccionamiento_ID is null)
		and (f.idPeriodo =@idPeriodo or @idPeriodo is null)
		and f.Fecha_Acogida between @fecha_inicio and @fecha_fin
	else if @tipo=14
		select f.fraccionamiento_id,rtrim(s.Descripcion) as junta,rtrim(v.Descripcion) as via,
		dbo._getMontoTotal(f.fraccionamiento_id) as total,dbo._getMontoPagado(f.fraccionamiento_id)as pagado,
		dbo._getMontoVencido(f.fraccionamiento_id)as vencido,dbo._getMontoAnulado(f.fraccionamiento_id)as anulado,
		dbo._getMontoPendiente(f.fraccionamiento_id)as pendiente
		from fraccionamiento f
		inner join Contribuyente c on f.Persona_id=c.persona_id
		inner join Junta_Via jv on c.junta_via_ID=jv.junta_via_ID
		inner join Sector s on jv.junta_ID=s.Sector_id
		inner join Via v on jv.via_ID=v.Via_id
		inner join tablas t on f.Estado=t.valor		
		where t.dep_id='48' 
		and (f.Cuotas=@NroCuota or @NroCuota is null)
		and ((select count(*)from crono_fraccionamiento cf where cf.fraccionamiento_id=f.fraccionamiento_id
				and cf.FechaVence<getdate())=@cuotasVencidas or @cuotasVencidas is null)
		and (v.Via_id=@via or @via is null) 
		and (s.Sector_id=@sector or @sector is null)
		and razon_social like '%'+@razon_social+'%'
		and (f.Estado=@Estado or @Estado is null)
		and (f.tipo_fraccionamiento_ID =@tipo_fraccionamiento_ID or @tipo_fraccionamiento_ID is null)
		and (f.idPeriodo =@idPeriodo or @idPeriodo is null)
		and f.Fecha_Acogida between @fecha_inicio and @fecha_fin
	ELSE IF @TIPO=15--validar cuota a pagar
	begin		
		if (select count(*) from fraccionamiento f 	where idPeriodo=@periodo_ID and Numero=@nroConvenio)>0
				select 1 as resultado;
		else 
				select 0 as resultado;
	end		
	else if @tipo=16
	begin
		select p.razon_social as persona,f.fraccionamiento_ID from fraccionamiento F
		inner join TipoFraccionamiento tfr on f.tipo_fraccionamiento_ID=tfr.tipo_fraccionamiento_ID
		INNER JOIN Contribuyente P ON F.Persona_id=P.persona_ID 
		where idperiodo=@periodo_ID AND Numero=@nrConvenio 
	end
	else if @tipo=17
	begin
		update fraccionamiento set Estado='T' where  fraccionamiento_id=@fraccionamiento_ID;
		update CuentaCorriente set estado='P' where estado!='F' and cuenta_corriente_ID in
		(select Cuenta_Corriente_id from det_fraccionamiento where Fraccionamiento_id=@fraccionamiento_ID)
	end
	else if @tipo=18
		select f.fraccionamiento_id,(cast(f.idPeriodo as varchar)+'-'+cast(f.numero as varchar))as convenio,
		f.Persona_id,rtrim(c.razon_social)as razon_social,rtrim(s.Descripcion) as junta,rtrim(v.Descripcion) as via,
		cast(f.Fecha_Acogida as date)AS fecha_acogida,f.Saldo,f.Cuotas,f.ValorCuota,
		(select count(*)from crono_fraccionamiento cf where cf.fraccionamiento_id=f.fraccionamiento_id
		and cf.FechaVence<getdate())as cuotasVencidas,
		t.descripcion as estado from fraccionamiento f
		inner join Contribuyente c on f.Persona_id=c.persona_id
		inner join Junta_Via jv on c.junta_via_ID=jv.junta_via_ID
		inner join Sector s on jv.junta_ID=s.Sector_id
		inner join Via v on jv.via_ID=v.Via_id
		inner join tablas t on f.Estado=t.valor
		where t.dep_id='48' and f.Estado='A'
		and (f.Cuotas=@NroCuota or @NroCuota is null)
		and ((select count(*)from crono_fraccionamiento cf where cf.fraccionamiento_id=f.fraccionamiento_id
				and cf.FechaVence<getdate())=@cuotasVencidas or @cuotasVencidas is null)
		and (v.Via_id=@via or @via is null) 
		and (s.Sector_id=@sector or @sector is null)
		and razon_social like '%'+@razon_social+'%'
		and (f.Estado=@Estado or @Estado is null)
		and (f.tipo_fraccionamiento_ID =@tipo_fraccionamiento_ID or @tipo_fraccionamiento_ID is null)
		and (f.idPeriodo =@idPeriodo or @idPeriodo is null)
		and f.Fecha_Acogida between @fecha_inicio and @fecha_fin

		else if @tipo = 19
		select f.fraccionamiento_id , tf.base_legal,f.Fecha_Acogida,
		case f.idPeriodoInicio 
		when 1 then 'ENE' when 2 then 'FEB' when 3 then 'MAR'
		when 4 then 'ABR' when 5 then 'MAY'	when 6 then 'JUN'
		when 7 then 'JUL' when 8 then 'AGO' when 9 then 'SET'
		when 10 then 'OCT' when 11 then 'NOV' when 12 then 'DIC' end
		+' '+convert(char(4),f.anio_inicio)+ '- '+
		case f.idPeriodoFin
		when 1 then 'ENE' when 2 then 'FEB' when 3 then 'MAR'
		when 4 then 'ABR' when 5 then 'MAY'	when 6 then 'JUN'
		when 7 then 'JUL' when 8 then 'AGO' when 9 then 'SET'
		when 10 then 'OCT' when 11 then 'NOV' when 12 then 'DIC' end
		+' '+ convert(char(4),f.anio_fin) as periodos,
		f.Deuda_Total,f.Inicial,f.Saldo,f.ValorCuota,f.Cuotas,t.descripcion as estado
		from fraccionamiento f
		inner join TipoFraccionamiento tf on f.tipo_fraccionamiento_ID = tf.tipo_fraccionamiento_ID
		inner join tablas t on f.Estado = t.valor
		where dep_id = 39 and Persona_id = @persona_ID
	else if @tipo = 20	-- falta saldo
		select f.Deuda_Total,f.Inicial,cf.fraccionamiento_id,cf.NroCuota,cf.Importe,cf.amortizacion,cf.Interes,
		cast(cf.FechaVence as date)as FechaVence,isnull(cast(cast(cf.FechaPago as date) as varchar(12)),'')as FechaPago,
		case when FechaPago is null then 'PENDIENTE' else 'PAGADO' end as estado,
		((f.Deuda_Total-f.Inicial )-(select isnull(sum(amortizacion),0) from crono_fraccionamiento cf1 
		where cf1.Fraccionamiento_id=cf.fraccionamiento_id
		and cf1.NroCuota<cf.NroCuota and cf1.NroCuota!=0)) 
		as saldo
		from crono_fraccionamiento cf 
		inner join fraccionamiento f on cf.Fraccionamiento_id = f.fraccionamiento_id
		where cf.Fraccionamiento_id=@fraccionamiento_ID and cf.NroCuota > 0
		group by f.Deuda_Total,f.Inicial,cf.Fraccionamiento_id,cf.NroCuota,cf.amortizacion,cf.Interes,cf.FechaVence,cf.FechaPago,cf.Importe,
		f.Deuda_Total
	else if @tipo = 21	
		select f.Inicial,f.Cuotas,tf.monto_derecho,f.Numero,cast(f.idPeriodo as int)idPeriodo ,tf.interes_compensa from fraccionamiento f inner join TipoFraccionamiento tf on f.tipo_fraccionamiento_ID=tf.tipo_fraccionamiento_ID
		where f.fraccionamiento_id=@fraccionamiento_ID
	else if @tipo = 22
		select f.fraccionamiento_id , tf.base_legal,f.Fecha_Acogida,
		case f.idPeriodoInicio 
		when 1 then 'ENE' when 2 then 'FEB' when 3 then 'MAR'
		when 4 then 'ABR' when 5 then 'MAY'	when 6 then 'JUN'
		when 7 then 'JUL' when 8 then 'AGO' when 9 then 'SET'
		when 10 then 'OCT' when 11 then 'NOV' when 12 then 'DIC' end
		+' '+convert(char(4),f.anio_inicio)+ '- '+
		case f.idPeriodoFin
		when 1 then 'ENE' when 2 then 'FEB' when 3 then 'MAR'
		when 4 then 'ABR' when 5 then 'MAY'	when 6 then 'JUN'
		when 7 then 'JUL' when 8 then 'AGO' when 9 then 'SET'
		when 10 then 'OCT' when 11 then 'NOV' when 12 then 'DIC' end
		+' '+ convert(char(4),f.anio_fin) as periodos,
		f.Deuda_Total,f.Inicial,f.Saldo,f.ValorCuota,f.Cuotas,t.descripcion as estado
		from fraccionamiento f
		inner join TipoFraccionamiento tf on f.tipo_fraccionamiento_ID = tf.tipo_fraccionamiento_ID
		inner join tablas t on f.Estado = t.valor
		where dep_id = 39 and f.fraccionamiento_id = @fraccionamiento_ID
	else if @tipo=23
	begin
		if (select  count(*) from crono_fraccionamiento where fraccionamiento_id=@fraccionamiento_ID and nroCuota=0
		and importe=0)>0
		begin 
			update CuentaCorriente set estado='F' where cuenta_corriente_ID in
			(select cuenta_corriente_ID from fraccionamiento f 
			inner join det_fraccionamiento df on f.fraccionamiento_id=df.Fraccionamiento_id
			where f.fraccionamiento_id=@fraccionamiento_ID);
			update fraccionamiento set Estado='A' where fraccionamiento_id=@fraccionamiento_ID
			update crono_fraccionamiento set FechaPago = GETDATE() where fraccionamiento_id=@fraccionamiento_ID
			 and NroCuota = 0
		end
	end
end
--exec _frac_Fraccionamiento_Proceso @tipo=23,@fraccionamiento_id=68
--select * from fraccionamiento
-- no estas llamando al procedimiento corrige eso arregla eso para que lo llame ya esta
-- pero si supuestamente si lo esta llamando.. 
--.. no se ps revisalo porque mira que ya lo ejecute y aca si lo hizo todo
--select  top 10 * from CuentaCorriente
--select * from fraccionamiento f
--select * from det_fraccionamiento
--select * from tablas where dep_id='39'
--select  * from CuentaCorriente where cuenta_corriente_ID in(
--select Cuenta_Corriente_id from det_fraccionamiento where Fraccionamiento_id=41)