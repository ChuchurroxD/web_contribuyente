<?php 
session_start();
include_once '../../model/conexion_model.php';


class Predio_Model
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
			case 'mostrar_datos_predio':
				echo $this->mostrar_datos_predio();
				break;	
            case 'mostrar_datos_pisos':
                echo $this->mostrar_datos_pisos();
                break;  					
		}
	}

	function prepararConsultaDetallePredio($opcion, $predio, $anio) {
		$consultaSql = "exec _Pred_Predio_Contribuyente @TipoConsulta='".$opcion."', @Predio_id='".$predio."', @idPeriodo='".$anio."'";
        //echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    function prepararConsultaDetallePisos($opcion, $predio, $anio) {
        $consultaSql = "exec _Pred_Pisos @TipoConsulta=13 , @predio_ID='".$predio."', @anio='".$anio."'";
        //echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }
    

    function mostrar_datos_predio() {  
        $this->prepararConsultaDetallePredio(23,$this->param['param_predio'],$this->param['param_periodo_predio']);
        $item = 0;                             
        while (odbc_fetch_row($this->result)) {
        	$item ++;           	
        	$tipo_predio = odbc_result($this->result, "tipo_predio");
        	$area_terreno = odbc_result($this->result, "area_terreno");
        	$valor_construccion = odbc_result($this->result, "valor_construccion");
        	$predio_ID = odbc_result($this->result, "predio_ID");
        	$tipo_inmueble = odbc_result($this->result, "tipo_inmueble");
        	$area_construida = odbc_result($this->result, "area_construida");
            $nombre_predio = odbc_result($this->result, "nombre_predio");        	                    
            $activo = odbc_result($this->result, "estado");
            $frente_metros = odbc_result($this->result, "frente_metros");
            $valor_otra_instalacion = odbc_result($this->result, "valor_otra_instalacion");
            $valor_terreno = odbc_result($this->result, "valor_terreno");
            $valor_area_comun = odbc_result($this->result, "valor_area_comun");
            $fecha_adquisicion = odbc_result($this->result, "fecha_adquisicion");
            $adquisicion = odbc_result($this->result, "adquisicion");
            $posesion = odbc_result($this->result, "posesion");
            $uso_predio = odbc_result($this->result, "uso_predio");
            $total_autovaluo = odbc_result($this->result, "total_autovaluo");
            $estado_predio = odbc_result($this->result, "estado_predio");
        }  
        echo '<table>        
                <tr>                                                                    
                    <td colspan="4" style="font-size: 10.5px; width: 1000px;  height: 25px; text-align: center;" bgcolor="#f4f600"><strong>Información del Predio en el Año: '.$this->param['param_periodo_predio'].'</strong>&nbsp;</td>                                                       
                </tr>
                <tr>                                                                    
                    <td colspan="4" style="font-size: 10.5px; width: 1000px;  height: 25px; text-align: center;" bgcolor="#fbeded"><strong>Caracteristicas General</strong>&nbsp;</td>                                                       
                </tr>
                <tr>                                                                    
                    <td colspan="4" style="font-size: 10.5px; width: 1000px;  height: 5px; text-align: center;"><strong></strong>&nbsp;</td>                                                       
                </tr>
                <tr>                                                                      
                    <td style="font-size: 10.5px; width: 250px; height: 25px;"><strong>&nbsp;&nbsp;Año:</strong>&nbsp; '.$this->param['param_periodo_predio'].'</td>
                    <td style="font-size: 11px; width: 250px; height: 25px;"><strong>&nbsp;Código Predio:</strong>&nbsp; '.utf8_encode($predio_ID).'</td>
                    <td style="font-size: 10.5px; width: 500px; height: 25px;" colspan="2"><strong>&nbsp;Ubicación:</strong>&nbsp;'.utf8_encode($nombre_predio).'</td>
                    
                </tr>
                <tr>
                    <td style="font-size: 10.5px; width: 200px; height: 25px;"><strong>&nbsp;Tipo Predio:</strong>&nbsp;'.utf8_encode($tipo_predio).'</td>                                                                    
                    <td style="font-size: 10.5px; width: 250px; height: 25px;"><strong>&nbsp;&nbsp;Tipo Inmueble:</strong>&nbsp; '.utf8_encode($tipo_inmueble).'</td>
                    <td style="font-size: 10.5px; width: 250px; height: 25px;"><strong>&nbsp;Estado :</strong>&nbsp;'.utf8_encode($estado_predio).'</td>
                    <td style="font-size: 10.5px; width: 300px; height: 25px;"><strong>&nbsp;Uso Predio:</strong>&nbsp;'.utf8_encode($uso_predio).'</td>
                                
                    
                </tr>
                <tr>
                <td style="font-size: 10.5px; width: 200px; height: 25px;"><strong>&nbsp;Área Terreno:</strong>&nbsp;'.utf8_encode($area_terreno).' m<sup>2</sup></td>'; 
                if ($area_construida == '.00') {
                    echo '<td style="font-size: 10.5px; width: 250px; height: 25px;"><strong>&nbsp;Área Construida:</strong>&nbsp;0.00 m<sup>2</sup></td>';
                } else {
                    echo '<td style="font-size: 10.5px; width: 250px; height: 25px;"><strong>&nbsp;Área Construida:</strong>&nbsp;'.utf8_encode($area_construida).' m<sup>2</sup></td>';
                }

                if ($frente_metros == '.00') {
                    echo '<td style="font-size: 10.5px; width: 250px; height: 25px;"><strong>&nbsp;Frente (m):</strong>&nbsp;0.00 m<sup>2</sup></td>';
                } else {
                    echo '<td style="font-size: 10.5px; width: 250px; height: 25px;"><strong>&nbsp;Frente (m):</strong>&nbsp;'.utf8_encode($frente_metros).' m<sup>2</sup></td>';
                }

                if ($valor_terreno == '.00') {
                    echo '<td style="font-size: 10.5px; width: 300px; height: 25px;"><strong>&nbsp;Valor Terreno:</strong>&nbsp;S/. 0.00</td>';
                } else {
                    echo '<td style="font-size: 10.5px; width: 300px; height: 25px;"><strong>&nbsp;Valor Terreno:</strong>&nbsp;S/. '.utf8_encode($valor_terreno).'</td>';
                }
                                                                                         
                    echo '          
                </tr>
                <tr>';
                if ($valor_construccion == '.00') {
                    echo '<td style="font-size: 10.5px; width: 200px; height: 25px;"><strong>&nbsp;Valor Construc.:</strong>&nbsp;S/. 0.00</td>';
                } else {
                    echo '<td style="font-size: 10.5px; width: 200px; height: 25px;"><strong>&nbsp;Valor Construc.:</strong>&nbsp;S/. '.utf8_encode($valor_construccion).'</td>';
                }
                if ($valor_otra_instalacion == '.00') {
                    echo '<td style="font-size: 10.5px; width: 250px; height: 25px;"><strong>&nbsp;Valor Otras Inst.:</strong>&nbsp;S/. 0.00</td>';
                } else {
                    echo '<td style="font-size: 10.5px; width: 250px; height: 25px;"><strong>&nbsp;Valor Otras Inst.:</strong>&nbsp;S/. '.utf8_encode($valor_otra_instalacion).'</td>';
                }
                if ($valor_area_comun == '.00') {
                    echo '<td style="font-size: 10.5px; width: 250px; height: 25px;"><strong>&nbsp;Valor Área Común:</strong>&nbsp;S/. 0.00</td>';
                } else {
                    echo '<td style="font-size: 10.5px; width: 250px; height: 25px;"><strong>&nbsp;Valor Área Común:</strong>&nbsp;S/. '.utf8_encode($valor_area_comun).'</td>';
                }
                if ($total_autovaluo == '.00') {
                    echo '<td style="font-size: 10.5px; width: 300px; height: 25px;"><strong>&nbsp;Autovaluo;</strong>&nbsp;S/. 0.00</td>';
                } else {
                    echo '<td style="font-size: 10.5px; width: 300px; height: 25px;"><strong>&nbsp;Autovaluo:</strong>&nbsp;S/. '.utf8_encode($total_autovaluo).'</td>';
                }
                    echo '
                    
                                  
                </tr> 
                <tr> 
                    <td style="font-size: 10.5px; width: 250px; height: 25px;"><strong>&nbsp;&nbsp;Adquisición:</strong>&nbsp;'.utf8_encode($adquisicion).'</td> 
                    <td style="font-size: 10.5px; width: 250px; height: 25px;"><strong>&nbsp;Fecha Adquisición:</strong>&nbsp;'.utf8_encode($fecha_adquisicion).'</td>                           
                    <td style="font-size: 10.5px; width: 250px; height: 25px;"><strong>&nbsp;Posesión:</strong>&nbsp;'.utf8_encode($posesion).'</td> 
                    <td style="font-size: 10.5px; width: 300px; height: 25px; color:#36bd17;"><strong>&nbsp;Activo:</strong>&nbsp;'.utf8_encode($activo).'</td>                   
                </tr>                                                                   
            </table>';            
        $this->cerrarAbrir(); 
    }

    function mostrar_datos_pisos() {  
        $this->prepararConsultaDetallePisos(13,$this->param['param_predio'],$this->param['param_periodo_predio']);
        $item = 0;                             
        while (odbc_fetch_row($this->result)) {
            $item ++;               
            $VEZ = odbc_result($this->result, "VEZ");
            $piso_ID = odbc_result($this->result, "piso_ID");
            $seccion = odbc_result($this->result, "seccion");
            $antiguedad = odbc_result($this->result, "antiguedad");
            $muro = odbc_result($this->result, "muro");
            $techo = odbc_result($this->result, "techo");
            $piso = odbc_result($this->result, "piso");                               
            $puerta = odbc_result($this->result, "puerta");
            $revestimiento = odbc_result($this->result, "revestimiento");
            $banio = odbc_result($this->result, "banio");
            $instalaciones = odbc_result($this->result, "instalaciones");
            $area_construida = odbc_result($this->result, "area_construida");
            $area_comun = odbc_result($this->result, "area_comun");
            $valor_construido_total = odbc_result($this->result, "valor_construido_total");
            $piso_clasificacion = odbc_result($this->result, "piso_clasificacion");
            $piso_material = odbc_result($this->result, "piso_material");
            $piso_estado = odbc_result($this->result, "piso_estado");
            $condicion = odbc_result($this->result, "condicion");
            $numero = odbc_result($this->result, "numero");
            echo '<table>                                                    
                <tr>                                                                      
                    <td style="font-size: 9px; width: 5%; height: 25px; text-align:center;">'.$numero.'</td>
                    <td style="font-size: 9px; width: 5%; height: 25px; text-align:center;">'.$seccion.'</td>
                    <td style="font-size: 9px; width: 3%; height: 25px; text-align:center;">'.$antiguedad.'</td>
                    <td style="font-size: 9px; width: 5%; height: 25px; text-align:center;">'.$muro.'</td>
                    <td style="font-size: 9px; width: 5%; height: 25px; text-align:center;">'.$techo.'</td>
                    <td style="font-size: 9px; width: 5%; height: 25px; text-align:center;">'.$piso.'</td>
                    <td style="font-size: 9px; width: 5%; height: 25px; text-align:center;">'.$puerta.'</td>
                    <td style="font-size: 9px; width: 5%; height: 25px; text-align:center;">'.$revestimiento.'</td>
                    <td style="font-size: 9px; width: 5%; height: 25px; text-align:center;">'.$banio.'</td>
                    <td style="font-size: 9px; width: 5%; height: 25px; text-align:center;">'.$instalaciones.'</td>';
                    if ($area_construida == '.00') {
                        echo '<td style="font-size: 9px; width: 8%; height: 25px;">0.00</td>';
                    } else {
                        echo '<td style="font-size: 9px; width: 8%; height: 25px;">'.$area_construida.'</td>';
                    }
                    if ($area_comun == '.00') {
                        echo '<td style="font-size: 9px; width: 8%; height: 25px;">0.00</td>';
                    } else {
                        echo '<td style="font-size: 9px; width: 8%; height: 25px;">'.$area_comun.'</td>';
                    }
                    if ($valor_construido_total == '.00') {
                        echo '<td style="font-size: 9px; width: 8%; height: 25px;">0.00</td>';
                    } else {
                        echo '<td style="font-size: 9px; width: 8%; height: 25px;">'.$valor_construido_total.'</td>';
                    }
                    
                    echo '<td style="font-size: 9px; width: 25%; height: 25px;">'.utf8_encode($piso_clasificacion).'</td>
                    <td style="font-size: 9px; width: 10%; height: 25px;">'.utf8_encode($piso_material).'</td>
                    <td style="font-size: 9px; width: 10%; height: 25px;">'.utf8_encode($piso_estado).'</td>
                    <td style="font-size: 9px; width: 10%; height: 25px;">'.utf8_encode($condicion).'</td>
                    
                </tr>';
        }  
        
            echo '</table>';            
        $this->cerrarAbrir(); 
    }
}
 ?>