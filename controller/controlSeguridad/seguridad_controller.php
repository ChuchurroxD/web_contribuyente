<?php 

	include_once '../../model/modelSeguridad/seguridad_model.php';

	$param = array();
	$param['param_opcion']='';
	$param['param_new_usuario']=0;
	$param['param_nuevo_password']='';
	
	    
	if (isset($_POST['param_opcion']))
	    $param['param_opcion'] = $_POST['param_opcion'];	
	if (isset($_POST['param_new_usuario']))
	    $param['param_new_usuario'] = $_POST['param_new_usuario'];
	if (isset($_POST['param_nuevo_password']))
	    $param['param_nuevo_password'] = $_POST['param_nuevo_password'];
	
	
	
	$Seguridad=new Seguridad_Model();
	echo $Seguridad->gestionar($param);

 ?>