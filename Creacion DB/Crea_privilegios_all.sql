/*======================================*/
/*  Bases de Datos Sistema de Informacion Administrativo.            /
/*======================================*/

-- Archivo: crea_Privilegios_Pedidos
--Este script Crea las tablas de la Base de Datos Sistema de Informacion Administrativo.
--Autor: Ivan Alexis Mancipe Callejas
--Fecha de Creación:  23-03-2024
--

connect gestion_emp/gesemp;
grant references on lugares to rh;
grant select on lugares to rh;

grant references on contratos to rh;
grant select on contratos to rr;

grant references on lugares to pedidos;
grant select on lugares to pedidos;

connect rh/rh;

grant alter on employees to gestion_emp;
grant references on employees to gestion_emp;
grant select,insert,update,delete on employees to gestion_emp;

grant references on employees to pedidos;
grant select on employees to pedidos;

conn pedidos/pedidos

grant references on proveedores to gestion_emp;
grant references on clientes to gestion_emp;
grant references on pedidos to rh;

-- Permisos para crear en PowerDesigner el modelo
grant references on departments to gestion_emp;
grant references on jobs to gestion_emp;
grant references on job_history to gestion_emp;
grant references on cargos to gestion_emp;
grant references on categorias to gestion_emp;
grant references on compania_envios to gestion_emp;
grant references on contactos to gestion_emp;
grant references on detalle_pedido to gestion_emp;
grant references on productos to gestion_emp;
grant references on pedidos to gestion_emp;
grant references on cargos to gestion_emp;
grant references on categorias to gestion_emp;
grant references on compania_envios to gestion_emp;
grant references on contactos to gestion_emp;
grant references on detalle_pedido to gestion_emp;
grant references on productos to gestion_emp;
grant references on pedidos to gestion_emp;