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
	<title>BSE Events</title>
	<link rel="stylesheet" href="../default/assets/css/bootstrap.min.css" />
	<link rel="stylesheet" href="../default/assets/font-awesome/4.2.0/css/font-awesome.min.css" />
	
	<link rel="stylesheet" href="../default/assets/fonts/fonts.googleapis.com.css" />
	<link rel="stylesheet" href="../default/assets/css/ace.min.css" class="ace-main-stylesheet" id="main-ace-style" />

	<link rel="stylesheet" href="../default/assets/css/ace.min.css" class="ace-main-stylesheet" id="main-ace-style" />
		
	<link rel="stylesheet" href="../default/css/home.css" />

	<script src="../default/assets/js/ace-extra.min.js"></script>

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
							<div class="col-sm-10 col-sm-offset-1">
								<div class="widget-box">
									<div class="widget-header widget-header-flat widget-header-small">
										<h5 class="widget-title" style="font-weight: bold;">
											<center><i class="ace-icon fa fa-user"></i>&nbsp;&nbsp;INFORMACIÓN DEL CONTRIBUYENTE</center>	
										</h5>									
									</div>

									<div class="widget-body">
										<div class="widget-main">
												<div class="row">
													<div class="col-sm-12">
														<h6 class="header blue lighter smaller">											
															Datos de Contribuyente
														</h6>									
													</div><!-- ./span -->
													
							                        <div class="row form-horizontal">
							                            <div class="form-group">
							                            	<div class="col-md-1"></div>		                               
							                               	<label for="socio" class="col-md-2 control-label" style='text-align: left; font-size: 11.5px;'><strong>Nombres / Razón Social:</strong></label>
							                               	<div class="col-md-3">
							                            		<label for="socio" class="control-label" id="nombres" style='text-align: left; font-size: 11px;'></label>                       
							                               	</div>	
							                               	<label for="socio" class="col-md-1 control-label" style='text-align: left; font-size: 11.5px;'><strong>Doc.Id:</strong></label>
							                               	<div class="col-md-2">
							                                   <label for="socio" class="control-label" id="docIdentidad" style='text-align: left; font-size: 11px;'></label> 
							                               	</div>	
							                               	<label for="socio" class="col-md-1 control-label" style='text-align: left; font-size: 11.5px;'><strong>Código: </strong></label>
							                               	<div class="col-md-2">
							                                   <label for="socio" class="control-label" id="codigo" style='text-align: left; font-size: 11px;'></label> 
							                               	</div>			                               		                              
							                            </div>		                          
							                            <div class="form-group">
							                            	<div class="col-md-1"></div>		                               
							                               <label for="socio" class="col-md-1 control-label" style='text-align: left; font-size: 11.5px;'><strong>Dirección:</strong></label>
							                               <div class="col-md-4">
							                            		<label for="socio" class="control-label" id="direccion" style='text-align: left; font-size: 11px;'></label>                       
							                               </div>	
							                               <label for="socio" class="col-md-1 control-label" style='text-align: left; font-size: 11.5px;'><strong>Sector:</strong></label>
							                               <div class="col-md-2">
							                                   <label for="socio" class="control-label" id="sector" style='text-align: left; font-size: 11px;'></label> 
							                               </div>	
							                               <label for="socio" class="col-md-1 control-label" style='text-align: left; font-size: 11.5px;'><strong>E. Cuenta: </strong></label>
							                               <div class="col-md-1">
							                                   <label for="socio" class="control-label" id="estadoCuenta" style='text-align: left; font-size: 11px;'></label> 
							                               </div>			                               		                              
								                        </div>								                                
							         				</div>
													
													<div class="hr hr8 hr-double"></div>

													<div class="clearfix">
														<div class="grid4">
															<center><a href="#" class="btn btn-link" id="verPredios"><i><img src="../../assets/images/home.png" alt=""></i>&nbsp;Predios</a></center> 														
														</div>

														<div class="grid4">
															<center><a href="#" class="btn btn-link" id="verDeudas"><i><img src="../../assets/images/numbers.png" alt=""></i>&nbsp;Estado Deudas</a></center> 		
														</div>

														<div class="grid4">
															<center><a href="#" class="btn btn-link" id="verCuentaCorriente"><i><img src="../../assets/images/table_refresh.png" alt=""></i>&nbsp;Cuenta Corriente</a></center> 	
														</div>

														<div class="grid4">
															<center><a href="#" class="btn btn-link" id="verRelaciones"><i><img src="../../assets/images/sub_dividir.png" alt=""></i>&nbsp;Relaciones</a></center> 	
														</div>													
													</div>
													<div class="clearfix">
														<div class="grid4">
															<center><a href="#" class="btn btn-link" id="verFraccionamiento"><i><img src="../../assets/images/pagos.png" alt=""></i>&nbsp;Fraccionamientos</a></center> 				
														</div>

														<div class="grid4">
															<center><a href="#" class="btn btn-link" id="verLiquidaciones"><i><img src="../../assets/images/vcard.png" alt=""></i>&nbsp;Liquidaciones</a></center> 
														</div>

														<div class="grid4">
															<center><a href="#" class="btn btn-link" id="verRecibosCobranza"><i><img src="../../assets/images/coins_add.png" alt=""></i>&nbsp;Recibos de Cobranza</a></center> 
														</div>													

														<div class="grid4">
															<center><a href="#" class="btn btn-link" id="verPagos"><i><img src="../../assets/images/email_attach.png" alt=""></i>&nbsp;Pagos</a></center> 
														</div>													
													</div>	
													<div class="clearfix">												
														<div class="grid4">
															<center><a href="#" class="btn btn-link" id="verValores"><i><img src="../../assets/images/sub_dividir.png" alt=""></i>&nbsp;Valores</a></center> 
														</div>
													</div>																											
												</div><!-- /.widget-main -->

										</div><!-- /.widget-body -->

									</div><!-- /.widget-box -->

								</div>				
								<div class="row" id="predios">
									<div class="col-sm-12">																				
										<div class="widget-box">
											<div class="widget-header widget-header-flat widget-header-small">
												<h5 class="widget-title" style="font-weight: bold;">
													<center>LISTADO DE PREDIOS</center>	
												</h5>									
											</div>
											<div class="widget-body">
												<div class="widget-main">
													<div class="row">
														<div class="form-horizontal">
															<div class="form-group col-sm-12">							                            
								                               	<label for="socio" class="col-md-1 col-sm-offset-4 control-label" style='text-align: left; font-size: 11.5px;'><strong>Año:</strong></label>
								                               	<div class="col-md-3" id="periodo">
								                            									                            		                
								                               	</div>								                               		                       
								                            </div>	
														</div>                      			
														<div>
															<table id="tablaPredios" class="table table-striped table-bordered">
																<thead>	
																	<tr>
														                <td bgcolor="#f4f600" colspan="7"><center><label for="socio" class="control-label" id="mensaje" style='text-align: center; font-size: 10px; font-weight: bold; color: #000;'></label></center></td>												                
														            </tr>										
														            <tr>
														                <td style="text-align: center; font-size: 10px; width: 3%; color: #000;" bgcolor="#bde8f9">#</td>
														                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;" bgcolor="#bde8f9">% Código</td>
														                <td style="text-align: center; font-size: 10px; width: 40%; color: #000;" bgcolor="#bde8f9">Ubicación</td>
														                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;" bgcolor="#bde8f9">% Condominio</td>
														                <td style="text-align: center; font-size: 10px; width: 8%; color: #000;" bgcolor="#bde8f9">Adquisición</td>	
														                <td style="text-align: center; font-size: 10px; width: 8%; color: #000;" bgcolor="#bde8f9">Posesión</td>
														                <td style="text-align: center; font-size: 10px; width: 5%; color: #000;" bgcolor="#bde8f9">Actual</td>														                
														            </tr>							         
																</thead>
																<tbody id="cuerpoPredios">	
																															            
														            																
																</tbody>
															</table>
														</div>				
													</div><!-- /.widget-main -->
												</div><!-- /.widget-body -->
											</div><!-- /.widget-box -->									
										</div>
									</div>
								</div><!-- ./row -->

								<div class="row" id="estadoDeudas">	
									<div class="col-sm-12">									
										<div class="widget-box">
											<div class="widget-header widget-header-flat widget-header-small">
												<h5 class="widget-title" style="font-weight: bold;">
													<center>RESUMEN CUENTA CORRIENTE</center>	
												</h5>									
											</div>

											<div class="widget-body">
												<div class="widget-main">
													<div class="row">
														                       																			
													</div><!-- /.widget-main -->
												</div><!-- /.widget-body -->
											</div><!-- /.widget-box -->									
										</div>	
									</div>							
								</div><!-- ./row -->

								<div class="row" id="cuentaCorriente">	
									<div class="col-sm-12">											
										<div class="widget-box">
											<div class="widget-header widget-header-flat widget-header-small">
												<h5 class="widget-title" style="font-weight: bold;">
													<center>ESTADO DE DEUDA A LA FECHA</center>	
												</h5>									
											</div>

											<div class="widget-body">
												<div class="widget-main">
													<div class="row">
														                       																			
													</div><!-- /.widget-main -->
												</div><!-- /.widget-body -->
											</div><!-- /.widget-box -->									
										</div>
									</div>									
								</div><!-- ./row -->	

								<div class="row" id="relaciones">
									<div class="col-sm-12">												
										<div class="widget-box">
											<div class="widget-header widget-header-flat widget-header-small">
												<h5 class="widget-title" style="font-weight: bold;">
													<center>RELACIONES DEL CONTRIBUYENTE</center>	
												</h5>									
											</div>

											<div class="widget-body">
												<div class="widget-main">
													<div class="row">
														                       																			
													</div><!-- /.widget-main -->
												</div><!-- /.widget-body -->
											</div><!-- /.widget-box -->									
										</div>
									</div>
								</div><!-- ./row -->	
								
								<div class="row" id='fraccionamiento'>	
									<div class="col-sm-12">											
										<div class="widget-box">
											<div class="widget-header widget-header-flat widget-header-small">
												<h5 class="widget-title" style="font-weight: bold;">
													<center>FRACCIONAMIENTOS</center>	
												</h5>									
											</div>

											<div class="widget-body">
												<div class="widget-main">
													<div class="row">
														                       																			
													</div><!-- /.widget-main -->
												</div><!-- /.widget-body -->
											</div><!-- /.widget-box -->									
										</div>
									</div>										
								</div><!-- ./row -->	

								<div class="row" id="liquidaciones">
									<div class="col-sm-12">												
										<div class="widget-box">
											<div class="widget-header widget-header-flat widget-header-small">
												<h5 class="widget-title" style="font-weight: bold;">
													<center>LIQUIDACIONES</center>	
												</h5>									
											</div>

											<div class="widget-body">
												<div class="widget-main">
													<div class="row">
														                       																			
													</div><!-- /.widget-main -->
												</div><!-- /.widget-body -->
											</div><!-- /.widget-box -->									
										</div>
									</div>									
								</div><!-- ./row -->	

								<div class="row" id="recibosCobranza">										
									<div class="col-sm-12">												
										<div class="widget-box">
											<div class="widget-header widget-header-flat widget-header-small">
												<h5 class="widget-title" style="font-weight: bold;">
													<center>LISTADO DE RECIBOS</center>	
												</h5>									
											</div>

											<div class="widget-body">
												<div class="widget-main">
													<div class="row">
														                       																			
													</div><!-- /.widget-main -->
												</div><!-- /.widget-body -->
											</div><!-- /.widget-box -->									
										</div>
									</div>										
								</div><!-- ./row -->	

								<div class="row" id="pagos">										
									<div class="col-sm-12">												
										<div class="widget-box">
											<div class="widget-header widget-header-flat widget-header-small">
												<h5 class="widget-title" style="font-weight: bold;">
													<center>LISTADO DE PAGOS</center>	
												</h5>									
											</div>

											<div class="widget-body">
												<div class="widget-main">
													<div class="row">
														                       																			
													</div><!-- /.widget-main -->
												</div><!-- /.widget-body -->
											</div><!-- /.widget-box -->									
										</div>
									</div>											
								</div><!-- ./row -->																

								<div class="row" id='valores'>										
									<div class="col-sm-12">												
										<div class="widget-box">
											<div class="widget-header widget-header-flat widget-header-small">
												<h5 class="widget-title" style="font-weight: bold;">
													<center>LISTADO DE VALORES</center>	
												</h5>									
											</div>

											<div class="widget-body">
												<div class="widget-main">
													<div class="row">
														<div class="form-horizontal">
															<div class="form-group col-sm-12">							                            
								                               	<label for="socio" class="col-md-1 col-sm-offset-4 control-label" style='text-align: left; font-size: 11.5px;'><strong>Año:</strong></label>
								                               	<div class="col-md-3" id="periodoValores">
								                            									                            		                
								                               	</div>								                               		                       
								                            </div>	
														</div>                      			
														<div>
															<table id="tablaValores" class="table table-striped table-bordered">
																<thead>	
																	<tr>
														                <td bgcolor="#f4f600" colspan="7"><center><label for="socio" class="control-label" id="mensaje" style='text-align: center; font-size: 10px; font-weight: bold; color: #000;'></label></center></td>												                
														            </tr>										
														            <tr>
														                <td style="text-align: center; font-size: 10px; width: 3%; color: #000;" bgcolor="#bde8f9">#</td>
														                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;" bgcolor="#bde8f9">% Código</td>
														                <td style="text-align: center; font-size: 10px; width: 40%; color: #000;" bgcolor="#bde8f9">Ubicación</td>
														                <td style="text-align: center; font-size: 10px; width: 10%; color: #000;" bgcolor="#bde8f9">% Condominio</td>
														                <td style="text-align: center; font-size: 10px; width: 8%; color: #000;" bgcolor="#bde8f9">Adquisición</td>	
														                <td style="text-align: center; font-size: 10px; width: 8%; color: #000;" bgcolor="#bde8f9">Posesión</td>
														                <td style="text-align: center; font-size: 10px; width: 5%; color: #000;" bgcolor="#bde8f9">Actual</td>														                
														            </tr>							         
																</thead>
																<tbody id="cuerpoValores">	
																															            
														            																
																</tbody>
															</table>
														</div>				
													</div><!-- /.widget-main -->
												</div><!-- /.widget-body -->
											</div><!-- /.widget-box -->									
										</div>
									</div>											
								</div><!-- ./row -->		
							</div>
						</div>
							
						<input type="hidden" dissabled="true" value="INFORMACION GENERAL" id="NombreGrupo">
                    	<input type="hidden" dissabled="true" value="Contribuyentes" id="NombreTarea">
			
						
					</div><!-- /.col -->


				</div><!-- /.row -->
			</div><!-- /.page-content -->
		</div>
	</div><!-- /.main-content -->

	<div class="footer">
		<div class="footer-inner">
			<div class="footer-content">
				<span class="bigger-120">
					<span class="blue bolder">BSE</span>
					&copy; All Rights Reserved
				</span>

				&nbsp;
				<span class="action-buttons">							
					<a href="../https://www.facebook.com/bse.com.pe/?fref=ts">
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
		<script src="../default/js/contribuyente.js"></script>
		<!-- inline scripts related to this page -->		
	</body>
</html>
<?php } ?>
<!--
<script src="../js/alerta.js"></script>
		<script type="text/javascript">
			//mostrarAlertaReco();
		</script>-->