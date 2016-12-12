<?php 

	include_once '../../model/modelInformacion/liquidacion_model.php';

	$param = array();
	$param['param_opcion']='';	
	$param['param_anio']='';	
	$param['param_mes']='';	
	$param['param_liquidacionID']='';	


	    
	if (isset($_POST['param_opcion']))
	    $param['param_opcion'] = $_POST['param_opcion'];

	if (isset($_POST['param_anio']))
	    $param['param_anio'] = $_POST['param_anio'];

	if (isset($_POST['param_mes']))
	    $param['param_mes'] = $_POST['param_mes'];	

	if (isset($_POST['param_liquidacionID']))
	    $param['param_liquidacionID'] = $_POST['param_liquidacionID'];
	
	$Liquidacion =new Liquidacion_Model();
	echo $Liquidacion->gestionar($param);

 ?>