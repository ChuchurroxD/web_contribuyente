<?php 

	include_once '../../model/modelInformacion/recibos_model.php';

	$param = array();
	$param['param_opcion']='';	
	$param['param_periodo_recibo']='';	
	$param['param_mes_inicial']='';	
	$param['param_mes_final']='';	



	    
	if (isset($_POST['param_opcion']))
	    $param['param_opcion'] = $_POST['param_opcion'];

	if (isset($_POST['param_periodo_recibo']))
	    $param['param_periodo_recibo'] = $_POST['param_periodo_recibo'];

	if (isset($_POST['param_mes_inicial']))
	    $param['param_mes_inicial'] = $_POST['param_mes_inicial'];

	if (isset($_POST['param_mes_final']))
	    $param['param_mes_final'] = $_POST['param_mes_final'];
	
	
	$Recibos =new Recibos_Model();
	echo $Recibos->gestionar($param);

 ?>