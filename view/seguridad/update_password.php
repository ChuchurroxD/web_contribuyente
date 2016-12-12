<?php 
	session_start();
	if(!isset($_SESSION['usuUsuario']) || !isset($_SESSION['usuId']))
	{
		header("Location:../../index.php");
	}
	else
	{
		date_default_timezone_set('America/Lima');
 ?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	<meta charset=utf-8 />
	<title>SISTEMA TRIBUTARIO</title>
	<link rel="stylesheet" href="../default/assets/css/bootstrap.min.css" />
	<link rel="stylesheet" href="../default/assets/font-awesome/4.2.0/css/font-awesome.min.css" />
	
	<link rel="stylesheet" href="../default/assets/fonts/fonts.googleapis.com.css" />
	<link rel="stylesheet" href="../default/assets/css/ace.min.css" class="ace-main-stylesheet" id="main-ace-style" />

	<link rel="stylesheet" href="../default/assets/css/ace.min.css" class="ace-main-stylesheet" id="main-ace-style" />
		
	<link rel="stylesheet" href="../default/css/home.css" />

	<script src="../default/assets/js/ace-extra.min.js"></script>
	<link rel="shortcut icon" href="../../assets/images/escudo.ico">
	</head>
	<body class="no-skin" >
		
		<?php 
		require('../sup_layout.php');
		 ?>

	<div class="main-container" id="main-container">

			<script type="text/javascript">
				try{ace.settings.check('main-container' , 'fixed')}catch(e){}
			</script>

			<div id="sidebar" class="sidebar                  responsive">
				<script type="text/javascript">
					try{ace.settings.check('sidebar' , 'fixed')}catch(e){}
				</script>

				<div class="sidebar-shortcuts" id="sidebar-shortcuts">
					<strong>MENÚ PRINCIPAL</strong>
				</div><!-- /.sidebar-shortcuts -->


				<!--Inicia la parte modificable-->

				<ul class="nav nav-list" id="permisos">
					
				</ul><!-- /.nav-list -->

				<div class="sidebar-toggle sidebar-collapse" id="sidebar-collapse">
					<i class="ace-icon fa fa-angle-double-left" data-icon1="ace-icon fa fa-angle-double-left" data-icon2="ace-icon fa fa-angle-double-right"></i>
				</div>

				<script type="text/javascript">
					try{ace.settings.check('sidebar' , 'collapsed')}catch(e){}
				</script>
			</div>

			<div class="main-content">

				<div class="main-content-inner">

					<div class="breadcrumbs" id="breadcrumbs">
						<script type="text/javascript">
							try{ace.settings.check('breadcrumbs' , 'fixed')}catch(e){}
						</script>

						<ul class="breadcrumb">
							<li>
								<i class="ace-icon fa fa-home home-icon"></i>
								<a href="../home/home.php">Home</a>
							</li>
							
						</ul><!-- /.breadcrumb -->
											
					</div>
					
					<div class="page-content">
						<div class="row">										
							<div class="col-sm-6 col-sm-offset-3">
								<div class="widget-box widget-color-blue2">
									<div class="widget-header">
										<center><h5 class="widget-title lighter smaller">Modificar Datos de Acceso</h5></center>
									</div>

									<div class="widget-body">
										<div class="widget-main padding-8">
											<div class="row form-horizontal">
												<input class="form-control" id="param_contraseña" name="param_contraseña" type="hidden" autofocus="" style="font-size: 13px;" value="<?php echo $_SESSION['usuPass'] ?>">
					                            <div class="form-group">	                            		                             
					                            	<label for="socio" class="col-md-4 control-label" style="font-size: 13px;">Nuevo Usuario:</label>
					                            	<div class="col-md-7">
					                            		<input class="form-control" placeholder="Ingrese nuevo usuario" id="param_new_usuario" name="param_new_usuario" type="text" autofocus="" style="font-size: 13px;">
					                            	</div>	
					                            </div>		                          					                            
					                            <div class="form-group">	                            		                             
					                            	<label for="socio" class="col-md-4 control-label" style="font-size: 13px;">Nuevo Password:</label>
					                            	<div class="col-md-7">
					                            		<input class="form-control" placeholder="Ingrese nuevo password" id="param_nuevo_password" name="param_nuevo_password" type="password" autofocus="" style="font-size: 13px;">
					                            	</div>	
					                            </div>	
					                            <div class="form-group">	                            		                             
					                            	<label for="socio" class="col-md-4 control-label" style="font-size: 13px;">Confirmar Password:</label>
					                            	<div class="col-md-7">
					                            		<input class="form-control" placeholder="Confirmar password" id="param_confirmar_password" name="param_confirmar_password" type="password" autofocus="" style="font-size: 13px;">
					                            	</div>	
					                            </div>
					                            <div class="row">
					                            	<div class="col-md-offset-5">					                            		
					                            		<button type="button" class="btn btn-primary" id="update_datos">Grabar</button>
							                            <button type="button" class="btn btn-primary col-md-offset-1" id="reset_datos">Reset</button>            
					                            	</div>                           	
						                        </div>							                                
					         				</div>
										</div>
									</div>
									

													
								</div>												
							</div>
						</div>


						
					</div><!-- /.col -->
					<input type="hidden" dissabled="true" value="Acceso" id="NombreGrupo">
                    <input type="hidden" dissabled="true" value="Contraseña" id="NombreTarea">

				</div><!-- /.row -->
			</div><!-- /.page-content -->
		</div>
	</div><!-- /.main-content -->

	<div class="footer">
		<div class="footer-inner">
			<div class="footer-content">
				<span class="bigger-120">
					<span class="blue bolder">PREMIUNT.NET</span>
					&copy; All Rights Reserved
				</span>

				&nbsp;
				<span class="action-buttons">							
					<a href="https://www.facebook.com/premiun.net?fref=ts">
						<i class="ace-icon fa fa-facebook-square text-primary bigger-150"></i>
					</a>						
				</span>
			</div>
		</div>
	</div>

	<a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
		<i class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
	</a>
</div><!-- /.main-container -->

		<!-- basic scripts -->

		<!--[if !IE]> -->
		<script src="../default/assets/js/jquery.2.1.1.min.js"></script>

		<!-- <![endif]-->

		<!--[if IE]>
<script src="../assets/js/jquery.1.11.1.min.js"></script>
<![endif]-->

		<!--[if !IE]> -->
		<script type="text/javascript">
			window.jQuery || document.write("<script src='../default/assets/js/jquery.min.js'>"+"<"+"/script>");
		</script>

		<!-- <![endif]-->

		<!--[if IE]>
<script type="text/javascript">
 window.jQuery || document.write("<script src='../assets/js/jquery1x.min.js'>"+"<"+"/script>");
</script>
<![endif]-->
		<script type="text/javascript">
			if('ontouchstart' in document.documentElement) document.write("<script src='../default/assets/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
		</script>
		<script src="../default/assets/js/bootstrap.min.js"></script>

		<!-- page specific plugin scripts -->

		<!--[if lte IE 8]>
		  <script src="../assets/js/excanvas.min.js"></script>
		<![endif]-->
		<script src="../default/assets/js/jquery-ui.custom.min.js"></script>
		<script src="../default/assets/js/jquery.ui.touch-punch.min.js"></script>
		<script src="../default/assets/js/jquery.easypiechart.min.js"></script>
		<script src="../default/assets/js/jquery.sparkline.min.js"></script>
		<script src="../default/assets/js/jquery.flot.min.js"></script>
		<script src="../default/assets/js/jquery.flot.pie.min.js"></script>
		<script src="../default/assets/js/jquery.flot.resize.min.js"></script>

		<!-- ace scripts -->
		<script src="../default/assets/js/ace-elements.min.js"></script>
		<script src="../default/assets/js/ace.min.js"></script>
		<script src="../default/js/password.js"></script>
		<!-- inline scripts related to this page -->		
	</body>
</html>
<?php } ?>
<!--
<script src="../js/alerta.js"></script>
		<script type="text/javascript">
			//mostrarAlertaReco();
		</script>-->