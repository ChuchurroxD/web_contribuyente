<?php 
	date_default_timezone_set('America/Lima');
	ob_start();
    if (isset($_GET['pagoID'])) {
        $pagoID = $_GET['pagoID'];
    }
	session_start();

    //$dsn = "Driver={SQL Server};Server=INTEL\JORGELUIS;Database=SG_Rentable;Integrated Security=SSPI;Persist Security Info=False;";
    //$con = odbc_connect( $dsn, 'sa', '123' ) or die ("Conexion Fallida".odbc_error());

  require('../../model/conexion_model2.php');
  $conexion = conectar();

?>
<style type="text/css">
<!--
    table.page_header {width: 100%; border: none;  border-bottom: solid 0.8mm; padding: 2mm }
    table.page_footer {width: 100%; border: none;  border-top: solid 0.8mm ; padding: 2mm}
-->
</style>

<page>
<?php
    
    $query = "exec _Repo_ReciboIngreso @pago_id = '".$pagoID."', @tipoConsulta = 3";
    //echo $query;
    $result = odbc_exec($conexion,$query);

    while (odbc_fetch_row($result)) {        
        $codigo_persona = odbc_result($result, "codigo_persona");
        $nombre_completo = odbc_result($result, "nombre_completo");
        $voucher = odbc_result($result, "voucher");
        $pagoDesc = odbc_result($result, "pagoDesc"); 
        $liquidacion_ID = odbc_result($result, "liquidacion_ID");                
        $Fecha_Pago = odbc_result($result, "Fecha_Pago");  
        $hora = odbc_result($result, "hora"); 
        $direccCompleta = odbc_result($result, "direccCompleta"); 
        $Cajero = odbc_result($result, "Cajero"); 
        $caja = odbc_result($result, "caja"); 
    } 

    
?>
    <table> 
       <tr>
          <td colspan="3" style="text-align: center;font-size: 9px";">MUNICIPALIDAD DISTRITAL DE MOCHE</td>              
      </tr>
      <tr>
          <td style="font-size: 9px; width:50px;">RUC:</td>
          <td style="font-size: 9px; width:70px;">20167741208</td> 
          <td style="font-size: 9px">RECIBO Nro: <?= $voucher ?></td>                         
      </tr>
      <tr>
          <td style="font-size: 9px; width:50px;">FECHA</td>
          <td style="font-size: 9px; width:70px;"><?= $Fecha_Pago ?></td> 
          <td style="font-size: 9px">Nro Liq: <?= $liquidacion_ID ?></td>                        
      </tr>
      <tr>
          <td style="font-size: 9px; width:50px;">HORA:</td>
          <td style="font-size: 9px; width:70px;"><?= $hora ?></td>                         
      </tr>
      <tr>
          <td style="font-size: 9px; width:50px;">CODIGO:</td>
          <td style="font-size: 9px; width:70px;"><?= $codigo_persona ?></td>                         
      </tr>
      <tr>
          <td style="font-size: 9px; width:50px;">PERSONA:</td>
          <td style="font-size: 9px;" colspan="2"><?= $nombre_completo ?></td>                         
      </tr>
      <tr>
          <td style="font-size: 8px ;width:50px;">DIRECCION:</td>
          <td style="font-size: 9px;" colspan="2"><?= $direccCompleta ?></td>                         
      </tr>
    </table>

    

    <table> <!-- Lo cambiaremos por CSS -->
       <tr>
          <td style="width:80px; font-size: 9px; text-align: center;">ESPECIFICA</td>          
          <td style="width:80px; font-size: 9px; text-align: center;">CONCEPTO</td>   
          <td style="width:80px; font-size: 9px; text-align: center;">IMPORTE</td>             
      </tr>
<?php
    
    $query2 = "exec _Repo_ReciboIngreso @pago_id = '".$pagoID."', @tipoConsulta = 4";
    //echo $query2;
    $result = odbc_exec($conexion,$query2);
    while (odbc_fetch_row($result)) {                     
        $ESPECIFICA = odbc_result($result, "ESPECIFICA");
        $CONCEPTO = odbc_result($result, "CONCEPTO");
        $IMPORTE = odbc_result($result, "IMPORTE");        
        echo'<tr>
            <td style="font-size: 9px; text-align:center">'.$ESPECIFICA.'</td>
            <td style="font-size: 9px; text-align:center">'.$CONCEPTO.'</td> 
            <td style="font-size: 9px; text-align:center">'.$IMPORTE.'</td>                         
        </tr>  ';
        }  

    $consultaSql = "exec _Pago_Pagos @tipo = 13, @pago_ID = '".$pagoID."'";
        //echo $consultaSql;
    //echo $query2;
    $result = odbc_exec($conexion,$consultaSql);
    while (odbc_fetch_row($result)) {                                 
        $MontoTotal = odbc_result($result, "MontoTotal");
        echo '<tr>
            <td style="text-align: left; font-size: 9px" colspan="2">TOTAL</td>
            <td style="text-align: left; font-size: 9px; text-align:center">'.$MontoTotal.'</td>                                                                        
        </tr>'; 
    }     
?>                  
    </table>
    <table> <!-- Lo cambiaremos por CSS -->      
      <tr>
          <td style="font-size: 9px" colspan="2">Son: <?= $pagoDesc ?></td>                        
      </tr>
      <tr>          
          <td style="font-size: 9px" colspan="2"><?= $caja ?></td>                            
      </tr>
      <tr>
          <td style="font-size: 9px">FECHA</td>
          <td style="font-size: 9px"><?php echo date("d-m-Y"); ?></td>                                 
      </tr>
      <tr>
          <td style="font-size: 9px">HORA:</td>
          <td style="font-size: 9px"><?php echo date("H:i:s"); ?></td>                         
      </tr>
      <tr>
          <td style="font-size: 9px">CAJERO:</td>
          <td style="font-size: 9px"><?= $Cajero ?></td>

      </tr>     
      <tr>
          <td style="font-size: 9px" colspan="2">COPIA FIEL A LA ORIGINAL</td>              
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