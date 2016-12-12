/**
 * Created by GEANPIER ALFARO on 23/04/2016.
 */
$(document).ready(function() {
    //Validacion con BootstrapValidator
    fl = $('#form-login');
    fl.bootstrapValidator({
        message: 'El valor no es válido.',       
        fields: {
            usuario: {
                validators: {
                    notEmpty: {
                        message: 'Este campo es requerido.'
                    }
                }
            },
            password: {
                validators: {
                    notEmpty: {
                        message: 'Este campo es requerido.'
                    }
                }
            }

        },
        submitHandler: function(validator, form, submitButton) {

            usuario = $('#usuario').val();
            password = $('#password').val();
            opcion = 'login';
            //location.href = "views/home.php"            
            $.ajax({
                type: 'POST',
                url: 'controller/controlusuario/usuario.php',
                data: 'usuario='+usuario+'&password='+password+'&opcion='+opcion,
                dataType : 'json',
                encode : true,
                success: function(data){
                    if(data == '1')
                        location.href = "view/Informacion/contribuyente.php";
                    else
                    {                        
                       if(data == '0')
                        {
                            nota("error","Los Datos Son Incorrectos.",2000);
                            $('#password').val('');
                        }
                    }
                }
            });

        }
    });
});


//funcion para enviar notificaciones al usuario la libreria la descargas de http://ned.im/noty/
//op: "error", "info" ,"success"
function nota(op,msg,time){
    if(time == undefined)time = 2000;
    var n = noty({text:msg,maxVisible: 1,type:op,killer:true,timeout:time,layout: 'top'});
}