window.onload = function()
{	
	mostrarMenu();
    $('#predios').show(); 
    $('#estadoDeudas').hide(); 
    $('#cuentaCorriente').hide(); 	
    $('#relaciones').hide(); 
    $('#fraccionamiento').hide();
    $('#liquidaciones').hide(); 
    $('#recibosCobranza').hide(); 
    $('#pagos').hide(); 
    $('#valores').hide(); 

};

$(function() {
    $('#verPredios').on('click', function(){ 
       $('#predios').show(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').hide(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').hide(); 
        $('#valores').hide();     
    }); 

    $('#verDeudas').on('click', function(){
        $('#predios').hide(); 
        $('#estadoDeudas').show(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').hide(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').hide(); 
        $('#valores').hide(); 
                  
    }); 

    $('#verCuentaCorriente').on('click', function(){ 
        $('#predios').hide(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').show();
        $('#relaciones').hide(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').hide(); 
        $('#valores').hide();  
    });

    $('#verRelaciones').on('click', function(){ 
        $('#predios').hide(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').show(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').hide(); 
        $('#valores').hide();  
    });

    $('#verFraccionamiento').on('click', function(){ 
        $('#predios').hide(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').hide(); 
        $('#fraccionamiento').show(); 
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').hide(); 
        $('#valores').hide();  
    });

    $('#verLiquidaciones').on('click', function(){ 
        $('#predios').hide(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').hide(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').show(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').hide(); 
        $('#valores').hide();  
    });

    $('#verRecibosCobranza').on('click', function(){ 
        $('#predios').hide(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').hide(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').show(); 
        $('#pagos').hide(); 
        $('#valores').hide();  
    });

    $('#verPagos').on('click', function(){ 
        $('#predios').hide(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').hide(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').show(); 
        $('#valores').hide();  
    });

    $('#verValores').on('click', function(){ 
        $('#predios').hide(); 
        $('#estadoDeudas').hide(); 
        $('#cuentaCorriente').hide();
        $('#relaciones').hide(); 
        $('#fraccionamiento').hide();
        $('#liquidaciones').hide(); 
        $('#recibosCobranza').hide(); 
        $('#pagos').hide(); 
        $('#valores').show();  
    });
});


function mostrarMenu()
{
    var grupo = document.getElementById('NombreGrupo').value;
    var tarea = document.getElementById('NombreTarea').value;
    //alert(grupo);
    $.ajax({
        type:'POST',
        data: 'opcion=mostrarMenu&grupo='+grupo+'&tarea='+tarea,        
        url: "../../controller/controlusuario/usuario.php",
        success:function(data){                              
            $('#permisos').html(data);                
        }
    });
}
