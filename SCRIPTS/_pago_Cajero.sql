USE [SG_Rentable]
GO
/****** Object:  StoredProcedure [dbo].[_pago_Cajero]    Script Date: 22/11/2016 09:31:35 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[_pago_Cajero]
             @Persona_id    char(9)=Null,
             @FechaInicio    datetime=Null,
             @FechaFin    datetime=Null,
             @Observacion    varchar(150)=Null,
             @Estado    bit=Null,
             @registro_fecha_add    datetime=Null,
             @registro_user_add    varchar(40)=Null,
             @registro_pc_add    varchar(40)=Null,
             @registro_fecha_update    datetime=Null,
             @registro_user_update    varchar(40)=Null,
             @registro_pc_update    varchar(40)=Null,
			 @persona_desc varchar(80)=null

,@TipoConsulta tinyint
AS 
if @TipoConsulta=1 
Begin
             UPDATE dbo.[Cajero]SET 
                          [FechaInicio]=@FechaInicio,
                          [FechaFin]=@FechaFin,
                          [Observacion]=@Observacion,
                          [Estado]=@Estado
						  --,[registro_fecha_add]=@registro_fecha_add,
                          --[registro_user_add]=@registro_user_add,
                          --[registro_pc_add]=@registro_pc_add,
                          --[registro_fecha_update]=@registro_fecha_update,
                          --[registro_user_update]=@registro_user_update,
                          --[registro_pc_update]=@registro_pc_update
             WHERE  Persona_id = @Persona_id

End

--===========================================================================================
--==========PROCEDIMIENTO CajeroGetByAll ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=2
begin
select c.Persona_id,p.NombreCompleto as Persona_Desc,FechaInicio,
(case when FechaFin is null then '1900/01/01'
else FechaFin end)as FechaFin,
(case when c.Observacion is null then ''
else c.Observacion end)as Observacion,c.Estado,
c.registro_fecha_add,c.registro_fecha_update,c.registro_pc_add,
c.registro_pc_update,c.registro_user_add,c.registro_user_update from Cajero c
inner join Persona p
on c.Persona_id=p.persona_ID
End

--===========================================================================================
--==========PROCEDIMIENTO CajeroGetByPrimaryKey ===============
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=3
begin
select c.Persona_id,p.NombreCompleto as Persona_Desc,FechaInicio,
(case when FechaFin is null then '1900/01/01'
else FechaFin end)as FechaFin,
(case when c.Observacion is null then ''
else c.Observacion end)as Observacion,c.Estado,
c.registro_fecha_add,c.registro_fecha_update,c.registro_pc_add,
c.registro_pc_update,c.registro_user_add,c.registro_user_update from Cajero c
inner join Persona p
on c.Persona_id=p.persona_ID
WHERE  c.Persona_id = @Persona_id
End

--===========================================================================================
--==========PROCEDIMIENTO CajeroInsert ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=4
Begin
             INSERT INTO [dbo].[Cajero]
             (
                          [Persona_id],
                          [FechaInicio],
                          [FechaFin],
                          [Observacion],
                          [Estado],
                          [registro_fecha_add],
                          [registro_user_add],
                          [registro_pc_add]
						  --,[registro_fecha_update],
                          --[registro_user_update],
                          --[registro_pc_update]

             )
             VALUES
             (
                          @Persona_id,
                          @FechaInicio,
                          @FechaFin,
                          @Observacion,
                          @Estado,
                          GETDATE(),
                          0,
                          ''
						  --,@registro_fecha_update,
                          --@registro_user_update,
                          --@registro_pc_update

             )
             SET @Persona_id= @@IDENTITY
End

--===========================================================================================
--==========PROCEDIMIENTO CajeroDelete ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=5
begin
Delete from Cajero
WHERE  Persona_id = @Persona_id
end

--===========================================================================================
else if @TipoConsulta=6
begin
select c.Persona_id,p.NombreCompleto as Persona_Desc,FechaInicio,
(case when FechaFin is null then '1900/01/01'
else FechaFin end)as FechaFin,
(case when c.Observacion is null then ''
else c.Observacion end)as Observacion,c.Estado,
c.registro_fecha_add,c.registro_fecha_update,c.registro_pc_add,
c.registro_pc_update,c.registro_user_add,c.registro_user_update from Cajero c
inner join Persona p
on c.Persona_id=p.persona_ID
where p.NombreCompleto Like  '%'+@persona_desc+'%'
end

--===========================================================================================
--==========PROCEDIMIENTO CajeroGetPersona_id ===============
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=7
Begin
select c.Persona_id,p.NombreCompleto as Persona_Desc,FechaInicio,
(case when FechaFin is null then '1900/01/01'
else FechaFin end)as FechaFin,
(case when c.Observacion is null then ''
else c.Observacion end)as Observacion,c.Estado,
c.registro_fecha_add,c.registro_fecha_update,c.registro_pc_add,
c.registro_pc_update,c.registro_user_add,c.registro_user_update from Cajero c
inner join Persona p
on c.Persona_id=p.persona_ID
where c.Persona_id = @Persona_id
end

--===========================================================================================
--===========================================================================================
--==========PROCEDIMIENTO CajeroDelete ========================
--===========================================================================================
--===========================================================================================
else
if @TipoConsulta=8
begin
update cajero set Estado=0 where Persona_id=@Persona_id
end
--===========================================================================================
--===========================================================================================
--==========PROCEDIMIENTO llenarComboCajero ========================
--===========================================================================================
--=======================================================================================
else if @TipoConsulta =9
select c.persona_ID , p.NombreCompleto from cajero c inner join persona p on c.Persona_id = p.persona_ID

else if @TipoConsulta = 10
select c.persona_ID , p.NombreCompleto from cajero c inner join persona p on c.Persona_id = p.persona_ID
union all select '0','--TODOS--'  order by persona_ID 


