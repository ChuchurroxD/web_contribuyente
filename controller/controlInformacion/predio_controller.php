<?php 

	include_once '../../model/modelInformacion/predio_model.php';

	$param = array();
	$param['param_opcion']='';	
	$param['param_periodo_predio']='';	
	$param['param_predio']='';	



	    
	if (isset($_POST['param_opcion']))
	    $param['param_opcion'] = $_POST['param_opcion'];

	if (isset($_POST['param_periodo_predio']))
	    $param['param_periodo_predio'] = $_POST['param_periodo_predio'];

	if (isset($_POST['param_predio']))
	    $param['param_predio'] = $_POST['param_predio'];
	
	
	$Predio =new Predio_Model();
	echo $Predio->gestionar($param);

 ?>