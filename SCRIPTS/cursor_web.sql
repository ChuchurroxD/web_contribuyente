




select * from contribuyente where persona_id = '287377   '
select * from usuario

insert into usuario (areas_codarea, estado, per_login, per_pass, nombre, per_codContributente) 
select '06', 1, persona_id,persona_id, razon_social, persona_id from contribuyente


declare @persona_id char(9) 
declare @razon_social varchar(200)
declare @usuario_id char(9) 
declare cursorUsuario cursor for
select persona_id, razon_social from contribuyente

open cursorUsuario
fetch cursorUsuario
into @persona_id, @razon_social
while(@@FETCH_STATUS = 0)
begin
	select  top 1 @usuario_id = per_codigo from usuario order by per_codigo desc 
	set @usuario_id = @usuario_id + 1
	
	insert into usuario (per_codigo,areas_codarea, estado, per_login, per_pass, nombre, per_codContributente, fecha_creacion) 
	values(@usuario_id, '06', 1, @persona_id,@persona_id, @razon_social, @persona_id, getdate())
	fetch cursorUsuario
	into @persona_id, @razon_social
end
close cursorUsuario
deallocate cursorUsuario

select * from usuario