select * from crono_fraccionamiento where nrocuota=0

para lass coutas0
que tienen monto 0 tiens que cambiarle una fecha de pago
ponles fecha de pago y ya estaria

 seponible la siguiente cuota
 pero antes se tiene
 que habilitar
 el fraccionamiento y cambiar el estado de cuenta corriente


 ya ps eso ya he hecho la vainao q tu me dijistes


 si ps pero ademas para los que quedaron en 0 su cuota 0 lo tienes
 que corregir ps

 USE SG_RENTABLE
 select * from fraccionamiento where fraccionamiento_id in(
 select fraccionamiento_id from crono_fraccionamiento where nrocuota=0 and importe=0)

 
 update cf set FechaPago=f.Fecha_Acogida
 from crono_fraccionamiento cf inner join fraccionamiento f
 on cf.Fraccionamiento_id=f.fraccionamiento_id where cf.nrocuota=0 and cf.importe=0

 update fraccionamiento set estado='A' where 
 fraccionamiento_id in(
 select fraccionamiento_id from crono_fraccionamiento where nrocuota=0 and importe=0)

 update CuentaCorriente set estado='F' where cuenta_corriente_ID in
			(select cuenta_corriente_ID from fraccionamiento f 
			inner join det_fraccionamiento df on f.fraccionamiento_id=df.Fraccionamiento_id
			where f.fraccionamiento_id in ( 
 select fraccionamiento_id from crono_fraccionamiento where nrocuota=0 and importe=0))











 ahora revisa si todo ya quedo

 como asi???

 revisa ps
 habia
 fraccionamiento
 que no se podian agar y cosas asi
 claro ps pero la vaina es q cuando hago un nuevo fraccionamiento 
 se me pone 0
 supuestamente con lo q yo hice ya no me aparece 0.

 correlo a ver
 crea uno
 estas modo
 loca verdadd?

 siii ps normal..

 apura ps altoque
 que tngo que salir

 oe pero lo pruebo kn lo q yo hice ese dia.. o q porq con lo q hice ese dia no lcquieras pruebalo
 pero con cuota 0
 inicial

 esta mal lo que has hecho 

 al generar el fraccionamiento
 crea otro


 ya esta mira alli no me aparece la couta 0


select * from pago_detalle_tributo where pagos_id in(select Pagos_id from pagos where FechaPago >dateadd(dd,-1,getdate()))

crea otro fraccionamiento para seguir probando

declare @tipo int=9
declare @nrocuota int=3
declare @fraccionamiento_ID int=67
declare @pago_ID int=176937

declare @fecha_aco datetime;
		declare @fecha_ven datetime;
		declare @cta_ int;
		declare @cob_int decimal(10,2);
		declare @tasa_int decimal(10,5);
		declare @deuda decimal(12,5);
		declare @interes decimal(12,5);
		declare @valorCuota decimal(12,5);
		declare @tribbb char(5);
		declare @an int;
		declare @me int;

		if @nroCuota=0 
		begin
			declare @derecho decimal(12,2)
			update CuentaCorriente set estado='F' where cuenta_corriente_ID in
			(select cuenta_corriente_ID from fraccionamiento f 
			inner join det_fraccionamiento df on f.fraccionamiento_id=df.Fraccionamiento_id

			where f.fraccionamiento_id=@fraccionamiento_ID);
			update fraccionamiento set Estado='A' where fraccionamiento_id=@fraccionamiento_ID
			select @derecho=tf.monto_derecho from fraccionamiento f
			inner join TipoFraccionamiento tf on f.tipo_fraccionamiento_ID=tf.tipo_fraccionamiento_ID
			where fraccionamiento_id=@fraccionamiento_ID
			if @derecho>0			
				insert into pago_detalle_tributo(pagos_ID,monto_pago,tributos_ID,anio,mes,clai_codigo)
				values(@pago_ID,@derecho,'0148 ',datepart(yy,getdate()),datepart(mm,getdate()),
				'1.3. 2.10. 1.99')				
			end		
		select @valorCuota=amortizacion from crono_fraccionamiento 
		where Fraccionamiento_id=@fraccionamiento_ID and NroCuota=@nroCuota
		
		declare cuentas cursor for
		SELECT f.Fecha_Acogida,cc.fecha_vence, cc.cuenta_corriente_ID,df.cobro_interes,df.tasa_interes,(cc.cargo-cc.abono)as deuda,
		((CASE WHEN cc.fecha_vence<f.Fecha_Acogida THEN DATEDIFF(DAY,cc.fecha_vence,f.Fecha_Acogida)else 0 end)
		*df.cobro_interes*df.tasa_interes*(cargo-abono))as interes,cc.tributo_ID ,cc.anio,cc.mes
		FROM det_fraccionamiento DF
		INNER JOIN CuentaCorriente CC ON DF.Cuenta_Corriente_id=CC.cuenta_corriente_ID
		inner join fraccionamiento f on df.Fraccionamiento_id=f.fraccionamiento_id
		WHERE CC.estado='P' and f.fraccionamiento_id=67
		order by cc.anio,cc.mes,cc.tributo_ID


		OPEN cuentas
		FETCH cuentas INTO @fecha_aco, @fecha_ven,@cta_,@cob_int ,@tasa_int, @deuda ,@interes,@tribbb,@an,@me
		WHILE (@@FETCH_STATUS = 0)
		BEGIN	
		if @valorCuota>0
			begin
			if @valorCuota>@deuda+@interes
				begin			
					update CuentaCorriente set abono=cargo , estado='C',fecha_cancelacion=getdate() where cuenta_corriente_ID=@cta_
					set @valorCuota=@valorCuota - (@deuda+@interes)				
					insert into pago_detalle_tributo(pagos_ID,monto_pago,tributos_ID,cuenta_corriente_ID,anio,mes,
					clai_codigo,EsActual)
					select @pago_ID,@deuda+@interes,tributo_ID,cuenta_corriente_ID,anio,mes,
					(case 
			when t.clai_codigo='1.1. 2. 1. 1. 1' then 
				(case when datepart(yy,getdate())>anio then '1.1.2.1.1.2' else '1.1. 2. 1. 1. 1' end)
			when t.clai_codigo='1.3. 3. 9. 2.23.1' then 
				(case when datepart(yy,getdate())>anio then '1.3. 3. 9. 2.23.2' else '1.3. 3. 9. 2.23.1' end)
				else t.clai_codigo end),
				(case when DATEPART(yy,GETDATE())>anio then 0 else 1 end)
					 from CuentaCorriente cc
					inner join tributos t on  cc.tributo_ID=t.tributos_ID
					where cuenta_corriente_ID=@cta_

					insert into pago_detalle_tributo (pagos_ID,monto_pago,tributos_ID,cuenta_corriente_ID,anio,mes,cantidad)
					values(@pago_ID,@deuda,@tribbb,@cta_,@an,@me,1)
					select @pago_ID,@deuda,@tribbb,@cta_,@an,@me,1
				end
				else
				begin
					if(@nroCuota=(select max(NroCuota) from crono_fraccionamiento where Fraccionamiento_id=@fraccionamiento_ID))
						begin
						update CuentaCorriente set abono=cargo , estado='C',fecha_cancelacion=getdate() 
						where cuenta_corriente_ID=@cta_					
						insert into pago_detalle_tributo(pagos_ID,monto_pago,tributos_ID,cuenta_corriente_ID,anio,mes)
						select @pago_ID,@deuda+@interes,tributo_ID,cuenta_corriente_ID,anio,mes from CuentaCorriente
						where cuenta_corriente_ID=@cta_

						insert into pago_detalle_tributo (pagos_ID,monto_pago,tributos_ID,cuenta_corriente_ID,anio,mes,cantidad)
						values(@pago_ID,@deuda,@tribbb,@cta_,@an,@me,1)

						select @pago_ID,@deuda,@tribbb,@cta_,@an,@me,1

						end
					else
					begin
						update CuentaCorriente set abono=abono+dbo._getMontoEfectivoPago(@tasa_int,
						@valorCuota,@fecha_ven,@fecha_aco,@cob_int)where cuenta_corriente_ID=@cta_
						insert into pago_detalle_tributo(pagos_ID,monto_pago,tributos_ID,
						cuenta_corriente_ID,anio,mes,cantidad,clai_codigo)
						select @pago_ID,@valorCuota,tributo_ID,cuenta_corriente_ID,anio,mes,1,t.clai_codigo from CuentaCorriente cc
						inner join Tributos t on cc.tributo_ID=t.tributos_ID
						where cuenta_corriente_ID=@cta_

						insert into pago_detalle_tributo (pagos_ID,monto_pago,tributos_ID,cuenta_corriente_ID,anio,mes,cantidad)
						values(@pago_ID,dbo._getMontoEfectivoPago(@tasa_int,
						@valorCuota,@fecha_ven,@fecha_aco,@cob_int),@tribbb,@cta_,@an,@me,1)
						select @pago_ID,dbo._getMontoEfectivoPago(@tasa_int,
						@valorCuota,@fecha_ven,@fecha_aco,@cob_int),@tribbb,@cta_,@an,@me,1
					end
					set @valorCuota=0				 
				end 
			end	
		FETCH cuentas INTO @fecha_aco, @fecha_ven,@cta_,@cob_int ,@tasa_int, @deuda ,@interes,@tribbb,@an,@me
		END 
		CLOSE cuentas
		DEALLOCATE cuentas 
		update crono_fraccionamiento set FechaPago=getdate()
		where Fraccionamiento_id=@fraccionamiento_ID and NroCuota=@nroCuota	