<?php 
session_start();
include_once '../../model/conexion_model.php';


class Seguridad_Model
{

	private $param = array();
	private $conexion = null;	

	function __construct()
	{
		$this->conexion = Conexion_model::getConexion();
	}

	function cerrarAbrir()
	{
		 odbc_close($this->conexion);
        $this->conexion = Conexion_Model::getConexion();
	}

	function gestionar($param)
	{
		$this->param = $param;
		switch ($this->param['param_opcion'])
		{
			case 'update_datos':
				echo $this->update_datos();
				break;			
		}
	}

	

	function prepararConsultaUsuario($opcion) {
		$consultaSql = "UPDATE usuario SET per_login = '".$this->param['param_new_usuario']."', per_pass = '".$this->param['param_nuevo_password']."' WHERE per_codigo = '".$_SESSION['usuId']."'";
        
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    
    function update_datos() {  
        $this->prepararConsultaUsuario('opc_update_contraseña');
        $this->cerrarAbrir();                                    
        echo 1; 
            //echo $this->param['ruta'];     
    }


}
 ?>