<div id="navbar" class="navbar navbar-default">

			<div class="navbar-container" id="navbar-container">
				<button type="button" class="navbar-toggle menu-toggler pull-left" id="menu-toggler" data-target="#sidebar">
					<span class="sr-only">Toggle sidebar</span>

					<span class="icon-bar"></span>

					<span class="icon-bar"></span>

					<span class="icon-bar"></span>
				</button>

				<div class="navbar-header pull-left">
					<a href="../home/home.php" class="navbar-brand">
						<small>
							<i class="fa fa-leaf"></i>
							SISTEMA DE ADMINISTRACIÓN TRIBUTARIA
						</small>
					</a>
				</div>

				<div class="navbar-buttons navbar-header pull-right" role="navigation">
					<ul class="nav ace-nav">						

						<li class="light-blue">
							<a data-toggle="dropdown" href="#" class="dropdown-toggle">								
								<span class="user-info">
									<small>Bienvenido,</small><?php echo $_SESSION['usuUsuario']?>
								</span>

								<i class="ace-icon fa fa-caret-down"></i>
							</a>

							<ul class="user-menu dropdown-menu-right dropdown-menu dropdown-yellow dropdown-caret dropdown-close">			
								<li class="divider"></li>
								<li>
									<a href="../../controller/controlusuario/cerrarsesion.php">
										<i class="ace-icon fa fa-power-off"></i>
										Cerrar Sesion
									</a>
								</li>
							</ul>
						</li>
					</ul>
				</div>
			</div><!-- /.navbar-container -->
		</div>