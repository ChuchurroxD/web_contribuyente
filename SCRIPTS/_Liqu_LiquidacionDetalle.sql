USE [SG_Rentable]
GO
/****** Object:  StoredProcedure [dbo].[_Liqu_LiquidacionDetalle]    Script Date: 22/11/2016 09:33:11 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[_Liqu_LiquidacionDetalle] 
@tipo int,
@persona_ID varchar(9)=null,
@predio_ID varchar(16)=null,
@grupo_trib char(3)=null,
@anio_ini int=null,
@anio_fin int=null,
@mes_ini int=null,
@mes_fin int=null,
@tributos varchar(200)=null,
@liquidacion_id int = null
as begin
if @tipo=1
BEGIN
	select persona_ID,cc.predio_ID,anio,
	ROUND((case when mes=1 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as ene,
	ROUND((case when mes=2 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as feb,
	ROUND((case when mes=3 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as mar,
	ROUND((case when mes=4 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as abr,
	ROUND((case when mes=5 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as may,
	ROUND((case when mes=6 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as jun,
	ROUND((case when mes=7 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as jul,
	ROUND((case when mes=8 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as ago,
	ROUND((case when mes=9 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as sep,
	ROUND((case when mes=10 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as oct,
	ROUND((case when mes=11 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as nov,
	ROUND((case when mes=12 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as dic,
	ROUND((cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2) as tot 
		into #deuda	from CuentaCorriente cc
	inner join Tributos t on cc.tributo_ID=t.tributos_ID
	 where  cc.estado='P' 
	 and cargo>0
	 and cc.persona_ID=@persona_ID
	 and cc.predio_ID=@predio_ID
	 and t.tipo_tributo=@grupo_trib
	 AND CC.activo=1

	 select persona_ID,predio_ID ,ANIO ,cast(SUM(ENE) as decimal(12,2))AS ENE ,cast(SUM(FEB)as decimal(12,2))AS FEB,
	 cast(SUM(MAR)as decimal(12,2))AS MAR,cast(SUM(ABR)as decimal(12,2))AS ABR, cast(SUM(MAY)as decimal(12,2))AS MAY,
	 cast(SUM(JUN)as decimal(12,2))AS JUN,cast(SUM(JUL)as decimal(12,2))AS JUL,cast(SUM(AGO)as decimal(12,2))AS AGO,
	 cast(SUM(SEP)as decimal(12,2))AS SEP,cast(SUM(OCT)as decimal(12,2))AS OCT, cast(SUM(NOV)as decimal(12,2))AS NOV,
	 cast(SUM(DIC)as decimal(12,2))AS DIC,cast(SUM(TOT)as decimal(12,2))AS TOT
	  from #deuda 
		group by persona_ID,predio_ID ,ANIO
		ORDER BY ANIO
		drop table #deuda;
		END
else if @tipo=2
BEGIN

select cc.persona_ID,cc.predio_ID,cc.anio,t.tributos_ID,t.abrev,
	ROUND((case when mes=1 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as ene,
	ROUND((case when mes=2 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as feb,
	ROUND((case when mes=3 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as mar,
	ROUND((case when mes=4 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as abr,
	ROUND((case when mes=5 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as may,
	ROUND((case when mes=6 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as jun,
	ROUND((case when mes=7 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as jul,
	ROUND((case when mes=8 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as ago,
	ROUND((case when mes=9 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as sep,
	ROUND((case when mes=10 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as oct,
	ROUND((case when mes=11 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as nov,
	ROUND((case when mes=12 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)) else 0 end),2)as dic,
	ROUND((cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2) as tot 
		into #deuda2	from CuentaCorriente cc
	inner join Tributos t on cc.tributo_ID=t.tributos_ID
	where cc.persona_ID=@persona_ID 
	and cc.predio_ID=@predio_ID 
	and cc.estado='P'
	and t.tipo_tributo=@grupo_trib
	AND CC.activo=1
	and cargo>0


	select persona_ID,predio_ID,anio,tributos_ID,abrev ,cast(SUM(ENE) as decimal(12,2))AS ENE ,cast(SUM(FEB)as decimal(12,2))AS FEB,
	 cast(SUM(MAR)as decimal(12,2))AS MAR,cast(SUM(ABR)as decimal(12,2))AS ABR, cast(SUM(MAY)as decimal(12,2))AS MAY,
	 cast(SUM(JUN)as decimal(12,2))AS JUN,cast(SUM(JUL)as decimal(12,2))AS JUL,cast(SUM(AGO)as decimal(12,2))AS AGO,
	 cast(SUM(SEP)as decimal(12,2))AS SEP,cast(SUM(OCT)as decimal(12,2))AS OCT, cast(SUM(NOV)as decimal(12,2))AS NOV,
	 cast(SUM(DIC)as decimal(12,2))AS DIC,cast(SUM(TOT)as decimal(12,2))AS TOT
	  from #deuda2
	group by persona_ID,predio_ID,anio,tributos_ID,abrev
	order by persona_ID,predio_ID,anio,tributos_ID,abrev
	END
	else 

	if @tipo=3
	select cc.persona_ID,cc.predio_ID,cc.anio,t.tributos_ID,t.abrev,
sum(case when mes=1 then (cargo-abono) else 0 end)as ene,
	sum(case when mes=2 then (cargo-abono) else 0 end)as feb,
	sum(case when mes=3 then (cargo-abono) else 0 end)as mar,
	sum(case when mes=4 then (cargo-abono) else 0 end)as abr,
	sum(case when mes=5 then (cargo-abono) else 0 end)as may,
	sum(case when mes=6 then (cargo-abono) else 0 end)as jun,
	sum(case when mes=7 then (cargo-abono) else 0 end)as jul,
	sum(case when mes=8 then (cargo-abono) else 0 end)as ago,
	sum(case when mes=9 then (cargo-abono) else 0 end)as sep,
	sum(case when mes=10 then (cargo-abono) else 0 end)as oct,
	sum(case when mes=11 then (cargo-abono) else 0 end)as nov,
	sum(case when mes=12 then (cargo-abono) else 0 end)as dic,
	sum(cargo-abono)as tot from CuentaCorriente cc
	inner join Tributos t on cc.tributo_ID=t.tributos_ID
	where cc.persona_ID=@persona_ID and cc.predio_ID=@predio_ID and cc.estado='P'
	and (cc.anio*10+cc.mes) BETWEEN (@anio_ini*10+@mes_ini)and(@anio_fin*10+@mes_fin)
	and cargo>0
	group by cc.persona_ID,cc.predio_ID,cc.anio,t.tributos_ID,t.abrev
	order by cc.anio,t.abrev
	else
	if @tipo=4
	select cc.persona_ID,cc.predio_ID,cc.anio,t.tributos_ID,t.abrev,
	cast(sum(case when mes=1 then (cargo -ABONO) +
	((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono))
	 else 0 end)as decimal(12,2))as ene,
	cast(sum(case when mes=2 then (cargo -ABONO) +
	round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)
		else 0 end)as decimal(12,2))as feb,
	cast(sum(case when mes=3 then (cargo -ABONO) +
	round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)
		else 0 end)as decimal(12,2))as mar,
	cast(sum(case when mes=4 then (cargo -ABONO) +
	round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)
		else 0 end)as decimal(12,2))as abr,
	cast(sum(case when mes=5 then (cargo -ABONO) +
	round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)
		else 0 end)as decimal(12,2))as may,
	cast(sum(case when mes=6 then (cargo -ABONO) +
	round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)
		else 0 end)as decimal(12,2))as jun,
	cast(sum(case when mes=7 then (cargo -ABONO) +
	round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)
		else 0 end)as decimal(12,2))as jul,
	cast(sum(case when mes=8 then (cargo -ABONO) +
	round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)
		else 0 end)as decimal(12,2))as ago,
	cast(sum(case when mes=9 then (cargo -ABONO) +
	round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)
		else 0 end)as decimal(12,2))as sep,
	cast(sum(case when mes=10 then (cargo -ABONO) +
	round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)
		else 0 end)as decimal(12,2))as oct,
	cast(sum(case when mes=11 then (cargo -ABONO) +
	round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)
		else 0 end)as decimal(12,2))as nov,
	cast(sum(case when mes=12 then (cargo-ABONO) +
	round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2)
		else 0 end)as decimal(12,2))as dic,
	cast(sum((cargo-abono) +
	round(((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
		*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono)),2))as decimal(12,2))
		as tot from CuentaCorriente cc
	inner join Tributos t on cc.tributo_ID=t.tributos_ID
	where cc.persona_ID=@persona_ID and  cc.estado='P'and cargo>0
	and (cc.anio*100+cc.mes) BETWEEN (@anio_ini*100+@mes_ini)and(@anio_fin*100+@mes_fin)
	and  @tributos  like '%'+rtrim(t.tributos_id)+'%'
	group by cc.persona_ID,cc.predio_ID,cc.anio,t.tributos_ID,t.abrev
	order by cc.anio,t.abrev
	end
	if @tipo = 5 -- por tributo
	begin
		select cc.tributo_ID,t.abrev,anio,
		ROUND((case when mes=1 then (cargo+interes_cobrado) else 0 end),2)as ene,
		ROUND((case when mes=2 then (cargo+interes_cobrado) else 0 end),2)as feb,
		ROUND((case when mes=3 then (cargo+interes_cobrado) else 0 end),2)as mar,
		ROUND((case when mes=4 then (cargo+interes_cobrado) else 0 end),2)as abr,
		ROUND((case when mes=5 then (cargo+interes_cobrado) else 0 end),2)as may,
		ROUND((case when mes=6 then (cargo+interes_cobrado) else 0 end),2)as jun,
		ROUND((case when mes=7 then (cargo+interes_cobrado) else 0 end),2)as jul,
		ROUND((case when mes=8 then (cargo+interes_cobrado) else 0 end),2)as ago,
		ROUND((case when mes=9 then (cargo+interes_cobrado) else 0 end),2)as sep,
		ROUND((case when mes=10 then (cargo+interes_cobrado) else 0 end),2)as oct,
		ROUND((case when mes=11 then (cargo+interes_cobrado) else 0 end),2)as nov,
		ROUND((case when mes=12 then (cargo+interes_cobrado) else 0 end),2)as dic,
		ROUND((cargo+interes_cobrado),2) as tot 
			into #deuda1	from CuentaCorriente cc
		inner join Tributos t on cc.tributo_ID=t.tributos_ID
		inner join DetalleLiquidacion dt on cc.Cuenta_Corriente_ID = dt.Cuenta_Corriente_ID
		 where dt.liquidacion_id = @liquidacion_id  and cargo>0
		 AND CC.activo=1
		 select tributo_ID,abrev ,ANIO ,SUM(ENE)AS ENE ,SUM(FEB)AS FEB,SUM(MAR)AS MAR,SUM(ABR)AS ABR,SUM(MAY)AS MAY,
		 SUM(JUN)AS JUN,SUM(JUL)AS JUL,SUM(AGO)AS AGO,SUM(SEP)AS SEP,SUM(OCT)AS OCT,SUM(NOV)AS NOV,SUM(DIC)AS DIC,SUM(TOT)AS TOT
		  from #deuda1 
		group by tributo_ID ,ANIO,abrev
		ORDER BY ANIO
		drop table #deuda1;
	END
	if @tipo = 6 -- por tributo
	begin
		select (importe+Intereses) as importeTotal from liquidacion where liquidacion_id = @liquidacion_id 
	END
	--select * from CuentaCorriente cc
	--inner join Tributos t on cc.tributo_ID=t.tributos_ID
	--where cc.persona_ID='1008' and  cc.estado='P'
	--and (cc.anio*100+cc.mes) BETWEEN (1990*100+1)and(2019*100+1)
	--and  '0008'  like '%'+rtrim(t.tributos_id)+'%'
	--AND anio=2011 AND MES=1

	--select cc.persona_ID,cc.predio_ID,cc.anio,t.tributos_ID,t.abrev,
	--sum(case when mes=1 then cargo +
	--((CASE WHEN cc.fecha_vence<GETDATE() THEN DATEDIFF(DAY,cc.fecha_vence,GETDATE())else 0 end)
	--	*cobro_interes*dbo.interesLiquidacion(t.tipo_tributo)*(cargo-abono))
	-- else 0 end)as ene	
	--from CuentaCorriente cc
	--inner join Tributos t on cc.tributo_ID=t.tributos_ID
	--where cc.persona_ID='1008' and  cc.estado='P'
	--and (cc.anio*100+cc.mes) BETWEEN (1990*100+1)and(2019*100+1)
	--and  '0008'  like '%'+rtrim(t.tributos_id)+'%' AND ANIO=2011 AND MES=1
	--group by cc.persona_ID,cc.predio_ID,cc.anio,t.tributos_ID,t.abrev
	--exec [_Liqu_LiquidacionDetalle] @tipo=4,@persona_ID='1008',@predio_ID='0',@anio_ini=1993,@mes_ini=2,@anio_fin=2011,@mes_fin=1	,@TRIBUTOS='0008'

