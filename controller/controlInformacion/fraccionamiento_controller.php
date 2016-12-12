<?php 

	include_once '../../model/modelInformacion/fraccionamiento_model.php';

	$param = array();
	$param['param_opcion']='';
	$param['param_fraccionamientoID']='';
	

	    
	if (isset($_POST['param_opcion']))
	    $param['param_opcion'] = $_POST['param_opcion'];

	if (isset($_POST['param_fraccionamientoID']))
	    $param['param_fraccionamientoID'] = $_POST['param_fraccionamientoID'];

	
	
	$Fraccionamiento =new Fraccionamiento_Model();
	echo $Fraccionamiento->gestionar($param);

 ?>