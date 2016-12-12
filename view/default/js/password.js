window.onload = function(){    
    mostrarMenu();  
}

$(function() {
    $('#update_datos').on('click', function(){        
       var param_opcion = 'update_datos';  
       var param_contraseña = document.getElementById('param_contraseña').value;
       var param_new_usuario = document.getElementById('param_new_usuario').value;       
       var param_nuevo_password = document.getElementById('param_nuevo_password').value;
       var param_confirmar_password = document.getElementById('param_confirmar_password').value;

       if (param_new_usuario == '' || param_nuevo_password =='' || param_confirmar_password == '') {
        alert('Ingrese todos los campos.');
       } else {
        if (param_nuevo_password != param_confirmar_password) {
            alert('Las nuevas contraseñas no concuerdan.');
        }else {
          $.ajax({
          type: 'POST',        
          data:'param_opcion='+param_opcion+'&param_new_usuario='+param_new_usuario+'&param_nuevo_password=' +param_nuevo_password,
          url: "../../controller/controlSeguridad/seguridad_controller.php",
          success: function(data){
              alert('Los datos han sido modificados correctamente. Inicie sesion con los datos modificados');   
              location.href="../../controller/controlusuario/cerrarsesion.php";                            
          },
          error: function(data){
                     
          }
        });
        }
       }
    }); 

    
    $('#reset_datos').on('click', function(){        
        document.getElementById('param_new_usuario').value= '';
        document.getElementById('param_actual_password').value= '';
        document.getElementById('param_nuevo_password').value= '';  
        document.getElementById('param_confirmar_password').value= ''; 
    }); 
});


function mostrarMenu()
{    
    var grupo = document.getElementById('NombreGrupo').value;
    var tarea = document.getElementById('NombreTarea').value;
    //alert(grupo);
    $.ajax({
        type:'POST',
        data: 'opcion=mostrarMenu&grupo='+grupo+'&tarea='+tarea,        
        url: "../../controller/controlusuario/usuario.php",
        success:function(data){                              
            $('#permisos').html(data);                
        }
    });
    //alert("kjb");
}

