<?php 
session_start();
include_once '../../model/conexion_model.php';


class Recibos_Model
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
			case 'mostrar_recibos':
				echo $this->mostrar_recibos();
				break;	
            case 'mostrar_recibos_busqueda':
                echo $this->mostrar_recibos_busqueda();
                break;  					
		}
	}

	function prepararConsultaRecibos($opcion, $persona_id, $anio, $mesInicial, $mesFinal) {
		$consultaSql = "exec _Reci_Recibos @tipoconsulta='".$opcion."',@anio='".$anio."',@mes1='".$mesInicial."',@mes2='".$mesFinal."',@persona='".$persona_id."'";
        //echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }
   

    function mostrar_recibos() {  
        $this->prepararConsultaRecibos(18,$_SESSION['usuContribuyente'],'', '', '');
        $item = 0;                             
        while (odbc_fetch_row($this->result)) {
        	$item ++;           	
        	$recibo_id = odbc_result($this->result, "recibo_id");
        	$anio = odbc_result($this->result, "anio");
        	$mes = odbc_result($this->result, "mes");
        	$estado = odbc_result($this->result, "estado"); 
            $Recibos = odbc_result($this->result, "Recibos");
            $mesParam = odbc_result($this->result, "mesParam");   
            $numeroRecibo = odbc_result($this->result, "numeroRecibo"); 
            echo '<table>        
                
                <tr>
                    <td style="font-size: 10px; width: 5%; height: 25px; text-align:center;">'.$item.'</td>
                    <td style="font-size: 10px; width: 8%; height: 25px; text-align:center;">'.$_SESSION['usuContribuyente'].'</td>
                    <td style="font-size: 10px; width: 8%; height: 25px; text-align:center;">'.utf8_encode($anio).'</td>
                    <td style="font-size: 10px; width: 15%; height: 25px; text-align:center;">'.utf8_encode($mes).'</td> 
                    <td style="font-size: 10px; width: 15%; height: 25px; text-align:center;">'.utf8_encode($Recibos).'</td> 
                    <td style="font-size: 10px; width: 15%; height: 25px; text-align:center;">'.utf8_encode($estado).'</td> 
                    <!--td style="text-align: center; font-size: 10px; height: 10px; width: 15%;">
                        <div class="hidden-sm hidden-xs action-buttons"> 
                            <a href="" onclick="imprimirRecibo('."'".$recibo_id."'".','."'".$mesParam."'".','."'".$anio."'".','."'".$numeroRecibo."'".')"><i><img src="../../assets/images/print.png" alt="" ></i> Imprimir</a>                                                      
                        </div>
                        <div class="hidden-md hidden-lg">
                            <div class="inline pos-rel">
                                <button class="btn btn-minier btn-yellow dropdown-toggle" data-toggle="dropdown" data-position="auto">
                                    <i class="ace-icon fa fa-caret-down icon-only bigger-120"></i>
                                </button>

                                <ul class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">
                                    <li>
                                        <a href="" onclick="imprimirRecibo('."'".$recibo_id."'".','."'".$mesParam."'".','."'".$anio."'".','."'".$numeroRecibo."'".')"><i><img src="../../assets/images/print.png" alt=""></i> Imprimir</a>                                     
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </td-->                              
                </tr>                
                                                                                 
            </table>';     	
        }  
                    
        $this->cerrarAbrir(); 
    }

    function mostrar_recibos_busqueda() {  
        $this->prepararConsultaRecibos(13,$_SESSION['usuContribuyente'],$this->param['param_periodo_recibo'], $this->param['param_mes_inicial'], $this->param['param_mes_final']);
        $item = 0;                             
        while (odbc_fetch_row($this->result)) {
            $item ++;               
            $recibo_id = odbc_result($this->result, "recibo_id");
            $anio = odbc_result($this->result, "anio");
            $mes = odbc_result($this->result, "mes");
            $estado = odbc_result($this->result, "estado"); 
            $Recibos = odbc_result($this->result, "Recibos");
            $mesParam = odbc_result($this->result, "mesParam");   
            $numeroRecibo = odbc_result($this->result, "numeroRecibo"); 
            echo '<table>        
                <tr>
                    <td style="font-size: 10px; width: 5%; height: 25px; text-align:center;">'.$item.'</td>
                    <td style="font-size: 10px; width: 8%; height: 25px; text-align:center;">'.$_SESSION['usuContribuyente'].'</td>
                    <td style="font-size: 10px; width: 8%; height: 25px; text-align:center;">'.utf8_encode($anio).'</td>
                    <td style="font-size: 10px; width: 15%; height: 25px; text-align:center;">'.utf8_encode($mes).'</td> 
                    <td style="font-size: 10px; width: 15%; height: 25px; text-align:center;">'.utf8_encode($Recibos).'</td> 
                    <td style="font-size: 10px; width: 15%; height: 25px; text-align:center;">'.utf8_encode($estado).'</td> 
                    <!--td style="text-align: center; font-size: 10px; height: 10px; width: 15%;">
                        <div class="hidden-sm hidden-xs action-buttons"> 
                            <a href="" onclick="imprimirRecibo('."'".$recibo_id."'".','."'".$mesParam."'".','."'".$anio."'".','."'".$numeroRecibo."'".')"><i><img src="../../assets/images/print.png" alt="" ></i> Imprimir</a>                                                      
                        </div>
                        <div class="hidden-md hidden-lg">
                            <div class="inline pos-rel">
                                <button class="btn btn-minier btn-yellow dropdown-toggle" data-toggle="dropdown" data-position="auto">
                                    <i class="ace-icon fa fa-caret-down icon-only bigger-120"></i>
                                </button>

                                <ul class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">
                                    <li>
                                        <a href="" onclick="imprimirRecibo('."'".$recibo_id."'".','."'".$mesParam."'".','."'".$anio."'".','."'".$numeroRecibo."'".')"><i><img src="../../assets/images/print.png" alt=""></i> Imprimir</a>                                     
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </td-->                              
                </tr>                
                                                                                 
            </table>';          
        }  
                    
        $this->cerrarAbrir(); 
    }
   
}
 ?>