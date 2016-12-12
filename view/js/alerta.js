function mostrarAlertaReco(){	
	var opc = 'ALERT_REC';
	$.ajax({
		type: 'POST',
		data:'opc='+opc,
		url: '../bd/bdAlerta.php',
		success: function(rpta){
			numVacunas = rpta.split("_");
			ceroDias = parseInt(numVacunas[0]);
			unDia = parseInt(numVacunas[1]);
			dosDias = parseInt(numVacunas[2]);
			numVacunas = ceroDias+unDia+dosDias;
			if(ceroDias>0){
				filaAlerta = "<li><a href='#'><div class='clearfix'><span class='pull-left'><i class='btn btn-xs no-hover btn-danger fa fa-phone'></i>  HOY</span><span class='pull-right badge badge-danger'>"+ceroDias+"</span></div></a></li>";
				$('#contenidoAlertas').html($('#contenidoAlertas').html()+filaAlerta);
			}
			if(unDia>0){
				filaAlerta = "<li><a href='#'><div class='clearfix'><span class='pull-left'><i class='btn btn-xs no-hover btn-warning fa fa-phone'></i>  MAÑANA</span><span class='pull-right badge badge-warning'>"+unDia+"</span></div></a></li>";
				$('#contenidoAlertas').html($('#contenidoAlertas').html()+filaAlerta);
			}
			if(dosDias>0){
				filaAlerta = "<li><a href='#'><div class='clearfix'><span class='pull-left'><i class='btn btn-xs no-hover btn-primary fa fa-phone'></i>  PASADO MAÑANA</span><span class='pull-right badge badge-primary'>"+dosDias+"</span></div></a></li>";
				$('#contenidoAlertas').html($('#contenidoAlertas').html()+filaAlerta);
			}
			$('#numAlertas').html(numVacunas);
			$('#notificaciones').html(" "+numVacunas+" Recordatorios");
			
		},
		error: function(rpta){
			alert(rpta);
		}
	});
}