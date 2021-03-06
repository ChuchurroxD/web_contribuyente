USE [SG_Rentable]
GO
/****** Object:  StoredProcedure [dbo].[_Mant_Periodo]    Script Date: 10/12/2016 11:43:10 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
--==========PROCEDIMIENTO PeriodoUpdate ========================
--===========================================================================================
--===========================================================================================
ALTER PROCEDURE [dbo].[_Mant_Periodo]
             @Peric_canio    char(4)=Null,
             @Peric_vdescripcion    varchar(250)=Null,
             @Peric_euit    decimal(12,2)=Null,
             @Peric_bactivo    bit=Null,
             @Peric_ntasaAlcabala    decimal(12,2)=Null,
             @Peric_iuitAlcabala    int=Null,
             @Peric_nmoraAlcaba    decimal(12,2)=Null,
			 @Interes decimal(12,2)=Null,
			 @FactorOficilizacion decimal(12,2)=Null,
			 @MinimoPredio decimal(12,2)=Null,
			 @TopeUITPension  decimal(12,2)=Null,
			 @codigo int=null,
			 @formulario decimal(12,2)=null

,@TipoConsulta tinyint
AS 
if @TipoConsulta=1 
Begin
             UPDATE dbo.[Periodo]SET 
                          [descripcion]=@Peric_vdescripcion,
                          [UIT]=@Peric_euit,
                          [activo]=@Peric_bactivo,
                          [tasaAlcabala]=@Peric_ntasaAlcabala,
                          [UITAlcabala]=@Peric_iuitAlcabala,
                          [moraAlcabala]=@Peric_nmoraAlcaba,
						  [Interes]=@Interes,
						  [FactorOficilizacion]=@FactorOficilizacion,
						  [MinimoPredio]=@MinimoPredio,
						  [TopeUITPension]=@TopeUITPension,
						  [formulario]=@formulario,
						  [Tramo1]=@Peric_euit*15
						  ,[Tramo2]=@Peric_euit*60
						  ,[Tramo3]=0
             WHERE  año = @Peric_canio

End

--===========================================================================================
--==========PROCEDIMIENTO PeriodoGetByAll ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=2
begin
Select año,descripcion,activo,UIT,
--CAST(tasaAlcabala AS decimal) AS 
tasaAlcabala, UITAlcabala,
--CAST(moraAlcabala AS decimal)AS 
moraAlcabala,Interes,FactorOficilizacion,MinimoPredio,TopeUITPension,formulario,CAST(Tramo1 as varchar(10)) as Tramo1,cast(Tramo2 as varchar(10)) as Tramo2,'Infinito' as tramo3  from Periodo ORDER BY año DESC

select*from periodo
End

--===========================================================================================
--==========PROCEDIMIENTO PeriodoGetByPrimaryKey ===============
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=3
begin
Select * from Periodo
WHERE  año = @Peric_canio
End

--===========================================================================================
--==========PROCEDIMIENTO PeriodoInsert ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=4
Begin
             INSERT INTO [dbo].[Periodo]
             (
                          [año],
                          [descripcion],
                          [UIT],
                          [activo],
                          [tasaAlcabala],
                          [UITAlcabala],
                          [moraAlcabala],
						   [Interes],
						  [FactorOficilizacion],
						  [MinimoPredio], [TopeUITPension],
						  [Tramo1],[Tramo2],[Tramo3],[formulario]

             )
             VALUES
             (
                          @Peric_canio,
                          @Peric_vdescripcion,
                          @Peric_euit,
						  @Peric_bactivo,
                          @Peric_ntasaAlcabala,
                          @Peric_iuitAlcabala,
                          @Peric_nmoraAlcaba,@Interes,
						  @FactorOficilizacion,
						  @MinimoPredio,
						  @TopeUITPension,
						  @Peric_euit*15,
						  @Peric_euit*60,
						  0,
						  @formulario

             )
             SET @Peric_canio= @@IDENTITY
End

--===========================================================================================
--==========PROCEDIMIENTO PeriodoDelete ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=5
begin
Delete from Periodo
WHERE  año = @Peric_canio
end

--===========================================================================================
else if @TipoConsulta=6
begin
Select * from Periodo
where descripcion Like @Peric_vdescripcion+ '%'
end

--===========================================================================================
--==========PROCEDIMIENTO PeriodoDelete ========================
--===========================================================================================
--===========================================================================================
else
IF @TipoConsulta=7
begin
Delete from Periodo
end
--===========================================================================================
--==========PROCEDIMIENTO ConfMultitablaeXISTEaGREGAR ========================
--===========================================================================================
--===========================================================================================
ELSE
IF  @TipoConsulta=8
		SELECT COUNT(*)AS TOTAL FROM Periodo WHERE  año=@Peric_canio
	
else if @TipoConsulta =9--combo de periodo
begin
	select año as anio from Periodo order by año desc
end
else if @TipoConsulta =10--periodo activo
begin
	select top 1 año as anio from Periodo where activo=1
end
else if @TipoConsulta =11 --periodopordescripcion
begin
	select p.año from periodo p
	where p.año not in(select anio from parametros where codigo=@codigo)
	order by año desc
end
ELSE IF @TipoConsulta=12
		SELECT COUNT(*)AS TOTAL FROM Periodo WHERE  activo=1--PARA VERIFICAR SIHAY UN SOLO PERIODO ACTIVO
ELSE IF @TipoConsulta=13
		SELECT COUNT(*)AS TOTAL FROM Periodo WHERE  activo=1 AND año!=@Peric_canio--PARA VERIFICAR SIHAY UN SOLO PERIODO ACTIVO
else if @TipoConsulta = 14 -- combo version 2
begin
	select año as anio,descripcion from Periodo union all select 0,'TODOS' order by descripcion desc
end
else if @TipoConsulta = 15 -- combo version 2
begin
	select año as anio, año as descripcion from Periodo order by año desc
end
