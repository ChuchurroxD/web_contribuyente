<?php 
	date_default_timezone_set('America/Lima');
	ob_start();
    if (isset($_GET['periodo'])) {
        $periodo = $_GET['periodo'];
    }

    if (isset($_GET['tributo'])) {
        $codtributo = $_GET['tributo'];
    }
	session_start();

    //$dsn = "Driver={SQL Server};Server=INTEL\JORGELUIS;Database=SG_Rentable;Integrated Security=SSPI;Persist Security Info=False;";
    //$con = odbc_connect( $dsn, 'sa', '123' ) or die ("Conexion Fallida".odbc_error());

    require('../../model/conexion_model2.php');
    $conexion = conectar();

    $time = time();
?>
<style type="text/css">
<!--
    table.page_header {width: 100%; border: none;  border-bottom: solid 0.8mm; padding: 2mm}
    table.page_footer {width: 100%; border: none;  border-top: solid 0.8mm ; padding: 2mm}
-->
</style>

<page backtop="14mm" backbottom="14mm" backleft="10mm" backright="10mm" pagegroup="new" style="font-size: 12pt">  
    <page_header>
        <table class="page_header">
             <tr>
             <td style="width: 8%; text-align: center">
             <img src="../../assets/images/escudo_moche.png" alt="loogo" style="width: 10mm">
                </td>
                <td style="width: 40%; text-align: left">MUNICIPALIDAD DISTRITAL DE MOCHE
                </td>
                <td style="width: 50%; text-align: right">Fecha de Impresión: <?php echo date('d-m-Y'); ?>
                </td>
                <td style="width: 2%">
                </td>
            </tr>            
        </table> 
        <br>
        <div align="center">   
                <strong style="font-size: 14pt">VERIFICACIÓN DE DEUDA</strong>
            </div><br><br>
    </page_header>      
    <page_footer>
        <table class="page_footer">
            <tr>
                <td style="width: 70%; text-align: left;">Impreso por: <?php echo $_SESSION['usuUsuario'] ?> - Cod: <?php echo $_SESSION['usuContribuyente'] ?></td>
                <td style="width: 30%; text-align: right">
                     PÁGINA [[page_cu]]/[[page_nb]] </td>
            </tr>                
        </table>
    </page_footer>           
        <br><br><br>

  <?php 
    $consultaSql2 = "EXEC _Mant_Contribuyente @persona_id = '".$_SESSION['usuContribuyente']."', @TipoConsulta = 40";          
        //echo $consultaSql;
    $result1 = odbc_exec($conexion,$consultaSql2);

    while (odbc_fetch_row($result1)) {        
        $persona_ID = odbc_result($result1, "persona_ID");
        $paterno = odbc_result($result1, "paterno");
        $materno = odbc_result($result1, "materno");
        $nombres = odbc_result($result1, "nombres");
        $tipoDocumentoDescripcion = odbc_result($result1, "tipoDocumentoDescripcion");
        $documento = odbc_result($result1, "documento");
        $direccCompleta = odbc_result($result1, "direccCompleta");                           
      }

  ?>
    <table>
      <tr>
        <td style="width: 300px; height: 5px; text-align: left; font-size: 10px; font-weight: bold;">DATOS DEL CONTRIBUYENTE:</td>
        <td style="width: 200px; height: 5px; text-align: center; font-size: 10px; font-weight: bold;">CÓDIGO: <?php echo $_SESSION['usuContribuyente'] ?></td>
      </tr>
      <tr>
        <td style="width: 500px; height: 5px; text-align: left; font-size: 10px;" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;1.- NOMBRE O RAZÓN SOCIAL: <?php echo $paterno?> <?php echo $materno?> <?php echo $nombres?></td>
        
      </tr>
      <tr>
        <td style="width: 500px; height: 5px; text-align: left;  font-size: 10px;" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;2.- DNI / RUC: <?php echo $tipoDocumentoDescripcion?> - <?php echo $documento?></td>
        
      </tr>
      <tr>
        <td style="width: 500px; height: 5px; text-align: left; font-size: 10px;" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;3.- DOMICILIO FISCAL: <?php echo $direccCompleta?></td>
        
      </tr>      
    </table><br>
    <table>
      <tr>
        <td style="width: 500px; height: 5px; text-align: left; font-size: 10px; font-weight: bold;">DATOS CONSULTADOS</td>       
      </tr>
      <tr>
        <td style="width: 500px; height: 5px; text-align: left; font-size: 10px;">&nbsp;&nbsp;&nbsp;&nbsp;1.- PERIODO: <?php 
        if ($periodo == '0') {
        ?> ACTUAL
        <?php
        } else {
          echo $periodo;
        }
       ?></td>
        
      </tr>
      <tr>
        <td style="width: 500px; height: 5px; text-align: left;  font-size: 10px;">&nbsp;&nbsp;&nbsp;&nbsp;2.- TRIBUTOS: <?php 
        if ($codtributo == '') {
        ?> TODOS
        <?php
        } else {
          echo $codtributo;
        }
        ?></td>
        
      </tr>        
    </table><br>
    <table BORDER CELLSPACING=0> <!-- Lo cambiaremos por CSS -->
      <thead>
       <tr>
          <th style="width: 10%; height: 10px; text-align: center; border:0; font-size: 10px;">Periodo</th>
          <th style="width: 8%; height: 10px; text-align: center; border:0; font-size: 10px;">Mes</th>
          <th style="width: 35%; height: 10px; text-align: center; border:0; font-size: 10px;">Tributo</th>
          <th style="width: 10%; height: 10px; text-align: center; border:0; font-size: 10px;">Tipo Tributo</th>
          <th style="width: 12%; height: 10px; text-align: center; border:0; font-size: 10px;">F. Vencimiento</th>  
          <th style="width: 10%; height: 10px; text-align: center; border:0; font-size: 10px;">Estado</th>
          <th style="width: 10%; height: 10px; text-align: center; border:0; font-size: 10px;">Pendiente</th>         
          <th style="width: 8%; height: 10px; text-align: center; border:0; font-size: 10px;">Total</th>             
      </tr>
    </thead>
    <tbody>
<?php
    
    $consultaSql = "exec _Pago_CuentaCorriente @TipoConsulta=19, @persona_ID='".$_SESSION['usuContribuyente']."', @anio = '".$periodo."', @tributo_ID = '".$codtributo."'";
    //echo $query;
    $result = odbc_exec($conexion,$consultaSql);

    while (odbc_fetch_row($result)) {        
        $anio = odbc_result($result, "anio");
        $mes = odbc_result($result, "mes");
        $tributo = odbc_result($result, "tributo");
        $tipo_tributo = odbc_result($result, "tipo_tributo");
        $fechaVencimiento = odbc_result($result, "fechaVencimiento");
        $estado = odbc_result($result, "estado");
        $pendiente = odbc_result($result, "pendiente");                   
        $total = odbc_result($result, "total");      
        echo'
        <tr style=" border: 1px solid #429FCA; border-radius: 5px" >
          <td style="width: 10%; height: 10px; text-align: center ;border-bottom:0; border-right:0; border-left:0; font-size: 10px;">'.$anio.'</td>
          <td style="width: 8%; height: 10px; text-align: center ;border-bottom:0; border-right:0; border-left:0; font-size: 10px;">'.$mes.'</td>
          <td style="width: 35%; height: 10px; text-align: left ;border-bottom:0; border-right:0; border-left:0; font-size: 10px;">&nbsp;'.$tributo.'</td>
          <td style="width: 10%; height: 10px; text-align: left ;border-bottom:0; border-right:0; border-left:0; font-size: 10px;">&nbsp;'.$tipo_tributo.'</td>
          <td style="width: 12%; height: 10px; text-align: center ;border-bottom:0; border-right:0; border-left:0; font-size: 10px;">'.$fechaVencimiento.'</td>  
          <td style="width: 10%; height: 10px; text-align: center ;border-bottom:0; border-right:0; border-left:0; font-size: 10px;">'.$estado.'</td>
          <td style="width: 10%; height: 10px; text-align: right  ;border-bottom:0; border-right:0; border-left:0; font-size: 10px;">'.$pendiente.'</td>         
          <td style="width: 8%; height: 10px; text-align: right  ;border-bottom:0; border-right:0; border-left:0; font-size: 10px;">'.$total.'</td>                       
        </tr>  
      ';
        } 
       $consultaSql3 = "exec _Pago_CuentaCorriente @TipoConsulta=20, @persona_ID='".$_SESSION['usuContribuyente']."', @anio = '".$periodo."', @tributo_ID = '".$codtributo."'";        
        $result3 = odbc_exec($conexion,$consultaSql3); 
        while (odbc_fetch_row($result3)) {        
          $totalFinal = odbc_result($result3, "total");
        }
        echo '<tr style=" border: 1px solid #429FCA; border-radius: 5px" >                
          <td style="width: 8%; height: 10px; text-align: right  ;border-bottom:0; border-right:0; border-left:0; font-size: 10px; font-weight:bold;" colspan="7">TOTAL</td> 
          <td style="width: 8%; height: 10px; text-align: right  ;border-bottom:0; border-right:0; border-left:0; font-size: 10px; font-weight:bold;">'.$totalFinal.'</td>                       
        </tr>';
?> 
      </tbody>                 
    </table><br><br><br>   
    <table>
      <tr>
        <td style="width: 300px; height: 5px; text-align: left; font-size: 12px; font-weight: bold;">DOCUMENTO NO VALIDO PARA TRAMITES</td>
      </tr>        
    </table>   
</page>

<?php
	$content = ob_get_clean();
	require('../../html2pdf/html2pdf.class.php');
	$pdf = new HTML2PDF('P','A4','fr','true','UTF-8');
	$pdf->writeHTML($content);
	$pdf->Output('Inventario-Fecha: '.date('d-m-Y').'.pdf')

?>