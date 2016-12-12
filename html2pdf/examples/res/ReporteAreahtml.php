<?php

include_once( "../../../config/conexion1.php");
require_once( "../../../includes/functions.php" );
$task = _GetParam($_REQUEST, 'task');

switch ($task) {
    case "cargarReporteArea": _cargarReporteArea();
        break;
    default: _CargarReporte();
}

function _traerData($tabla, $indice) {
    $bandera=false;
    $cadena='';
    foreach ($tabla as $key2 => $v2) {
        if ($v2->idDep == $indice){
            $bandera=true;
            $cadena = $cadena.'<li> 
                    <table style="border-radius: 2mm;border: 1;width: 99%">
                    <tr>
                    <td style="width: 60%">' . utf8_decode($v2->Descripcion).'</td>
                    <td style="width: 20%; text-align: right">'.utf8_decode($v2->RecepExpediente).'</td>
                    <td style="width: 20%; text-align: right">'.utf8_decode($v2->CreaExpediente).'</td>  
                    </tr>
                    </table> ' . _traerData($tabla, $v2->idArea). '</li>';
        }
    }
    if ($bandera==true)
        return '<ul> ' .$cadena. '</ul>';
    else
        return '';
}

function _cargarReporteArea() {
    global $database;
    $sqlC = "exec rep_ReporteArea @tipo=3,@idEmpresa=" . $_SESSION["idEmpresa"] . ",@idUnidadNegocio=" . $_SESSION["idUnidadNegocio"] . "";
    $database->setQuery($sqlC);
    $count = $database->loadResult();

    if ($count != 0) {

        $sqlem = "exec rep_ReporteArea @tipo=2,@idempresa=1,@idUnidadNegocio=1";
        $database->setQuery($sqlem);
        $rowse = $database->loadObjectList();
        foreach ($rowse as $key => $v) {
            $empresa = utf8_decode($v->empresa);
            $UnidadNegocio = utf8_decode($v->UnidadNegocio);
        }

        $sql = "exec rep_ReporteArea @tipo=1,@idEmpresa=" . $_SESSION["idEmpresa"] . ",
        @idUnidadNegocio=" . $_SESSION["idUnidadNegocio"] . "";
        $database->setQuery($sql);
        $RowsDatos = $database->loadObjectList();

        echo '
<style type="text/css">
<!--
    table.page_header {width: 100%; border: none; background-color: #DDDDFF; border-bottom: solid 1mm #AAAADD; padding: 2mm }
    table.page_footer {width: 100%; border: none; background-color: #DDDDFF; border-top: solid 1mm #AAAADD; padding: 2mm}
-->
</style>
<page backtop="14mm" backbottom="14mm" backleft="10mm" backright="10mm" style="font-size: 12pt">
    <page_header>
        <table class="page_header">
             <tr>
                <td style="width: 50%; text-align: left">
                   ' . $empresa . ' - ' . $UnidadNegocio . '
                </td>
                <td style="width: 50%; text-align: right">
                    Fecha: ' . date("d/m/Y") . '
                </td>
            </tr>
        </table>
    </page_header>
    <page_footer>
        <table class="page_footer">
            <tr>
                <td style="width: 33%; text-align: left;">
                    Usuario: 
                </td>
                <td style="width: 34%; text-align: center">';

        echo '  </td>
                <td style="width: 33%; text-align: right">
                     Página [[page_cu]]/[[page_nb]]';
        echo '        </td>
            </tr>
        </table>
    </page_footer>
    <div align="center"><span style="font-size: 20px; font-weight: bold;text-decoration: underline">
            Reporte de Áreas</span></div><br>
  <br>
    <table style="width: 100%;padding:3px">
    <tr>
        <td style="width: 60%; text-align: center; background: #429FCA;   border-color: #429FCA"> ÁREAS </td>
        <td style="width: 18%; text-align: center; background: #429FCA;   border-color: #429FCA">RECEPCIONA EXPEDIENTE</td>
        <td style="width: 15%; text-align: center; background: #429FCA;   border-color: #429FCA">CREA EXPED.</td>                
    </tr>
    </table>
        <ul style="width: 90%">';

        foreach ($RowsDatos as $key => $v) {
            if ($v->idDep == 0) {
                echo '
                <li>
                    <table style="border-radius: 2mm;border: 1px; background: #CEECF5;width: 100%">
                    <tr>
                        <td style="width: 60%">' . utf8_decode($v->Descripcion).'</td>
                        <td style="width: 20%; text-align: right">'.utf8_decode($v->RecepExpediente).'</td>
                        <td style="width: 20%; text-align: right">'.utf8_decode($v->CreaExpediente).'</td>                       
                    </tr>
                    </table>';

                echo _traerData($RowsDatos, $v->idArea);
                echo '</li>';
            }
        }

        echo '
    </ul>
</page>
    ';
    } else {
        echo '<page style = "font-size: 14px"><br><br><br><br><br><br><br><br><br><br><br><br>
            <table align = "center" style = "border-radius: 6mm; border: none; background: #CEECF5;" >
            <tr><td style = "width: 100mm; height: 15mm; text-align: center; ">&nbsp;
            &nbsp;
            NO EXISTEN DATOS<br></td></tr></table> </page>';
    }
}

?>
