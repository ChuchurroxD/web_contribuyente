<?php 

	include_once '../../model/modelInformacion/estadoDeuda_model.php';

	$param = array();
	$param['param_opcion']='';
	$param['param_periodo_deuda']='';
	$param['param_tributo_deuda']='';	

	    
	if (isset($_POST['param_opcion']))
	    $param['param_opcion'] = $_POST['param_opcion'];

	if (isset($_POST['param_periodo_deuda']))
	    $param['param_periodo_deuda'] = $_POST['param_periodo_deuda'];

	if (isset($_POST['param_tributo_deuda']))
	    $param['param_tributo_deuda'] = $_POST['param_tributo_deuda'];

	
	$EstadoDeuda =new EstadoDeuda_Model();
	echo $EstadoDeuda->gestionar($param);

 ?>