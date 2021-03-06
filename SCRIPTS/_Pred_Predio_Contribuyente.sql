USE [SG_Rentable]
GO
/****** Object:  StoredProcedure [dbo].[_Pred_Predio_Contribuyente]    Script Date: 10/12/2016 11:38:06 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
--==========PROCEDIMIENTO PREDio_COntribuyenteUpdate ========================
--===========================================================================================
--===========================================================================================
ALTER PROCEDURE [dbo].[_Pred_Predio_Contribuyente]
             @predio_contribuyente_id    int=Null output,
             @idPeriodo    smallint=Null,
             @Fecha    datetime=Null,
             @Porcentaje_Condomino    decimal(12,4)=Null,
             @ExonAutoValuo    bit=Null,
             @AnioCompra    int=Null,
             @estado    bit=Null,
             @Predio_id    char(16)=Null,
             @persona_ID    char(9)=Null,
             @tipo_adquisicion    int=Null,
             @tipo_posesion    int=Null,
			 @tipo_contribuyente    int=Null,
             @expediente    varchar(15)=Null,
             @observaciones    varchar(1000)=Null,
             @registro_user   varchar(40)=Null,
			 @idPeriodoAntiguo int=Null
,@TipoConsulta tinyint
AS 
BEGIN 

DECLARE			--@idPeriodo int =2016,
				--@registro_user int,
				@idContribuyente varchar(20),
				@area_terreno decimal(12,2), 
				@arancel decimal(12,2),
				--@Predio_id char(16),
				@Porcentaje_Condo decimal(12,2),
				 @valor_terreno    decimal(18,2)=Null,
				 @valor_construccion   decimal(18,2)=Null,
				 @valor_otra_instalacion   decimal(18,2)=Null,
				 @total_autovaluo   decimal(18,2)=Null,
				 @Tramo1   decimal(18,2)=Null,
				 @Tramo2   decimal(18,2)=Null,
		         @impuesto_predial decimal(18,2)=Null,
				 @id_alicuota    char(3)=Null,
				 @total_autovaluo_SUMA   decimal(18,2)=0,
				 @tipocobro int=null,
				 @veces int=null,
				 @fechaVencimiento date=null,
				 @a int=0,@formulario  decimal(12,2),
				 @totalAutovaluo decimal(18,2),
				 @ValorMinimoPredio decimal(12,2),
				 @totalPredioCont int
if @TipoConsulta=1 
Begin
             UPDATE dbo.[PREDio_COntribuyente]SET 
                          [idPeriodo]=@idPeriodo,
                          [Fecha]=@Fecha,
                          [Porcentaje_Condomino]=@Porcentaje_Condomino,
                          [ExonAutoValuo]=@ExonAutoValuo,
                          [AnioCompra]=YEAR(@Fecha),
                          [estado]=@estado,
                         -- [Predio_id]=@Predio_id,
                          [persona_ID]=@persona_ID,
                          [tipo_adquisicion]=@tipo_adquisicion,
                          [tipo_posesion]=@tipo_posesion,
                          [expediente]=@expediente,
                          [observaciones]=@observaciones,
                          [registro_fecha_update]=GETDATE(),
                          [registro_user_update]=@registro_user,
                          [registro_pc_update]=HOST_NAME()
             WHERE  predio_contribuyente_id = @predio_contribuyente_id

End

--===========================================================================================
--==========PROCEDIMIENTO PREDio_COntribuyenteGetByAll ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=2
begin
 Select PC.*, T.descripcion AS adq_descripcion,Ti.descripcion AS pose_descripcion,CON.razon_social
 from PREDio_COntribuyente PC 
	LEFT JOIN TABLAS T ON (PC.tipo_adquisicion=t.valor and T.dep_id=4 and T.estado=1)
	LEFT JOIN TABLAS TI ON (PC.tipo_posesion=tI.valor and TI.dep_id=18 and TI.estado=1)
	left JOIN Contribuyente CON ON CON.persona_id=PC.persona_ID

End

--===========================================================================================
--==========PROCEDIMIENTO PREDio_COntribuyenteGetByPrimaryKey ===============
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=3
begin
Select * from PREDio_COntribuyente
WHERE  predio_contribuyente_id = @predio_contribuyente_id
End

--===========================================================================================
--==========PROCEDIMIENTO PREDio_COntribuyenteInsert ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=4
Begin
             INSERT INTO [dbo].[PREDio_COntribuyente]
             (
                          [idPeriodo],
                          [Fecha],
                          [Porcentaje_Condomino],
                          [ExonAutoValuo],
                          [AnioCompra],
                          [estado],
                          [Predio_id],
                          [persona_ID],
                          [tipo_adquisicion],
                          [tipo_posesion],
                          [expediente],
                          [observaciones],
                          [registro_fecha_add],
                          [registro_user_add],
                          [registro_pc_add],
                          [registro_fecha_update],
                          [registro_user_update],
                          [registro_pc_update]


             )
             VALUES
             (
                          @idPeriodo,
                          @Fecha,
                          @Porcentaje_Condomino,
                          @ExonAutoValuo,
                          YEAR(@Fecha),
                          @estado,
                          @Predio_id,
                          @persona_ID,
                          @tipo_adquisicion,
                          @tipo_posesion,
                          @expediente,
                          @observaciones,
                          GETDATE(),
                          @registro_user,
                          HOST_NAME(),
                          GETDATE(),
                          @registro_user,
                          HOST_NAME()

             )
             SET @predio_contribuyente_id= @@IDENTITY
End

--===========================================================================================
--==========PROCEDIMIENTO PREDio_COntribuyenteDelete ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=5
begin
Delete from PREDio_COntribuyente
WHERE  predio_contribuyente_id = @predio_contribuyente_id
end

--===========================================================================================
else if @TipoConsulta=6
begin
Select * from PREDio_COntribuyente
where idPeriodo Like @idPeriodo+ '%'
end

--===========================================================================================
--==========PROCEDIMIENTO PREDio_COntribuyenteDelete ========================
--===========================================================================================
--===========================================================================================
else IF @TipoConsulta=7
begin
Delete from PREDio_COntribuyente
end

else IF @TipoConsulta=8
begin
SELECT SUM(Porcentaje_Condomino) AS porcentaje FROM PREDio_COntribuyente
WHERE Predio_id=@Predio_id
GROUP BY Predio_id
-- select*from PREDio_COntribuyente
end
else if @TipoConsulta=9
begin
 Select PC.*, T.descripcion AS adq_descripcion,Ti.descripcion AS pose_descripcion,con.razon_social
  from PREDio_COntribuyente PC 
	LEFT JOIN TABLAS T ON (PC.tipo_adquisicion=t.valor and T.dep_id=4 and T.estado=1)
	LEFT JOIN TABLAS TI ON (PC.tipo_posesion=tI.valor and TI.dep_id=18 and TI.estado=1)
	left JOIN Contribuyente CON ON CON.persona_id=PC.persona_ID
	WHERE PC.Predio_id=@Predio_id and PC.idPeriodo=@idPeriodo
End
ELSE if @TipoConsulta=10--MODIFICAR PREDIO ID 
Begin
             UPDATE PREDio_COntribuyente SET 
                          [Predio_id]=@Predio_id
			WHERE  [Predio_id]='0' AND [registro_user_add]=@registro_user and idPeriodo=@idPeriodo
			
			
End
ELSE if @TipoConsulta=11--ELIMINAR LOS Q HALLA
Begin
	DELETE FROM PREDio_COntribuyente WHERE  Predio_id='0' AND registro_user_add=@registro_user and idPeriodo=@idPeriodo
	DELETE FROM Predio WHERE  Predio_id='0' 

End
ELSE IF @TipoConsulta=12 --COPIAR A PERIODO
BEGIN
	INSERT INTO PREDio_COntribuyente
	(idPeriodo,Fecha,Porcentaje_Condomino,ExonAutoValuo,AnioCompra,estado,Predio_id,persona_ID,tipo_adquisicion,tipo_posesion,expediente,
	observaciones,registro_fecha_add,registro_user_add,registro_pc_add,registro_fecha_update,registro_user_update,registro_pc_update)
	SELECT @idPeriodo,getDate(),P.Porcentaje_Condomino,P.ExonAutoValuo,P.AnioCompra,
	P.estado,P.Predio_id,P.persona_ID,P.tipo_adquisicion,P.tipo_posesion,expediente,P.observaciones,getDate(),
	@registro_user,HOST_NAME(),getdate(),@registro_user,HOST_NAME()
	FROM PREDio_COntribuyente P where P.idPeriodo=@idPeriodoAntiguo;
END
ELSE IF @TipoConsulta=13 -- CALCULO DE PREDIO MASIVO
BEGIN
		SELECT @Tramo1= TRAMO1 FROM Periodo WHERE AÑO=@idPeriodo
		SELECT @Tramo2= TRAMO2 FROM Periodo WHERE AÑO=@idPeriodo
		DECLARE cContribuyente CURSOR FOR SELECT  persona_id FROM Contribuyente where @ExonAutoValuo=0 and persona_id='7861'
		OPEN cContribuyente
		FETCH cContribuyente INTO @idContribuyente
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @total_autovaluo_SUMA=0;
	   	   DECLARE cPredio CURSOR FOR SELECT ISNULL(P.area_terreno,0),ISNULL(P.arancel,1),PC.Predio_id,ISNULL(PC.Porcentaje_Condomino ,100)
							   FROM PREDIO_CONTRIBUYENTE PC 
								INNER JOIN PREDIO P ON PC.Predio_id=P.predio_ID
								WHERE PC.persona_ID=@idContribuyente AND PC.idPeriodo= @idPeriodo
		   OPEN cPredio
		   FETCH NEXT FROM cPredio INTO @area_terreno,@arancel,@Predio_id,@Porcentaje_Condo 

			   WHILE @@FETCH_STATUS = 0
			   BEGIN
					SET @valor_terreno=@area_terreno*@arancel;
					SET @valor_construccion=dbo._getValorEdificaciones(@Predio_id,@idPeriodo);
					SET @valor_otra_instalacion=dbo._getValorOtrasInstalaciones(@Predio_id);
					SET @total_autovaluo=(@valor_terreno+@valor_otra_instalacion+@valor_construccion)*@Porcentaje_Condo/100;--PREGUNTAR
					SET @total_autovaluo_SUMA=@total_autovaluo_SUMA+@total_autovaluo;
				  FETCH NEXT FROM cPredio INTO @area_terreno,@arancel,@Predio_id,@Porcentaje_Condo 
   
			   END
		   CLOSE cPredio
		   DEALLOCATE cPredio
		   
		   if @total_autovaluo_SUMA<=@Tramo1
					BEGIN 
					SET @id_alicuota='0.2';
					SET @impuesto_predial=@total_autovaluo_SUMA*0.002;
					END
					ELSE IF @total_autovaluo_SUMA<=@Tramo2
						BEGIN 
						SET @id_alicuota='0.6';
						SET @impuesto_predial=(@Tramo1)*0.002+(@total_autovaluo_SUMA-@Tramo1)*0.006;
						END
						ELSE
							BEGIN 
							SET @id_alicuota='1';
							SET @impuesto_predial=(@Tramo1)*0.002+(@Tramo2-@Tramo1)*0.006+(@total_autovaluo_SUMA-@Tramo2)*0.01;
							END
		 select TOP 1  @tipocobro= cast(valor as int) from parametros  where anio=@idPeriodo and codigo=4 and estado=1;
		 sET @veces=12/@tipocobro;
		 set @a=0;
		 WHILE (@a < @tipocobro)--INSERCION DE CONDOMINIOS
			BEGIN
				set @a=@a+1;
				select TOP 1  @fechaVencimiento=fecha_vence  from parametro_mes 
				where periodo_id=@idPeriodo and mes=@veces*@a and tipo=1 and estado=1
			
				insert into CuentaCorriente (persona_ID,predio_ID,tributo_ID,anio,mes,fecha_vence,cargo,abono,estado,activo,
					fecha_generacion,tipo_opera,num_operacion,registro_user_add,registro_pc_add,registro_fecha_add,
					registro_user_update,registro_pc_update,registro_fecha_update)
					values(@idContribuyente,'0','0008',@idPeriodo,@veces*@a,@fechaVencimiento,@impuesto_predial/@tipocobro,0,'P',1,
					GETDATE(),1,1,@registro_user,HOST_NAME(),GETDATE(),@registro_user,HOST_NAME(),GETDATE())
			 
			END

		FETCH NEXT FROM cContribuyente INTO  @idContribuyente
		END

		CLOSE cContribuyente
		DEALLOCATE cContribuyente



END
else if @TipoConsulta=14
Begin
             INSERT INTO [dbo].[PREDio_COntribuyente]
             (
                          [idPeriodo],[Fecha],[Porcentaje_Condomino],[ExonAutoValuo],
                          [AnioCompra],[estado],[Predio_id],[persona_ID],[tipo_adquisicion],
                          [tipo_posesion],[expediente],[observaciones],[registro_fecha_add],
                          [registro_user_add],[registro_pc_add],[registro_fecha_update],
						  [registro_user_update],[registro_pc_update]

             )
             VALUES
             (
                          dbo.getAnio(),@Fecha,@Porcentaje_Condomino,0,
                          YEAR(@Fecha),1,@Predio_id,@persona_ID,@tipo_adquisicion,
                          @tipo_posesion,@expediente,'',GETDATE(),
                          @registro_user,HOST_NAME(),GETDATE(),
                          @registro_user,HOST_NAME()

             )
             SET @predio_contribuyente_id= @@IDENTITY
End

	ELSE IF @TipoConsulta=15
	BEGIN
	SET @idPeriodo=dbo.getAnio()
	select @Tramo1 =(UIT*50) from Periodo WHERE AÑO=@idPeriodo
	Select TOP 1 @Tramo2= total_autovaluo from Predio P WHERE P.predio_ID=@Predio_id AND P.estado=1 
		if @Tramo2<=@Tramo1
		select 1
		else
		select 2
	END
	ELSE IF @TipoConsulta=16
	BEGIN
	if @idPeriodo is null
		set @idPeriodo=dbo.getAnio()
	select @predio_contribuyente_id= count(*)from PREDio_COntribuyente 
	where Predio_id=@Predio_id and idPeriodo=@idPeriodo and estado=1 and persona_ID!=@persona_ID
	select @Porcentaje_Condomino=Porcentaje_Condomino from PREDio_COntribuyente 
	where Predio_id=@Predio_id and idPeriodo=@idPeriodo and estado=1 and persona_ID=@persona_ID
	select @predio_contribuyente_id as predio_contribuyente_id,
	@Porcentaje_Condomino as Porcentaje_Condomino
--	select * from PREDio_COntribuyente
	END
	else if @TipoConsulta = 17
	select max(p.vez) as vez,pc.Predio_id, pc.Porcentaje_Condomino,pc.tipo_adquisicion,pc.tipo_posesion,p.estado , 
	t.descripcion as adquisicion, t2.descripcion as posesion,p.nombre_predio--ltrim(RTRIM(p.nombre_predio)) as nombre_predio
	from PREDio_COntribuyente pc 
	inner join tablas t on pc.tipo_adquisicion = t.valor
	inner join tablas t2 on pc.tipo_posesion = t2.valor
	inner join Predio_auditoria p on pc.Predio_id = p.predio_ID
	where t.dep_id = 4 and t2.dep_id = 18 and pc.persona_ID = @persona_ID and p.periodo_id = @idPeriodo
	group by pc.Predio_id,pc.Porcentaje_Condomino,pc.tipo_adquisicion,pc.tipo_posesion,p.estado,t.descripcion,
	t2.descripcion,p.nombre_predio

	else if @TipoConsulta = 18
	
	select max(p.vez) as vez,t3.descripcion as tipo_predio,p.area_terreno,p.valor_construccion,t.descripcion as adquisicion,
	p.predio_ID,isnull(t4.descripcion,'') as tipo_inmueble,p.area_construida,p.valor_otra_instalacion,p.fecha_adquisicion,t5.descripcion as estado_predio,
	p.frente_metros,p.valor_area_comun,t2.descripcion as posesion,p.nombre_predio ,isnull(t6.descripcion,'') as uso_predio,p.valor_terreno,
	p.total_autovaluo ,case when p.estado = 1 then 'SI' else 'NO' end estado,s.Descripcion as sector
	from PREDio_COntribuyente pc 
	inner join Predio_auditoria p on pc.Predio_id = p.predio_ID
	inner join tablas t on p.tipo_adquisicion = t.valor
	inner join tablas t2 on pc.tipo_posesion = t2.valor
	inner join tablas t3 on p.tipo_predio = t3.valor
	inner join tablas t4 on convert(char(3),p.tipo_inmueble) = t4.valor
	inner join tablas t5 on p.estado_predio = t5.valor
	inner join tablas t6 on p.uso_predio = t6.valor
	inner join Junta_Via jv on p.junta_via_ID = jv.junta_via_ID
	inner join Sector s on jv.junta_ID = s.Sector_id
	where p.predio_ID = @Predio_id and p.periodo_id = @idPeriodo and t.dep_id = 4 and t2.dep_id = 18 and t3.dep_id = 5 and t4.dep_id = 11
	and t5.dep_id = 7 and t6.dep_id = 8 and pc.idPeriodo = @idPeriodo
	group by t3.descripcion,p.area_terreno,p.valor_construccion,t.descripcion,p.predio_ID,t4.descripcion,p.area_construida,p.valor_otra_instalacion,p.fecha_adquisicion,
	t5.descripcion,p.frente_metros,p.valor_area_comun,t2.descripcion,p.nombre_predio,t6.descripcion,p.valor_terreno,p.total_autovaluo,p.estado,s.Descripcion
	ELSE IF @TipoConsulta=19--para carta de contribuytente
		BEGIN
		SELECT 
		(
			(CASE WHEN p.direccion_completa IS NULL THEN dbo._getDireccionFiscal(p.junta_via_ID,p.num_via,p.interior,p.mz,p.lote,p.edificio,p.piso,p.dpto,p.tienda,p.kilometro)
			when p.direccion_completa='' then dbo._getDireccionFiscal(p.junta_via_ID,p.num_via,p.interior,p.mz,p.lote,p.edificio,p.piso,p.dpto,p.tienda,p.kilometro)
			else p.direccion_completa end)+' INSCRITO DESDE '+CAST( YEAR(PC.FECHA)AS VARCHAR))+'-'+CAST(MONTH(PC.Fecha)AS VARCHAR)+
			'-'+CAST(DAY(PC.Fecha )AS VARCHAR) AS predios  FROM Predio P
		INNER JOIN PREDio_COntribuyente PC ON PC.PREDIO_ID=P.predio_ID
		WHERE PC.idPeriodo=@idPeriodo AND PC.persona_ID=@persona_ID
		END
	ELSE IF @TipoConsulta=20
	BEGIN
		WHILE(@idPeriodo<=@idPeriodoAntiguo)
		BEGIN
		SET @veces=YEAR(@Fecha);
		EXEC _Pred_Predio_Contribuyente
              0,@idPeriodo, @Fecha, @Porcentaje_Condomino ,0,
             @veces ,1,@Predio_id,@persona_ID,@tipo_adquisicion ,
             @tipo_posesion ,@tipo_contribuyente ,@expediente ,
             @observaciones ,@registro_user ,@idPeriodoAntiguo ,4
		SET @idPeriodo=@idPeriodo+1;
		END
	END
	ELSE IF @TipoConsulta=21
	BEGIN
		if(SELECT count(*) FROM PREDio_COntribuyente where Predio_id=@Predio_id 
		and idPeriodo=@idPeriodo and estado=1)>1
			update PREDio_COntribuyente set estado=0,registro_user_update=@registro_user,
			registro_fecha_update=getdate(),registro_pc_update=HOST_NAME()  
			where Predio_id=@Predio_id and persona_ID=@persona_ID
			and idPeriodo>=@idPeriodo
		else
		begin
			update PREDio_COntribuyente set estado=0,registro_user_update=@registro_user,
			registro_fecha_update=getdate(),registro_pc_update=HOST_NAME()  
			where Predio_id=@Predio_id and persona_ID=@persona_ID and idPeriodo>=@idPeriodo
			update predio set estado=0,registro_user_update=@registro_user,
			registro_fecha_update=getdate(),registro_pc_update=HOST_NAME()  
			 where predio_ID=@Predio_id
			--update Predio_auditoria set estado=0
			--where predio_ID=@Predio_id and periodo_id>=@idPeriodo
			--select*from Predio_auditoria p where p.predio_ID=@Predio_id and p.periodo_id>=@idPeriodo
			--and p.vez=(select max(vez)from Predio_auditoria 
			--where predio_ID=p.predio_ID and periodo_id=p.periodo_id)

			 insert into Predio_auditoria (periodo_id,predio_ID,junta_via_ID,NUM_VIA,CATASTRO,INTERIOR,MZ,LOTE,
			 EDIFICIO,piso,dpto,tienda,direccion_completa,kilometro,nombre_predio,referencia,frente_a,frente_metros,
			 num_personas,fecha_terreno,tipo_operacion,area_terreno,area_construida,anios_antiguedad,tipo_inmueble,
			 tipo_predio,estado_predio,uso_predio,uso_codigo,num_ficha,tipo_adquisicion,clase_edificacion,
			 fecha_adquisicion,exo_predial,exo_predial_porcentaje,exo_anio,motivo_exoneracion,porcen_area_comun,
			 valor_referencial,valor_terreno,valor_construccion,valor_otra_instalacion,valor_area_comun,
			 total_autovaluo,impuesto_predial,alcabala,anio_adquisicion,fecha_inscripcion,anio_inscripcion,
			 clasificacion_rustico,categoria_rustico,tipo_rustico,uso_rustico,hectareas,estado,expediente,lista_negra,
			 nuevo_uso,sector,nuevo_frente_a,validado,registro_fecha_add,registro_user_add,unidad_idep,
			 num_uni_indep,arancel,Fiscalizado,id_alicuota,norte,sur,este,oeste,Condicion_Rustico,Adquisicion_Rustico,
			 GrupoTierra_Rustico,registro_pc_add,registro_fecha_update,registro_user_update,registro_pc_update,
			 casa,mapa,condicionPropietario,cuadra,terreno_sin_construir,alquiler,lado,idPadre,vez,DescripcionHistorial)
			 select p.periodo_id,p.predio_ID,p.junta_via_ID,p.NUM_VIA,p.CATASTRO,p.INTERIOR,p.MZ,p.LOTE,
			 p.EDIFICIO,p.piso,p.dpto,p.tienda,p.direccion_completa,p.kilometro,p.nombre_predio,p.referencia,p.frente_a,p.frente_metros,
			 p.num_personas,p.fecha_terreno,p.tipo_operacion,p.area_terreno,p.area_construida,p.anios_antiguedad,p.tipo_inmueble,
			 p.tipo_predio,p.estado_predio,p.uso_predio,p.uso_codigo,p.num_ficha,p.tipo_adquisicion,p.clase_edificacion,
			 p.fecha_adquisicion,p.exo_predial,p.exo_predial_porcentaje,p.exo_anio,p.motivo_exoneracion,p.porcen_area_comun,
			 p.valor_referencial,p.valor_terreno,p.valor_construccion,p.valor_otra_instalacion,p.valor_area_comun,
			 p.total_autovaluo,p.impuesto_predial,p.alcabala,p.anio_adquisicion,p.fecha_inscripcion,p.anio_inscripcion,
			 p.clasificacion_rustico,p.categoria_rustico,p.tipo_rustico,p.uso_rustico,p.hectareas,0,p.expediente,p.lista_negra,
			 p.nuevo_uso,p.sector,p.nuevo_frente_a,p.validado,GETDATE(),@registro_user,p.unidad_idep,
			 p.num_uni_indep,p.arancel,p.Fiscalizado,p.id_alicuota,p.norte,p.sur,p.este,p.oeste,p.Condicion_Rustico,p.Adquisicion_Rustico,
			 p.GrupoTierra_Rustico,HOST_NAME(),GETDATE(),@registro_user,HOST_NAME(),
			 p.casa,p.mapa,p.condicionPropietario,p.cuadra,p.terreno_sin_construir,p.alquiler,p.lado,p.idPadre,(p.vez+1),p.DescripcionHistorial 
			 from Predio_auditoria p where p.predio_ID=@Predio_id and p.periodo_id>=@idPeriodo
			and p.vez=(select max(vez)from Predio_auditoria 
			where predio_ID=p.predio_ID and periodo_id=p.periodo_id)
		end
	END
	else if @TipoConsulta = 22
	select max(p.vez) as vez,pc.Predio_id, pc.Porcentaje_Condomino,pc.tipo_adquisicion,pc.tipo_posesion,p.estado , 
	t.descripcion as adquisicion, t2.descripcion as posesion,p.nombre_predio--ltrim(RTRIM(p.nombre_predio)) as nombre_predio
	from PREDio_COntribuyente pc 
	inner join tablas t on pc.tipo_adquisicion = t.valor
	inner join tablas t2 on pc.tipo_posesion = t2.valor
	inner join Predio_auditoria p on pc.Predio_id = p.predio_ID
	where t.dep_id = 4 and t2.dep_id = 18 and pc.persona_ID = @persona_ID and p.periodo_id = year(getdate())
	group by pc.Predio_id,pc.Porcentaje_Condomino,pc.tipo_adquisicion,pc.tipo_posesion,p.estado,t.descripcion,
	t2.descripcion,p.nombre_predio

	else if @TipoConsulta = 23
	
	select max(p.vez) as vez,t3.descripcion as tipo_predio,p.area_terreno,p.valor_construccion,t.descripcion as adquisicion,
	p.predio_ID,isnull(t4.descripcion,'') as tipo_inmueble,p.area_construida,p.valor_otra_instalacion,CONVERT (char(10), p.fecha_adquisicion, 103) as fecha_adquisicion,t5.descripcion as estado_predio,
	p.frente_metros,p.valor_area_comun,t2.descripcion as posesion,p.nombre_predio ,isnull(t6.descripcion,'') as uso_predio,p.valor_terreno,
	p.total_autovaluo ,case when p.estado = 1 then 'SI' else 'NO' end estado,s.Descripcion as sector
	from PREDio_COntribuyente pc 
	inner join Predio_auditoria p on pc.Predio_id = p.predio_ID
	inner join tablas t on p.tipo_adquisicion = t.valor
	inner join tablas t2 on pc.tipo_posesion = t2.valor
	inner join tablas t3 on p.tipo_predio = t3.valor
	inner join tablas t4 on convert(char(3),p.tipo_inmueble) = t4.valor
	inner join tablas t5 on p.estado_predio = t5.valor
	inner join tablas t6 on p.uso_predio = t6.valor	
	inner join Junta_Via jv on p.junta_via_ID = jv.junta_via_ID
	inner join Sector s on jv.junta_ID = s.Sector_id
	where p.predio_ID = @Predio_id and p.periodo_id = @idPeriodo and t.dep_id = 4 and t2.dep_id = 18 and t3.dep_id = 5 and t4.dep_id = 11
	and t5.dep_id = 7 and t6.dep_id = 8 and pc.idPeriodo = @idPeriodo AND P.vez = (SELECT MAX(vez) FROM Predio_auditoria PAU 
						WHERE PAU.periodo_id = P.periodo_id and PAU.predio_ID = P.predio_ID) 
	group by t3.descripcion,p.area_terreno,p.valor_construccion,t.descripcion,p.predio_ID,t4.descripcion,p.area_construida,p.valor_otra_instalacion,p.fecha_adquisicion,
	t5.descripcion,p.frente_metros,p.valor_area_comun,t2.descripcion,p.nombre_predio,t6.descripcion,p.valor_terreno,p.total_autovaluo,p.estado,s.Descripcion
END--fin de todo

