<?php 
session_start();
include_once '../../model/conexion_model.php';


class CuentaCorriente_Model
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
			case 'mostrar_cuenta_corriente_anual':
				echo $this->mostrar_cuenta_corriente_anual();
				break;
            case 'mostrar_cuenta_corriente_mensual':
                echo $this->mostrar_cuenta_corriente_mensual();
                break;	
            			
		}
	}

	function prepararConsultaCuentaCorriente($opcion, $persona_id, $anio) {
		$consultaSql = "exec _Pla_cuentaCorriente @tipoconsulta='".$opcion."',@anio='".$anio."',@persona_ID='".$persona_id."'";
        //echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }
   

    function mostrar_cuenta_corriente_anual() {  
        $this->prepararConsultaCuentaCorriente(1,$_SESSION['usuContribuyente'],'');
        $item = 0;                             
        while (odbc_fetch_row($this->result)) {          	        	
        	$anio = odbc_result($this->result, "anio");
        	$totalCargoP = odbc_result($this->result, "totalCargoP");
        	$totalAbonoP = odbc_result($this->result, "totalAbonoP"); 
            $totalDeudaP = odbc_result($this->result, "totalDeudaP");
            $totalInteresP = odbc_result($this->result, "totalInteresP");   
            $totalCargoA = odbc_result($this->result, "totalCargoA"); 
            $totalAbonoA = odbc_result($this->result, "totalAbonoA"); 
            $totalDeudaA = odbc_result($this->result, "totalDeudaA"); 
            $totalInteresA = odbc_result($this->result, "totalInteresA"); 
            $totalCargoT= odbc_result($this->result, "totalCargoT");
            $totalAbonoT= odbc_result($this->result, "totalAbonoT"); 
            $totalDeudaN= odbc_result($this->result, "totalDeudaN"); 
            $totalDeudaT= odbc_result($this->result, "totalDeudaT"); 
            echo '<table>';
            if ($anio == 'Resumen: ') {
                echo '<td style="text-align: center; font-size: 10px; width: 8%; color: #000;  font-weight: bold;">'.$anio.'</td>';
                if ($totalCargoP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">'.$totalCargoP.'</td>';
                }
                if ($totalAbonoP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000; font-weight: bold;">'.$totalAbonoP.'</td>';
                }
                if ($totalDeudaP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">'.$totalDeudaP.'</td>';
                }
                if ($totalInteresP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000; font-weight: bold;">'.$totalInteresP.'</td>';
                }
                if ($totalCargoA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">'.$totalCargoA.'</td>';
                }
                if ($totalAbonoA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000; font-weight: bold;">'.$totalAbonoA.'</td>';
                }
                if ($totalDeudaA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000; font-weight: bold;">'.$totalDeudaA.'</td>';
                }
                if ($totalInteresA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000; font-weight: bold;">'.$totalInteresA.'</td>';
                }
                if ($totalCargoT == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000; font-weight: bold;">'.$totalCargoT.'</td>';
                }
                if ($totalAbonoT == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000; font-weight: bold;">'.$totalAbonoT.'</td>';
                }
                if ($totalDeudaN == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:10%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width:10%; color: #000; font-weight: bold;">'.$totalDeudaN.'</td>';
                }
                if ($totalDeudaT == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:10%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000; font-weight: bold;">'.$totalDeudaT.'</td>';
                } 
                
            } else {
                echo '<td style="text-align: center; font-size: 10px; width: 8%; color: #000; ">'.$anio.'</td>';
                if ($totalCargoP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000;">'.$totalCargoP.'</td>';
                }
                if ($totalAbonoP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">'.$totalAbonoP.'</td>';
                }
                if ($totalDeudaP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">'.$totalDeudaP.'</td>';
                }
                if ($totalInteresP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">'.$totalInteresP.'</td>';
                }
                if ($totalCargoA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">'.$totalCargoA.'</td>';
                }
                if ($totalAbonoA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">'.$totalAbonoA.'</td>';
                }
                if ($totalDeudaA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">'.$totalDeudaA.'</td>';
                }
                if ($totalInteresA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">'.$totalInteresA.'</td>';
                }
                if ($totalCargoT == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">'.$totalCargoT.'</td>';
                }
                if ($totalAbonoT == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">'.$totalAbonoT.'</td>';
                }
                if ($totalDeudaN == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">'.$totalDeudaN.'</td>';
                }
                if ($totalDeudaT == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">'.$totalDeudaT.'</td>';
                } 
            }                                                                   
            echo '</table>';     	
        }         
        $this->cerrarAbrir(); 
    }

    function mostrar_cuenta_corriente_mensual() {  
        $this->prepararConsultaCuentaCorriente(2,$_SESSION['usuContribuyente'],$this->param['param_periodo_cuenta']);
        $item = 0;                             
        while (odbc_fetch_row($this->result)) {                         
            $mes = odbc_result($this->result, "mes");
            $totalCargoP = odbc_result($this->result, "totalCargoP");
            $totalAbonoP = odbc_result($this->result, "totalAbonoP"); 
            $totalDeudaP = odbc_result($this->result, "totalDeudaP");
            $totalInteresP = odbc_result($this->result, "totalInteresP");   
            $totalCargoA = odbc_result($this->result, "totalCargoA"); 
            $totalAbonoA = odbc_result($this->result, "totalAbonoA"); 
            $totalDeudaA = odbc_result($this->result, "totalDeudaA"); 
            $totalInteresA = odbc_result($this->result, "totalInteresA"); 
            $totalCargoT= odbc_result($this->result, "totalCargoT");
            $totalAbonoT= odbc_result($this->result, "totalAbonoT"); 
            $totalDeudaN= odbc_result($this->result, "totalDeudaN"); 
            $totalDeudaT= odbc_result($this->result, "totalDeudaT"); 
            echo '<table>';
            if ($mes == 'Resumen: ') {
                echo '<td style="text-align: center; font-size: 10px; width: 8%; color: #000;  font-weight: bold;">'.$mes.'</td>';
                if ($totalCargoP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">'.$totalCargoP.'</td>';
                }
                if ($totalAbonoP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000; font-weight: bold;">'.$totalAbonoP.'</td>';
                }
                if ($totalDeudaP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">'.$totalDeudaP.'</td>';
                }
                if ($totalInteresP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000; font-weight: bold;">'.$totalInteresP.'</td>';
                }
                if ($totalCargoA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">'.$totalCargoA.'</td>';
                }
                if ($totalAbonoA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000; font-weight: bold;">'.$totalAbonoA.'</td>';
                }
                if ($totalDeudaA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000; font-weight: bold;">'.$totalDeudaA.'</td>';
                }
                if ($totalInteresA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000; font-weight: bold;">'.$totalInteresA.'</td>';
                }
                if ($totalCargoT == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000; font-weight: bold;">'.$totalCargoT.'</td>';
                }
                if ($totalAbonoT == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000; font-weight: bold;">'.$totalAbonoT.'</td>';
                }
                if ($totalDeudaN == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:10%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width:10%; color: #000; font-weight: bold;">'.$totalDeudaN.'</td>';
                }
                if ($totalDeudaT == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:10%; color: #000; font-weight: bold;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000; font-weight: bold;">'.$totalDeudaT.'</td>';
                } 
                
            } else {
                echo '<td style="text-align: center; font-size: 10px; width: 8%; color: #000; ">'.$mes.'</td>';
                if ($totalCargoP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000;">'.$totalCargoP.'</td>';
                }
                if ($totalAbonoP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">'.$totalAbonoP.'</td>';
                }
                if ($totalDeudaP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width:8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">'.$totalDeudaP.'</td>';
                }
                if ($totalInteresP == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">'.$totalInteresP.'</td>';
                }
                if ($totalCargoA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">'.$totalCargoA.'</td>';
                }
                if ($totalAbonoA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">'.$totalAbonoA.'</td>';
                }
                if ($totalDeudaA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">'.$totalDeudaA.'</td>';
                }
                if ($totalInteresA == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 8%; color: #000;">'.$totalInteresA.'</td>';
                }
                if ($totalCargoT == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">'.$totalCargoT.'</td>';
                }
                if ($totalAbonoT == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">'.$totalAbonoT.'</td>';
                }
                if ($totalDeudaN == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">'.$totalDeudaN.'</td>';
                }
                if ($totalDeudaT == '.00') {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 10px; width: 10%; color: #000;">'.$totalDeudaT.'</td>';
                } 
            }                                                                   
            echo '</table>';    
        }         
        $this->cerrarAbrir(); 
    }
    
   
}
 ?>