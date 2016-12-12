<?php 
session_start();
include_once '../../model/conexion_model.php';


class Liquidacion_Model
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
			case 'mostrar_todas_liquidaciones':
				echo $this->mostrar_todas_liquidaciones();
				break;			
			case 'mostrar_busqueda_liquidaciones':
				echo $this->mostrar_busqueda_liquidaciones();
				break;
			case 'mostrar_total_liquidaciones':
				echo $this->mostrar_total_liquidaciones();
				break;
			case 'mostrar_total_liquidaciones_busqueda':
				echo $this->mostrar_total_liquidaciones_busqueda();
				break;
			case 'mostrar_liquidacion_detalle':
				echo $this->mostrar_liquidacion_detalle();
				break;
		}
	}

	function prepararConsultaLiquidacion($opcion, $mes, $anio) {
		$consultaSql = "exec _liqu_Liquidacion_Proceso @tipo='".$opcion."', @persona_ID='".$_SESSION['usuContribuyente']."', @mes='".$mes."', @anio='".$anio."'";
        //echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    function prepararConsultaLiquidacionDetalle($opcion, $liquidacionID) {
		$consultaSql = "exec _Liqu_LiquidacionDetalle @tipo='".$opcion."' , @liquidacion_id = '".$liquidacionID."'";
        //echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    
    function mostrar_todas_liquidaciones() {  
        $this->prepararConsultaLiquidacion(22,0,0);
        $item = 0;                             
        while (odbc_fetch_row($this->result)) {
        	$item ++;           	
        	$liquidacion_id = odbc_result($this->result, "liquidacion_id");
        	$fecha = odbc_result($this->result, "fecha");
        	$importe = odbc_result($this->result, "importe");
        	$Intereses = odbc_result($this->result, "Intereses");
        	$importeTotal = odbc_result($this->result, "importeTotal");
        	$estado = odbc_result($this->result, "estado");        	        
            echo'<tr>
                <td style="text-align: center; font-size: 10px; width: 3%; color: #000;">'.$item.'</td>                
                <td style="text-align: left; font-size: 10px; width: 5%; color: #000;">'.utf8_encode($liquidacion_id).'</td>
                <td style="text-align: center; font-size: 10px; width: 13%; color: #000;">'.utf8_encode($fecha).'</td>
                <td style="text-align: center; font-size: 10px; width: 5%; color: #000;">'.utf8_encode($importe).'</td>';
                if ($Intereses == '.00') {
                	echo'<td style="text-align: center; font-size: 10px; width: 5%; color: #000;">0.00</td>';
                } else {
                	echo'<td style="text-align: center; font-size: 10px; width: 5%; color: #000;">'.$Intereses.'</td>';
                }
                echo '<td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($importeTotal).'</td>
                <td style="text-align: center; font-size: 10px; width: 5%; color: #000;">'.utf8_encode($estado).'</td>              
                <td style="text-align: center; font-size: 10px; height: 20px; width: 20%;">
                        <div class="hidden-sm hidden-xs action-buttons"> 
                            <a href="" onclick="detallesLiquidacion('.$liquidacion_id.')"><i><img src="../../assets/images/ver.png" alt="" ></i> Detalles</a>                                                      
                            <!--a href="" onclick="imprimir_liquidacion('.$liquidacion_id.')"><i><img src="../../assets/images/print.png" alt="" ></i> Imprimir</a-->                             
                        </div>
                        <div class="hidden-md hidden-lg">
                            <div class="inline pos-rel">
                                <button class="btn btn-minier btn-yellow dropdown-toggle" data-toggle="dropdown" data-position="auto">
                                    <i class="ace-icon fa fa-caret-down icon-only bigger-120"></i>
                                </button>

                                <ul class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">
                                    <li>
                                        <a href="" onclick="detallesLiquidacion('.$liquidacion_id.')"><i><img src="../../assets/images/ver.png" alt=""></i> Detalles</a>                                     
                                        <!--a href="" onclick="imprimir_liquidacion('.$liquidacion_id.')"><i><img src="../../assets/images/print.png" alt=""></i> Imprimir</a-->                                        
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </td> 
            </tr>';
        }              
        $this->cerrarAbrir(); 
    }

    function mostrar_busqueda_liquidaciones() {  
        $this->prepararConsultaLiquidacion(22,$this->param['param_mes'],$this->param['param_anio']);
        $item = 0;                             
        while (odbc_fetch_row($this->result)) {
        	$item ++;           	
        	$liquidacion_id = odbc_result($this->result, "liquidacion_id");
        	$fecha = odbc_result($this->result, "fecha");
        	$importe = odbc_result($this->result, "importe");
        	$Intereses = odbc_result($this->result, "Intereses");
        	$importeTotal = odbc_result($this->result, "importeTotal");
        	$estado = odbc_result($this->result, "estado");        	        
            echo'<tr>
                <td style="text-align: center; font-size: 10px; width: 3%; color: #000;">'.$item.'</td>                
                <td style="text-align: left; font-size: 10px; width: 5%; color: #000;">'.utf8_encode($liquidacion_id).'</td>
                <td style="text-align: center; font-size: 10px; width: 13%; color: #000;">'.utf8_encode($fecha).'</td>
                <td style="text-align: center; font-size: 10px; width: 5%; color: #000;">'.utf8_encode($importe).'</td>';
                if ($Intereses == '.00') {
                	echo'<td style="text-align: center; font-size: 10px; width: 5%; color: #000;">0.00</td>';
                } else {
                	echo'<td style="text-align: center; font-size: 10px; width: 5%; color: #000;">'.$Intereses.'</td>';
                }
                echo '<td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($importeTotal).'</td>
                <td style="text-align: center; font-size: 10px; width: 5%; color: #000;">'.utf8_encode($estado).'</td>              
                <td style="text-align: center; font-size: 10px; height: 20px; width: 20%;">
                        <div class="hidden-sm hidden-xs action-buttons"> 
                            <a href="" onclick="detallesLiquidacion('.$liquidacion_id.')"><i><img src="../../assets/images/ver.png" alt="" ></i> Detalles</a>                                                      
                            <!--a href="" onclick="imprimir_liquidacion('.$liquidacion_id.')"><i><img src="../../assets/images/print.png" alt="" ></i> Imprimir</a-->                             
                        </div>
                        <div class="hidden-md hidden-lg">
                            <div class="inline pos-rel">
                                <button class="btn btn-minier btn-yellow dropdown-toggle" data-toggle="dropdown" data-position="auto">
                                    <i class="ace-icon fa fa-caret-down icon-only bigger-120"></i>
                                </button>

                                <ul class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">
                                    <li>
                                        <a href="" onclick="detallesLiquidacion('.$liquidacion_id.')"><i><img src="../../assets/images/ver.png" alt=""></i> Detalles</a>                                     
                                        <!--a href="" onclick="imprimir_liquidacion('.$liquidacion_id.')"><i><img src="../../assets/images/print.png" alt=""></i> Imprimir</a-->                                        
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </td> 
            </tr>';
        }                    
        $this->cerrarAbrir(); 
    }

    function mostrar_total_liquidaciones() {               
        $this->prepararConsultaLiquidacion(23,0,0);                             
        while (odbc_fetch_row($this->result)) {        	        	        	
        	$totalImporte = odbc_result($this->result, "totalImporte");
        	$totalInteres = odbc_result($this->result, "totalInteres");
        	$importeTotal = odbc_result($this->result, "importeTotal");
            echo '<tr>
                <td style="text-align: right; font-size: 10px;  font-weight: bold; color: #000; width: 60%;" bgcolor="#ffe9e6" colspan="3">TOTAL</td>
                <td style="text-align: center; font-size: 10px;  font-weight: bold; color: #000; width: 8%;" bgcolor="#ffe9e6">'.$totalImporte.'</td>';
                if ($totalInteres == '.00') {
                	echo'<td style="text-align: center; font-size: 10px; width: 8%; color: #000; font-weight: bold;" bgcolor="#ffe9e6">0.00</td>';
                } else {
                	echo'<td style="text-align: center; font-size: 10px; width: 8%; color: #000; font-weight: bold;" bgcolor="#ffe9e6">'.$totalInteres.'</td>';
                }
                echo '<td style="text-align: center; font-size: 10px; font-weight: bold; color: #000; width: 15%;" bgcolor="#ffe9e6">'.$importeTotal.'</td>	
                <td style="text-align: center; font-size: 10px; width: 90%; color: #000;" bgcolor="#ffe9e6" colspan="2"></td>              
               
            </tr>'; 
        }        
        $this->cerrarAbrir(); 
    }

    function mostrar_total_liquidaciones_busqueda() {               
        $this->prepararConsultaLiquidacion(23,$this->param['param_mes'],$this->param['param_anio']);                        
        while (odbc_fetch_row($this->result)) {        	        	        	
        	$totalImporte = odbc_result($this->result, "totalImporte");
        	$totalInteres = odbc_result($this->result, "totalInteres");
        	$importeTotal = odbc_result($this->result, "importeTotal");
            echo '<tr>
                <td style="text-align: right; font-size: 10px;  font-weight: bold; color: #000; width: 60%;" bgcolor="#ffe9e6" colspan="3">TOTAL</td>
                <td style="text-align: center; font-size: 10px;  font-weight: bold; color: #000; width: 8%;" bgcolor="#ffe9e6">'.$totalImporte.'</td>';
                if ($totalInteres == '.00') {
                	echo'<td style="text-align: center; font-size: 10px; width: 8%; color: #000; font-weight: bold;" bgcolor="#ffe9e6">0.00</td>';
                } else {
                	echo'<td style="text-align: center; font-size: 10px; width: 8%; color: #000; font-weight: bold;" bgcolor="#ffe9e6">'.$totalInteres.'</td>';
                }
                echo '<td style="text-align: center; font-size: 10px; font-weight: bold; color: #000; width: 15%;" bgcolor="#ffe9e6">'.$importeTotal.'</td>	
                <td style="text-align: center; font-size: 10px; width: 90%; color: #000;" bgcolor="#ffe9e6" colspan="2"></td>  
            </tr>'; 
        }        
        $this->cerrarAbrir(); 
    }

    function mostrar_liquidacion_detalle() {               
        $this->prepararConsultaLiquidacionDetalle(5,$this->param['param_liquidacionID']);                        
        while (odbc_fetch_row($this->result)) {        	        	        	
        	$tributo_ID = odbc_result($this->result, "tributo_ID");
        	$abrev = odbc_result($this->result, "abrev");
        	$ANIO = odbc_result($this->result, "ANIO");
        	$ENE = odbc_result($this->result, "ENE");
        	$FEB = odbc_result($this->result, "FEB");
        	$MAR = odbc_result($this->result, "MAR");
        	$ABR = odbc_result($this->result, "ABR");
        	$MAY = odbc_result($this->result, "MAY");
        	$JUN = odbc_result($this->result, "JUN");
        	$JUL = odbc_result($this->result, "JUL");
        	$AGO = odbc_result($this->result, "AGO");
        	$SEP = odbc_result($this->result, "SEP");
        	$OCT = odbc_result($this->result, "OCT");
        	$NOV = odbc_result($this->result, "NOV");
        	$DIC = odbc_result($this->result, "DIC");
        	$TOT = odbc_result($this->result, "TOT");
            echo '<tr>               
                <td style="text-align: center; font-size: 10px; color: #000; width: 25%;">'.$tributo_ID.' - '.$abrev.'</td>
                <td style="text-align: center; font-size: 10px; color: #000; width: 8%;">'.$ANIO.'</td>';
                if ($ENE == '.00') {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;"> </td>';
                } else {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;">'.$ENE.'</td>';
                }
                if ($FEB == '.00') {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;"> </td>';
                } else {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;">'.$FEB.'</td>';
                }
                if ($MAR == '.00') {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;"> </td>';
                } else {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;">'.$MAR.'</td>';
                }
                if ($ABR == '.00') {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;"> </td>';
                } else {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;">'.$ABR.'</td>';
                }
                if ($MAY == '.00') {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;"> </td>';
                } else {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;">'.$MAY.'</td>';
                }
                if ($JUN == '.00') {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;"> </td>';
                } else {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;">'.$JUN.'</td>';
                }
                if ($JUL == '.00') {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;"> </td>';
                } else {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;">'.$JUL.'</td>';
                }
                if ($AGO == '.00') {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;"> </td>';
                } else {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;">'.$AGO.'</td>';
                }
                if ($SEP == '.00') {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;"> </td>';
                } else {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;">'.$SEP.'</td>';
                }
                if ($OCT == '.00') {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;"> </td>';
                } else {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000; ">'.$OCT.'</td>';
                }
                if ($NOV == '.00') {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;"> </td>';
                } else {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;">'.$NOV.'</td>';
                }
                if ($DIC == '.00') {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;"> </td>';
                } else {
                	echo'<td style="text-align: right; font-size: 10px; width: 5%; color: #000;">'.$DIC.'</td>';
                }
                echo '<td style="text-align: right; font-size: 10px; font-weight: bold; color: #000; width: 15%;">'.$TOT.'</td>
            </tr>'; 
        }  
        $this->prepararConsultaLiquidacionDetalle(6,$this->param['param_liquidacionID']); 
        while (odbc_fetch_row($this->result)) {        	        	        	        	
        	$importeTotal = odbc_result($this->result, "importeTotal");
            echo '<tr>
                <td style="text-align: right; font-size: 10px;  font-weight: bold; color: #000;" bgcolor="#ffe9e6" colspan="14">TOTAL</td>
                <td style="text-align: right; font-size: 10px;  font-weight: bold; color: #000;" bgcolor="#ffe9e6">'.$importeTotal.'</td>                
            </tr>'; 
        }              
        $this->cerrarAbrir(); 
    }


}
 ?>