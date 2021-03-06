USE [SG_Rentable]
GO
/****** Object:  StoredProcedure [dbo].[_Pred_Pisos]    Script Date: 22/11/2016 09:35:02 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
--==========PROCEDIMIENTO pisosUpdate ========================
--===========================================================================================
--===========================================================================================
 ALTER PROCEDURE [dbo].[_Pred_Pisos] 
             @piso_ID    int=Null output,
             @numero    int=Null,
             @seccion    varchar(3)=Null,
             @fecha_construc    datetime=Null,
             @antiguedad    int=Null,
             @muro    char(1)=Null,
             @techo    char(1)=Null,
             @piso    char(1)=Null,
             @puerta    char(1)=Null,
             @revestimiento    char(1)=Null,
             @banio    char(1)=Null,
             @instalaciones    char(1)=Null,
             --@valor_unitario    decimal(18,2)=Null,
             @incremento    decimal(18,2)=Null,
             --@porcent_depreci    decimal(5)=Null,
             --@valor_unit_depreciado    decimal(18,2)=Null,
             @area_construida    decimal(18,2)=Null,
             --@valor_construido    decimal(18,2)=Null,
             @area_comun    decimal(18,2)=Null,
         --    @valor_comun    decimal(18,2)=Null,
         --    @valor_construido_total    decimal(18,2)=Null,
             @anio    smallint=Null,
             @estado    bit=Null,
             @predio_ID    char(16)=Null,
             @piso_clasificacion    int=Null,
             @piso_material    int=Null,
             @piso_estado    int=Null,
             @condicion    smallint=Null,
             @persona_ID    char(9)=Null,
             @metros_alquilados    decimal(18,2)=Null,
             @clase    char(3)=Null,
             @registro_user    varchar(40)=Null,
			 @periodo_id int=null,
			 @periodo_idFin int=null

,@TipoConsulta tinyint
AS
BEGIN
			declare 
			 @valor_unitario    decimal(18,2)=Null,
             @porcent_depreci    decimal(12,2)=Null,
			 @valor_construido    decimal(18,2)=Null,
             @valor_unit_depreciado    decimal(18,2)=Null,
			 @valor_comun    decimal(18,2)=Null,
			 @valor_construido_total    decimal(18,2)=Null,
			 @vez int,@consideraaño int=1,
			 @piso_idTemporal int
			 --@piso_id_insertado int=Null
if @TipoConsulta=1 
Begin
			--select top 1 @consideraaño=(case when valor =1 then 1--no
			--			 when valor=2 then 0--si
			--			  end) from tablas where dep_id='129' and estado=1
			IF (year(@fecha_construc)!=1900)
				BEGIN
				set @antiguedad=@periodo_id-year(@fecha_construc)-1--años de antiguedad del piso, corre a partir del siguiente año de construccion
				if(@antiguedad<0)
				set @antiguedad=0;
				END
			SET @valor_unitario=dbo._getValorUnitarioxPiso(@muro,@techo,@piso,@puerta,@revestimiento,@banio,@instalaciones,@periodo_id)--@valor_unitario,
			--SET @porcent_depreci=dbo._getDepPorcentajePiso(cast(@antiguedad as char(3)),@piso_estado,@piso_clasificacion,@piso_material,@anio)--@porcent_depreci,
			SET @porcent_depreci=dbo._getDepPorcentajePiso('',@piso_estado,@piso_clasificacion,@piso_material,@periodo_id,@antiguedad)--@porcent_depreci,
            SET @valor_unit_depreciado= @valor_unitario*(1-@porcent_depreci/100)
			SET @valor_construido=@valor_unit_depreciado*@area_construida
			SET @valor_comun=@valor_construido/100*@area_comun
			SET @valor_construido_total=@valor_construido+@valor_comun+@valor_construido/100*@incremento
			--SET @valor_construido_total=@valor_construido+@valor_comun
			 UPDATE dbo.[pisos]SET 
                          [numero]=@numero,
                          [seccion]=@seccion,
                          [fecha_construc]=@fecha_construc,
                          [antiguedad]=@antiguedad,
                          [muro]=@muro,
                          [techo]=@techo,
                          [piso]=@piso,
                          [puerta]=@puerta,
                          [revestimiento]=@revestimiento,
                          [banio]=@banio,
                          [instalaciones]=@instalaciones,
                          [valor_unitario]=@valor_unitario,
                          [incremento]=@incremento,
                          [porcent_depreci]= @porcent_depreci,
                          [valor_unit_depreciado]=@valor_unit_depreciado,
                          [area_construida]=@area_construida,
                          [valor_construido]=@valor_construido,
                          [area_comun]=@area_comun,
                          [valor_comun]=@valor_comun,
                          [valor_construido_total]=@valor_construido_total,
                          [anio]=@anio,
                          [estado]=@estado,
                         -- [predio_ID]=@predio_ID,
                          [piso_clasificacion]=@piso_clasificacion,
                          [piso_material]=@piso_material,
                          [piso_estado]=@piso_estado,
                          [condicion]=@condicion,
                          [persona_ID]=@persona_ID,
                          [metros_alquilados]=@metros_alquilados,
                          [clase]=@clase,
                          [registro_fecha_add]=GETDATE(),
                          [registro_user_add]=@registro_user,
                          [registro_pc_add]=HOST_NAME(),
                          [registro_fecha_update]=GETDATE(),
                          [registro_user_update]=@registro_user,
                          [registro_pc_update]=HOST_NAME()
             WHERE  piso_ID = @piso_ID
			 if @predio_ID!='0'--is no inserta nuevo
			 begin
			 select @vez =(ISNULL(max(vez),0)+1)from pisos_auditoria where piso_ID=@piso_ID and periodo_id=@periodo_id
				INSERT INTO [dbo].[pisos_auditoria]
					   ([piso_ID],[numero],[seccion],[fecha_construc],[antiguedad],[muro],[techo],[piso],[puerta],[revestimiento]
					   ,[banio],[instalaciones],[valor_unitario],[incremento],[porcent_depreci],[valor_unit_depreciado]
					   ,[area_construida],[valor_construido],[area_comun],[valor_comun],[valor_construido_total],[anio]
					   ,[estado],[predio_ID],[piso_clasificacion],[piso_material],[piso_estado]
					   ,[condicion],[persona_ID],[metros_alquilados],[clase],[registro_fecha_add],[registro_user_add],[registro_pc_add]
					   ,[registro_fecha_update],[registro_user_update],[registro_pc_update],[periodo_id],[vez])
				 VALUES
					   (@piso_ID,@numero,@seccion,@fecha_construc,@antiguedad,@muro,@techo,@piso,@puerta,@revestimiento,
						@banio,@instalaciones,@valor_unitario,@incremento,@porcent_depreci,@valor_unit_depreciado,
						@area_construida,@valor_construido,@area_comun,@valor_comun,@valor_construido_total,@anio,
						@estado,@predio_ID,@piso_clasificacion,@piso_material,@piso_estado,
						@condicion,@persona_ID,@metros_alquilados,@clase,GETdATE(),@registro_user,HOST_NAME(),
						GETDATE(),@registro_user,HOST_NAME(),@periodo_id,@vez)
			end

End

--===========================================================================================
--==========PROCEDIMIENTO pisosGetByAll ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=2
begin
select P.*,TL.valor AS clasificacion_id,TL.descripcion  as clasificacion_descripcion,
ISNULL(TM.valor,1) AS material_id,ISNULL(TM.descripcion,'') as material_descripcion,
ISNULL(TE.valor,1) as estado_id,ISNULL(TE.descripcion,'') as estado_descripcion,
ISNULL(TCO.valor,1) as condicion_id,ISNULL(TCO.descripcion,'') as condicion_descripcion,
ISNULL(TA.valor,1) as antiguedad_id,ISNULL(TA.descripcion,'') as antiguedad_descripcion,
con.razon_social
 from pisos P
LEFT JOIN TABLAS TL ON (TL.valor=P.piso_clasificacion AND TL.dep_id=20 AND TL.estado=1)
LEFT JOIN TABLAS TM ON (TM.valor=P.piso_material AND TM.dep_id=21 AND TM.estado=1)
LEFT JOIN TABLAS TE ON (TE.valor=P.piso_estado AND TE.dep_id=22 AND TE.estado=1)
LEFT JOIN TABLAS TCO ON (TCO.valor=P.condicion AND TCO.dep_id=34 AND TCO.estado=1)
LEFT JOIN TABLAS TA ON (TA.valor =cast(P.antiguedad as varchar) AND TA.dep_id=71 AND TA.estado=1)
left JOIN Contribuyente CON ON CON.persona_id=P.persona_ID
where p.estado=1
End

--===========================================================================================
--==========PROCEDIMIENTO pisosGetByPrimaryKey ===============
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=3
begin
Select * from pisos
WHERE  piso_ID = @piso_ID
End

--===========================================================================================
--==========PROCEDIMIENTO pisosInsert ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=4
Begin
			select top 1 @consideraaño=(case when valor =1 then 1--no
						 when valor=2 then 0--si
						  end) from tablas where dep_id='129' and estado=1
			set @antiguedad=@periodo_id-year(@fecha_construc)-@consideraaño--años de antiguedad del piso, corre a partir del siguiente año de construccion
			if(@antiguedad<=0)
				set @antiguedad=0;
			SET @valor_unitario=dbo._getValorUnitarioxPiso(@muro,@techo,@piso,@puerta,@revestimiento,@banio,@instalaciones,@periodo_id)--@valor_unitario,
			SET @porcent_depreci=dbo._getDepPorcentajePiso('',@piso_estado,@piso_clasificacion,@piso_material,@periodo_id,@antiguedad)--@porcent_depreci,
            SET @valor_unit_depreciado= @valor_unitario*(1-@porcent_depreci/100)
			SET @valor_construido=@valor_unit_depreciado*@area_construida
			SET @valor_comun=@valor_construido/100*@area_comun
			--SET @valor_construido_total=@valor_construido+@valor_comun
			SET @valor_construido_total=@valor_construido+@valor_comun+@valor_construido/100*@incremento
             INSERT INTO [dbo].[pisos]
             (
                          [numero],
                          [seccion],
                          [fecha_construc],
                          [antiguedad],
                          [muro],
                          [techo],
                          [piso],
                          [puerta],
                          [revestimiento],
                          [banio],
                          [instalaciones],
                          [valor_unitario],
                          [incremento],
                          [porcent_depreci],
                          [valor_unit_depreciado],
                          [area_construida],
                          [valor_construido],
                          [area_comun],
                          [valor_comun],
                          [valor_construido_total],
                          [anio],
                          [estado],
                          [predio_ID],
                          [piso_clasificacion],
                          [piso_material],
                          [piso_estado],
                          [condicion],
                          [persona_ID],
                          [metros_alquilados],
                          [clase],
                          [registro_fecha_add],
                          [registro_user_add],
                          [registro_pc_add],
                          [registro_fecha_update],
                          [registro_user_update],
                          [registro_pc_update]

             )
             VALUES
             (
                          @numero,
                          @seccion,
                          @fecha_construc,
                          @antiguedad,
                          @muro,
                          @techo,
                          @piso,
                          @puerta,
                          @revestimiento,
                          @banio,
                          @instalaciones,
                          @valor_unitario,
                          @incremento,
                          @porcent_depreci,
                          @valor_unit_depreciado,
                          @area_construida,
                          @valor_construido,
                          @area_comun,
                          @valor_comun,
                          @valor_construido_total,
                          @anio,
                          @estado,
                          @predio_ID,
                          @piso_clasificacion,
                          @piso_material,
                          @piso_estado,
                          @condicion,
                          @persona_ID,
                          @metros_alquilados,
                          @clase,
                          GETdATE(),
                          @registro_user,
                          HOST_NAME(),
                          GETDATE(),
                          @registro_user,
                          HOST_NAME()

             )
             SET @piso_ID= @@IDENTITY
			 --auditoria
			 if @predio_ID!='0'--is no inserta nuevo
			 begin
			 INSERT INTO [dbo].[pisos_auditoria]
					   ([piso_ID],[numero],[seccion],[fecha_construc],[antiguedad],[muro],[techo],[piso],[puerta],[revestimiento]
					   ,[banio],[instalaciones],[valor_unitario],[incremento],[porcent_depreci],[valor_unit_depreciado]
					   ,[area_construida],[valor_construido],[area_comun],[valor_comun],[valor_construido_total],[anio]
					   ,[estado],[predio_ID],[piso_clasificacion],[piso_material],[piso_estado]
					   ,[condicion],[persona_ID],[metros_alquilados],[clase],[registro_fecha_add],[registro_user_add],[registro_pc_add]
					   ,[registro_fecha_update],[registro_user_update],[registro_pc_update],[periodo_id],[vez])
				 VALUES
					   (@piso_ID,@numero,@seccion,@fecha_construc,@antiguedad,@muro,@techo,@piso,@puerta,@revestimiento,
						@banio,@instalaciones,@valor_unitario,@incremento,@porcent_depreci,@valor_unit_depreciado,
						@area_construida,@valor_construido,@area_comun,@valor_comun,@valor_construido_total,@anio,
						@estado,@predio_ID,@piso_clasificacion,@piso_material,@piso_estado,
						@condicion,@persona_ID,@metros_alquilados,@clase,GETdATE(),@registro_user,HOST_NAME(),
						GETDATE(),@registro_user,HOST_NAME(),@periodo_id,1)
			end
			--select @piso_ID;
End

--===========================================================================================
--==========PROCEDIMIENTO pisosDelete ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=5
begin
Delete from pisos
WHERE  piso_ID = @piso_ID
end

--===========================================================================================
else if @TipoConsulta=6
begin
Select * from pisos
where numero Like @numero+ '%'
end

--===========================================================================================
--==========PROCEDIMIENTO pisosDelete ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=7
begin
Delete from pisos
end

else if @TipoConsulta=8
begin
	select P.*,TL.valor AS clasificacion_id,TL.descripcion  as clasificacion_descripcion,
	ISNULL(TM.valor,1) AS material_id,ISNULL(TM.descripcion,'') as material_descripcion,
	ISNULL(TE.valor,1) as estado_id,ISNULL(TE.descripcion,'') as estado_descripcion,
	ISNULL(TCO.valor,1) as condicion_id,ISNULL(TCO.descripcion,'') as condicion_descripcion,
--	ISNULL(TA.valor,1) as antiguedad_id,ISNULL(TA.descripcion,'') as antiguedad_descripcion,
	'1' as antiguedad_id,'1' as antiguedad_descripcion,
	con.razon_social
	 from pisos P
	LEFT JOIN TABLAS TL ON (TL.valor=P.piso_clasificacion AND TL.dep_id=20 AND TL.estado=1)
	LEFT JOIN TABLAS TM ON (TM.valor=P.piso_material AND TM.dep_id=21 AND TM.estado=1)
	LEFT JOIN TABLAS TE ON (TE.valor=P.piso_estado AND TE.dep_id=22 AND TE.estado=1)
	LEFT JOIN TABLAS TCO ON (TCO.valor=P.condicion AND TCO.dep_id=34 AND TCO.estado=1)
	--LEFT JOIN TABLAS TA ON (TA.valor =cast(P.antiguedad as varchar) AND TA.dep_id=71 AND TA.estado=1)
	left JOIN Contribuyente CON ON CON.persona_id=P.persona_ID
	WHERE P.predio_ID=@predio_ID and p.estado=1
End
ELSE if @TipoConsulta=9--MODIFICAR PREDIO ID 
Begin
             UPDATE pisos SET 
                          [Predio_id]=@Predio_id
			WHERE  [Predio_id]='0' AND [registro_user_add]=@registro_user 
			if @predio_ID!='0'--is no inserta nuevo
			 begin
				INSERT INTO [dbo].[pisos_auditoria]
					   ([piso_ID],[numero],[seccion],[fecha_construc],[antiguedad],[muro],[techo],[piso],[puerta],[revestimiento]
					   ,[banio],[instalaciones],[valor_unitario],[incremento],[porcent_depreci],[valor_unit_depreciado]
					   ,[area_construida],[valor_construido],[area_comun],[valor_comun],[valor_construido_total],[anio]
					   ,[estado],[predio_ID],[piso_clasificacion],[piso_material],[piso_estado]
					   ,[condicion],[persona_ID],[metros_alquilados],[clase],[registro_fecha_add],[registro_user_add],[registro_pc_add]
					   ,[registro_fecha_update],[registro_user_update],[registro_pc_update],[periodo_id],[vez])
				 SELECT   piso_ID, numero, seccion, fecha_construc, antiguedad, muro, techo, piso, puerta, revestimiento,
						 banio, instalaciones, valor_unitario, incremento, porcent_depreci, valor_unit_depreciado,
						 area_construida, valor_construido, area_comun, valor_comun, valor_construido_total, anio,
						 estado, predio_ID, piso_clasificacion, piso_material, piso_estado,
						 condicion, persona_ID, metros_alquilados, clase,GETdATE(),@registro_user,HOST_NAME(),
						GETDATE(),@registro_user,HOST_NAME(),@periodo_id,1 
						FROM Pisos where predio_ID=@predio_ID  AND [registro_user_add]=@registro_user 
						
			end 

End
ELSE if @TipoConsulta=10--ELIMINAR LOS Q HALLA
Begin
             DELETE FROM pisos
			WHERE  Predio_id='0' AND registro_user_add=@registro_user 

End
else if @TipoConsulta=11
begin
	select P.*,TL.valor AS clasificacion_id,TL.descripcion  as clasificacion_descripcion,
	ISNULL(TM.valor,1) AS material_id,ISNULL(TM.descripcion,'') as material_descripcion,
	ISNULL(TE.valor,1) as estado_id,ISNULL(TE.descripcion,'') as estado_descripcion,
	ISNULL(TCO.valor,1) as condicion_id,ISNULL(TCO.descripcion,'') as condicion_descripcion,
	'1' as antiguedad_id,'1' as antiguedad_descripcion,
	--ISNULL(TA.valor,1) as antiguedad_id,ISNULL(TA.descripcion,'') as antiguedad_descripcion,
	con.razon_social
	 from pisos P
	LEFT JOIN TABLAS TL ON (TL.valor=P.piso_clasificacion AND TL.dep_id=20 AND TL.estado=1)
	LEFT JOIN TABLAS TM ON (TM.valor=P.piso_material AND TM.dep_id=21 AND TM.estado=1)
	LEFT JOIN TABLAS TE ON (TE.valor=P.piso_estado AND TE.dep_id=22 AND TE.estado=1)
	LEFT JOIN TABLAS TCO ON (TCO.valor=P.condicion AND TCO.dep_id=34 AND TCO.estado=1)
	--LEFT JOIN TABLAS TA ON (TA.valor =cast(P.antiguedad as varchar) AND TA.dep_id=71 AND TA.estado=1)
	left JOIN Contribuyente CON ON CON.persona_id=P.persona_ID
	WHERE P.predio_ID=@predio_ID and p.estado=@estado
End
ELSE if @TipoConsulta=12--COPIAR PISOS DE SUBDIVISION
Begin
			--set @antiguedad=year(getdate())-year(@fecha_construc)-1--años de antiguedad del piso, corre a partir del siguiente año de construccion
			SET @valor_unitario=dbo._getValorUnitarioxPiso(@muro,@techo,@piso,@puerta,@revestimiento,@banio,@instalaciones,@anio)--@valor_unitario,
			SET @porcent_depreci=dbo._getDepPorcentajePiso('',@piso_estado,@piso_clasificacion,@piso_material,@anio,@antiguedad)--@porcent_depreci,
            SET @valor_unit_depreciado= @valor_unitario*(1-@porcent_depreci/100)
			SET @valor_construido=@valor_unit_depreciado*@area_construida
			SET @valor_comun=@valor_construido/100*@area_comun
			--SET @valor_construido_total=@valor_construido+@valor_comun
			SET @valor_construido_total=@valor_construido+@valor_comun+@valor_construido/100*@incremento
             INSERT INTO [dbo].[pisos]
             (
                          [numero],[seccion],[fecha_construc], [antiguedad],[muro], [techo], [piso],[puerta],
                          [revestimiento],  [banio],[instalaciones],[valor_unitario],[incremento],
                          [porcent_depreci],[valor_unit_depreciado],[area_construida],[valor_construido],
                          [area_comun],[valor_comun],[valor_construido_total],[anio],[estado],[predio_ID],
                          [piso_clasificacion],[piso_material],[piso_estado],[condicion],[persona_ID],
                          [metros_alquilados],[clase],[registro_fecha_add],[registro_user_add],
                          [registro_pc_add],[registro_fecha_update],[registro_user_update],[registro_pc_update],
						  [idPadre]--pisopadre
             )
             VALUES
             (
                          @numero,@seccion,@fecha_construc,@antiguedad,@muro,@techo,@piso,@puerta,
                          @revestimiento,@banio,@instalaciones,@valor_unitario,@incremento,
                          @porcent_depreci,@valor_unit_depreciado,@area_construida,@valor_construido,
                          @area_comun,@valor_comun,@valor_construido_total,@anio,@estado,@predio_ID,
                          @piso_clasificacion,@piso_material,@piso_estado,@condicion,@persona_ID,
                          @metros_alquilados,@clase,GETdATE(),@registro_user,
                          HOST_NAME(),GETDATE(),@registro_user,HOST_NAME(),
						  @piso_ID
             )
             --SET @piso_ID= @@IDENTITY
			 update pisos set estado=0 where piso_ID=@piso_ID
End
else if @TipoConsulta = 13
	select ISNULL(max(p.vez),0) as VEZ,p.piso_ID,p.seccion,p.antiguedad,p.muro,p.techo,p.piso,p.puerta,p.revestimiento,p.banio,p.instalaciones,
	p.area_construida,p.area_comun,isnull(p.valor_construido_total,0) as valor_construido_total, tl.descripcion as piso_clasificacion, tm.descripcion as piso_material,
	te.descripcion as piso_estado, isnull(tco.descripcion,'') as condicion, p.numero
	--ISNULL(TA.valor,1) as antiguedad_id,ISNULL(TA.descripcion,'') as antiguedad_descripcion
	--con.razon_social
	 from pisos_auditoria P
	LEFT JOIN TABLAS TL ON (TL.valor=P.piso_clasificacion AND TL.dep_id=20 AND TL.estado=1)
	LEFT JOIN TABLAS TM ON (TM.valor=P.piso_material AND TM.dep_id=21 AND TM.estado=1)
	LEFT JOIN TABLAS TE ON (TE.valor=P.piso_estado AND TE.dep_id=22 AND TE.estado=1)
	LEFT JOIN TABLAS TCO ON (TCO.valor=P.condicion AND TCO.dep_id=34 AND TCO.estado=1)
	--LEFT JOIN TABLAS TA ON (TA.valor =cast(P.antiguedad as varchar) AND TA.dep_id=71 AND TA.estado=1)
	--left JOIN Contribuyente CON ON CON.persona_id=P.persona_ID
	WHERE P.predio_ID=@predio_ID and p.estado=1 and periodo_id=@anio and
	vez=(select ISNULL(max(vez),0) from pisos_auditoria where  piso_ID=p.piso_ID and Predio_id=@predio_ID  and periodo_id=@anio)
	group by p.piso_ID,p.seccion,p.antiguedad,p.muro,p.techo,p.piso,p.puerta,p.revestimiento,p.banio,p.instalaciones,
	p.area_construida,p.area_comun,p.valor_construido_total, tl.descripcion, tm.descripcion, tco.descripcion, p.numero, te.descripcion
	order by p.numero
ELSE IF @TipoConsulta=14--creacion de pisos inscripcion
	BEGIN
--	EXEC Suma 1, 2, @resultado OUTPUT
--SELECT @resultado
	exec _Pred_Pisos @piso_ID OUTPUT,@numero ,@seccion  ,@fecha_construc,@antiguedad ,@muro,@techo ,@piso ,@puerta ,@revestimiento,
             @banio,@instalaciones,@incremento ,@area_construida,@area_comun ,@anio ,@estado,@predio_ID ,@piso_clasificacion ,
             @piso_material ,@piso_estado ,@condicion ,@persona_ID,@metros_alquilados,@clase ,@registro_user ,
			 @periodo_idFin,@periodo_idFin,4 --ini fin)
			 SET @piso_idTemporal=@piso_ID;
		WHILE(@periodo_id<@periodo_idFin)
		BEGIN
		select top 1 @consideraaño=(case when valor =1 then 1--no
						 when valor=2 then 0--si
						  end) from tablas where dep_id='129' and estado=1
			set @antiguedad=@periodo_id-year(@fecha_construc)-@consideraaño--años de antiguedad del piso, corre a partir del siguiente año de construccion
			if(@antiguedad>0)
			BEGIN
			SET @valor_unitario=dbo._getValorUnitarioxPiso(@muro,@techo,@piso,@puerta,@revestimiento,@banio,@instalaciones,@periodo_id)--@valor_unitario,
			SET @porcent_depreci=dbo._getDepPorcentajePiso('',@piso_estado,@piso_clasificacion,@piso_material,@periodo_id,@antiguedad)--@porcent_depreci,
            SET @valor_unit_depreciado= @valor_unitario*(1-@porcent_depreci/100)
			SET @valor_construido=@valor_unit_depreciado*@area_construida
			SET @valor_comun=@valor_construido/100*@area_comun
			--SET @valor_construido_total=@valor_construido+@valor_comun
			SET @valor_construido_total=@valor_construido+@valor_comun+@valor_construido/100*@incremento
			 INSERT INTO [dbo].[pisos_auditoria]
					   ([piso_ID],[numero],[seccion],[fecha_construc],[antiguedad],[muro],[techo],[piso],[puerta],[revestimiento]
					   ,[banio],[instalaciones],[valor_unitario],[incremento],[porcent_depreci],[valor_unit_depreciado]
					   ,[area_construida],[valor_construido],[area_comun],[valor_comun],[valor_construido_total],[anio]
					   ,[estado],[predio_ID],[piso_clasificacion],[piso_material],[piso_estado]
					   ,[condicion],[persona_ID],[metros_alquilados],[clase],[registro_fecha_add],[registro_user_add],[registro_pc_add]
					   ,[registro_fecha_update],[registro_user_update],[registro_pc_update],[periodo_id],[vez])
				 VALUES
					   (@piso_idTemporal,@numero,@seccion,@fecha_construc,@antiguedad,@muro,@techo,@piso,@puerta,@revestimiento,
						@banio,@instalaciones,@valor_unitario,@incremento,@porcent_depreci,@valor_unit_depreciado,
						@area_construida,@valor_construido,@area_comun,@valor_comun,@valor_construido_total,@anio,
						@estado,@predio_ID,@piso_clasificacion,@piso_material,@piso_estado,
						@condicion,@persona_ID,@metros_alquilados,@clase,GETdATE(),@registro_user,HOST_NAME(),
						GETDATE(),@registro_user,HOST_NAME(),@periodo_id,1)
			END
		SET @periodo_id=@periodo_id+1;
		END
	END
END --FINAL DE TODO
