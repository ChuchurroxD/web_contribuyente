<?php 
session_start();
include_once '../../model/conexion_model.php';


class Usuario_model
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
			case 'login':
				echo $this->login();
				break;
			case 'mostrarMenu':
				echo $this->mostrarMenu();					
				break;
		}
	}

	function prepararConsultaUsuario($opcion) {
        $consultaSql = "exec sp_logeo ";
		$consultaSql.="@opcion='".$opcion."',";
		$consultaSql.="@Usuario='".$this->param['param_usuUsuario']."',";
        $consultaSql.="@Password='".$this->param['param_usuClave']."'";        
        //echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    function prepararConsultaMenu($opcion='', $grupoid='')
	{
		$consultaSql2 = "exec sp_logeo ";
		$consultaSql2.="@opcion='".$opcion."',";
		$consultaSql2.="@Persona='".$_SESSION['usuId']."',";
        $consultaSql2.="@Grupo='".$grupoid."'";  	
		//echo $consultaSql2;
		$this->result2 = odbc_exec($this->conexion,$consultaSql2);
	}

	
	function ejecutarConsultaRespuesta() {
        $respuesta = '';
        while ($fila = odbc_fetch_array($this->result)) {
            $respuesta = $fila["respuesta"];
        }
        return $respuesta;
    }


	function login()
	{
		$this->prepararConsultaUsuario('opc_login_respuesta');
        //echo 1;
        $respuesta = $this->ejecutarConsultaRespuesta();
        if ($respuesta == '1') {
            $this->cerrarAbrir();
            $this->prepararConsultaUsuario('opc_login_listar');
            while ($fila = odbc_fetch_array($this->result)) {
                $_SESSION['usuId'] = $fila['usuId'];
                $_SESSION['usuUsuario'] = $fila['usuUsuario'];                
                $_SESSION['usuContribuyente'] = $fila['usuContribuyente'];  
                $_SESSION['usuPass'] = $fila['usuPass'];  
                $_SESSION['cokie'] = $fila["usuUsuario"].time();
            }    
			echo '1';
		} 
		else
		{			
			echo '0';
		}
	}


	private function getArrayGrupos() {
        $datos = array();
        while ($fila = odbc_fetch_array($this->result2)) {
            array_push($datos, array(
                "grupo" => $fila["Gru_nombre"],
                "grupoID" => $fila["grupo_id"],  
                "grupoIcono" => $fila["gru_icono"]             
                ));
        }
        return $datos;
    }

    private function getArrayTareas() {
        $datos = array();
        while ($fila = odbc_fetch_array($this->result2)) {
            array_push($datos, array(
                "tarea" => $fila["tar_nombre"],
                "tareaRuta" => $fila["tar_url"]                
                ));
        }
        return $datos;
    }

    private

	function mostrarMenu()
	{
		$this->cerrarAbrir();
		$this->prepararConsultaMenu('opc_mostrargrupos',0);
		$datosGrupos = $this->getArrayGrupos();
		for($i=0; $i<count($datosGrupos); $i++)
		{	

			if($datosGrupos[$i]['grupo'] === $this->param['grupo'])
				echo '<li class="open">';
			else 		
				echo '<li class="">';
			echo '				
					
						<a href="#" class="dropdown-toggle">
							<i class="menu-icon fa ' .utf8_encode($datosGrupos[$i]['grupoIcono']).'"></i>
							<span class="menu-text">
								'.utf8_encode($datosGrupos[$i]['grupo']).'
							</span>

							<b class="arrow fa fa-angle-down"></b>
						</a>

						<b class="arrow"></b>

						<ul class="submenu">';		
			$this->cerrarAbrir();
			$this->prepararConsultaMenu('opc_mostrartareas',$datosGrupos[$i]['grupoID']);
			$datosTareas = $this->getArrayTareas();
			for($j=0; $j<count($datosTareas); $j++)
			{
				if($datosTareas[$j]['tarea'] === $this->param['tarea'])
					echo '<li class="active">';
				else 		
					echo '<li class="">';
				echo '
	                    <a href="'.$datosTareas[$j]['tareaRuta'].'">
	                        <i class="menu-icon fa fa-caret-right"></i>
	                        '.utf8_encode($datosTareas[$j]['tarea']).'
	                    </a>
	                    <b class="arrow"></b>                           
	                </li>';
			}			
			echo '		</ul>
					</li>';
		}
	}


}
 ?>