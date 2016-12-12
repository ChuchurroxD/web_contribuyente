<?php 
session_start();
include_once '../../model/conexion_model.php';


class Fraccionamiento_Model
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
			case 'mostrar_fraccionamientos':
				echo $this->mostrar_fraccionamientos();
				break;	            	
            case 'mostrar_datos_fraccionamientos':
                echo $this->mostrar_datos_fraccionamientos();
                break;
            case 'mostrar_tributos_afectados':
                echo $this->mostrar_tributos_afectados();
                break;
            case 'mostrar_cronograma_fraccionamiento':
                echo $this->mostrar_cronograma_fraccionamiento();
                break;
		}
	}

	function prepararConsultaFraccionamiento($opcion, $persona_ID, $fraccID) {
		$consultaSql = "exec _frac_Fraccionamiento_Proceso @persona_ID = '".$persona_ID."', @tipo = '".$opcion."', @fraccionamiento_ID = '".$fraccID."'";
        //echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    function prepararConsultaTributoFracc($opcion, $fraccID) {
        $consultaSql = "exec _Pred_tributo @TipoConsulta = '".$opcion."', @fraccionamiento_ID = '".$fraccID."'";
        echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    
    function mostrar_fraccionamientos() {  
        $this->prepararConsultaFraccionamiento(19,$_SESSION['usuContribuyente'],''); 
        $item = 0;                        
        while (odbc_fetch_row($this->result)) {   
            $item++;     	      
        	$fraccionamiento_id = odbc_result($this->result, "fraccionamiento_id");
        	$base_legal = odbc_result($this->result, "base_legal");
        	$Fecha_Acogida = odbc_result($this->result, "Fecha_Acogida");
        	$periodos = odbc_result($this->result, "periodos");
        	$Deuda_Total = odbc_result($this->result, "Deuda_Total");
        	$Inicial = odbc_result($this->result, "Inicial");
            $Saldo = odbc_result($this->result, "Saldo");         	        
            $ValorCuota = odbc_result($this->result, "ValorCuota"); 
            $Cuotas = odbc_result($this->result, "Cuotas");
            $estado = odbc_result($this->result, "estado");
            echo'<tr>
                <td style="text-align: center; font-size: 9px; width: 3%; color: #000;">'.$item.'</td>                
                <td style="text-align: center; font-size: 9px; width: 5%; color: #000;">'.utf8_encode($fraccionamiento_id).'</td>
                <td style="text-align: left; font-size: 9px; width: 15%; color: #000;">'.utf8_encode($base_legal).'</td>
                <td style="text-align: left; font-size: 9px; width: 14%; color: #000;">'.utf8_encode($Fecha_Acogida).'</td>
                <td style="text-align: left; font-size: 9px; width: 12%; color: #000;">'.utf8_encode($periodos).'</td>
                <td style="text-align: center; font-size: 9px; width: 8%; color: #000;">'.utf8_encode($Deuda_Total).'</td>';
                if ($Inicial == '.00') {
                    echo '<td style="text-align: right; font-size: 9px; width: 5%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: right; font-size: 9px; width: 5%; color: #000;">'.utf8_encode($Inicial).'</td>';
                }
                echo '<td style="text-align: right; font-size: 9px; width: 7%; color: #000;">'.utf8_encode($Saldo).'</td>
                <td style="text-align: right; font-size: 9px; width: 7%; color: #000;">'.utf8_encode($ValorCuota).'</td>
                <td style="text-align: center; font-size: 9px; width: 8%; color: #000;">'.utf8_encode($Cuotas).'</td>
                <td style="text-align: center; font-size: 9px; width: 7%; color: #000;">'.utf8_encode($estado).'</td>
                <td style="text-align: center; font-size: 9px; width: 30%;">
                        <div class="hidden-sm hidden-xs action-buttons"> 
                            <a href="" onclick="detallesFraccionamiento('.$fraccionamiento_id.')"><i><img src="../../assets/images/ver.png" alt="" ></i> Detalles</a>                                                                                                          
                        </div>
                        <div class="hidden-md hidden-lg">
                            <div class="inline pos-rel">
                                <button class="btn btn-minier btn-yellow dropdown-toggle" data-toggle="dropdown" data-position="auto">
                                    <i class="ace-icon fa fa-caret-down icon-only bigger-120"></i>
                                </button>

                                <ul class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">
                                    <li>
                                        <a href="" onclick="detallesFraccionamiento('.$fraccionamiento_id.')"><i><img src="../../assets/images/ver.png" alt=""></i> Detalles</a>                                                                                                                 
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </td>
            </tr>';
        } 
        $this->cerrarAbrir(); 
    }

    function mostrar_datos_fraccionamientos() {  
        $this->prepararConsultaFraccionamiento(22,$_SESSION['usuContribuyente'],$this->param['param_fraccionamientoID']);                       
        while (odbc_fetch_row($this->result)) {                       
            $fraccionamiento_id = odbc_result($this->result, "fraccionamiento_id");
            $base_legal = odbc_result($this->result, "base_legal");
            $Fecha_Acogida = odbc_result($this->result, "Fecha_Acogida");
            $periodos = odbc_result($this->result, "periodos");
            $Deuda_Total = odbc_result($this->result, "Deuda_Total");
            $Inicial = odbc_result($this->result, "Inicial");
            $Saldo = odbc_result($this->result, "Saldo");                   
            $ValorCuota = odbc_result($this->result, "ValorCuota"); 
            $Cuotas = odbc_result($this->result, "Cuotas");
            $estado = odbc_result($this->result, "estado");
            echo'<table>        
                <tr>                                                                    
                    <td colspan="4" style="font-size: 10.5px; width: 1000px;  height: 30px;"><strong>&nbsp;&nbsp;Base Legal:</strong>&nbsp;'.utf8_encode($base_legal).'</td>                                                       
                </tr>
                <tr>                                                                      
                    <td style="font-size: 10.5px; width: 300px; height: 30px;"><strong>&nbsp;&nbsp;Fecha Acogida:</strong>&nbsp;'.utf8_encode($Fecha_Acogida).'</td>
                    <td style="font-size: 11px; width: 300px; height: 30px;"><strong>&nbsp;&nbsp;Periodos Afectados:</strong>&nbsp;'.utf8_encode($periodos).'</td>
                    <td style="font-size: 10.5px; width: 200px; height: 30px;"><strong>&nbsp;&nbsp;Estado:</strong>&nbsp;'.utf8_encode($estado).'</td>
                    <td style="font-size: 10.5px; width: 200px; height: 30px;"><strong>&nbsp;&nbsp;Deuda Total</strong>&nbsp;'.utf8_encode($Deuda_Total).'</td>
                </tr>
                <tr>                                                                      
                    <td style="font-size: 10.5px; width: 300px; height: 30px;"><strong>&nbsp;&nbsp;Deuda Fraccionada:</strong>&nbsp;'.utf8_encode($Saldo).'</td>
                    <td style="font-size: 10.5px; width: 300px; height: 30px;"><strong>&nbsp;&nbsp;Valor Cuota:</strong>&nbsp;'.utf8_encode($ValorCuota).'</td>
                    <td style="font-size: 10.5px; width: 200px; height: 30px;"><strong>&nbsp;&nbsp;Nro Cuotas:</strong>&nbsp;'.utf8_encode($Cuotas).'</td>';
                if ($Inicial == '.00') {
                    echo '<td style="font-size: 10.5px; width: 200px; height: 30px;"><strong>&nbsp;&nbsp;Cuota Inicial:</strong>&nbsp;0.00</td>';
                } else {
                    echo '<td style="font-size: 10.5px; width: 200px; height: 30px;"><strong>&nbsp;&nbsp;Cuota Inicial:</strong>&nbsp;'.utf8_encode($Inicial).'</td>';
                }                                
                echo '</tr>                                                                   
        </table>';
        } 
        $this->cerrarAbrir(); 
    }

    function mostrar_tributos_afectados() {  
        $this->prepararConsultaTributoFracc(16,$this->param['param_fraccionamientoID']);                       
        while (odbc_fetch_row($this->result)) {                       
            $tributos_ID = odbc_result($this->result, "tributos_ID");
            $descripcion = odbc_result($this->result, "descripcion");            
        }
            echo'<tr>
                <td style="text-align: center; font-size: 9px; width: 5%; color: #000;">'.$tributos_ID.'</td>                
                <td style="text-align: center; font-size: 9px; width: 12%; color: #000;">'.utf8_encode($descripcion).'</td>
            </tr>';

        $this->cerrarAbrir(); 
    }

    function mostrar_cronograma_fraccionamiento() {  
        $this->prepararConsultaFraccionamiento(20,$_SESSION['usuContribuyente'],$this->param['param_fraccionamientoID']);              
        while (odbc_fetch_row($this->result)) {               
            $NroCuota = odbc_result($this->result, "NroCuota");
            $saldo = odbc_result($this->result, "saldo");
            $amortizacion = odbc_result($this->result, "amortizacion");
            $Interes = odbc_result($this->result, "Interes");
            $Importe = odbc_result($this->result, "Importe");            
            $FechaVence = odbc_result($this->result, "FechaVence");                   
            $FechaPago = odbc_result($this->result, "FechaPago"); 
            $estado = odbc_result($this->result, "estado");
            echo'<tr>              
                <td style="text-align: center; font-size: 9px; width: 10%; color: #000;">'.utf8_encode($NroCuota).'</td>
                <td style="text-align: center; font-size: 9px; width: 10%; color: #000;">'.utf8_encode($saldo).'</td>
                <td style="text-align: center; font-size: 9px; width: 10%; color: #000;">'.utf8_encode($amortizacion).'</td>';
                if ($Interes == '.00') {
                    echo '<td style="text-align: center; font-size: 9px; width: 10%; color: #000;">0.00</td>';
                } else {
                    echo '<td style="text-align: center; font-size: 9px; width: 10%; color: #000;">'.utf8_encode($Interes).'</td>';
                }
                echo '<td style="text-align: center; font-size: 9px; width: 10%; color: #000;">'.utf8_encode($Importe).'</td>
                <td style="text-align: center; font-size: 9px; width: 7%; color: #000;">'.utf8_encode($FechaVence).'</td>';
                if ($FechaPago == '') {
                    echo '<td style="text-align: center; font-size: 9px; width: 10%; color: #000;">--</td>';
                } else {
                    echo '<td style="text-align: center; font-size: 9px; width: 10%; color: #000;">'.utf8_encode($FechaPago).'</td>                ';
                }
                echo '<td style="text-align: center; font-size: 9px; width: 10%; color: #000;">'.utf8_encode($estado).'</td>                
            </tr>';
        } 
        $this->cerrarAbrir(); 
    }

}
 ?>