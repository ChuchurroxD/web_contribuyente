
var dia = document.getElementById('param_fechaInicio');
var date = new Date();
var añoActual = date.getFullYear();
//FUNCIONES
function alCargarDocumento(){
    dia.value=añoActual + "-01-01";  
}

//EVENTOS
window.addEventListener("load", alCargarDocumento);


window.onload = function()
{  
    $('#tablaLiquidacion').dataTable({
        "bPaginate": true,
        "bFilter": false,
        "bInfo": false
    });   
    $('#mensaje').html("Información del Predio en el Año Actual por defecto"); 
    mostrarMenu();
    mostrarPeriodo();
    $('#predios').show(); 
    $('#estadoDeudas').hide(); 
    $('#cuentaCorriente').hide();   
    $('#relaciones').hide(); 
    $('#fraccionamiento').hide();
    $('#liquidaciones').hide(); 
    $('#recibosCobranza').hide(); 
    $('#pagos').hide(); 
    $('#valores').hide(); 
    $('#pagosDetalle').hide(); 
    $('#detalle_liquidacion').hide();
    $('#fraccionamientoDetalle').hide();   
    $('#predioDetalle').hide();
    mostrarContribuyente();    
    mostrarPrediosActual();    
    mostrarTipoPago();
    mostrarCajero(); 
    mostrarCaja();  
};

$(function() {
    $('#verPredios').on('click', function(){ 
        event.preventDefault();
       $('#predios').show(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').hide(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').hide(); 
        $('#valores').hide();
        $('#pagosDetalle').hide();
        $('#detalle_liquidacion').hide();
        $('#fraccionamientoDetalle').hide(); 
        $('#predioDetalle').hide();   
        mostrarPeriodo(); 
        mostrarPrediosPorPeriodo();    
    }); 

    $('#verDeudas').on('click', function(){
        event.preventDefault();
        $('#predios').hide(); 
        $('#estadoDeudas').show(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').hide(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').hide(); 
        $('#valores').hide(); 
        $('#pagosDetalle').hide();
        $('#detalle_liquidacion').hide();
        $('#fraccionamientoDetalle').hide(); 
        $('#predioDetalle').hide(); 
        mostrarPeriodoDeuda();   
        mostrarTributos();  
        mostrarEstadoDeuda();       
    }); 

    $('#verCuentaCorriente').on('click', function(){ 
        event.preventDefault();
        $('#predios').hide(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').show();
        $('#relaciones').hide(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').hide(); 
        $('#valores').hide();
        $('#pagosDetalle').hide();
        $('#detalle_liquidacion').hide();
        $('#fraccionamientoDetalle').hide(); 
        $('#predioDetalle').hide();
        mostrarComboPeriodoCuenta();
        mostrarCuentaCorrienteAnual();                
    });

    $('#verRelaciones').on('click', function(){ 
        event.preventDefault();
        $('#predios').hide(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').show(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').hide(); 
        $('#valores').hide();
        $('#pagosDetalle').hide();
        $('#detalle_liquidacion').hide();
        $('#fraccionamientoDetalle').hide();   
        $('#predioDetalle').hide();       
        mostrarRelaciones();
    });

    $('#verFraccionamiento').on('click', function(){ 
        event.preventDefault();
        $('#predios').hide(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').hide(); 
        $('#fraccionamiento').show(); 
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').hide(); 
        $('#valores').hide(); 
        $('#pagosDetalle').hide();
        $('#detalle_liquidacion').hide();
        $('#fraccionamientoDetalle').hide();  
        $('#predioDetalle').hide(); 
        mostrarFraccionamientos();  
    });

    $('#verLiquidaciones').on('click', function(){ 
        event.preventDefault();
        $('#predios').hide(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').hide(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').show(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').hide(); 
        $('#valores').hide();  
        $('#pagosDetalle').hide(); 
        $('#detalle_liquidacion').hide();
        $('#fraccionamientoDetalle').hide();   
        $('#predioDetalle').hide();
        mostrarComboPeriodoLiquidacion();          
        mostrarLiquidacionTodos();  
    });

    $('#verRecibosCobranza').on('click', function(){ 
        event.preventDefault();
        $('#predios').hide(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').hide(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').show(); 
        $('#pagos').hide(); 
        $('#valores').hide();
        $('#pagosDetalle').hide(); 
        $('#detalle_liquidacion').hide();
        $('#fraccionamientoDetalle').hide();   
        $('#predioDetalle').hide();
        mostrarPeriodoRecibos();
        mostrarRecibos();
    });

    $('#verPagos').on('click', function(){ 
        event.preventDefault();
        $('#predios').hide(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').hide(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').show(); 
        $('#valores').hide(); 
        $('#pagosDetalle').hide();
        $('#detalle_liquidacion').hide();
        $('#fraccionamientoDetalle').hide();  
        $('#predioDetalle').hide();
        mostrarPagos();
        
    });

    $('#verValores').on('click', function(){ 
        event.preventDefault();
        $('#mensajeValores').html("Información Valores de Cobranza en el Año Actual por defecto"); 
        $('#predios').hide(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').hide(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').hide(); 
        $('#valores').show(); 
        $('#pagosDetalle').hide();
        $('#detalle_liquidacion').hide();
        $('#fraccionamientoDetalle').hide(); 
        $('#predioDetalle').hide();         
        mostrarPeriodoValores();
        mostrarValoresActual();  
    });

    $('#busqueda').on('click', function(){ 
        event.preventDefault();
        mostrarPagosBusqueda();
        $('#mensajePagos').hide();
        $('#detalle_liquidacion').hide();
        $('#fraccionamientoDetalle').hide();   
    });

    $('#volverPago').on('click', function(){ 
        event.preventDefault();
        $('#pagos').show(); 
        $('#pagosDetalle').hide();
        $('#detalle_liquidacion').hide();
        $('#fraccionamientoDetalle').hide();  
        mostrarPagos();
    });

    $('#volverLiquidacion').on('click', function(){ 
        event.preventDefault();
        $('#liquidaciones').show(); 
        $('#detalle_liquidacion').hide();
        $('#fraccionamientoDetalle').hide();          
        //
        var param_anio_liqui= document.getElementById('param_periodo_liquidacion').value;
        var param_mes_liqui= document.getElementById('param_mes_liquidacion').value;
        if (param_mes_liqui == '0' && param_anio_liqui == '0') {
            mostrarLiquidacionTodos();
        } else {
            mostrarLiquiPeriodo();
        }
    });

    $('#volverFraccionamiento').on('click', function(){ 
        event.preventDefault();
        $('#fraccionamiento').show(); 
        $('#fraccionamientoDetalle').hide();          
        mostrarFraccionamientos();
    });   

    $('#listarRecibos').on('click', function(){ 
        event.preventDefault();        
        mostrarRecibosBusqueda();
    });
});


function mostrarMenu() {
    event.preventDefault();
    var grupo = document.getElementById('NombreGrupo').value;
    var tarea = document.getElementById('NombreTarea').value;    
    $.ajax({
        type:'POST',
        data: 'opcion=mostrarMenu&grupo='+grupo+'&tarea='+tarea,        
        url: "../../controller/controlusuario/usuario.php",
        success:function(data){                              
            $('#permisos').html(data);                
        }
    });
}

function mostrarContribuyente(){
    event.preventDefault();
    var param_opcion = 'datos_contribuyente'
    //alert(grupo);
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,
        dataType: 'json',
        url: "../../controller/controlInformacion/contribuyente_controller.php",
        success:function(data){ 
            if(data.length > 0) {
               $.each(data, function (i, value) {
                    $("#nombres").html(value["paterno"]+' '+value["materno"]+' '+value["nombres"]);
                    $("#docIdentidad").html(value["tipoDocumentoDescripcion"]+' - '+value["documento"]);
                    $("#codigo").html(value["persona_ID"]);
                    $("#direccion").html(value["direccCompleta"]);
                    $("#sector").html(value["sector"]);
                    $("#estadoCuenta").html(value["estado_contribuyente"]);
                    
                });
            }                                        
        }
    });
}

function mostrarPeriodo(){
    event.preventDefault();
    var param_opcion = 'mostrar_periodo'
    //alert(grupo);
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/contribuyente_controller.php",
        success:function(data){         
            $('#periodo').html(data);                                            
        }
    });
}

function mostrarRelaciones(){
    event.preventDefault();
    var param_opcion = 'mostrar_relaciones';
    //alert(grupo);
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/contribuyente_controller.php",
        success:function(data){         
            $('#cuerpoRelaciones').html(data);   
        }
    });
}


function mostrarPeriodoValores(){
    event.preventDefault();
    var param_opcion = 'mostrar_periodo_valores'
    //alert(grupo);
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/contribuyente_controller.php",
        success:function(data){         
            $('#periodoValores').html(data);   
        }
    });
}

function mostrarPrediosActual(){   
    event.preventDefault();
   //alert('Predios del año actual');
   var param_opcion = 'opcion_predios_actual'
   $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/contribuyente_controller.php",
        success:function(data){         
            $('#cuerpoPredios').html(data);                                
        }
    });
}

function mostrarValoresActual(){  
    event.preventDefault(); 
   //alert('Predios del año actual');
   var param_opcion = 'opcion_valores_actual'
   $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/contribuyente_controller.php",
        success:function(data){         
            $('#cuerpoValores').html(data);                                
        }
    });
}

function mostrarPrediosPorPeriodo(){
    event.preventDefault();
   var param_periodo = document.getElementById('param_periodo').value; 
   $('#mensaje').html("Información del Predio en el Año: "+param_periodo); 
   var param_opcion = 'opcion_predio_seleccionado'
   $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_periodo='+param_periodo,        
        url: "../../controller/controlInformacion/contribuyente_controller.php",
        success:function(data){         
            $('#cuerpoPredios').html(data);                                
        }
    });
}

function mostrarValoresPorPeriodo(){
    event.preventDefault();
   var param_periodo = document.getElementById('param_periodo_valores').value; 
   $('#mensaje').html("Información Valores de Cobranza en el Año: "+param_periodo); 
   var param_opcion = 'opcion_valores_seleccionado'
   $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_periodo='+param_periodo,        
        url: "../../controller/controlInformacion/contribuyente_controller.php",
        success:function(data){         
            $('#cuerpoValores').html(data);                                
        }
    });
}

function mostrarTipoPago(){
    event.preventDefault();
    var param_opcion = 'mostrar_combo_tipo_pago'    
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/contribuyente_controller.php",
        success:function(data){         
            $('#tipoPago').html(data);                                            
        }
    });
}

function mostrarCajero(){
    event.preventDefault();
    var param_opcion = 'mostrar_combo_cajero'    
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/contribuyente_controller.php",
        success:function(data){         
            $('#cajero').html(data);                                            
        }
    });
}

function mostrarCaja(){
    event.preventDefault();
    var param_opcion = 'mostrar_combo_caja'    
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/contribuyente_controller.php",
        success:function(data){         
            $('#caja').html(data);                                            
        }
    });
}

function mostrarPagos(){  
    event.preventDefault();  
    var param_fechaInicio = document.getElementById('param_fechaInicio').value; 
    var param_fechaFin = document.getElementById('param_fechaFin').value; 
    var param_tipoPago = document.getElementById('param_tipoPago').value; 
    var param_cajero = document.getElementById('param_cajero').value; 
    var param_caja = document.getElementById('param_caja').value;     
    var param_opcion = 'mostrar_pagos';    
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_fechaInicio='+param_fechaInicio+'&param_fechaFin='+param_fechaFin+'&param_tipoPago='+param_tipoPago+'&param_cajero='+param_cajero+'&param_caja='+param_caja,  
        url: "../../controller/controlInformacion/contribuyente_controller.php",
        success:function(data){         
            $('#cuerpoPagos').html(data); 
        }            
    });
}

function mostrarPagosBusqueda(){  
    event.preventDefault();  
    var param_fechaInicio = document.getElementById('param_fechaInicio').value; 
    var param_fechaFin = document.getElementById('param_fechaFin').value; 
    var param_tipoPago = document.getElementById('param_tipoPago').value; 
    var param_cajero = document.getElementById('param_cajero').value; 
    var param_caja = document.getElementById('param_caja').value;     
    var param_opcion = 'mostrar_pagos_busqueda';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_fechaInicio='+param_fechaInicio+'&param_fechaFin='+param_fechaFin+'&param_tipoPago='+param_tipoPago+'&param_cajero='+param_cajero+'&param_caja='+param_caja,  
        url: "../../controller/controlInformacion/contribuyente_controller.php",
        success:function(data){         
            $('#cuerpoPagos').html(data);                                            
        }
    });
}

function detallesPago(pagoID){ 
    event.preventDefault();      
    $('#pagos').hide(); 
    $('#pagosDetalle').show();
    var param_opcion = 'mostrar_pagos_detalle_cabecera';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_pagoID='+pagoID,  
        url: "../../controller/controlInformacion/contribuyente_controller.php",
        success:function(data){         
            $('#cuerpoPagosDetalleCabecera').html(data);    
            pago_detalle(pagoID);
        }
    });        
}

function pago_detalle(pagoID){ 
    event.preventDefault();     
    var param_opcion = 'mostrar_pagos_detalle';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_pagoID='+pagoID,  
        url: "../../controller/controlInformacion/contribuyente_controller.php",
        success:function(data){         
            $('#cuerpoPagosDetalle').html(data);                
        }
    });        
}

function imprimir_pago(pagoID){ 
    event.preventDefault();   
    open("../Reportes/reporte_pago.php?pagoID=" + pagoID + "", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes, top=100,left=300, width: 800,height: 400");    
}

function mostrarComboPeriodoLiquidacion(){
    event.preventDefault();
    var param_opcion = 'mostrar_combo_periodo_liquidacion'    
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/combos_controller.php",
        success:function(data){         
            $('#periodoLiquidacion').html(data);                                            
        }
    });
}

function mostrarComboPeriodoCuenta(){
    event.preventDefault();
    var param_opcion = 'mostrar_combo_periodo_cuenta'    
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/combos_controller.php",
        success:function(data){         
            $('#periodoCuenta').html(data);                                            
        }
    });
}

function mostrarLiquidacionTodos(){
    event.preventDefault();
    var param_opcion = 'mostrar_todas_liquidaciones'    
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/liquidacion_controller.php",
        success:function(data){         
            $('#tablaLiquidacion').DataTable().destroy();
            $('#cuerpoLiquidacion').html(data);
            $('#tablaLiquidacion').DataTable();
            mostrarTotalLiquidacion();                                            
        }
    });
}

function mostrarLiquiPeriodo(){
    event.preventDefault();
    var param_anio = document.getElementById('param_periodo_liquidacion').value; 
    var param_mes = document.getElementById('param_mes_liquidacion').value; 
    var param_opcion = 'mostrar_busqueda_liquidaciones';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_anio='+param_anio+'&param_mes='+param_mes,        
        url: "../../controller/controlInformacion/liquidacion_controller.php",
        success:function(data){         
            $('#tablaLiquidacion').DataTable().destroy();
            $('#cuerpoLiquidacion').html(data);
            $('#tablaLiquidacion').DataTable();
            mostrarTotalLiquidacionBusqueda();                                            
        }
    });
}

function mostrarTotalLiquidacion(){
    event.preventDefault();    
    var param_opcion = 'mostrar_total_liquidaciones';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/liquidacion_controller.php",
        success:function(data){         
            $('#cuerpoLiquidacionTotal').html(data);                                        
        }
    });
}

function mostrarTotalLiquidacionBusqueda(){
    event.preventDefault();    
    var param_anio = document.getElementById('param_periodo_liquidacion').value; 
    var param_mes = document.getElementById('param_mes_liquidacion').value; 
    var param_opcion = 'mostrar_total_liquidaciones_busqueda';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_anio='+param_anio+'&param_mes='+param_mes,        
        url: "../../controller/controlInformacion/liquidacion_controller.php",
        success:function(data){         
            $('#cuerpoLiquidacionTotal').html(data);                                        
        }
    });
}

function detallesLiquidacion(liquidacionID){ 
    event.preventDefault();      
    $('#liquidaciones').hide(); 
    $('#detalle_liquidacion').show();
    $('#mensajeLiquidacion').html("DETALLE DE LIQUIDACIÓN N° "+liquidacionID); 
    var param_opcion = 'mostrar_liquidacion_detalle';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_liquidacionID='+liquidacionID,  
        url: "../../controller/controlInformacion/liquidacion_controller.php",            
        success:function(data){         
            $('#cuerpoLiquidacionDetalle').html(data);                
        }
    });    
}

function imprimir_liquidacion(liquidacionID){ 
    event.preventDefault();   
    open("../Reportes/reporte_liquidacion.php?liquidacionID=" + liquidacionID + "", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes, top=100,left=300, width: 800,height: 400");    
}

function mostrarPeriodoDeuda(){
    event.preventDefault();
    var param_opcion = 'mostrar_combo_periodo_deuda'    
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/combos_controller.php",
        success:function(data){         
            $('#periodoDeuda').html(data);                                            
        }
    });
}

function mostrarTributos(){
    event.preventDefault();
    var param_opcion = 'mostrar_combo_tributo_deuda'    
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/combos_controller.php",
        success:function(data){         
            $('#tributos').html(data);                                            
        }
    });
}

function mostrarEstadoDeuda(){
    event.preventDefault();    
    var param_opcion = 'mostrar_deuda_total';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/estadoDeuda_controller.php",
        success:function(data){         
            $('#cuerpoEstadoDeuda').html(data);                                        
        }
    });
}

function mostrarBusquedaDeuda(){
    event.preventDefault();    
    var param_periodo_deuda = document.getElementById('param_periodo_deuda').value; 
    var param_tributo_deuda = document.getElementById('param_tributo_deuda').value; 
    var param_opcion = 'mostrar_total_deuda_busqueda';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_periodo_deuda='+param_periodo_deuda+'&param_tributo_deuda='+param_tributo_deuda,        
        url: "../../controller/controlInformacion/estadoDeuda_controller.php",
        success:function(data){         
            $('#cuerpoEstadoDeuda').html(data);                                        
        }
    });
}

function imprimirDeuda(){ 
    event.preventDefault();
    var periodo = document.getElementById('param_periodo_deuda').value; 
    var tributo = document.getElementById('param_tributo_deuda').value;    
    open("../Reportes/reporte_deuda.php?periodo="+periodo+"&tributo="+tributo+"", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes, top=100,left=300, width: 800,height: 400");    
}

function mostrarFraccionamientos(){
    event.preventDefault();        
    var param_opcion = 'mostrar_fraccionamientos';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/fraccionamiento_controller.php",
        success:function(data){         
            $('#cuerpoFraccionamiento').html(data);                                        
        }
    });
}

function detallesFraccionamiento(fraccionamientoID){ 
    event.preventDefault();      
    $('#fraccionamiento').hide(); 
    $('#fraccionamientoDetalle').show();
    mostrarDatosFraccionamiento(fraccionamientoID);
    mostrarTributosAfectados(fraccionamientoID);
    mostrarCronograma(fraccionamientoID);
}


function mostrarDatosFraccionamiento(fraccionamientoID){ 
    event.preventDefault();      
    var param_opcion = 'mostrar_datos_fraccionamientos';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_fraccionamientoID='+fraccionamientoID,        
        url: "../../controller/controlInformacion/fraccionamiento_controller.php",
        success:function(data){         
            $('#tablaDatos').html(data);                                        
        }
    });
}

function mostrarTributosAfectados(fraccionamientoID){ 
    event.preventDefault();      
    var param_opcion = 'mostrar_tributos_afectados';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_fraccionamientoID='+fraccionamientoID,        
        url: "../../controller/controlInformacion/fraccionamiento_controller.php",
        success:function(data){         
            $('#cuerpoTributosAfectados').html(data);                                        
        }
    });
}

function mostrarCronograma(fraccionamientoID){ 
    event.preventDefault();      
    var param_opcion = 'mostrar_cronograma_fraccionamiento';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_fraccionamientoID='+fraccionamientoID,        
        url: "../../controller/controlInformacion/fraccionamiento_controller.php",
        success:function(data){         
            $('#cuerpoCronograma').html(data);                                        
        }
    });
}

function detallesPredio(predioID){ 
    event.preventDefault(); 
    //alert(predioID);     
    $('#predios').hide(); 
    $('#predioDetalle').show();    
    mostrarDatosPredio(predioID);
    mostrarDatosPisos(predioID);
}

function mostrarDatosPredio(predioID){
    event.preventDefault();    
    var param_periodo_predio = document.getElementById('param_periodo').value;     
    var param_opcion = 'mostrar_datos_predio';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_periodo_predio='+param_periodo_predio+'&param_predio='+predioID,
        url: "../../controller/controlInformacion/predio_controller.php",
        success:function(data){         
            $('#tablaDatosPredio').html(data);                                        
        }
    });
}

function mostrarDatosPisos(predioID){
    event.preventDefault();    
    var param_periodo_predio = document.getElementById('param_periodo').value;     
    var param_opcion = 'mostrar_datos_pisos';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_periodo_predio='+param_periodo_predio+'&param_predio='+predioID,
        url: "../../controller/controlInformacion/predio_controller.php",
        success:function(data){         
            $('#cuerpoDetallePredio').html(data);                                        
        }
    });
}

function mostrarPeriodoRecibos(){
    event.preventDefault();
    var param_opcion = 'mostrar_periodo_recibos'
    //alert(grupo);
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,        
        url: "../../controller/controlInformacion/combos_controller.php",
        success:function(data){         
            $('#añoProcesar').html(data);                                            
        }
    });
}

function mostrarRecibos(){
    event.preventDefault();        
    var param_opcion = 'mostrar_recibos';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,
        url: "../../controller/controlInformacion/recibos_controller.php",
        success:function(data){         
            $('#cuerpoRecibos').html(data);                                        
        }
    });
}

function mostrarRecibosBusqueda(){
    event.preventDefault();  
    var param_periodo_recibo = document.getElementById('param_periodo_recibo').value;
    var param_mes_inicial = document.getElementById('param_mes_inicial').value;
    var param_mes_final = document.getElementById('param_mes_final').value;      
    var param_opcion = 'mostrar_recibos_busqueda';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_periodo_recibo='+param_periodo_recibo+'&param_mes_inicial='+param_mes_inicial+'&param_mes_final='+param_mes_final,
        url: "../../controller/controlInformacion/recibos_controller.php",
        success:function(data){         
            $('#cuerpoRecibos').html(data);                                        
        }
    });
}

function mostrarCuentaCorrienteAnual(){
    event.preventDefault();     
    var param_opcion = 'mostrar_cuenta_corriente_anual';
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion,
        url: "../../controller/controlInformacion/cuentaCorriente_controller.php",
        success:function(data){         
            $('#cuerpoCuentaCorriente').html(data);                                        
        }
    });
}

function mostrarCuentaMes(){
    event.preventDefault();     
    var param_periodo_cuenta = document.getElementById('param_periodo_cuenta').value;
    var param_opcion = 'mostrar_cuenta_corriente_mensual';    
    $.ajax({
        type:'POST',
        data:'param_opcion='+param_opcion+'&param_periodo_cuenta='+param_periodo_cuenta,
        url: "../../controller/controlInformacion/cuentaCorriente_controller.php",
        success:function(data){         
            $('#cuerpoCuentaCorriente').html(data);                                        
        }
    });
}




function imprimirRecibo(reciboID, mes, anio, numero){ 
    event.preventDefault();   
    //alert(reciboID);
    //alert(mes);
    //alert(anio);
    open("../Reportes/reporte_recibo.php?reciboID=" + reciboID + "&mes=" + mes + "&anio=" + anio + "&mes=" + mes + "&numero=" + numero + "", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes, top=100,left=300, width: 800,height: 400");    
}








