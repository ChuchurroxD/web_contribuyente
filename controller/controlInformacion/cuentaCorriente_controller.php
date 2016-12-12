<?php 

	include_once '../../model/modelInformacion/cuentaCorriente_model.php';

	$param = array();
	$param['param_opcion']='';	
	$param['param_periodo_cuenta']='';	
	    
	if (isset($_POST['param_opcion']))
	    $param['param_opcion'] = $_POST['param_opcion'];

	if (isset($_POST['param_periodo_cuenta']))
	    $param['param_periodo_cuenta'] = $_POST['param_periodo_cuenta'];
	
	$CuentaCorriente =new CuentaCorriente_Model();
	echo $CuentaCorriente->gestionar($param);

 ?>