USE [SG_Rentable]
GO
/****** Object:  StoredProcedure [dbo].[_Mant_Relacion_Contribuyente]    Script Date: 22/11/2016 09:30:45 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
--==========PROCEDIMIENTO relacion_contribuyenteUpdate ========================
--===========================================================================================
--===========================================================================================
ALTER PROCEDURE [dbo].[_Mant_Relacion_Contribuyente]
             @relacion_ID    int=Null output,
             @cod_allegado    char(9)=Null,
             @razon_social    varchar(100)=Null,
             @ruc    char(11)=Null,
             @tipo_relacion    int=Null,
             @persona_ID    char(9)=Null,
             @estado    bit=Null,
             @registro_fecha_add    datetime=Null,
             @registro_pc_add    varchar(40)=Null,
             @registro_user_add    varchar(40)=Null,
             @registro_fecha_update    datetime=Null,
             @registro_pc_update    varchar(40)=Null,
             @registro_user_update    varchar(40)=Null

,@TipoConsulta tinyint
AS 
if @TipoConsulta=1 
Begin
             UPDATE dbo.[relacion_contribuyente]SET 
                          [tipo_relacion]=@tipo_relacion,
                          [estado]=@estado,
                          [registro_fecha_update]=GETDATE(),
                          [registro_pc_update]=HOST_NAME(),
                          [registro_user_update]=@registro_user_update
             WHERE  relacion_ID = @relacion_ID

End

--===========================================================================================
--==========PROCEDIMIENTO relacion_contribuyenteGetByAll ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=2
begin
Select RC.*,TA.descripcion AS tipo_relacion_descripcion from relacion_contribuyente RC
LEFT JOIN tablas TA ON (TA.valor=RC.tipo_relacion and TA.dep_id=23)where rc.cod_allegado=@cod_allegado
End

--===========================================================================================
--==========PROCEDIMIENTO relacion_contribuyenteGetByPrimaryKey ===============
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=3
begin
Select * from relacion_contribuyente
WHERE  relacion_ID = @relacion_ID
End

--===========================================================================================
--==========PROCEDIMIENTO relacion_contribuyenteInsert ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=4
Begin
select @razon_social= paterno+' '+materno+' '+nombres,@ruc=documento from Persona where persona_ID=@persona_ID
       INSERT INTO [dbo].[relacion_contribuyente]
             (
                 [cod_allegado],[razon_social],[ruc], [tipo_relacion],[persona_ID], [estado],
                 [registro_fecha_add],[registro_pc_add],[registro_user_add],[registro_fecha_update],[registro_pc_update],[registro_user_update]
			)
             VALUES
             (
                 @cod_allegado,@razon_social,@ruc,@tipo_relacion,@persona_ID,@estado,
                 getdate(),host_name(),@registro_user_add,getdate(),host_name(),@registro_user_add

             )
             SET @relacion_ID= @@IDENTITY
End

--===========================================================================================
--==========PROCEDIMIENTO relacion_contribuyenteDelete ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=5
begin
Delete from relacion_contribuyente
WHERE  relacion_ID = @relacion_ID
end

--===========================================================================================
else if @TipoConsulta=6
begin
Select * from relacion_contribuyente
where cod_allegado Like @cod_allegado+ '%'
end

--===========================================================================================
--==========PROCEDIMIENTO relacion_contribuyenteGetcod_allegado ===============
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=7
Begin
Select * from relacion_contribuyente
where cod_allegado = @cod_allegado
end

--===========================================================================================
--===========================================================================================
--==========PROCEDIMIENTO relacion_contribuyenteGetpersona_ID ===============
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=8
Begin
Select * from relacion_contribuyente
where persona_ID = @persona_ID
end

--===========================================================================================
--===========================================================================================
--==========PROCEDIMIENTO relacion_contribuyente ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta = 9
begin
select rc.relacion_ID,rc.razon_social,rc.ruc,c.direccCompleta,t.descripcion as relacion,t2.descripcion as tipo_documento
from relacion_contribuyente rc
inner join Contribuyente c on rc.persona_ID = c.persona_id
inner join Persona p on rc.persona_ID = p.persona_ID
inner join tablas t on rc.tipo_relacion = t.valor
inner join tablas t2 on p.tipo_documento = t2.valor
where t.dep_id = 23 and t2.dep_id = 3 and rc.cod_allegado = @persona_ID -- si no es contribuyente no puede ser pariente
end




