<?php 
session_start();
include_once '../../model/conexion_model.php';


class Contribuyente_Model
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
			case 'datos_contribuyente':
				echo $this->datos_contribuyente();
				break;	
			case 'mostrar_periodo':
				echo $this->mostrar_periodo();
				break;
			case 'mostrar_periodo_valores':
				echo $this->mostrar_periodo_valores();
				break;
			case 'opcion_predios_actual':
				echo $this->opcion_predios_actual();
				break;			
			case 'opcion_valores_actual':
				echo $this->opcion_valores_actual();
				break;
			case 'opcion_predio_seleccionado':
				echo $this->opcion_predio_seleccionado();
				break;	
			case 'opcion_valores_seleccionado':
				echo $this->opcion_valores_seleccionado();
				break;	
			case 'mostrar_relaciones':
				echo $this->mostrar_relaciones();
                break;
			case 'mostrar_combo_tipo_pago':
				echo $this->mostrar_combo_tipo_pago();
				break;	
			case 'mostrar_combo_cajero':
				echo $this->mostrar_combo_cajero();
				break;
			case 'mostrar_combo_caja':
				echo $this->mostrar_combo_caja();
				break;
			case 'mostrar_pagos':
				echo $this->mostrar_pagos();
				break;
			case 'mostrar_pagos_busqueda':
				echo $this->mostrar_pagos_busqueda();
				break;
			case 'mostrar_pagos_detalle_cabecera':
				echo $this->mostrar_pagos_detalle_cabecera();
				break;
			case 'mostrar_pagos_detalle':
				echo $this->mostrar_pagos_detalle();
				break;
		}
	}

//////////////////////////////////////////// MOSTRAR CONTRIBUYENTE ////////////////////////////////////////////////////

	function prepararConsultaContribuyente($codigo) {		
		$consultaSql = "EXEC _Mant_Contribuyente @persona_id = '".$_SESSION['usuContribuyente']."', @TipoConsulta = '".$codigo."'";          
        //echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

	private function getArrayContribuyente() {
        $datos = array();
        while ($fila = odbc_fetch_array($this->result)) {
            array_push($datos, array(
                "persona_ID" => utf8_encode($fila["persona_ID"]),
                "paterno" => utf8_encode($fila["paterno"]),
                "materno" => utf8_encode($fila["materno"]),
                "nombres" => utf8_encode($fila["nombres"]),
                "tipoDocumentoDescripcion" => utf8_encode($fila["tipoDocumentoDescripcion"]),
                "documento" => utf8_encode($fila["documento"]),
                "direccCompleta" => utf8_encode($fila["direccCompleta"]),
                "sector" => utf8_encode($fila["sector"]),
                "estado_contribuyente" => utf8_encode($fila["estado_contribuyente"])
                ));
        }
        return $datos;
    }

    function datos_contribuyente() {     	    
    	$datos =array();
        $this->prepararConsultaContribuyente(40);        
        $datos = $this->getArrayContribuyente();        
            echo json_encode($datos);  
    }

//////////////////////////////////////////// MOSTRAR COMBOS ////////////////////////////////////////////////////

    function prepararComboPeriodo($codigo) {		
		$consultaSql = "EXEC _Mant_Periodo @Tipoconsulta = '".$codigo."'";          
        //echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    function mostrar_periodo() {     	    
    	$this->prepararComboPeriodo(15);  
        $anioActual = date ("Y");  
        echo '
            <select class="form-control" id="param_periodo" name="param_periodo" onchange="mostrarPrediosPorPeriodo();">';
                
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

    function mostrar_periodo_valores() {     	    
    	$this->prepararComboPeriodo(15);        
        echo '
            <select class="form-control" id="param_periodo_valores" name="param_periodo_valores" onchange="mostrarValoresPorPeriodo();">';
                
        while (odbc_fetch_row($this->result)) {
        	$anio = odbc_result($this->result, "anio");
        	$descripcion = odbc_result($this->result, "descripcion");
            echo'<option value="'.$anio.'">'.utf8_encode($descripcion).'</option>';
        }
        echo '</select>';
        $this->cerrarAbrir();
    }

    function prepararComboTipoPago($codigo, $padre) {		
		$consultaSql = "EXEC _Conf_Multitabla @Tipoconsulta = '".$codigo."',@Confc_cIdPadre = '".$padre."'";          
        //echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    function prepararComboCajero($codigo) {		
		$consultaSql = "EXEC _pago_Cajero @TipoConsulta = '".$codigo."'";          
        //echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    function prepararComboCaja($codigo) {		
		$consultaSql = "EXEC _Pago_Caja @TipoConsulta = '".$codigo."'";          
        //echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    function mostrar_combo_tipo_pago() {     	    
    	$this->prepararComboTipoPago(12, 45);        
        echo '
            <select class="form-control" id="param_tipoPago" name="param_tipoPago">';
                
        while (odbc_fetch_row($this->result)) {
        	$valor = odbc_result($this->result, "valor");
        	$descripcion = odbc_result($this->result, "descripcion");
            echo'<option value="'.$valor.'">'.utf8_encode($descripcion).'</option>';
        }
        echo '</select>';
        $this->cerrarAbrir();
    }

    function mostrar_combo_cajero() {     	    
    	$this->prepararComboCajero(10);        
        echo '
            <select class="form-control" id="param_cajero" name="param_cajero">';
                
        while (odbc_fetch_row($this->result)) {
        	$persona_ID = odbc_result($this->result, "persona_ID");
        	$NombreCompleto = odbc_result($this->result, "NombreCompleto");
            echo'<option value="'.$persona_ID.'">'.utf8_encode($NombreCompleto).'</option>';
        }
        echo '</select>';
        $this->cerrarAbrir();
    }

    function mostrar_combo_caja() {     	    
    	$this->prepararComboCaja(11);        
        echo '
            <select class="form-control" id="param_caja" name="param_caja">';
                
        while (odbc_fetch_row($this->result)) {
        	$Caja_id = odbc_result($this->result, "Caja_id");
        	$descripcion = odbc_result($this->result, "descripcion");
            echo'<option value="'.$Caja_id.'">'.utf8_encode($descripcion).'</option>';
        }
        echo '</select>';
        $this->cerrarAbrir();
    }


//////////////////////////////////////////// MOSTRAR PREDIOS ////////////////////////////////////////////////////

    function prepararConsultaPredios($codigo) {		
		$consultaSql = "EXEC _Pred_Predio_Contribuyente @persona_ID = '".$_SESSION['usuContribuyente']."', @TipoConsulta  = '".$codigo."', @idPeriodo = '".$this->param['param_periodo']."'";          
        echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    function opcion_predios_actual() {     	    
    	$this->prepararConsultaPredios(22);  
    	$item = 0;                             
        while (odbc_fetch_row($this->result)) {
        	$item ++;   
        	$Porcentaje_condominio = odbc_result($this->result, "Porcentaje_Condomino");
        	$Predio_id = odbc_result($this->result, "Predio_id");
        	$posesion = odbc_result($this->result, "posesion");
        	$adquisicion = odbc_result($this->result, "adquisicion");
        	$nombre_predio = odbc_result($this->result, "nombre_predio");
        	$estado = odbc_result($this->result, "estado");
            echo'<tr>
                <td style="text-align: center; font-size: 10px; width: 3%; color: #000;">'.$item.'</td>
                <td style="text-align: left; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($Predio_id).'</td>
                <td style="text-align: left; font-size: 10px; width: 40%; color: #000;">'.utf8_encode($nombre_predio).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.$Porcentaje_condominio.'</td>
                <td style="text-align: center; font-size: 10px; width: 8%; color: #000;">'.$adquisicion.'</td>	
                <td style="text-align: center; font-size: 10px; width: 8%; color: #000;">'.utf8_encode($posesion).'</td>';

                if ($estado == '1') {
                	echo '<td style="text-align: center; font-size: 10px; width: 5%; color: #000;"><img src="../../assets/images/check.png" style="height: 13px; width: 20%;" alt=""></td>';
                }
                														                
            echo '<td style="text-align: center; font-size: 10px; height: 10px; width: 10%;">
                        <div class="hidden-sm hidden-xs action-buttons"> 
                            <a href="" onclick="detallesPredio('."'".$Predio_id."'".')"><i><img src="../../assets/images/ver.png" alt="" ></i> Detalles</a>                                                      
                        </div>
                        <div class="hidden-md hidden-lg">
                            <div class="inline pos-rel">
                                <button class="btn btn-minier btn-yellow dropdown-toggle" data-toggle="dropdown" data-position="auto">
                                    <i class="ace-icon fa fa-caret-down icon-only bigger-120"></i>
                                </button>

                                <ul class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">
                                    <li>
                                        <a href="" onclick="detallesPredio('."'".$Predio_id."'".')"><i><img src="../../assets/images/ver.png" alt=""></i> Detalles</a>                                     
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </td>
            </tr>';
        }      
        echo '<tr>
                <td style="text-align: center; font-size: 10px; width: 100%; font-weight: bold; color: #7c150a;" bgcolor="#ffe9e6" colspan="8">Total de Predios: '.$item.'</td>														                
            </tr>';     
        $this->cerrarAbrir();
    }

    function opcion_predio_seleccionado() {     	    
    	$this->prepararConsultaPredios(17);  
    	$item = 0;                             
        while (odbc_fetch_row($this->result)) {
        	$item ++;   
        	$Porcentaje_condominio = odbc_result($this->result, "Porcentaje_Condomino");
        	$Predio_id = odbc_result($this->result, "Predio_id");
        	$posesion = odbc_result($this->result, "posesion");
        	$adquisicion = odbc_result($this->result, "adquisicion");
        	$nombre_predio = odbc_result($this->result, "nombre_predio");
        	$estado = odbc_result($this->result, "estado");
            echo'<tr>
                <td style="text-align: center; font-size: 10px; width: 3%; color: #000;">'.$item.'</td>
                <td style="text-align: left; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($Predio_id).'</td>
                <td style="text-align: left; font-size: 10px; width: 40%; color: #000;">'.utf8_encode($nombre_predio).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.$Porcentaje_condominio.'</td>
                <td style="text-align: center; font-size: 10px; width: 8%; color: #000;">'.$adquisicion.'</td>	
                <td style="text-align: center; font-size: 10px; width: 8%; color: #000;">'.utf8_encode($posesion).'</td>';

                if ($estado == '1') {
                	echo '<td style="text-align: center; font-size: 10px; width: 5%; color: #000;"><img src="../../assets/images/check.png" style="height: 13px; width: 20%;" alt=""></td>';
                }

                if ($estado == '0') {
                    echo '<td style="text-align: center; font-size: 10px; width: 5%; color: #000;"><img src="../../assets/images/estado0.png" style="height: 13px; width: 20%;" alt=""></td>';
                }
                														                
            echo '<td style="text-align: center; font-size: 10px; height: 10px; width: 10%;">
                        <div class="hidden-sm hidden-xs action-buttons"> 
                            <a href="" onclick="detallesPredio('."'".$Predio_id."'".');"><i><img src="../../assets/images/ver.png" alt="" ></i> Detalles</a>                                                      
                        </div>
                        <div class="hidden-md hidden-lg">
                            <div class="inline pos-rel">
                                <button class="btn btn-minier btn-yellow dropdown-toggle" data-toggle="dropdown" data-position="auto">
                                    <i class="ace-icon fa fa-caret-down icon-only bigger-120"></i>
                                </button>

                                <ul class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">
                                    <li>
                                        <a href="" onclick="detallesPredio('."'".$Predio_id."'".');"><i><img src="../../assets/images/ver.png" alt=""></i> Detalles</a>                                     
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </td>
            </tr>';
        }      
        echo '<tr>
                <td style="text-align: center; font-size: 10px; width: 100%; font-weight: bold; color: #7c150a;" bgcolor="#ffe9e6" colspan="8">Total de Predios: '.$item.'</td>                                                                     
            </tr>';     
        $this->cerrarAbrir();
    }


//////////////////////////////////////////// MOSTRAR VALORES ////////////////////////////////////////////////////

    function prepararConsultaValores($codigo) {		
		$consultaSql = "EXEC _Valo_ValoresCobranza @persona = '".$_SESSION['usuContribuyente']."', @tipoconsulta  = '".$codigo."', @anio = '".$this->param['param_periodo']."'";          
        //echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    function opcion_valores_actual() {     	    
    	$this->prepararConsultaValores(110);  
    	$item = 0;                             
        while (odbc_fetch_row($this->result)) {
        	$item ++;   
        	$documento = odbc_result($this->result, "documento");
        	$numero = odbc_result($this->result, "numero");
        	$predio = odbc_result($this->result, "predio");
        	$ubicacion = odbc_result($this->result, "ubicacion");
        	$fecha_recep = odbc_result($this->result, "fecha_recep");
        	$fecha_vence = odbc_result($this->result, "fecha_vence");
        	$deuda = odbc_result($this->result, "deuda");
        	$estado = odbc_result($this->result, "estado");
            echo'<tr>
                <td style="text-align: center; font-size: 10px; width: 3%; color: #000;">'.$item.'</td>
                <td style="text-align: left; font-size: 10px; width: 20%; color: #000;">'.utf8_encode($documento).'</td>
                <td style="text-align: center; font-size: 10px; width: 5%; color: #000;">'.utf8_encode($numero).'</td>
                <td style="text-align: center; font-size: 10px; width: 8%; color: #000;">'.utf8_encode($predio).'</td>
                <td style="text-align: left; font-size: 10px; width: 25%; color: #000;">'.utf8_encode($ubicacion).'</td>	
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($fecha_recep).'</td>				
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($fecha_vence).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($deuda).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($estado).'</td>
           	</tr>';
        }      
          
        $this->cerrarAbrir();
    }

    function opcion_valores_seleccionado() {     	    
    	$this->prepararConsultaValores(101);  
    	$item = 0;                             
        while (odbc_fetch_row($this->result)) {
        	$item ++;   
        	$documento = odbc_result($this->result, "documento");
        	$numero = odbc_result($this->result, "numero");
        	$predio = odbc_result($this->result, "predio");
        	$ubicacion = odbc_result($this->result, "ubicacion");
        	$fecha_recep = odbc_result($this->result, "fecha_recep");
        	$fecha_vence = odbc_result($this->result, "fecha_vence");
        	$deuda = odbc_result($this->result, "deuda");
        	$estado = odbc_result($this->result, "estado");
            echo'<tr>
                <td style="text-align: center; font-size: 10px; width: 3%; color: #000;">'.$item.'</td>
                <td style="text-align: left; font-size: 10px; width: 20%; color: #000;">'.utf8_encode($documento).'</td>
                <td style="text-align: center; font-size: 10px; width: 5%; color: #000;">'.utf8_encode($numero).'</td>
                <td style="text-align: center; font-size: 10px; width: 8%; color: #000;">'.utf8_encode($predio).'</td>
                <td style="text-align: left; font-size: 10px; width: 25%; color: #000;">'.utf8_encode($ubicacion).'</td>	
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($fecha_recep).'</td>				
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($fecha_vence).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($deuda).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($estado).'</td>
           	</tr>';
        }      
          
        $this->cerrarAbrir();
    }
    
       
//////////////////////////////////////////// MOSTRAR RELACIONES ////////////////////////////////////////////////////

    function prepararConsultaRelaciones($codigo) {		
		$consultaSql = "EXEC _Mant_Relacion_Contribuyente @persona_ID  = '".$_SESSION['usuContribuyente']."', @TipoConsulta  = '".$codigo."'";
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    function mostrar_relaciones() {     	    
    	$this->prepararConsultaRelaciones(9);  
    	$item = 0;                             
        while (odbc_fetch_row($this->result)) {
        	$item ++;           	
        	$relacion_ID = odbc_result($this->result, "relacion_ID");
        	$razon_social = odbc_result($this->result, "razon_social");
        	$ruc = odbc_result($this->result, "ruc");
        	$direccCompleta = odbc_result($this->result, "direccCompleta");
        	$relacion = odbc_result($this->result, "relacion");
        	$tipo_documento = odbc_result($this->result, "tipo_documento");
            echo'<tr>
                <td style="text-align: center; font-size: 10px; width: 3%; color: #000;">'.$item.'</td>
                <td style="text-align: center; font-size: 10px; width: 5%; color: #000;">'.utf8_encode($relacion_ID).'</td>
                <td style="text-align: left; font-size: 10px; width: 25%; color: #000;">'.utf8_encode($razon_social).'</td>
                <td style="text-align: center; font-size: 10px; width: 7%; color: #000;">'.utf8_encode($tipo_documento).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($ruc).'</td>	
                <td style="text-align: left; font-size: 10px; width: 28%; color: #000;">'.utf8_encode($direccCompleta).'</td>
                <td style="text-align: center; font-size: 10px; width: 8%; color: #000;">'.utf8_encode($relacion).'</td>
            </tr>';
        }      
        
        $this->cerrarAbrir();
    }




//////////////////////////////////////////// PROCESOS DE PAGOS ////////////////////////////////////////////////////

    function prepararConsultaPagos($codigo) {	

    	$fecha_inicio = date('d/m/Y',strtotime($this->param['param_fechaInicio']));	
    	$fecha_fin = date('d/m/Y',strtotime($this->param['param_fechaFin']));	
		$consultaSql = "exec _Pago_Pagos @tipo = '".$codigo."', @fecha_inicio = '".$fecha_inicio."', @fecha_fin = '".$fecha_fin."' , @cajero_ID = '".$this->param['param_cajero']."', @caja_ID = '".$this->param['param_caja']."', @TipoPago = '".$this->param['param_tipoPago']."', @persona_ID = '".$_SESSION['usuContribuyente']."', @pago_ID = '".$this->param['param_pagoID']."'";
		//echo $consultaSql;
        $this->result = odbc_exec($this->conexion,$consultaSql);
    }

    function mostrar_pagos() {     	    
    	$this->prepararConsultaPagos(47);  
    	$item = 0;                             
        while (odbc_fetch_row($this->result)) {
        	$item ++;           	
        	$Pagos_id = odbc_result($this->result, "Pagos_id");
        	$nro_Recibo = odbc_result($this->result, "nro_Recibo");
        	$fechaPago = odbc_result($this->result, "fechaPago");
        	$hora = odbc_result($this->result, "hora");
        	$tipo = odbc_result($this->result, "tipo");
        	$MontoTotal = odbc_result($this->result, "MontoTotal");
        	$recibo_usado = odbc_result($this->result, "recibo_usado");
        	$NroCopias = odbc_result($this->result, "NroCopias");
            echo'<tr>
                <td style="text-align: center; font-size: 10px; width: 3%; color: #000;">'.$item.'</td>                
                <td style="text-align: left; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($nro_Recibo).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($fechaPago).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($hora).'</td>	
                <td style="text-align: left; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($tipo).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($Pagos_id).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($MontoTotal).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($recibo_usado).'</td>
                <td style="text-align: center; font-size: 10px; width: 5%; color: #000;">'.utf8_encode($NroCopias).'</td>
                <td style="text-align: center; font-size: 10px; height: 10px; width: 20%;">
                        <div class="hidden-sm hidden-xs action-buttons"> 
                            <a href="" onclick="detallesPago('.$Pagos_id.')"><i><img src="../../assets/images/ver.png" alt="" ></i> Detalles</a>                                                      
                            <a href="" onclick="imprimir_pago('.$Pagos_id.')"><i><img src="../../assets/images/print.png" alt="" ></i> Imprimir</a>                             
                        </div>
                        <div class="hidden-md hidden-lg">
                            <div class="inline pos-rel">
                                <button class="btn btn-minier btn-yellow dropdown-toggle" data-toggle="dropdown" data-position="auto">
                                    <i class="ace-icon fa fa-caret-down icon-only bigger-120"></i>
                                </button>

                                <ul class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">
                                    <li>
                                        <a href="" onclick="detallesPago('.$Pagos_id.')"><i><img src="../../assets/images/ver.png" alt=""></i> Detalles</a>                                     
                                        <a href="" onclick="imprimir_pago('.$Pagos_id.')"><i><img src="../../assets/images/print.png" alt=""></i> Imprimir</a>                                        
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </td> 
            </tr>';
        }      
        
        $this->cerrarAbrir();
    }

    function mostrar_pagos_busqueda() {     	    
    	$this->prepararConsultaPagos(26);  
    	$item = 0;                             
        while (odbc_fetch_row($this->result)) {
        	$item ++;           	
        	$Pagos_id = odbc_result($this->result, "Pagos_id");
        	$nro_Recibo = odbc_result($this->result, "nro_Recibo");
        	$fechaPago = odbc_result($this->result, "fechaPago");
        	$hora = odbc_result($this->result, "hora");
        	$tipo = odbc_result($this->result, "tipo");
        	$MontoTotal = odbc_result($this->result, "MontoTotal");
        	$recibo_usado = odbc_result($this->result, "recibo_usado");
        	$NroCopias = odbc_result($this->result, "NroCopias");
            echo'<tr>
                <td style="text-align: center; font-size: 10px; width: 3%; color: #000;">'.$item.'</td>                
                <td style="text-align: left; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($nro_Recibo).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($fechaPago).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($hora).'</td>	
                <td style="text-align: left; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($tipo).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($Pagos_id).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($MontoTotal).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($recibo_usado).'</td>
                <td style="text-align: center; font-size: 10px; width: 5%; color: #000;">'.utf8_encode($NroCopias).'</td>
                <td style="text-align: center; font-size: 10px; height: 10px; width: 20%;">
                        <div class="hidden-sm hidden-xs action-buttons"> 
                            <a href="" onclick="detallesPago('.$Pagos_id.','.$MontoTotal.')"><i><img src="../../assets/images/ver.png" alt=""></i> Detalles</a>                                                      
                            <a href="" onclick="imprimir_pago('.$Pagos_id.')"><i><img src="../../assets/images/print.png" alt=""></i> Imprimir</a>                             
                        </div>
                        <div class="hidden-md hidden-lg">
                            <div class="inline pos-rel">
                                <button class="btn btn-minier btn-yellow dropdown-toggle" data-toggle="dropdown" data-position="auto">
                                    <i class="ace-icon fa fa-caret-down icon-only bigger-120"></i>
                                </button>

                                <ul class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">
                                    <li>
                                        <a href="#" onclick="detallesPago('.$Pagos_id.')"><i><img src="../../assets/images/ver.png" alt=""></i> Detalles</a>                                     
                                        <a href="" onclick="imprimir_pago('.$Pagos_id.')"><i><img src="../../assets/images/print.png" alt=""></i> Imprimir</a>                                        
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </td> 
            </tr>';
        }      
        
        $this->cerrarAbrir();
    }

    function mostrar_pagos_detalle_cabecera() {     	    
    	$this->prepararConsultaPagos(13);  
    	$item = 0;                             
        while (odbc_fetch_row($this->result)) {
        	$item ++;           	
        	$Pagos_Det_ID = odbc_result($this->result, "Pagos_Det_ID");
        	$Pagos_id = odbc_result($this->result, "Pagos_id");
        	$FormaPago = odbc_result($this->result, "FormaPago");
        	$pago_soles = odbc_result($this->result, "pago_soles");
        	$pago_dolares = odbc_result($this->result, "pago_dolares");        	
        	$NroDocumento = odbc_result($this->result, "NroDocumento");
        	$formaPago_descripcion = odbc_result($this->result, "formaPago_descripcion");
            echo'<tr>
                <td style="text-align: center; font-size: 10px; width: 3%; color: #000;">'.$item.'</td>                
                <td style="text-align: left; font-size: 10px; width: 10%; color: #000;">'.utf8_encode($formaPago_descripcion).'</td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.$pago_soles.'</td>';
                if ($pago_dolares = '.00') {
                	echo'<td style="text-align: center; font-size: 10px; width: 10%; color: #000;">0.00</td>';
                } else {
                	echo'<td style="text-align: center; font-size: 10px; width: 10%; color: #000;">'.$pago_dolares.'</td>';
                }
                
                echo '<td style="text-align: left; font-size: 10px; width: 10%; color: #000;"></td>
                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;"></td>                
            </tr>';
        }      
        
        $this->cerrarAbrir();
    }

    function mostrar_pagos_detalle() {     	    
    	$this->prepararConsultaPagos(48);  
    	$item = 0;                             
        while (odbc_fetch_row($this->result)) {
        	$item ++;           	
        	$anio = odbc_result($this->result, "anio");
        	$tributos_ID = odbc_result($this->result, "tributos_ID");
        	$tributo_descripcion = odbc_result($this->result, "tributo_descripcion");
        	$enero = odbc_result($this->result, "enero");
        	$febrero = odbc_result($this->result, "febrero");        	
        	$marzo = odbc_result($this->result, "marzo");
        	$abril = odbc_result($this->result, "abril");
        	$mayo = odbc_result($this->result, "mayo");
        	$junio = odbc_result($this->result, "junio");
        	$julio = odbc_result($this->result, "julio");
        	$agosto = odbc_result($this->result, "agosto");
        	$setiembre = odbc_result($this->result, "setiembre");
        	$octubre = odbc_result($this->result, "octubre");
        	$noviembre = odbc_result($this->result, "noviembre");
        	$diciembre = odbc_result($this->result, "diciembre");
        	$total = odbc_result($this->result, "total");
        	$predio = odbc_result($this->result, "predio");
        	$Direccion_Predio = odbc_result($this->result, "Direccion_Predio");
            echo'<tr>
                <td style="text-align: center; font-size: 8.5px; width: 3%; color: #000;">'.$item.'</td>                
                <td style="text-align: center; font-size: 8.5px; width: 4%; color: #000;">'.$predio.'</td>
                <td style="text-align: left; font-size: 8.5px; width: 35%; color: #000;">'.utf8_encode($Direccion_Predio).'</td>  
                <td style="text-align: center; font-size: 8.5px; width: 5%; color: #000;">'.$tributos_ID.'</td>  
                <td style="text-align: left; font-size: 8.5px; width: 25%; color: #000;">'.utf8_encode($tributo_descripcion).'</td>  
                <td style="text-align: center; font-size: 8.5px; width: 5%; color: #000;">'.$anio.'</td>  
                <td style="text-align: center; font-size: 8.5px; width: 8%; color: #000;">'.$enero.'</td>  
                <td style="text-align: center; font-size: 8.5px; width: 8%; color: #000;">'.$febrero.'</td>           
                <td style="text-align: center; font-size: 8.5px; width: 8%; color: #000;">'.$marzo.'</td>  
                <td style="text-align: center; font-size: 8.5px; width: 8%; color: #000;">'.$abril.'</td>  
                <td style="text-align: center; font-size: 8.5px; width: 8%; color: #000;">'.$mayo.'</td>  
                <td style="text-align: center; font-size: 8.5px; width: 8%; color: #000;">'.$junio.'</td>  
                <td style="text-align: center; font-size: 8.5px; width: 8%; color: #000;">'.$julio.'</td>  
                <td style="text-align: center; font-size: 8.5px; width: 8%; color: #000;">'.$agosto.'</td>  
                <td style="text-align: center; font-size: 8.5px; width: 8%; color: #000;">'.$setiembre.'</td> 
                <td style="text-align: center; font-size: 8.5px; width: 8%; color: #000;">'.$octubre.'</td> 
                <td style="text-align: center; font-size: 8.5px; width: 8%; color: #000;">'.$noviembre.'</td> 
                <td style="text-align: center; font-size: 8.5px; width: 8%; color: #000;">'.$diciembre.'</td> 
                <td style="text-align: center; font-size: 8.5px; width: 10%; color: #000; font-weight: bold;">'.$total.'</td> 
            </tr>';
        }    
        $this->prepararConsultaPagos(13);                              
        while (odbc_fetch_row($this->result)) {        	        	        	
        	$MontoTotal = odbc_result($this->result, "MontoTotal");
            echo '<tr>
                <td style="text-align: right; font-size: 10px; width: 100%; font-weight: bold; color: #000;" bgcolor="#ffe9e6" colspan="18">TOTAL</td>
                <td style="text-align: center; font-size: 10px; width: 100%; font-weight: bold; color: #000;" bgcolor="#ffe9e6">'.$MontoTotal.'</td>														                
            </tr>'; 
        }           
         
        $this->cerrarAbrir();
    }
  
}
 ?>