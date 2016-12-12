<?php 
	date_default_timezone_set('America/Lima');
	ob_start();
    if (isset($_GET['liquidacionID'])) {
        $liquidacionID = $_GET['liquidacionID'];
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

</page>

<?php
	$content = ob_get_clean();
	require('../../html2pdf/html2pdf.class.php');
	$pdf = new HTML2PDF('P','A4','fr','true','UTF-8');
	$pdf->writeHTML($content);
	$pdf->Output('Inventario-Fecha: '.date('d-m-Y').'.pdf')

?>