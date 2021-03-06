USE [SG_Rentable]
GO
/****** Object:  StoredProcedure [dbo].[_Pago_CuentaCorriente]    Script Date: 10/12/2016 11:51:46 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
--==========PROCEDIMIENTO CuentaCorrienteUpdate ========================
--===========================================================================================
--===========================================================================================
ALTER PROCEDURE [dbo].[_Pago_CuentaCorriente]
             @cuenta_corriente_ID    int=Null output,
             @persona_ID    char(9)=Null,
             @predio_ID    char(16)=Null,
             @tributo_ID    char(5)=Null,
             @anio    int=null,
             @mes    int=Null,
             @fecha_vence    datetime=Null,
             @cargo    decimal(9)=Null,
             @abono    decimal(9)=Null,
             @fecha_cancelacion    datetime=Null,
             @observaciones    varchar(100)=Null,
             @estado    char(1)=Null,
             @activo    bit=Null,
             @fecha_generacion    datetime=Null,
             @tipo_opera    int=Null,
             @fecha_anula_descarga    datetime=Null,
             @num_operacion    int=Null,
             @registro_user_add    int=Null,
             @registro_fecha_add    datetime=Null,
             @registro_pc_add    varchar(40)=Null,
             @registro_user_update    int=Null,
             @registro_fecha_update    datetime=Null,
             @registro_pc_update    varchar(40)=Null,
             @interes_cobrado    decimal(9)=Null,
			 @tributo_IDPredio    char(5)=Null,
			 @tributo_IDArbitrio    char(5)=Null,
			 @tributo_IDFormulario    char(5)=Null,
			 @tributo_IDAlcabala    char(5)=Null,
			 @tributo_IDTodos	 char(5)=null,
			 @TipoConsulta tinyint
AS 
if @TipoConsulta=1 
Begin
             UPDATE dbo.[CuentaCorriente]SET 
                          [persona_ID]=@persona_ID,
                          [predio_ID]=@predio_ID,
                          [tributo_ID]=@tributo_ID,
                          [anio]=@anio,
                          [mes]=@mes,
                          [fecha_vence]=@fecha_vence,
                          [cargo]=@cargo,
                          [abono]=@abono,
                          [fecha_cancelacion]=@fecha_cancelacion,
                          [observaciones]=@observaciones,
                          [estado]=@estado,
                          [activo]=@activo,
                          [fecha_generacion]=@fecha_generacion,
                          [tipo_opera]=@tipo_opera,
                          [fecha_anula_descarga]=@fecha_anula_descarga,
                          [num_operacion]=@num_operacion,
                          [registro_user_add]=@registro_user_add,
                          [registro_fecha_add]=@registro_fecha_add,
                          [registro_pc_add]=@registro_pc_add,
                          [registro_user_update]=@registro_user_update,
                          [registro_fecha_update]=@registro_fecha_update,
                          [registro_pc_update]=@registro_pc_update,
                          [interes_cobrado]=@interes_cobrado
             WHERE  cuenta_corriente_ID = @cuenta_corriente_ID

End

--===========================================================================================
--==========PROCEDIMIENTO CuentaCorrienteGetByAll ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=2
begin
Select * from CuentaCorriente order by anio,tributo_ID
End

--===========================================================================================
--==========PROCEDIMIENTO CuentaCorrienteGetByPrimaryKey ===============
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=3
begin
Select * from CuentaCorriente
WHERE  cuenta_corriente_ID = @cuenta_corriente_ID
End

--===========================================================================================
--==========PROCEDIMIENTO CuentaCorrienteInsert ========================
--===========================================================================================
--===========================================================================================
else if @TipoConsulta=4
Begin
             INSERT INTO [dbo].[CuentaCorriente]
             (
                          [persona_ID],
                          [predio_ID],
                          [tributo_ID],
                          [anio],
                          [mes],
                          [fecha_vence],
                          [cargo],
                          [abono],
                          [fecha_cancelacion],
                          [observaciones],
                          [estado],
                          [activo],
                          [fecha_generacion],
                          [tipo_opera],
                          [fecha_anula_descarga],
                          [num_operacion],
                          [registro_user_add],
                          [registro_fecha_add],
                          [registro_pc_add],
                          [registro_user_update],
                          [registro_fecha_update],
                          [registro_pc_update],
                          [interes_cobrado]

             )
             VALUES
             (
                          @persona_ID,
                          @predio_ID,
                          @tributo_ID,
                          @anio,
                          @mes,
                          @fecha_vence,
                          @cargo,
                          @abono,
                          @fecha_cancelacion,
                          @observaciones,
                          @estado,
                          @activo,
                          @fecha_generacion,
                          @tipo_opera,
                          @fecha_anula_descarga,
                          @num_operacion,
                          @registro_user_add,
                          @registro_fecha_add,
                          @registro_pc_add,
                          @registro_user_update,
                          @registro_fecha_update,
                          @registro_pc_update,
                          @interes_cobrado

             )
             SET @cuenta_corriente_ID= @@IDENTITY
End
else if @TipoConsulta =5 --cuenta corriente de contribuyente
begin
	select cc.cuenta_corriente_ID,cc.persona_ID,cc.predio_ID,cc.tributo_ID,cc.fecha_vence,cc.anio,t.descripcion as tributo,ta.descripcion as tipo_tributo,
	case when cc.fecha_cancelacion is not null then SUM(cc.abono) else 0 end Pagado , case when cc.fecha_cancelacion is null then SUM(cc.cargo+cc.interes_cobrado) else 0 end Pendiente
	, SUM(cargo+interes_cobrado) as total, cc.mes,cc.estado
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.valor
	where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 48
	group by cc.cuenta_corriente_ID,cc.persona_ID,cc.predio_ID,cc.tributo_ID,cc.fecha_vence,cc.anio,t.descripcion,ta.descripcion,cc.fecha_cancelacion, cc.mes,cc.estado
end

else if @TipoConsulta = 6
	select isnull(SUM(cargo + interes_cobrado),0) as total, isnull(SUM(case when fecha_cancelacion is not null then cargo + interes_cobrado else 0 end),0) as pendiente_total ,
	isnull(SUM(case when fecha_cancelacion is null then cargo + interes_cobrado else 0 end),0) as Pagado_Total
	from CuentaCorriente where persona_ID = @persona_ID

else if @TipoConsulta = 7
	select 
		cc.cuenta_corriente_ID,
		cc.persona_ID,
		cc.predio_ID,
		cc.tributo_ID,
		cc.fecha_vence,
		cc.anio,
		t.descripcion as tributo,
		ta.descripcion as tipo_tributo,
		case when cc.fecha_cancelacion is not null then SUM(cc.abono) else 0 end Pagado ,
		case when cc.fecha_cancelacion is null then SUM(cc.cargo+cc.interes_cobrado) else 0 end Pendiente, 
		SUM(cargo+interes_cobrado) as total,
		cc.mes,
		cc.estado
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.valor
	where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 48 and t.tributos_ID =@tributo_ID and cc.anio = @anio
	group by cc.cuenta_corriente_ID,cc.persona_ID,cc.predio_ID,cc.tributo_ID,cc.fecha_vence,cc.anio,t.descripcion,ta.descripcion,cc.fecha_cancelacion, cc.mes,cc.estado

 else if @TipoConsulta = 8 -- todos los periodos seleccionando tributo
	select cc.cuenta_corriente_ID,
	cc.persona_ID,
	cc.predio_ID,
	cc.tributo_ID,
	CAST(cc.fecha_vence AS DATE)AS fecha_vence,cc.anio,t.descripcion as tributo,ta.descripcion as tipo_tributo,
	 SUM(cc.abono) as Pagado ,  SUM(cc.cargo-cc.abono) as Pendiente
	, SUM(cargo) as total, cc.mes,t2.descripcion as estado
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.valor
	where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 48 and (t.tributos_ID =@tributo_ID or @tributo_ID='')
	and (cc.anio=@anio or @anio=0)and cc.estado in ('p','f')
	group by cc.cuenta_corriente_ID,cc.persona_ID,cc.predio_ID,cc.tributo_ID,cc.fecha_vence,
	cc.anio,t.descripcion,ta.descripcion,cc.fecha_cancelacion, cc.mes,t2.descripcion 
	order by cc.anio,cc.mes,ta.descripcion

 else if @TipoConsulta = 9 -- todos tributos seleccionando periodo
	select 
		cc.cuenta_corriente_ID,
		cc.persona_ID,
		cc.predio_ID,
		cc.tributo_ID,
		cc.fecha_vence,
		cc.anio,
		t.descripcion as tributo,
		ta.descripcion as tipo_tributo,
		case when cc.fecha_cancelacion is not null then SUM(cc.abono) else 0 end Pagado , 
		case when cc.fecha_cancelacion is null then SUM(cc.cargo + cc.interes_cobrado) else 0 end Pendiente,
		SUM(cargo+interes_cobrado) as total, 
		cc.mes,
		cc.estado
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.valor
	where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 48 and cc.anio = @anio
	group by cc.cuenta_corriente_ID,cc.persona_ID,cc.predio_ID,cc.tributo_ID,cc.fecha_vence,cc.anio,t.descripcion,ta.descripcion,cc.fecha_cancelacion, cc.mes,cc.estado

else if @TipoConsulta = 10 -- selecciona tributos y periodo
	select isnull(SUM(cargo + interes_cobrado),0) as total, isnull(SUM(case when fecha_cancelacion is not null then cargo + interes_cobrado else 0 end),0) as pendiente_total ,
	isnull(SUM(case when fecha_cancelacion is null then cargo + interes_cobrado else 0 end),0) as Pagado_Total
	from CuentaCorriente where persona_ID = @persona_ID and tributo_ID = @tributo_ID and anio = @anio

else if @TipoConsulta = 11 -- selecciona tributo y todos los periodos
	select isnull(SUM(cargo + interes_cobrado),0) as total, isnull(SUM(case when fecha_cancelacion is not null then cargo + interes_cobrado else 0 end),0) as pendiente_total ,
	isnull(SUM(case when fecha_cancelacion is null then cargo + interes_cobrado else 0 end),0) as Pagado_Total
	from CuentaCorriente where persona_ID = @persona_ID and tributo_ID = @tributo_ID
else if @TipoConsulta = 12 -- selecciona periodo y todos los tributos
	select isnull(SUM(cargo + interes_cobrado),0) as total, isnull(SUM(case when fecha_cancelacion is not null then cargo + interes_cobrado else 0 end),0) as pendiente_total ,
	isnull(SUM(case when fecha_cancelacion is null then cargo + interes_cobrado else 0 end),0) as Pagado_Total
	from CuentaCorriente where persona_ID = @persona_ID and anio = @anio
	
else if @TipoConsulta = 13
	select cc.cuenta_corriente_ID,cc.persona_ID,cc.predio_ID,cc.tributo_ID,cc.fecha_vence,cc.anio,t.descripcion as tributo,ta.descripcion as tipo_tributo,
	 SUM(cc.abono) as Pagado ,  SUM(cc.cargo-cc.abono) as Pendiente
	, SUM(cargo) as total, cc.mes,t2.descripcion as estado
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.valor
	where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 48 and (t.tributos_ID =@tributo_ID or @tributo_ID='')
	and (cc.anio=@anio or @anio=0)and cc.estado in ('p','f','c')
	group by cc.cuenta_corriente_ID,cc.persona_ID,cc.predio_ID,cc.tributo_ID,cc.fecha_vence,
	cc.anio,t.descripcion,ta.descripcion,cc.fecha_cancelacion, cc.mes,t2.descripcion 
	order by cc.anio, cc.tributo_id
else if @TipoConsulta = 14
BEGIN
	SELECT cc.cuenta_corriente_ID,
	CC.persona_ID,
	CC.predio_ID,
	CC.tributo_ID, 
	CAST(CC.fecha_vence AS DATE) AS fecha_vence, CC.anio, T.descripcion AS tributo, TA.descripcion AS tipo_tributo,
	 ( CASE WHEN CC.estado = 'P' THEN SUM(cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.abono)
			WHEN CC.estado = 'B' THEN SUM(CC.cargo)
			WHEN CC.estado = 'Q' THEN SUM(CC.cargo)
			ELSE 0.00	
	 END) AS Pagado ,
	 (  CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'B' THEN 0.00
			WHEN CC.estado = 'Q' THEN 0.00
			ELSE 0.00	
	 END ) AS Pendiente, 
	(CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo)
			WHEN CC.estado = 'B' THEN SUM(cc.cargo)
			WHEN CC.estado = 'Q' THEN SUM(cc.cargo)
			ELSE 0.00		 
	END) AS total, 
	CC.mes, T2.descripcion AS estado
	from CuentaCorriente CC 
	INNER JOIN Tributos T on CC.tributo_ID = t.tributos_ID
	INNER JOIN tablas TA on T.tipo_tributo = TA.valor
	INNER JOIN tablas T2 on CC.estado = T2.abrev
	--where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 48 and (t.tributos_ID =@tributo_ID or @tributo_ID='')
	WHERE persona_ID = @persona_ID AND ta.dep_id = 1 and t2.dep_id = 50 
	AND (T.tributos_ID = @tributo_IDPredio OR T.tributos_ID = @tributo_IDArbitrio OR T.tributos_ID = @tributo_IDFormulario OR T.tributos_ID = @tributo_IDAlcabala OR @tributo_IDTodos = '')
	AND (CC.anio=@anio or @anio=0) AND CC.estado IN ('B', 'E', 'M', 'S', 'D', 'X', 'F', 'N', 'P', 'T', 'Q')
	AND CC.cargo >= 0
	GROUP by CC.cuenta_corriente_ID, CC.persona_ID, CC.predio_ID, CC.tributo_ID, CC.fecha_vence,
	CC.anio, T.descripcion, TA.descripcion, CC.fecha_cancelacion, CC.mes, T2.descripcion, CC.estado
	order by CC.anio, CC.mes, ta.descripcion
END
ELSE IF @tipoConsulta = 15
BEGIN
	SELECT 
	CC.cuenta_corriente_ID,
	CC.persona_ID,
	CC.predio_ID,
	CC.tributo_ID,
	CC.fecha_vence, 
	CC.anio, T.descripcion AS tributo, TA.descripcion AS tipo_tributo,
	( CASE WHEN CC.estado = 'P' THEN SUM(CC.abono)
			WHEN CC.estado = 'F' THEN SUM(CC.abono)
			WHEN CC.estado = 'B' THEN SUM(CC.cargo)
			WHEN CC.estado = 'Q' THEN SUM(CC.cargo)
			WHEN CC.estado = 'C' THEN SUM(CC.abono)
			ELSE 0.00	
	 END) AS Pagado ,
	 (  CASE WHEN CC.estado = 'P' THEN SUM(CC.cargo - CC.abono)
			WHEN CC.estado = 'F' THEN SUM(CC.cargo - CC.abono)
			WHEN CC.estado = 'B' THEN 0.00
			WHEN CC.estado = 'Q' THEN 0.00
			WHEN CC.estado = 'C' THEN SUM(CC.cargo - CC.abono)
			ELSE 0.00	
	 END ) AS Pendiente, 
	(CASE WHEN CC.estado = 'P' THEN SUM(CC.cargo)
			WHEN CC.estado = 'F' THEN SUM(CC.cargo)
			WHEN CC.estado = 'B' THEN SUM(CC.cargo)
			WHEN CC.estado = 'Q' THEN SUM(CC.cargo)
			WHEN CC.estado = 'C' THEN SUM(CC.cargo)
			ELSE 0.00		 
	END) AS total,
	CC.mes, T2.descripcion AS estado
	from CuentaCorriente CC 
	INNER JOIN Tributos T ON CC.tributo_ID = T.tributos_ID
	INNER JOIN tablas TA ON T.tipo_tributo = TA.valor
	INNER JOIN tablas T2 ON CC.estado = T2.abrev
	WHERE persona_ID = @persona_ID AND ta.dep_id = 1 AND t2.dep_id = 50
	AND (T.tributos_ID = @tributo_IDPredio OR T.tributos_ID = @tributo_IDArbitrio OR t.tributos_ID = @tributo_IDFormulario OR t.tributos_ID = @tributo_IDAlcabala OR @tributo_IDTodos = '')
	AND (CC.anio = @anio or @anio = 0) AND CC.estado IN ( 'B', 'E', 'M', 'S', 'D', 'X', 'F', 'N', 'P', 'T', 'C')
	AND CC.cargo >= 0
	GROUP BY CC.cuenta_corriente_ID, CC.persona_ID, CC.predio_ID, CC.tributo_ID, CC.fecha_vence,
	CC.anio, T.descripcion, TA.descripcion, CC.fecha_cancelacion, CC.mes,t2.descripcion, CC.estado
	ORDER BY CC.anio, CC.tributo_id
END
ELSE IF @tipoConsulta = 16
BEGIN
	select cc.cuenta_corriente_ID,
	cc.persona_ID,
	cc.predio_ID,
	cc.tributo_ID,
	cc.fecha_vence,cc.anio,t.descripcion as tributo,ta.descripcion as tipo_tributo,
	( CASE WHEN CC.estado = 'P' THEN SUM(cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.abono)
			WHEN CC.estado = 'B' THEN SUM(CC.cargo)
			WHEN CC.estado = 'Q' THEN SUM(CC.cargo)
			WHEN CC.estado = 'C' THEN SUM(cc.abono)
			ELSE 0.00	
	 END) as Pagado ,
	 (  CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'B' THEN 0.00
			WHEN CC.estado = 'Q' THEN 0.00
			WHEN CC.estado = 'C' THEN SUM(cc.cargo-cc.abono)
			ELSE 0.00	
	 END )as Pendiente, 
	(CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo)
			WHEN CC.estado = 'B' THEN SUM(cc.cargo)
			WHEN CC.estado = 'Q' THEN SUM(cc.cargo)
			WHEN CC.estado = 'C' THEN SUM(cc.cargo)
			ELSE 0.00		 
	END) as total,
	cc.mes,t2.descripcion as estado
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.abrev
	where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 50
	and cc.estado in ( 'B', 'P', 'Q', 'C')
	group by cc.cuenta_corriente_ID,cc.persona_ID,cc.predio_ID,cc.tributo_ID,cc.fecha_vence,
	cc.anio,t.descripcion,ta.descripcion,cc.fecha_cancelacion, cc.mes,t2.descripcion, cc.estado
	order by cc.anio, cc.tributo_id
END
ELSE IF @tipoConsulta = 17
BEGIN
	select cc.cuenta_corriente_ID,
	cc.persona_ID,
	cc.predio_ID,
	cc.tributo_ID,
	cc.fecha_vence,cc.anio,t.descripcion as tributo,ta.descripcion as tipo_tributo,
	( CASE WHEN CC.estado = 'P' THEN SUM(cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.abono)
			WHEN CC.estado = 'B' THEN SUM(CC.cargo)
			WHEN CC.estado = 'Q' THEN SUM(CC.cargo)
			WHEN CC.estado = 'C' THEN SUM(cc.abono)
			ELSE 0.00	
	 END) as Pagado ,
	 (  CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'B' THEN 0.00
			WHEN CC.estado = 'Q' THEN 0.00
			WHEN CC.estado = 'C' THEN SUM(cc.cargo-cc.abono)
			ELSE 0.00	
	 END )as Pendiente, 
	(CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo)
			WHEN CC.estado = 'B' THEN SUM(cc.cargo)
			WHEN CC.estado = 'Q' THEN SUM(cc.cargo)
			WHEN CC.estado = 'C' THEN SUM(cc.cargo)
			ELSE 0.00		 
	END) as total,
	cc.mes,t2.descripcion as estado
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.abrev
	where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 50	
	and (cc.anio=@anio or @anio=0)and cc.estado in ( 'B', 'P', 'Q', 'C')
	group by cc.cuenta_corriente_ID,cc.persona_ID,cc.predio_ID,cc.tributo_ID,cc.fecha_vence,
	cc.anio,t.descripcion,ta.descripcion,cc.fecha_cancelacion, cc.mes,t2.descripcion, cc.estado
	order by cc.anio, cc.tributo_id
END
ELSE IF @tipoConsulta = 18
BEGIN
	select cc.cuenta_corriente_ID,
	cc.persona_ID,
	cc.predio_ID,
	cc.tributo_ID,
	cc.fecha_vence,cc.anio,t.descripcion as tributo,ta.descripcion as tipo_tributo,
	( CASE WHEN CC.estado = 'P' THEN SUM(cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.abono)
			WHEN CC.estado = 'B' THEN SUM(CC.cargo)
			WHEN CC.estado = 'Q' THEN SUM(CC.cargo)
			WHEN CC.estado = 'C' THEN SUM(cc.abono)
			ELSE 0.00	
	 END) as Pagado ,
	 (  CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'B' THEN 0.00
			WHEN CC.estado = 'Q' THEN 0.00
			WHEN CC.estado = 'C' THEN SUM(cc.cargo-cc.abono)
			ELSE 0.00	
	 END )as Pendiente, 
	(CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo)
			WHEN CC.estado = 'B' THEN SUM(cc.cargo)
			WHEN CC.estado = 'Q' THEN SUM(cc.cargo)
			WHEN CC.estado = 'C' THEN SUM(cc.cargo)
			ELSE 0.00		 
	END) as total,
	cc.mes,t2.descripcion as estado, CONVERT (char(10), CC.fecha_vence, 103) as fechaVencimiento
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.abrev
	where persona_ID = 8080 and ta.dep_id = 1 and t2.dep_id = 50 and t2.descripcion = 'Pendiente'
	and cc.estado in ( 'B', 'P', 'Q', 'C')
	group by cc.cuenta_corriente_ID,cc.persona_ID,cc.predio_ID,cc.tributo_ID,cc.fecha_vence,
	cc.anio,t.descripcion,ta.descripcion,cc.fecha_cancelacion, cc.mes,t2.descripcion, cc.estado
	order by cc.anio, cc.tributo_id, cc.mes
END
ELSE IF @tipoConsulta = 19
BEGIN
	IF @anio = '' and @tributo_ID = ''
	BEGIN 
		select cc.cuenta_corriente_ID,
	cc.persona_ID,
	cc.predio_ID,
	cc.tributo_ID,
	cc.fecha_vence,cc.anio,t.descripcion as tributo,ta.descripcion as tipo_tributo,
	( CASE WHEN CC.estado = 'P' THEN SUM(cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.abono)
			WHEN CC.estado = 'B' THEN SUM(CC.cargo)
			WHEN CC.estado = 'Q' THEN SUM(CC.cargo)
			WHEN CC.estado = 'C' THEN SUM(cc.abono)
			ELSE 0.00	
	 END) as Pagado ,
	 (  CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'B' THEN 0.00
			WHEN CC.estado = 'Q' THEN 0.00
			WHEN CC.estado = 'C' THEN SUM(cc.cargo-cc.abono)
			ELSE 0.00	
	 END )as Pendiente, 
	(CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo)
			WHEN CC.estado = 'B' THEN SUM(cc.cargo)
			WHEN CC.estado = 'Q' THEN SUM(cc.cargo)
			WHEN CC.estado = 'C' THEN SUM(cc.cargo)
			ELSE 0.00		 
	END) as total,
	cc.mes,t2.descripcion as estado,CONVERT (char(10), CC.fecha_vence, 103) as fechaVencimiento
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.abrev
	where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 50 and t2.descripcion = 'Pendiente'
	and cc.estado in ( 'B', 'P', 'Q', 'C')
	group by cc.cuenta_corriente_ID,cc.persona_ID,cc.predio_ID,cc.tributo_ID,cc.fecha_vence,
	cc.anio,t.descripcion,ta.descripcion,cc.fecha_cancelacion, cc.mes,t2.descripcion, cc.estado
	order by cc.anio, cc.tributo_id, cc.mes end
	ELSE
	IF @anio = ''
	BEGIN 
		select cc.cuenta_corriente_ID,
	cc.persona_ID,
	cc.predio_ID,
	cc.tributo_ID,
	cc.fecha_vence,cc.anio,t.descripcion as tributo,ta.descripcion as tipo_tributo,
	( CASE WHEN CC.estado = 'P' THEN SUM(cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.abono)
			WHEN CC.estado = 'B' THEN SUM(CC.cargo)
			WHEN CC.estado = 'Q' THEN SUM(CC.cargo)
			WHEN CC.estado = 'C' THEN SUM(cc.abono)
			ELSE 0.00	
	 END) as Pagado ,
	 (  CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'B' THEN 0.00
			WHEN CC.estado = 'Q' THEN 0.00
			WHEN CC.estado = 'C' THEN SUM(cc.cargo-cc.abono)
			ELSE 0.00	
	 END )as Pendiente, 
	(CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo)
			WHEN CC.estado = 'B' THEN SUM(cc.cargo)
			WHEN CC.estado = 'Q' THEN SUM(cc.cargo)
			WHEN CC.estado = 'C' THEN SUM(cc.cargo)
			ELSE 0.00		 
	END) as total,
	cc.mes,t2.descripcion as estado, CONVERT (char(10), CC.fecha_vence, 103) as fechaVencimiento
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.abrev
	where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 50 and t2.descripcion = 'Pendiente'
	and cc.estado in ( 'B', 'P', 'Q', 'C') and t.tributos_ID = @tributo_ID
	group by cc.cuenta_corriente_ID,cc.persona_ID,cc.predio_ID,cc.tributo_ID,cc.fecha_vence,
	cc.anio,t.descripcion,ta.descripcion,cc.fecha_cancelacion, cc.mes,t2.descripcion, cc.estado
	order by cc.anio, cc.tributo_id, cc.mes end
	ELSE
	IF @tributo_ID = ''
	BEGIN 
		select cc.cuenta_corriente_ID,
	cc.persona_ID,
	cc.predio_ID,
	cc.tributo_ID,
	cc.fecha_vence,cc.anio,t.descripcion as tributo,ta.descripcion as tipo_tributo,
	( CASE WHEN CC.estado = 'P' THEN SUM(cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.abono)
			WHEN CC.estado = 'B' THEN SUM(CC.cargo)
			WHEN CC.estado = 'Q' THEN SUM(CC.cargo)
			WHEN CC.estado = 'C' THEN SUM(cc.abono)
			ELSE 0.00	
	 END) as Pagado ,
	 (  CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'B' THEN 0.00
			WHEN CC.estado = 'Q' THEN 0.00
			WHEN CC.estado = 'C' THEN SUM(cc.cargo-cc.abono)
			ELSE 0.00	
	 END )as Pendiente, 
	(CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo)
			WHEN CC.estado = 'B' THEN SUM(cc.cargo)
			WHEN CC.estado = 'Q' THEN SUM(cc.cargo)
			WHEN CC.estado = 'C' THEN SUM(cc.cargo)
			ELSE 0.00		 
	END) as total,
	cc.mes,t2.descripcion as estado, CONVERT (char(10), CC.fecha_vence, 103) as fechaVencimiento
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.abrev
	where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 50 and t2.descripcion = 'Pendiente'
	and cc.estado in ( 'B', 'P', 'Q', 'C') and cc.anio = @anio
	group by cc.cuenta_corriente_ID,cc.persona_ID,cc.predio_ID,cc.tributo_ID,cc.fecha_vence,
	cc.anio,t.descripcion,ta.descripcion,cc.fecha_cancelacion, cc.mes,t2.descripcion, cc.estado
	order by cc.anio, cc.tributo_id, cc.mes end
	ELSE
		select cc.cuenta_corriente_ID,
	cc.persona_ID,
	cc.predio_ID,
	cc.tributo_ID,
	cc.fecha_vence,cc.anio,t.descripcion as tributo,ta.descripcion as tipo_tributo,
	( CASE WHEN CC.estado = 'P' THEN SUM(cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.abono)
			WHEN CC.estado = 'B' THEN SUM(CC.cargo)
			WHEN CC.estado = 'Q' THEN SUM(CC.cargo)
			WHEN CC.estado = 'C' THEN SUM(cc.abono)
			ELSE 0.00	
	 END) as Pagado ,
	 (  CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo-cc.abono)
			WHEN CC.estado = 'B' THEN 0.00
			WHEN CC.estado = 'Q' THEN 0.00
			WHEN CC.estado = 'C' THEN SUM(cc.cargo-cc.abono)
			ELSE 0.00	
	 END )as Pendiente, 
	(CASE WHEN CC.estado = 'P' THEN SUM(cc.cargo)
			WHEN CC.estado = 'F' THEN SUM(cc.cargo)
			WHEN CC.estado = 'B' THEN SUM(cc.cargo)
			WHEN CC.estado = 'Q' THEN SUM(cc.cargo)
			WHEN CC.estado = 'C' THEN SUM(cc.cargo)
			ELSE 0.00		 
	END) as total,
	cc.mes,t2.descripcion as estado, CONVERT (char(10), CC.fecha_vence, 103) as fechaVencimiento
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.abrev
	where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 50 and t2.descripcion = 'Pendiente'
	and cc.estado in ( 'B', 'P', 'Q', 'C') and t.tributos_ID = @tributo_ID and cc.anio = @anio
	group by cc.cuenta_corriente_ID,cc.persona_ID,cc.predio_ID,cc.tributo_ID,cc.fecha_vence,
	cc.anio,t.descripcion,ta.descripcion,cc.fecha_cancelacion, cc.mes,t2.descripcion, cc.estado
	order by cc.anio, cc.tributo_id, cc.mes
	END
	ELSE IF @tipoConsulta = 20
BEGIN
	IF @anio = '' and @tributo_ID = ''
	BEGIN 
		select sum(cargo) as total
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.abrev
	where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 50 and t2.descripcion = 'Pendiente'
	and cc.estado in ( 'B', 'P', 'Q', 'C')
	end
	ELSE
	IF @anio = ''
	BEGIN 
		select sum(cargo) as total
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.abrev
	where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 50 and t2.descripcion = 'Pendiente'
	and cc.estado in ( 'B', 'P', 'Q', 'C') and t.tributos_ID = @tributo_ID
	 end
	ELSE
	IF @tributo_ID = ''
	BEGIN 
		select sum(cargo) as total
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.abrev
	where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 50 and t2.descripcion = 'Pendiente'
	and cc.estado in ( 'B', 'P', 'Q', 'C') and cc.anio = @anio
	 end
	ELSE
		select sum(cargo) as total
	from CuentaCorriente cc inner join Tributos t on cc.tributo_ID = t.tributos_ID
	inner join tablas ta on t.tipo_tributo = ta.valor
	inner join tablas t2 on cc.estado = t2.abrev
	where persona_ID = @persona_ID and ta.dep_id = 1 and t2.dep_id = 50 and t2.descripcion = 'Pendiente'
	and cc.estado in ( 'B', 'P', 'Q', 'C') and t.tributos_ID = @tributo_ID and cc.anio = @anio
	
	END
ELSE IF @tipoConsulta = 21
BEGIN
	SELECT distinct 
		P.predio_ID + ' - ' + ISNULL(P.direccion_completa, 'Sin direcciòn') as 'direccion_completa',
		P.predio_ID 
	FROM PREDIO P
	INNER JOIN PREDio_COntribuyente PC ON P.predio_ID=PC.Predio_id
	WHERE PC.persona_ID = @persona_ID AND (PC.idPeriodo = @anio OR @anio = 0) AND P.estado=1 AND PC.estado=1
	UNION ALL
	SELECT 'TODOS', '0' ORDER BY direccion_completa desc
END





