<?php 
session_start();
include_once '../../model/conexion_model.php';


class Combos_Model
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
			case 'mostrar_combo_periodo_liquidacion':
				echo $this->mostrar_combo_periodo_liquidacion();
				break;
			case 'mostrar_combo_mes_liquidacion':
				echo $this->mostrar_combo_mes_liquidacion();
				break;			
			case 'mostrar_combo_periodo_deuda':
				echo $this->mostrar_combo_periodo_deuda();
				break;	
			case 'mostrar_combo_tributo_deuda':
				echo $this->mostrar_combo_tributo_deuda();
				break;	
            case 'mostrar_periodo_recibos':
                echo $this->mostrar_periodo_recibos();
                break;    
            case 'mostrar_combo_periodo_cuenta':
                echo $this->mostrar_combo_periodo_cuenta();
                break; 
                
		}
	}

	function prepararConsultaCombos($opcion) {
		$consultaSql = "EXEC _Mant_Periodo @Tipoconsulta = '".$opcion."'";   
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    function prepararConsultaCombosTributos($opcion) {
		$consultaSql = "EXEC _Pred_tributo @Tipoconsulta = '".$opcion."', @persona_ID = '".$_SESSION['usuContribuyente']."'";   
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    
    function mostrar_combo_periodo_liquidacion() {  
        $this->prepararConsultaCombos(14);
        echo '
            <select class="form-control" id="param_periodo_liquidacion" name="param_periodo_liquidacion" onchange="mostrarLiquiPeriodo();">';               
        while (odbc_fetch_row($this->result)) {
        	$anio = odbc_result($this->result, "anio");
        	$descripcion = odbc_result($this->result, "descripcion");
            echo'<option value="'.$anio.'">'.utf8_encode($descripcion).'</option>';
        }
        echo '</select>';
        $this->cerrarAbrir();  
    }  

    function mostrar_combo_periodo_deuda() {  
        $this->prepararConsultaCombos(14);
        echo '
            <select class="form-control" id="param_periodo_deuda" name="param_periodo_deuda" onchange="mostrarBusquedaDeuda();">';               
        while (odbc_fetch_row($this->result)) {
        	$anio = odbc_result($this->result, "anio");
        	$descripcion = odbc_result($this->result, "descripcion");
            echo'<option value="'.$anio.'">'.utf8_encode($descripcion).'</option>';
        }
        echo '</select>';
        $this->cerrarAbrir();  
    }   

    function mostrar_combo_periodo_cuenta() {  
        $this->prepararConsultaCombos(14);
        echo '
            <select class="form-control" id="param_periodo_cuenta" name="param_periodo_cuenta" onchange="mostrarCuentaMes();">';               
        while (odbc_fetch_row($this->result)) {
            $anio = odbc_result($this->result, "anio");
            $descripcion = odbc_result($this->result, "descripcion");
            echo'<option value="'.$anio.'">'.utf8_encode($descripcion).'</option>';
        }
        echo '</select>';
        $this->cerrarAbrir();  
    }  

    function mostrar_combo_tributo_deuda() {  
        $this->prepararConsultaCombosTributos(14);
        echo '
            <select class="form-control" id="param_tributo_deuda" name="param_tributo_deuda" onchange="mostrarBusquedaDeuda();">';               
        while (odbc_fetch_row($this->result)) {
        	$tributo_ID = odbc_result($this->result, "tributo_ID");
        	$tributo = odbc_result($this->result, "tributo");
            echo'<option value="'.$tributo_ID.'">'.utf8_encode($tributo).'</option>';
        }
        echo '</select>';
        $this->cerrarAbrir();  
    } 

    function mostrar_periodo_recibos() {            
        $this->prepararConsultaCombos(15);  
        $anioActual = date ("Y");  
        echo '
            <select class="form-control" id="param_periodo_recibo" name="param_periodo_recibo">';
                
        while (odbc_fetch_row($this->result)) {
            $anio = odbc_result($this->result, "anio");
            $descripcion = odbc_result($this->result, "descripcion");
            if ($anio == $anioActual) {
                echo'<option value="'.$anio.'" selected>'.utf8_encode($descripcion).'</option>';
            }
            echo'<option value="'.$anio.'">'.utf8_encode($descripcion).'</option>';
        }
        echo '</select>';
        $this->cerrarAbrir();
    }  


}
 ?>