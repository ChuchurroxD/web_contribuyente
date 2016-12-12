<?php

date_default_timezone_set("America/Lima");
class Conexion_Model {

    public static function getConexion() {
    	
    	$dsn = "Driver={SQL Server};Server=INTEL\JORGELUIS;Database=SG_Rentable;Integrated Security=SSPI;Persist Security Info=False;";

        $conexion = odbc_connect( $dsn, 'sa', '123' ) or die ("Conexion Fallida".odbc_error());
		//@mysql_select_db("tramitesveh",$conexion)or die("Error cargando la base de datos".mysql_error());    
        return $conexion;
    }

}
?>