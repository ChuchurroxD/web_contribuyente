<?php 

	include_once '../../model/modelInformacion/contribuyente_model.php';

	$param = array();
	$param['param_opcion']='';
	$param['param_periodo']='';
	$param['param_fechaInicio']='';
	$param['param_fechaFin']='';
	$param['param_tipoPago']='';
	$param['param_cajero']='';
	$param['param_caja']='';
	$param['param_pagoID']='';
	
	
	    
	if (isset($_POST['param_opcion']))
	    $param['param_opcion'] = $_POST['param_opcion'];

	if (isset($_POST['param_periodo']))
	    $param['param_periodo'] = $_POST['param_periodo'];

	if (isset($_POST['param_fechaInicio']))
	    $param['param_fechaInicio'] = $_POST['param_fechaInicio'];

	if (isset($_POST['param_fechaFin']))
	    $param['param_fechaFin'] = $_POST['param_fechaFin'];

	if (isset($_POST['param_tipoPago']))
	    $param['param_tipoPago'] = $_POST['param_tipoPago'];

	if (isset($_POST['param_cajero']))
	    $param['param_cajero'] = $_POST['param_cajero'];	

	if (isset($_POST['param_caja']))
	    $param['param_caja'] = $_POST['param_caja'];

	if (isset($_POST['param_pagoID']))
	    $param['param_pagoID'] = $_POST['param_pagoID'];
	
	
	
	$Contribuyente =new Contribuyente_Model();
	echo $Contribuyente->gestionar($param);

 ?>