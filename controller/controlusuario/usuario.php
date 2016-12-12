<?php 

	include_once '../../model/modelusuario/usuario_model.php';

	$param = array();
	$param['param_opcion']='';
	$param['param_usuId']=0;
	$param['param_usuUsuario']='';
	$param['param_usuClave']='';
	$param['param_usuEstado'] = 1;

	$param['grupo'] = '';
	$param['tarea'] = '';

	if (isset($_SESSION['coneisc_usuId']))
	    $param['param_usuId'] = $_SESSION['coneisc_usuId'];
	    
	if (isset($_POST['opcion']))
	    $param['param_opcion'] = $_POST['opcion'];
	
	if (isset($_POST['param_usuId']))
	    $param['param_usuId'] = $_POST['param_usuId'];
	if (isset($_POST['usuario']))
	    $param['param_usuUsuario'] = $_POST['usuario'];
	if (isset($_POST['password']))
	    $param['param_usuClave'] = $_POST['password'];
	if (isset($_POST['param_usuEstado'])) {
	    if ($_POST['param_usuEstado'] == 'true')
	        $param['param_usuEstado'] = '1';
	    if ($_POST['param_usuEstado'] == 'false')
	        $param['param_usuEstado'] = '0';
	}

	if(isset($_POST['grupo']))
	{
		$param['grupo'] = $_POST['grupo'];
	}

	if(isset($_POST['tarea']))
	{
		$param['tarea'] = $_POST['tarea'];
	}
	
	$Usuario=new Usuario_Model();
	echo $Usuario->gestionar($param);

 ?>