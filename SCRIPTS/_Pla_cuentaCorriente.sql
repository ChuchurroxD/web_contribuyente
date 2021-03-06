USE [SG_Rentable]
GO
/****** Object:  StoredProcedure [dbo].[_Pla_cuentaCorriente]    Script Date: 30/11/2016 08:58:13 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
--==========PROCEDIMIENTO CuentaCorrienteUpdate ========================
--===========================================================================================
--===========================================================================================
create PROCEDURE [dbo].[_Pla_cuentaCorriente]             
             @persona_ID    char(9)=Null,
			 @anio    char(9)=Null,
			 @tipoconsulta tinyint
AS 
if @tipoconsulta=1 
Begin
	if object_id( 'tempdb..##tabla2') is not null drop table ##tabla2; 
    SELECT 
		CC.anio,
		cargoPredio = sum(case when T.tributos_ID = '0008' then CC.cargo else 0 end),
		abonoPredio = sum(case when T.tributos_ID = '0008' then CC.abono else 0 end),
		deudaPredio = sum(case when T.tributos_ID = '0008' then CC.cargo-CC.abono else 0 end),
		interesPredio = sum(case when T.tributos_ID = '0008' then CC.interes_cobrado else 0 end),
		cargoArbitrio = sum(case when T.tributos_ID = '0043' then CC.cargo else 0 end),
		abonoArbitrio = sum(case when T.tributos_ID = '0043' then CC.abono else 0 end),
		deudaArbitrio = sum(case when T.tributos_ID = '0043' then CC.cargo-CC.abono else 0 end),
		interesArbitrio = sum(case when T.tributos_ID = '0043' then CC.interes_cobrado else 0 end),
		cargoTotal = sum(case when T.tributos_ID = '0008' then CC.cargo else 0 end) + sum(case when T.tributos_ID = '0043' then CC.cargo else 0 end),
		abonoTotal = sum(case when T.tributos_ID = '0008' then CC.abono else 0 end) + sum(case when T.tributos_ID = '0043' then CC.abono else 0 end),
		deudaNeta = sum(case when T.tributos_ID = '0008' then CC.cargo-CC.abono else 0 end) + sum(case when T.tributos_ID = '0043' then CC.cargo-CC.abono else 0 end),
		deudaTotal = sum(case when T.tributos_ID = '0008' then CC.cargo-CC.abono else 0 end) + sum(case when T.tributos_ID = '0043' then CC.cargo-CC.abono else 0 end) + sum(case when T.tributos_ID = '0008' then CC.interes_cobrado else 0 end) + sum(case when T.tributos_ID = '0043' then CC.interes_cobrado else 0 end)
	INTO ##tabla2
	FROM CuentaCorriente CC 
	INNER JOIN Tributos T ON T.tributos_ID = CC.tributo_ID
	WHERE CC.persona_ID = @persona_ID AND CC.activo = 1
	GROUP BY CC.anio
	ORDER BY CC.anio DESC

	SELECT 
		1 AS ROW,
		'Resumen: ' AS anio,
		sum(cargoPredio) AS totalCargoP,
		sum(abonoPredio) AS totalAbonoP,
		sum(deudaPredio) AS totalDeudaP,
		sum(interesPredio) AS totalInteresP,
		sum(cargoArbitrio) AS totalCargoA,
		sum(abonoArbitrio) AS totalAbonoA,
		sum(deudaArbitrio) AS totalDeudaA,
		sum(interesArbitrio) AS totalInteresA,
		sum(cargoTotal) AS totalCargoT,
		sum(abonoTotal) AS totalAbonoT,
		sum(deudaNeta) AS totalDeudaN,
		sum(deudaTotal) AS totalDeudaT
	FROM ##tabla2
	UNION
	SELECT
			anio AS row,
			CONVERT(varchar(10),anio) AS anio,
			cargoPredio, abonoPredio, deudaPredio, interesPredio,
			cargoArbitrio, abonoArbitrio, deudaArbitrio, interesArbitrio,
			cargoTotal, abonoTotal, deudaNeta, deudaTotal
	FROM ##tabla2 
	ORDER BY row DESC
End

if @tipoconsulta=2 
Begin
	if object_id( 'tempdb..##tabla3') is not null drop table ##tabla3; 
    SELECT 
		CC.mes,
		cargoPredio = sum(case when T.tributos_ID = '0008' then CC.cargo else 0 end),
		abonoPredio = sum(case when T.tributos_ID = '0008' then CC.abono else 0 end),
		deudaPredio = sum(case when T.tributos_ID = '0008' then CC.cargo-CC.abono else 0 end),
		interesPredio = sum(case when T.tributos_ID = '0008' then CC.interes_cobrado else 0 end),
		cargoArbitrio = sum(case when T.tributos_ID = '0043' then CC.cargo else 0 end),
		abonoArbitrio = sum(case when T.tributos_ID = '0043' then CC.abono else 0 end),
		deudaArbitrio = sum(case when T.tributos_ID = '0043' then CC.cargo-CC.abono else 0 end),
		interesArbitrio = sum(case when T.tributos_ID = '0043' then CC.interes_cobrado else 0 end),
		cargoTotal = sum(case when T.tributos_ID = '0008' then CC.cargo else 0 end) + sum(case when T.tributos_ID = '0043' then CC.cargo else 0 end),
		abonoTotal = sum(case when T.tributos_ID = '0008' then CC.abono else 0 end) + sum(case when T.tributos_ID = '0043' then CC.abono else 0 end),
		deudaNeta = sum(case when T.tributos_ID = '0008' then CC.cargo-CC.abono else 0 end) + sum(case when T.tributos_ID = '0043' then CC.cargo-CC.abono else 0 end),
		deudaTotal = sum(case when T.tributos_ID = '0008' then CC.cargo-CC.abono else 0 end) + sum(case when T.tributos_ID = '0043' then CC.cargo-CC.abono else 0 end) + sum(case when T.tributos_ID = '0008' then CC.interes_cobrado else 0 end) + sum(case when T.tributos_ID = '0043' then CC.interes_cobrado else 0 end)
	INTO ##tabla3
	FROM CuentaCorriente CC 
	INNER JOIN Tributos T ON T.tributos_ID = CC.tributo_ID
	WHERE CC.persona_ID = @persona_ID AND CC.activo = 1 AND CC.anio = @anio 
	GROUP BY CC.mes
	ORDER BY CC.mes DESC

	SELECT 
		20 AS ROW,
		'Resumen: ' AS mes,
		sum(cargoPredio) AS totalCargoP,
		sum(abonoPredio) AS totalAbonoP,
		sum(deudaPredio) AS totalDeudaP,
		sum(interesPredio) AS totalInteresP,
		sum(cargoArbitrio) AS totalCargoA,
		sum(abonoArbitrio) AS totalAbonoA,
		sum(deudaArbitrio) AS totalDeudaA,
		sum(interesArbitrio) AS totalInteresA,
		sum(cargoTotal) AS totalCargoT,
		sum(abonoTotal) AS totalAbonoT,
		sum(deudaNeta) AS totalDeudaN,
		sum(deudaTotal) AS totalDeudaT
	FROM ##tabla3
	UNION
	SELECT
		  mes AS row,
		  DATENAME(month , DateAdd( month , mes, 0 ) - 1),
		   cargoPredio, abonoPredio, deudaPredio, interesPredio,
		   cargoArbitrio, abonoArbitrio, deudaArbitrio, interesArbitrio,
		   cargoTotal, abonoTotal, deudaNeta, deudaTotal
	FROM ##tabla3 
	ORDER BY row asc
End

if @tipoconsulta=3 
Begin
	SELECT 
		CC.anio,
		cargoPredio = sum(case when T.tributos_ID = '0008' then CC.cargo else 0 end),
		abonoPredio = sum(case when T.tributos_ID = '0008' then CC.abono else 0 end),
		deudaPredio = sum(case when T.tributos_ID = '0008' then CC.cargo-CC.abono else 0 end),
		interesPredio = sum(case when T.tributos_ID = '0008' then CC.interes_cobrado else 0 end),
		cargoArbitrio = sum(case when T.tributos_ID = '0043' then CC.cargo else 0 end),
		abonoArbitrio = sum(case when T.tributos_ID = '0043' then CC.abono else 0 end),
		deudaArbitrio = sum(case when T.tributos_ID = '0043' then CC.cargo-CC.abono else 0 end),
		interesArbitrio = sum(case when T.tributos_ID = '0043' then CC.interes_cobrado else 0 end),
		cargoTotal = sum(case when T.tributos_ID = '0008' then CC.cargo else 0 end) + sum(case when T.tributos_ID = '0043' then CC.cargo else 0 end),
		abonoTotal = sum(case when T.tributos_ID = '0008' then CC.abono else 0 end) + sum(case when T.tributos_ID = '0043' then CC.abono else 0 end),
		deudaNeta = sum(case when T.tributos_ID = '0008' then CC.cargo-CC.abono else 0 end) + sum(case when T.tributos_ID = '0043' then CC.cargo-CC.abono else 0 end),
		deudaTotal = sum(case when T.tributos_ID = '0008' then CC.cargo-CC.abono else 0 end) + sum(case when T.tributos_ID = '0043' then CC.cargo-CC.abono else 0 end) + sum(case when T.tributos_ID = '0008' then CC.interes_cobrado else 0 end) + sum(case when T.tributos_ID = '0043' then CC.interes_cobrado else 0 end)
	
	FROM CuentaCorriente CC 
	INNER JOIN Tributos T ON T.tributos_ID = CC.tributo_ID
	WHERE CC.persona_ID = @persona_ID AND CC.activo = 1
	GROUP BY CC.anio
	ORDER BY CC.anio DESC
End

if @tipoconsulta=4
Begin
	 SELECT 
		CC.anio,		
		cargoTotal = sum(case when T.tributos_ID = '0008' then CC.cargo else 0 end) + sum(case when T.tributos_ID = '0043' then CC.cargo else 0 end),
		abonoTotal = sum(case when T.tributos_ID = '0008' then CC.abono else 0 end) + sum(case when T.tributos_ID = '0043' then CC.abono else 0 end)
	FROM CuentaCorriente CC 
	INNER JOIN Tributos T ON T.tributos_ID = CC.tributo_ID
	WHERE CC.persona_ID = @persona_ID AND CC.activo = 1
	GROUP BY CC.anio
	ORDER BY CC.anio DESC

End
