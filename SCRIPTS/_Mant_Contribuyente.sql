USE [SG_Rentable]
GO
/****** Object:  StoredProcedure [dbo].[_Mant_Contribuyente]    Script Date: 22/11/2016 09:59:46 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--===========================================================================================
--==========PROCEDIMIENTO ContribuyenteUpdate ========================
--===========================================================================================
--====================================== =====================================================
ALTER PROCEDURE [dbo].[_Mant_Contribuyente]
             @persona_id    char(9)=Null,
             @razon_social    varchar(200)=Null,
             @ruc    varchar(21)=Null,
             @junta_via_ID    int=Null,
             @c_num    varchar(30)=Null,
             @c_mz    varchar(5)=Null,
             @c_lote    varchar(10)=Null,
             @c_interior    varchar(5)=Null,
             @c_dpto    varchar(5)=Null,
             @estado    bit=Null,
         --    @registro_fecha    datetime=Null,
           --  @fecha_registro    datetime=Null,
             @registro_user    varchar(40)=Null,
             @Contacto    varchar(150)=Null,
             @dniRepresentante    varchar(11)=Null,
             @DireccRepresentante    varchar(150)=Null,
			 @referencia text=Null,
			 @c_edificio  varchar(100)=null,
			 @c_piso varchar(100)=null,
			 @c_tienda varchar(100)=null,
			 @expedientebusqueda varchar(50)=null,
			 @Ubi_codigo varchar(6)=null,
			 @periodo int=null,
			 @codPredio char(16)=null,
			 @n1 varchar(50)=null,
			 @n2 varchar(50)=null,
			 @n3 varchar(50)=null,
			 @n4 varchar(50)=null,
			 @OtraDireccion varchar(1000)=null,
			 @documento varchar(10)=null,
			 @empresaCOnstrucora bit=null,
			 @oficina int=null,
			 @junta_ID INT =NULL,
			 @numero int=null

,@TipoConsulta tinyint
AS 
if @TipoConsulta=1 
Begin
             UPDATE dbo.[Contribuyente]SET 
                          [razon_social]=@razon_social,
                          [ruc]=@ruc,
                          [junta_via_ID]=@junta_via_ID,
                          [c_num]=@c_num,
                          [c_mz]=@c_mz,
                          [c_lote]=@c_lote,
                          [c_interior]=@c_interior,
                          [c_dpto]=@c_dpto,
                          [estado]=@estado,
                          [registro_fecha_update]=GETDATE(),
                          [registro_user_update]=@registro_user,
						  [registro_pc_update]=HOST_NAME(),
                          [Contacto]=@Contacto,
                          [dniRepresentante]=@dniRepresentante,
                          [DireccRepresentante]=@DireccRepresentante,
                          [direccCompleta]=dbo._getDireccionFiscal(@junta_via_ID,@c_num,@c_interior,@c_mz,@c_lote,@c_edificio,@c_piso,@c_dpto,@c_tienda,''),
						  [referencia]=@referencia,
						  [c_edificio]=@c_edificio,
						  [c_piso]=@c_piso,
						  [c_tienda]=@c_tienda,
						  [Ubi_codigo]=Ubi_codigo,
						  [empresaCOnstrucora]=@empresaCOnstrucora
             WHERE  persona_id=@persona_id

End

--===========================================================================================
--==========PROCEDIMIENTO ContribuyenteGetByAll ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=2
begin
SELECT TOP 50 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,PER.nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		JV.junta_ID,JV.via_ID,ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,JV1.junta_ID AS c_junta,JV1.via_ID AS c_via,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante,
		CON.empresaCOnstrucora
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
				INNER JOIN Junta_Via JV ON JV.junta_via_ID=PER.junta_via_ID
				INNER JOIN Junta_Via JV1 ON JV1.junta_via_ID=CON.junta_via_ID
End

--===========================================================================================
--==========PROCEDIMIENTO ContribuyenteGetByPrimaryKey ===============
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=3
begin
Select * from Contribuyente
WHERE   persona_id=@persona_id
End

--===========================================================================================
--==========PROCEDIMIENTO ContribuyenteInsert ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=4
Begin
             INSERT INTO [dbo].[Contribuyente]
             (
                          [persona_id],
                          [razon_social],
                          [ruc],
                          [junta_via_ID],
                          [c_num],
                          [c_mz],
                          [c_lote],
                          [c_interior],
                          [c_dpto],
                          [estado],
                          [registro_fecha],
                          [fecha_registro],
                          [registro_user_add],
                          [Contacto],
                          [dniRepresentante],
                          [DireccRepresentante],
                          [direccCompleta],
						  [referencia],
						  [c_edificio],[c_piso],[c_tienda],[Ubi_codigo],
						  [registro_pc_add],[registro_fecha_update],
						  [registro_user_update],[registro_pc_update],
						  [empresaCOnstrucora]

             )
             VALUES
             (
                          @persona_id,
                          @razon_social,
                          @ruc,
                          @junta_via_ID,
                          @c_num,
                          @c_mz,
                          @c_lote,
                          @c_interior,
                          @c_dpto,
                          @estado,
                          getdate(),--@registro_fecha,
                          getDate(),--@fecha_registro,
                          @registro_user,
                          @Contacto,
                          @dniRepresentante,
                          @DireccRepresentante,
						   dbo._getDireccionFiscal(@junta_via_ID,@c_num,@c_interior,@c_mz,@c_lote,@c_edificio,@c_piso,@c_dpto,@c_tienda,''),
						  @referencia,
						  @c_edificio,
						  @c_piso,
						  @c_tienda,@Ubi_codigo,
						  HOST_NAME(),GETDATE(),
						  @registro_user,HOST_NAME(),
						  @empresaCOnstrucora
             )
             SET @persona_id= @@IDENTITY
End

--===========================================================================================
--==========PROCEDIMIENTO ContribuyenteDelete ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=5
begin
Delete from Contribuyente
WHERE   persona_id=@persona_id
end

--===========================================================================================
else if @TipoConsulta=6
begin
Select * from Contribuyente
where razon_social Like @razon_social+ '%'
end

--===========================================================================================
--==========PROCEDIMIENTO ContribuyenteDelete ========================
--===========================================================================================
--===========================================================================================

else if @TipoConsulta=7
begin
Delete from Contribuyente
end
ELSE IF @TipoConsulta=8--verificar si existe contribuyente
BEGIN 
select COUNT(*) AS TOTAL from Contribuyente where persona_id=@persona_id
END

ELSE IF @TipoConsulta=9 --busqueda de contribuyente por nro de doc
BEGIN 
		SELECT top 100 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		JV.junta_ID,JV.via_ID,ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,JV1.junta_ID AS c_junta,JV1.via_ID AS c_via,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
				LEFT JOIN Junta_Via JV ON JV.junta_via_ID=PER.junta_via_ID
				LEFT JOIN Junta_Via JV1 ON JV1.junta_via_ID=CON.junta_via_ID
				 WHERE CON.ruc LIKE @ruc and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END
ELSE IF @TipoConsulta=10 --busqueda de contribuyente por còdigo de contribuyente
BEGIN 
		SELECT top 100 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		JV.junta_ID,JV.via_ID,ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,JV1.junta_ID AS c_junta,JV1.via_ID AS c_via,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
				LEFT JOIN Junta_Via JV ON JV.junta_via_ID=PER.junta_via_ID
				LEFT JOIN Junta_Via JV1 ON JV1.junta_via_ID=CON.junta_via_ID 
				where CON.persona_id =@persona_id and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END
ELSE IF @TipoConsulta=11 --busqueda de contribuyente por nombre de contribuyente
BEGIN 
		SELECT top 100 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		JV.junta_ID,JV.via_ID,ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,JV1.junta_ID AS c_junta,JV1.via_ID AS c_via,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
				LEFT JOIN Junta_Via JV ON JV.junta_via_ID=PER.junta_via_ID
				LEFT JOIN Junta_Via JV1 ON JV1.junta_via_ID=CON.junta_via_ID 
				where CON.razon_social like @n1 and CON.razon_social like @n2 and 
					  CON.razon_social like @n3 and CON.razon_social like @n4
					  and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END
ELSE IF @TipoConsulta=12 --busqueda de contribuyente por DIRECCION ANTIGUA
BEGIN 
SELECT top 100 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		'1' AS junta_ID,'1' AS via_ID,ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,'1' AS c_junta,'1' AS c_via,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID 
				where PER.OtraDireccion=@OtraDireccion and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END
ELSE IF @TipoConsulta=13 --busqueda de contribuyente por EXPEDIENTE
BEGIN 
		SELECT top 100 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		JV.junta_ID,JV.via_ID,ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,JV1.junta_ID AS c_junta,JV1.via_ID AS c_via,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
				LEFT JOIN Junta_Via JV ON JV.junta_via_ID=PER.junta_via_ID
				LEFT JOIN Junta_Via JV1 ON JV1.junta_via_ID=CON.junta_via_ID
				 WHERE PER.expediente=@expedientebusqueda and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END
ELSE IF @TipoConsulta=14 --busqueda de contribuyente por direcciòn
BEGIN 
		SELECT top 100 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		JV.junta_ID,JV.via_ID,ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,JV1.junta_ID AS c_junta,JV1.via_ID AS c_via,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
				INNER JOIN Junta_Via JV ON JV.junta_via_ID=PER.junta_via_ID
				INNER JOIN Junta_Via JV1 ON JV1.junta_via_ID=CON.junta_via_ID
				where CON.direccCompleta=dbo._getDireccionFiscal(@junta_via_ID,@c_num,@c_interior,@c_mz,@c_lote,@c_edificio,@c_piso,@c_dpto,@c_tienda,'')
				and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END
ELSE IF @TipoConsulta=15 --busqueda de contribuyente por direcciòn
BEGIN 
SELECT top 100 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
JV.junta_ID,JV.via_ID,ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,JV1.junta_ID AS c_junta,JV1.via_ID AS c_via,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
FROM Contribuyente CON
INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
LEFT JOIN Junta_Via JV ON JV.junta_via_ID=PER.junta_via_ID
LEFT JOIN Junta_Via JV1 ON JV1.junta_via_ID=CON.junta_via_ID
WHERE CON.junta_via_ID LIKE @ruc AND (CON.c_num LIKE @c_num or CON.c_num is null) AND  (CON.c_interior like @c_interior or CON.c_interior is null)
AND (CON.c_mz LIKE @c_mz or CON.c_mz is null) AND (CON.c_lote LIKE @c_lote or CON.c_lote is null) AND (CON.c_edificio LIKE @c_edificio or CON.c_edificio is null)
AND (CON.c_piso LIKE @c_piso or CON.c_piso is null) AND (CON.c_dpto LIKE @c_dpto or CON.c_dpto is null) AND (CON.c_tienda LIKE @c_tienda or CON.c_tienda is null)
and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END
ELSE IF @TipoConsulta=16 --busqueda de contribuyente por CODIGO DE PREDIO
BEGIN 
		SELECT distinct PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		JV.junta_ID,JV.via_ID,ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,JV1.junta_ID AS c_junta,JV1.via_ID AS c_via,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,cast(ISNULL(CON.referencia,'')as varchar) AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
				LEFT JOIN Junta_Via JV ON JV.junta_via_ID=PER.junta_via_ID
				LEFT JOIN Junta_Via JV1 ON JV1.junta_via_ID=CON.junta_via_ID
				INNER JOIN PREDio_COntribuyente PRC ON (PRC.persona_ID=CON.persona_id AND PRC.idPeriodo=@periodo)
				WHERE PRC.Predio_id=@codpredio and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
		
END



ELSE IF @TipoConsulta=17 --busqueda de contribuyente por nro de doc
BEGIN 
		SELECT top 100 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		'1' AS junta_ID,'1' AS via_ID,ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,'1' AS c_junta,'1' AS c_via,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
				 WHERE CON.ruc LIKE @ruc and CON.estado=1 and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END
ELSE IF @TipoConsulta=18 --busqueda de contribuyente por còdigo de contribuyente 
BEGIN 
		SELECT top 100 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		'1' AS junta_ID,'1' AS via_ID,ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,'1' AS c_junta,'1' AS c_via,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID 
				where CON.persona_id =@persona_id and CON.estado=1 and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END
ELSE IF @TipoConsulta=19 --busqueda de contribuyente por nombre de contribuyente 
BEGIN 
		SELECT top 100 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		'1' AS junta_ID,'1' AS via_ID,ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,'1' AS c_junta,'1' AS c_via,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
				where CON.razon_social like @n1 and CON.razon_social like @n2 and 
					  CON.razon_social like @n3 and CON.razon_social like @n4 and CON.estado=1 
					  and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END
ELSE IF @TipoConsulta=20 --busqueda de contribuyente por EXPEDIENTE 
BEGIN 
		SELECT top 100 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		'1' AS junta_ID,'1' AS via_ID,ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,'1' AS c_junta,'1' AS c_via,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
				 WHERE PER.expediente=@expedientebusqueda and CON.estado=1 and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END
ELSE IF @TipoConsulta=21 --busqueda de contribuyente por direcciòn DE PREDIO
BEGIN 
	SELECT  DISTINCT top 50 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
	SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
	--'1' AS junta_ID,'1' AS via_ID,
	ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
	ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
	ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
	ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,
	--JV1.junta_ID AS c_junta,JV1.via_ID AS c_via,
	ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
	ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
	ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,cast(ISNULL(CON.referencia,'')as varchar) AS referencia,
	ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
	FROM Contribuyente CON
	INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
	INNER JOIN PREDIO_CONTRIBUYENTE PC ON PC.persona_ID=CON.persona_id
	INNER JOIN PREDIO PRE ON PRE.predio_id=PC.predio_id
	INNER JOIN Junta_Via JV1 ON JV1.junta_via_ID=PRE.junta_via_ID
	WHERE PRE.junta_via_ID LIKE @ruc AND PRE.num_via LIKE @c_num AND  PRE.interior like @c_interior 
	AND PRE.mz LIKE @c_mz  AND PRE.lote LIKE @c_lote AND PRE.edificio LIKE @c_edificio 
	AND PRE.piso LIKE @c_piso AND PRE.dpto LIKE @c_dpto AND PRE.tienda LIKE @c_tienda 
	AND PC.estado=1 AND PRE.estado=1 and CON.estado=1 and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END
ELSE IF @TipoConsulta=22 --busqueda de contribuyente por CODIGO DE PREDIO
BEGIN 
		SELECT distinct top 50 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		'1' AS junta_ID,'1' AS via_ID,ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,'1' AS c_junta,'1' AS c_via,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,cast(ISNULL(CON.referencia,'')as varchar) AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
				INNER JOIN PREDio_COntribuyente PRC ON (PRC.persona_ID=CON.persona_id AND PRC.idPeriodo=@periodo)
				WHERE PRC.Predio_id=@codpredio and CON.estado=1 and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
		
END
--exec _Mant_Contribuyente @TipoConsulta=16,@codpredio='2016615154049',@periodo=2016
--select*from PREDio_COntribuyente where Predio_id='2016615154049'
--select*FROM Contribuyente CON
--				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
--				INNER JOIN Junta_Via JV ON JV.junta_via_ID=PER.junta_via_ID
--				INNER JOIN Junta_Via JV1 ON JV1.junta_via_ID=CON.junta_via_ID
--				INNER JOIN PREDio_COntribuyente PRC ON (PRC.persona_ID=CON.persona_id AND PRC.idPeriodo=2016 )
--				WHERE PRC.Predio_id='2016615154049'
--ELSE IF @TipoConsulta=11
--BEGIN 
--select persona_id as codigo from Contribuyente where dniRepresentante=@dniRepresentante
--END
--exec _Mant_Contribuyente @TipoConsulta=15,@ruc='%',@c_num='324',@c_interior ='%'
--, @c_mz='%' ,@c_lote='%',@c_edificio='%' ,@c_piso='%',@c_dpto='%',@c_tienda='%'
--select*from Contribuyente where junta_via_ID like '%'
else if @TipoConsulta = 23 -- busqueda por numero doc en pagos y predios
		SELECT PER.persona_ID,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,t.descripcion as tipoDocumentoDescripcion,PER.documento,
					ISNULL(CON.direccCompleta,'') AS direccCompleta,s.Descripcion as sector , case when CON.estado =1 then 'ACTIVO' else 'INACTIVO' end estado_contribuyente
					FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID 
				inner join tablas t on PER.tipo_documento = t.valor
				inner join Junta_Via jv on CON.junta_via_ID = jv.junta_via_ID
				inner join Sector s on jv.junta_ID = s.Sector_id
				where CON.ruc like @ruc and CON.estado=1 and t.dep_id = 3 and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
else if @TipoConsulta = 24 -- busqueda por codigo contribuyente en pagos y predios
			SELECT PER.persona_ID,PER.paterno,PER.materno,PER.nombres,t.descripcion as tipoDocumentoDescripcion,PER.documento,
					ISNULL(CON.direccCompleta,'') AS direccCompleta,s.Descripcion as sector , case when CON.estado =1 then 'ACTIVO' else 'INACTIVO' end estado_contribuyente
					FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID 
				inner join tablas t on PER.tipo_documento = t.valor
				inner join Junta_Via jv on CON.junta_via_ID = jv.junta_via_ID
				inner join Sector s on jv.junta_ID = s.Sector_id
				where CON.persona_id =@persona_id and CON.estado=1 and t.dep_id = 3 and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
else if @TipoConsulta = 25 --busqueda por nombre contribuyente en pagos y predios
			SELECT PER.persona_ID,PER.paterno,PER.materno,PER.nombres,t.descripcion as tipoDocumentoDescripcion,PER.documento,
					ISNULL(CON.direccCompleta,'') AS direccCompleta,s.Descripcion as sector , case when CON.estado =1 then 'ACTIVO' else 'INACTIVO' end estado_contribuyente
					FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID 
				inner join tablas t on PER.tipo_documento = t.valor
				inner join Junta_Via jv on CON.junta_via_ID = jv.junta_via_ID
				inner join Sector s on jv.junta_ID = s.Sector_id
				where CON.razon_social like @n1 and CON.razon_social like @n2 and
					  CON.razon_social like @n3 and CON.razon_social like @n4 and CON.estado=1
					  and t.dep_id = 3 and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
else if @TipoConsulta = 26 --busqueda por direccion contribuyente en pagos y predios
			SELECT PER.persona_ID,PER.paterno,PER.materno,PER.nombres,t.descripcion as tipoDocumentoDescripcion,PER.documento,
					ISNULL(CON.direccCompleta,'') AS direccCompleta,s.Descripcion as sector , case when CON.estado =1 then 'ACTIVO' else 'INACTIVO' end estado_contribuyente
			FROM Contribuyente CON
			INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
			inner join tablas t on PER.tipo_documento = t.valor
			inner join Junta_Via jv on CON.junta_via_ID = jv.junta_via_ID
			inner join Sector s on jv.junta_ID = s.Sector_id
			INNER JOIN PREDIO_CONTRIBUYENTE PC ON PC.persona_ID=CON.persona_id
			INNER JOIN PREDIO PRE ON PRE.predio_id=PC.predio_id
			WHERE PRE.junta_via_ID LIKE @ruc AND PRE.num_via LIKE @c_num AND  PRE.interior like @c_interior 
			AND PRE.mz LIKE @c_mz AND PRE.lote LIKE @c_lote AND PRE.edificio LIKE @c_edificio 
			AND PRE.piso LIKE @c_piso AND PRE.dpto LIKE @c_dpto AND PRE.tienda LIKE @c_tienda 
			AND PC.estado=1 AND PRE.estado=1 and CON.estado=1 and t.dep_id = 3 and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
else if @TipoConsulta=27
begin
SELECT TOP 50 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,PER.nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
				where per.documento like '%'+@documento+'%' and CON.estado=1 and per.ESTADO=1
End
else if @TipoConsulta=28
begin
SELECT TOP 50 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,PER.nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
				where per.persona_ID like '%'+@persona_ID+'%' and CON.estado=1 and per.ESTADO=1
End
else if @TipoConsulta=29
begin
SELECT TOP 50 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,PER.nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
				where CON.razon_social like @n1 and CON.razon_social like @n2 and
					  CON.razon_social like @n3 and CON.razon_social like @n4 and CON.estado=1 and per.ESTADO=1
End
else if @TipoConsulta = 30--BUSQUEDA DE PERSONAS
			SELECT PER.persona_ID,CON.razon_social FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID 
				where CON.razon_social like @n1 and CON.razon_social like @n2 and
					  CON.razon_social like @n3 and CON.razon_social like @n4 and CON.estado=1
ELSE IF @TipoConsulta=31--datos de persona
SELECT razon_social,'' as tipo_documento,cast((ta.descripcion +'-'+PER.documento)as varchar(30)) as documento,
(case when (CON.direccCompleta is null or CON.direccCompleta ='')   then dbo._getDireccionFiscal(CON.junta_via_ID,CON.c_num,CON.c_interior,CON.c_mz,CON.c_lote,CON.c_edificio,CON.c_piso,CON.c_dpto,CON.c_tienda,'')
	  ELSE CON.direccCompleta END) AS direccCompleta
  FROM Contribuyente CON
INNER JOIN PERSONA PER ON PER.persona_ID= CON.persona_id
INNER JOIN TABLAS TA ON TA.valor= PER.tipo_documento AND TA.dep_id=3
WHERE CON.persona_id=@persona_id 
ELSE IF @TipoConsulta=32--datos de conyuge
	begin
	SELECT TOP 1 PER.NombreCompleto AS razon_social,'' as tipo_documento,
	cast((ta.descripcion +'-'+PER.documento)as varchar(30)) as documento,
	dbo._getDireccionFiscal(PER.junta_via_ID,PER.num_via,PER.interior,PER.mz,PER.lote,PER.edificio,
	PER.piso,PER.dpto,PER.tienda,'')  AS direccCompleta 	FROM relacion_contribuyente RC
	INNER JOIN PERSONA PER ON PER.persona_ID= RC.persona_id
	--inner join Contribuyente CON ON CON.persona_id=PER.persona_ID
	INNER JOIN TABLAS TA ON TA.valor= PER.tipo_documento AND TA.dep_id=3
	where tipo_relacion =1 and cod_allegado=@persona_id
	ORDER BY relacion_ID ASC
	end
ELSE IF @TipoConsulta=33--datos de REPORESENTANTE LEGAL
	begin
	Select TOP 1 CON.Contacto AS razon_social,'' as tipo_documento,
	cast(('DNI -'+con.dniRepresentante)as varchar(30)) as documento,
	CON.DireccRepresentante  as direccCompleta
	 FROM Contribuyente CON
	INNER JOIN PERSONA PER ON PER.persona_ID= CON.persona_id
	INNER JOIN TABLAS TA ON TA.valor= PER.tipo_documento AND TA.dep_id=3
	WHERE CON.persona_id= @persona_id 
	end
ELSE IF @TipoConsulta=35 --busqueda de contribuyente por direcciòn DE PREDIO, calle%,sector%
BEGIN 
	SELECT  DISTINCT top 50  PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
	SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
	--'1' AS junta_ID,'1' AS via_ID,
	ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
	ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
	ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
	ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,
	--JV1.junta_ID AS c_junta,JV1.via_ID AS c_via,
	ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
	ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
	ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,cast(ISNULL(CON.referencia,'')as varchar) AS referencia,
	ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
	FROM Contribuyente CON
	INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
	INNER JOIN PREDIO_CONTRIBUYENTE PC ON PC.persona_ID=CON.persona_id
	INNER JOIN PREDIO PRE ON PRE.predio_id=PC.predio_id
	INNER JOIN Junta_Via JV1 ON JV1.junta_via_ID=PRE.junta_via_ID
	inner join Sector s on s.Sector_id=JV1.junta_ID
	inner join via v on v.Via_id=JV1.via_ID
	WHERE --PRE.junta_via_ID LIKE @ruc AND 
	s.Descripcion like @Contacto and v.Descripcion like @DireccRepresentante and
	PRE.num_via LIKE @c_num AND  PRE.interior like @c_interior 
	AND PRE.mz LIKE @c_mz  AND PRE.lote LIKE @c_lote AND PRE.edificio LIKE @c_edificio 
	AND PRE.piso LIKE @c_piso AND PRE.dpto LIKE @c_dpto AND PRE.tienda LIKE @c_tienda 
	AND PC.estado=1 AND PRE.estado=1 and CON.estado=1 and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END
ELSE IF @TipoConsulta=36 --busqueda de contribuyente por direcciòn DE PREDIO SECTOR_ID
BEGIN 
	SELECT  DISTINCT top 50  PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
	SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
	--'1' AS junta_ID,'1' AS via_ID,
	ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
	ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
	ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
	ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,
	--JV1.junta_ID AS c_junta,JV1.via_ID AS c_via,
	ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
	ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
	ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,cast(ISNULL(CON.referencia,'')as varchar) AS referencia,
	ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
	FROM Contribuyente CON
	INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
	INNER JOIN PREDIO_CONTRIBUYENTE PC ON PC.persona_ID=CON.persona_id
	INNER JOIN PREDIO PRE ON PRE.predio_id=PC.predio_id
	INNER JOIN Junta_Via JV1 ON JV1.junta_via_ID=PRE.junta_via_ID
	inner join via v on v.Via_id=JV1.via_ID
	WHERE --PRE.junta_via_ID LIKE @ruc AND 
	JV1.junta_ID=@Contacto AND V.Descripcion LIKE @DireccRepresentante AND
	PRE.num_via LIKE @c_num AND  PRE.interior like @c_interior 
	AND PRE.mz LIKE @c_mz  AND PRE.lote LIKE @c_lote AND PRE.edificio LIKE @c_edificio 
	AND PRE.piso LIKE @c_piso AND PRE.dpto LIKE @c_dpto AND PRE.tienda LIKE @c_tienda 
	AND PC.estado=1 AND PRE.estado=1 and CON.estado=1 and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END
else IF @TipoConsulta=37--buscada por sector
BEGIN 
	SELECT  DISTINCT  PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
	SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
	--'1' AS junta_ID,'1' AS via_ID,
	ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
	ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
	ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
	ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,
	--JV1.junta_ID AS c_junta,JV1.via_ID AS c_via,
	ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
	ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
	ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,cast(ISNULL(CON.referencia,'')as varchar) AS referencia,
	ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
	FROM Contribuyente CON
	INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
	INNER JOIN PREDIO_CONTRIBUYENTE PC ON PC.persona_ID=CON.persona_id
	INNER JOIN PREDIO PRE ON PRE.predio_id=PC.predio_id
	INNER JOIN Junta_Via JV1 ON JV1.junta_via_ID=PRE.junta_via_ID
	WHERE --PRE.junta_via_ID LIKE @ruc AND 
	JV1.junta_ID=@junta_ID AND 
	PC.estado=1 AND PRE.estado=1 and CON.estado=1 and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END
else IF @TipoConsulta=38--busqueda de todos los secotres
BEGIN 
	SELECT  DISTINCT  PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
	SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
	--'1' AS junta_ID,'1' AS via_ID,
	ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
	ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
	ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
	ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,
	--JV1.junta_ID AS c_junta,JV1.via_ID AS c_via,
	ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
	ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
	ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,cast(ISNULL(CON.referencia,'')as varchar) AS referencia,
	ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante
	FROM Contribuyente CON
	INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID
	INNER JOIN PREDIO_CONTRIBUYENTE PC ON PC.persona_ID=CON.persona_id
	INNER JOIN PREDIO PRE ON PRE.predio_id=PC.predio_id
	WHERE 
	PC.estado=1 AND PRE.estado=1 and CON.estado=1 and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0
END

else if @TipoConsulta=39
BEGIN
SELECT top 100 PER.persona_ID,PER.tipo_persona,PER.paterno,PER.materno,rtrim(PER.nombres)as nombres,ISNULL(PER.fechaNacimiento,'01/01/1992') AS fechaNacimiento,PER.tipo_documento,PER.documento,
		SUBSTRING(PER.Ubi_codigo,0,3)as departamento,SUBSTRING(PER.Ubi_codigo,0,5)as provincia,PER.Ubi_codigo as distrito,ISNULL(PER.sexo,'F') AS 'sexo',
		'1' AS junta_ID,'1' AS via_ID,ISNULL(PER.num_via,'')AS num_via,ISNULL(PER.mz,'')AS mz,ISNULL(PER.interior,'')AS interior,ISNULL(CON.direccCompleta,'') AS direccCompleta,
		ISNULL(PER.Lote,'')AS Lote,ISNULL(PER.edificio,'')AS edificio,ISNULL(PER.piso,'')AS piso,ISNULL(PER.Dpto,'') AS Dpto,
		ISNULL(PER.tienda,'')AS tienda,ISNULL(PER.fono_oficina,'')AS fono_oficina,ISNULL(PER.Fono_Domicilio,'')AS Fono_Domicilio,
		ISNULL(PER.email,'')AS email,ISNULL(PER.celular,'')AS celular,'1' AS c_junta,'1' AS c_via,ISNULL(CON.c_num,'')AS c_num,ISNULL(con.c_mz,'')AS c_mz,
		ISNULL(CON.c_interior,'')AS c_interior,ISNULL(CON.c_lote,'')AS c_lote,ISNULL(CON.C_edificio,'')AS C_edificio,ISNULL(CON.c_piso,'')AS c_piso,
		ISNULL(CON.c_dpto,'')AS c_dpto,ISNULL(CON.c_tienda,'')AS c_tienda,ISNULL(PER.expediente,'')AS expediente,ISNULL(CON.referencia,'')AS referencia,
		ISNULL(CON.Contacto,'')AS Contacto,ISNULL(CON.dniRepresentante,'')AS dniRepresentante,ISNULL(CON.DireccRepresentante,'') AS DireccRepresentante,
		t.descripcion
				FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID	
				inner join tablas t on PER.tipo_persona=t.valor				
				 WHERE t.dep_id=19 and CON.ruc LIKE @ruc and CON.estado=1 and dbo.ValidaAccesoOficina (con.Junta_Via_id , @oficina)<> 0 
END 
else if @TipoConsulta=40
BEGIN
SELECT PER.persona_ID,PER.paterno,PER.materno,PER.nombres,t.descripcion as tipoDocumentoDescripcion,PER.documento,
					ISNULL(CON.direccCompleta,'') AS direccCompleta,s.Descripcion as sector , case when CON.estado =1 then 'ACTIVO' else 'INACTIVO' end estado_contribuyente
					FROM Contribuyente CON
				INNER JOIN PERSONA PER ON CON.persona_id=PER.persona_ID 
				inner join tablas t on PER.tipo_documento = t.valor
				inner join Junta_Via jv on CON.junta_via_ID = jv.junta_via_ID
				inner join Sector s on jv.junta_ID = s.Sector_id
				where CON.persona_id =@persona_id and CON.estado=1 and t.dep_id = 3 
END 
	--SELECT*FROM Persona
--SELECT*FROM TABLAS WHERE dep_id=3 DESCRIPCION LIKE'%docu%'

