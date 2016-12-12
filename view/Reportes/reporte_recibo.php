<?php 
	date_default_timezone_set('America/Lima');
	ob_start();
    if (isset($_GET['reciboID'])) {
        $reciboID = $_GET['reciboID'];
    }

    if (isset($_GET['mes'])) {
        $mes = $_GET['mes'];
    }

    if (isset($_GET['anio'])) {
        $anio = $_GET['anio'];
    }

    if (isset($_GET['numero'])) {
        $numero = $_GET['numero'];
    }

	session_start(); 
  $time = time(); 
  require('../../model/conexion_model2.php');

  //$dsn = "Driver={SQL Server};Server=INTEL\JORGELUIS;Database=SG_Rentable;Integrated Security=SSPI;Persist Security Info=False;";
  //$con = odbc_connect( $dsn, 'sa', '123' ) or die ("Conexion Fallida".odbc_error());
  $conexion = conectar();
    
?>
<style type="text/css">
<!--
    table.page_header {width: 100%; border: none;  border-bottom: solid 0.8mm; padding: 2mm}
    table.page_footer {width: 100%; border: none;  border-top: solid 0.8mm ; padding: 2mm}
-->
</style>

<page>
    
<?php
    $query = "select c.razon_social,c.direccCompleta,cast(s.Sector_id as varchar)+' '+s.Descripcion as junta 
from Contribuyente c inner join Junta_Via jv on c.junta_via_ID=jv.junta_via_ID
inner join Sector s on jv.junta_ID=s.Sector_id where c.persona_id='".$_SESSION['usuContribuyente']."'";
    //echo $query;
    $result = odbc_exec($conexion,$query);

    while (odbc_fetch_row($result)) {        
        $razon_social = odbc_result($result, "razon_social");
        $direccCompleta = odbc_result($result, "direccCompleta");
        $junta = odbc_result($result, "junta");
        
    }

    $query2 = "select convert( char(10), fecha_genera, 103) as fechaEmi , convert( char(10), fecha_vence , 103) as fechaVence
from recibo where recibo_id= '".$reciboID."'";
    //echo $query;
    $result2 = odbc_exec($conexion,$query2);

    while (odbc_fetch_row($result2)) {        
        $fechaEmi = odbc_result($result2, "fechaEmi");
        $fechaVence = odbc_result($result2, "fechaVence");        
    }  
    
?>

    <table> 
      <tr>
          <td style="text-align: left;font-size: 10px; width: 300px; font-weight: bold;">MUNICIPALIDAD DISTRITAL DE MOCHE</td> 
          <td style="text-align: left;font-size: 14px; font-weight: bold; width: 300px;" rowspan="2">RECIBO DE COBRANZA N°: <?php echo $numero ?></td>                  
      </tr>
      <tr>
          <td style="text-align: left;font-size: 10px; width: 300px;font-weight: bold;" >RUC: 20167741208</td> 
             
      </tr>
      <tr>
          <td style="text-align: left;font-size: 10px; width: 300px;font-weight: bold;">AMIGO CONTRIBUYENTE</td> 
          <td style="text-align: left;font-size: 14px; font-weight: bold; width: 300px">cód.: <?php echo $_SESSION['usuContribuyente'] ?></td>                  
      </tr>
      <tr>
          <td style="text-align: justify;font-size: 10px; width: 650px" colspan="2">LE SOLICITAMOS CANCELE SU DEUDA TRIBUTARIA DE AÑOS ANTERIORES EVITANDO EL INICIO DEL <strong>PROCEDIMEINTO COACTIVO PERTINENTE</strong> QUE SE LLEVARA A CABO EN CASO DE INCUMPLIMIENTO DE PAGO. EVITESE MOLESTIAS FUTURAS CUMPLIENDO CON SU OBLIGACIÓN Y A LA VEZ APOYARÁ EN LA CONSTRUCCIÓN DE NUEVAS OBRAS.</td> 
                        
      </tr>
      <tr>
          <td style="text-align: left; font-size: 10px";"><strong>PERIODO: &nbsp;&nbsp;&nbsp;</strong><?php echo $anio ?></td>                         
      </tr>
      <tr>
          <td style="text-align: left; font-size: 10px;" colspan="2"><strong>NOMBRE: &nbsp;&nbsp;&nbsp;</strong><?php echo $razon_social ?></td>     
      </tr>
      <tr>
          <td style="text-align: left; font-size: 10px;" colspan="2"><strong>DOMICILIO: </strong><?php echo $direccCompleta ?></td>                     
      </tr>
      <tr>
          <td style="text-align: left; font-size: 10px;"><strong>LUGAR: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong><?php echo $junta ?></td>     
          <td style="text-align: left; font-size: 10px;"><strong>USUARIO: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong><?php echo $_SESSION['usuUsuario'] ?></td>       
      </tr>
      <tr>
          
          <td style="text-align: left; font-size: 10px;"><strong>FECH. EMIS: &nbsp;</strong><?php echo $fechaEmi ?></td>
          <td style="text-align: left; font-size: 10px;"><strong>FECH. VENC: &nbsp;</strong><?php echo $fechaVence ?></td>            
      </tr>
    </table>
  <br><br><br>
    <table border="1"> 
      
      <tr>
          <td style="text-align: left; font-size: 10px;" colspan="7">FECH. VENC:</td> 
          <td style="text-align: left; font-size: 10px;" colspan="2">FECH. VENC:</td> 
          <td style="text-align: left; font-size: 10px;" rowspan="5" ="2">FECH. VENC:</td>                 
      </tr>
      <tr>
          <td style="text-align: left; font-size: 10px;" colspan="7">FECH. VENC:</td> 
          <td style="text-align: left; font-size: 10px;" colspan="2">FECH. VENC:</td> 
                     
      </tr>
      <tr>
          <td style="text-align: left; font-size: 10px;" colspan="7">FECH. VENC:</td> 
          <td style="text-align: left; font-size: 10px;" colspan="2">FECH. VENC:</td> 
                        
      </tr>
      <tr>
          <td style="text-align: left; font-size: 10px;" colspan="7">FECH. VENC:</td> 
          <td style="text-align: left; font-size: 10px;" colspan="2">FECH. VENC:</td> 
                          
      </tr>
      <tr>
          <td style="text-align: left; font-size: 10px;" colspan="7">FECH. VENC:</td> 
          <td style="text-align: left; font-size: 10px;" colspan="2">FECH. VENC:</td> 
                      
      </tr>
      <tr>
          <td style="text-align: left; font-size: 10px;" colspan="7">FECH. VENC:</td> 
          <td style="text-align: left; font-size: 10px;" colspan="2">FECH. VENC:</td> 
                        
      </tr>
<?php 
    $query3 = "SELECT  7783 as Recibo, CASE WHEN  cc.anio < ('".$anio."'-4) THEN 0 else cc.anio END AS Periodo , cc.tributo_ID , t.abrev , 
SUM(cc.cargo - cc.abono) AS DeudaAnt, left(dbo.getNombreMes(1),8)AS Mes,  'DA' AS Tipo
FROM    SG_Rentable .DBO.CuentaCorriente CC INNER JOIN SG_Rentable .DBO.Tributos t 
    ON t.tributos_id = cc.tributo_id
WHERE cc.anio < '".$anio."'  AND cc.estado = 'P'  and cc.persona_id = 253
GROUP BY CASE WHEN  cc.anio< ('".$anio."'-4) THEN 0 else cc.anio END , cc.tributo_ID , t.abrev 
ORDER BY t.abrev ";
    //echo $query;
    $result3 = odbc_exec($conexion,$query3);

    while (odbc_fetch_row($result3)) {        
        $Periodo = odbc_result($result3, "Periodo");
        $fechaVence = odbc_result($result3, "fechaVence");
        if ($Periodo == '0') {
          $Periodo = 'ANTE.';
        } 
        echo '<tr>
          <td style="text-align: left; font-size: 10px; width: 80px">TRIBUTOS</td>
          <td style="text-align: left; font-size: 10px; width: 60px">'.$Periodo.'</td>          
          <td style="text-align: left; font-size: 10px; width: 40px">TOTAL</td>
          <td style="text-align: left; font-size: 10px; width: 40px">2016</td>
          <td style="text-align: left; font-size: 10px; width: 40px">2016</td>
          <td style="text-align: left; font-size: 10px; width: 40px">2016</td>
          <td style="text-align: left; font-size: 10px; width: 40px">2016</td>               
      </tr>';

    } 

?>
     
    </table>

</page>

<?php
	$content = ob_get_clean();
	require('../../html2pdf/html2pdf.class.php');
	$pdf = new HTML2PDF('P','A4','fr','true','UTF-8');
	$pdf->writeHTML($content);
	$pdf->Output('Inventario-Fecha: '.date('d-m-Y').'.pdf')

?>