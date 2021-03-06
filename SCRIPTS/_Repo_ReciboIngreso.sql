USE [SG_Rentable]
GO
/****** Object:  StoredProcedure [dbo].[_Repo_ReciboIngreso]    Script Date: 22/11/2016 09:32:46 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[_Repo_ReciboIngreso](
	@pago_id int = null,
	@tipoConsulta int
) 	 
AS
	SET NOCOUNT ON
	declare @total DECIMAL(12,2)
	declare @totalDesc varchar(100)
	declare @cantidad int
	if object_id( 'tempdb..##tabla1') is not null drop table ##tabla1;
	if object_id( 'tempdb..##tabla2') is not null drop table ##tabla2;
	IF @tipoConsulta = 1
	BEGIN	
	select @total=MontoTotal from Pagos where Pagos_id=@pago_id
	set @cantidad=10-(select count(*) from pago_detalle_tributo where pagos_ID=@pago_id)
	set @totalDesc=(select dbo.CantidadConLetra(@total))
		SELECT 
			C.persona_id AS 'CÓDIGO PERSONA',
			left((case when c.ruc='00000000' then '0' else rtrim(c.ruc) end)+'-'+ rtrim(C.razon_social),35) AS 'NOMBRE COMPLETO',
			left(C.direccCompleta,30) AS 'DIRECCIÓN',
			p.codigo_voucher AS 'CÓDIGO PAGO',		
			T.clai_codigo AS 'ESPECIFICA',
			CONCAT(left(T.descripcion,20), ' - ' , cast(pd.mes as varchar), ' - ',PD.anio) AS 'CONCEPTO',
			PD.monto_pago AS 'IMPORTE'		,
			@totalDesc AS pagoDesc		into ##tabla1 
		FROM pago_detalle_tributo PD
		inner join Pagos p on pd.pagos_ID=p.Pagos_id
		INNER JOIN Tributos T ON T.tributos_ID = PD.tributos_ID		
		INNER JOIN CuentaCorriente CC ON CC.Cuenta_Corriente_ID = PD.cuenta_corriente_ID
		INNER JOIN Contribuyente C ON C.persona_ID = CC.persona_ID
		
		WHERE p.pagos_ID = @pago_id
		ORDER BY PD.mes, PD.anio
		WHILE (@cantidad>0)
		BEGIN  
			insert into ##tabla1([CÓDIGO PERSONA],[NOMBRE COMPLETO],DIRECCIÓN,[CÓDIGO PAGO],ESPECIFICA,CONCEPTO,
			IMPORTE,pagoDesc)values('','','','','','',0,'')
			set @cantidad=@cantidad-1
		END 
		select * from ##tabla1
	END	
	else IF @tipoConsulta = 2
	BEGIN	
	set @cantidad=10-(select count(*) from pago_detalle_tributo where pagos_ID=@pago_id)
	select @total=MontoTotal from Pagos where Pagos_id=@pago_id
	set @totalDesc=(select dbo.CantidadConLetra(@total))
		SELECT 
			p.Persona_id AS 'CÓDIGO PERSONA',
			left(rtrim(p.Pagante),35) AS 'NOMBRE COMPLETO',
			'' AS 'DIRECCIÓN',
			p.codigo_voucher AS 'CÓDIGO PAGO',		
			pd.clai_codigo AS 'ESPECIFICA',
			CONCAT(left(pd.descripcion,20), ' - ' ,  cast(PD.mes as varchar), ' - ',PD.anio,' - ',PD.cantidad) AS 'CONCEPTO',
			PD.monto_pago AS 'IMPORTE'		,
			@totalDesc AS pagoDesc	into ##tabla2	
		FROM pago_detalle_tributo PD
		inner join Pagos p on pd.pagos_ID=p.Pagos_id
		--INNER JOIN Tributos T ON T.tributos_ID = PD.tributos_ID		
		WHERE p.pagos_ID = @pago_id
		ORDER BY PD.mes, PD.anio
		WHILE (@cantidad>0)
		BEGIN  
			insert into ##tabla2([CÓDIGO PERSONA],[NOMBRE COMPLETO],DIRECCIÓN,[CÓDIGO PAGO],ESPECIFICA,CONCEPTO,
			IMPORTE,pagoDesc)values('','','','','','',0,'')
			set @cantidad=@cantidad-1
		END 
		select * from ##tabla2
	END
	else IF @tipoConsulta = 3
	BEGIN	
	select @total=MontoTotal from Pagos where Pagos_id=@pago_id
	set @totalDesc=(select dbo.CantidadConLetra(@total))
		SELECT 
			p.Persona_id AS 'codigo_persona',
			left(rtrim(p.Pagante),35) AS 'nombre_completo',
			'' AS 'direccion',
			p.codigo_voucher AS 'voucher',
			@totalDesc AS pagoDesc,
			p.liquidacion_ID, CONVERT (char(10), P.FechaPago, 105) as Fecha_Pago,
			convert(varchar,p.fechaPago,108) as hora, ISNULL(CON.direccCompleta,'') AS direccCompleta,
			(SELECT CONCAT(PE.paterno,' ',PE.materno,' ',PE.nombres) FROM cajeroCaja CC INNER JOIN Pagos P ON P.CajeroCaja_id = CC.CajeroCaja_id
			INNER JOIN persona PE on PE.persona_id = CC.Persona_id
			GROUP BY PE.paterno,PE.materno, PE.nombres) AS Cajero, (select C.Descripcion from Caja C INNER JOIN CajeroCaja CC on CC.Caja_id = C.Caja_id INNER JOIN Pagos P ON P.CajeroCaja_id = CC.CajeroCaja_id group by C.Descripcion) as caja
		FROM pago_detalle_tributo PD
		inner join Pagos p on pd.pagos_ID=p.Pagos_id
		inner join Contribuyente CON on CON.Persona_id = P.Persona_id
		--INNER JOIN Tributos T ON T.tributos_ID = PD.tributos_ID		
		WHERE p.pagos_ID = @pago_id	
		GROUP BY p.Persona_id, p.codigo_voucher, p.Pagante,p.liquidacion_ID, P.FechaPago,CON.direccCompleta
	END

	else IF @tipoConsulta = 4
	BEGIN		
	select @total=MontoTotal from Pagos where Pagos_id=@pago_id
	set @totalDesc=(select dbo.CantidadConLetra(@total))
		SELECT 
			p.Persona_id AS 'CÓDIGO PERSONA',
			left(rtrim(p.Pagante),35) AS 'NOMBRE COMPLETO',
			'' AS 'DIRECCIÓN',
			p.codigo_voucher AS 'CÓDIGO PAGO',		
			pd.clai_codigo AS 'ESPECIFICA',
			CONCAT(left(pd.descripcion,20), ' - ' ,  cast(PD.mes as varchar), ' - ',PD.anio,' - ',PD.cantidad) AS 'CONCEPTO',
			PD.monto_pago AS 'IMPORTE'		,
			@totalDesc AS pagoDesc
		FROM pago_detalle_tributo PD
		inner join Pagos p on pd.pagos_ID=p.Pagos_id
		--INNER JOIN Tributos T ON T.tributos_ID = PD.tributos_ID		
		WHERE p.pagos_ID = @pago_id
		ORDER BY PD.mes, PD.anio
	END
	
	--exec _Repo_ReciboIngreso @pago_id = '175811', @tipoConsulta = 2

