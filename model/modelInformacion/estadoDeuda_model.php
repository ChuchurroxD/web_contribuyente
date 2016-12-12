<?php 
session_start();
include_once '../../model/conexion_model.php';


class EstadoDeuda_Model
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
			case 'mostrar_deuda_total':
				echo $this->mostrar_deuda_total();
				break;	

            case 'mostrar_total_deuda_busqueda':
                echo $this->mostrar_total_deuda_busqueda();
                break;  		
		}
	}

	function prepararConsultaLiquidacion($opcion, $persona_ID, $anio, $tributo) {
		$consultaSql = "exec _Pago_CuentaCorriente @TipoConsulta='".$opcion."', @persona_ID='".$persona_ID."', @anio = '".$anio."', @tributo_ID = '".$tributo."'";
        //echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    
    function mostrar_deuda_total() {  
        $this->prepararConsultaLiquidacion(18,$_SESSION['usuContribuyente'],'','');                        
        while (odbc_fetch_row($this->result)) {        	      
        	$anio = odbc_result($this->result, "anio");
        	$mes = odbc_result($this->result, "mes");
        	$tributo = odbc_result($this->result, "tributo");
        	$tipo_tributo = odbc_result($this->result, "tipo_tributo");
        	$fechaVencimiento = odbc_result($this->result, "fechaVencimiento");
        	$estado = odbc_result($this->result, "estado");
            $pendiente = odbc_result($this->result, "pendiente");         	        
            $total = odbc_result($this->result, "total"); 
            echo'<tr>
                <td style="text-align: center; font-size: 10px; width: 3%; color: #000; height: 5px"">'.$anio.'</td>                
                <td style="text-align: center; font-size: 10px; width: 3%; color: #000; height: 5px"">'.utf8_encode($mes).'</td>
                <td style="text-align: left; font-size: 10px; width: 20%; color: #000; height: 5px"">'.utf8_encode($tributo).'</td>
                <td style="text-align: left; font-size: 10px; width: 10%; color: #000; height: 5px"">'.utf8_encode($tipo_tributo).'</td>
                <td style="text-align: center; font-size: 10px; width: 8%; color: #000; height: 5px"">'.utf8_encode($fechaVencimiento).'</td>
                <td style="text-align: center; font-size: 10px; width: 5%; color: #000; height: 5px"">'.utf8_encode($estado).'</td>
                <td style="text-align: center; font-size: 10px; width: 5%; color: #000; height: 5px"">'.utf8_encode($pendiente).'</td>
                <td style="text-align: right; font-size: 10px; width: 5%; color: #000; font-weight: bold; height: 5px"">'.utf8_encode($total).'</td>
            </tr>';
        }  
        $this->prepararConsultaLiquidacion(20,$_SESSION['usuContribuyente'],$this->param['param_periodo_deuda'],$this->param['param_tributo_deuda']);             
        while (odbc_fetch_row($this->result)) {               
            $totalFinal = odbc_result($this->result, "total");
        }
        echo '<tr>                
                <td style="text-align: right; font-size: 10px; width: 5%; color: #000; height: 5px; font-weight: bold;" colspan="7">TOTAL</td>
                <td style="text-align: right; font-size: 10px; width: 5%; color: #000; font-weight: bold; height: 5px"">'.utf8_encode($totalFinal).'</td>
            </tr>';
        $this->cerrarAbrir(); 
    }

    function mostrar_total_deuda_busqueda() {  
        $this->prepararConsultaLiquidacion(19,$_SESSION['usuContribuyente'],$this->param['param_periodo_deuda'],$this->param['param_tributo_deuda']);                        
        while (odbc_fetch_row($this->result)) {               
            $anio = odbc_result($this->result, "anio");
            $mes = odbc_result($this->result, "mes");
            $tributo = odbc_result($this->result, "tributo");
            $tipo_tributo = odbc_result($this->result, "tipo_tributo");
            $fechaVencimiento = odbc_result($this->result, "fechaVencimiento");
            $estado = odbc_result($this->result, "estado");
            $pendiente = odbc_result($this->result, "pendiente");                   
            $total = odbc_result($this->result, "total"); 
            echo'<tr>
                <td style="text-align: center; font-size: 10px; width: 3%; color: #000; height: 5px"">'.$anio.'</td>                
                <td style="text-align: center; font-size: 10px; width: 3%; color: #000; height: 5px"">'.utf8_encode($mes).'</td>
                <td style="text-align: left; font-size: 10px; width: 20%; color: #000; height: 5px"">'.utf8_encode($tributo).'</td>
                <td style="text-align: left; font-size: 10px; width: 10%; color: #000; height: 5px"">'.utf8_encode($tipo_tributo).'</td>
                <td style="text-align: center; font-size: 10px; width: 8%; color: #000; height: 5px"">'.utf8_encode($fechaVencimiento).'</td>
                <td style="text-align: center; font-size: 10px; width: 5%; color: #000; height: 5px"">'.utf8_encode($estado).'</td>
                <td style="text-align: center; font-size: 10px; width: 5%; color: #000; height: 5px"">'.utf8_encode($pendiente).'</td>
                <td style="text-align: right; font-size: 10px; width: 5%; color: #000; font-weight: bold; height: 5px"">'.utf8_encode($total).'</td>

            </tr>';
        }              
        $this->prepararConsultaLiquidacion(20,$_SESSION['usuContribuyente'],$this->param['param_periodo_deuda'],$this->param['param_tributo_deuda']);             
        while (odbc_fetch_row($this->result)) {               
            $totalFinal = odbc_result($this->result, "total");
        }
        echo '<tr>                
                <td style="text-align: right; font-size: 10px; width: 5%; color: #000; height: 5px; font-weight: bold;" colspan="7">TOTAL</td>
                <td style="text-align: right; font-size: 10px; width: 5%; color: #000; font-weight: bold; height: 5px"">'.utf8_encode($totalFinal).'</td>
            </tr>';
        $this->cerrarAbrir();
    }

}
 ?>