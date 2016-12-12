<?php 
	include_once '../../model/modelInformacion/combos_model.php';

	$param = array();
	$param['param_opcion']='';	
	    
	if (isset($_POST['param_opcion']))
	    $param['param_opcion'] = $_POST['param_opcion'];

	$Combos =new Combos_Model();
	echo $Combos->gestionar($param);
 ?>