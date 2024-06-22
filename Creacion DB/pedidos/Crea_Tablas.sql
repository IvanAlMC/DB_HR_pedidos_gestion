/*======================================*/
/* Bases de Datos Sistema de Informacion Administrattiva - SIA.            /
/*======================================*/

-- Archivo: crea_Tablas.sql
--Este script Crea las tablas de la Base de Datos SIA
--Autor: Ivan Alexis Mancipe Callejas
--Fecha de Creación:  23-03-2024
--

create table CARGOS
(
   Id_Cargo		number                        not null,
   Cargo_Contacto	varchar2(50)                  not null
);


create table CONTACTOS
(
   Id_Contacto		number			not null,
   Nombre_Contacto	varchar2(50)		not null,
   Id_Cargo		number			not null
);


create table PROVEEDORES 
(
   Id_Proveedor            number                        not null,
   Nombre_Compania         varchar2(50)                  not null,
   Id_Contacto		   number                        not null,
   Direccion               varchar2(50)                  not null,
   Id_Lugar		   number                        not null,	   
   Codigo_postal           varchar2(50)                  not null,
   Telefono                varchar2(50)                  not null,
   Fax                     varchar2(50)                  
);


create table CATEGORIAS 
(
   Id_Categoria			number                        not null,
   Nombre_Categoria  	       	varchar2(20)                  not null,
   Descripcion			varchar2(65)                  not null
);


create table PRODUCTOS 
(
   Id_Producto			number			not null,
   Nombre_Producto  	       	varchar2(50)            not null,
   Id_Proveedor			number                  not null,
   Id_Categoria			number	                not null,
   Fecha_Vencimiento		Date				,
   Cantidad_por_Unidad		varchar2(25)		not null,
   Precio_por_Unidad		number(5,2)             not null,
   Unidades_en_Existencia	number		        not null,
   Unidades_Pedidas		number                  not null,
   Nivel_de_Nuevo_Pedido 	number                  not null,
   Suspendido 			varchar2(1)		not null
);

create table COMPANIA_ENVIOS 
(
   Id_Compania_Envios		number                        not null,
   Nombre_Compania_E  	       	varchar2(20)                  not null,
   Telefono			varchar2(20)                  not null
);


create table CLIENTES 
(
   Id_Cliente			number			not null,
   Codigo_Cliente  	       	varchar2(10)            not null,
   Nombre_Compañía		varchar2(50)		not null,
   Id_Contacto			number	                not null,
   Direccion			varchar2(50)		not null,
   Id_Lugar			number                  not null,
   Codigo_postal		varchar2(15)			,
   Telefono			varchar2(20)		not null,
   Fax				varchar2(20)
);


create table PEDIDOS
(
   Id_Pedido		number		not null,
   Id_Cliente  	       	number		not null,
   EMPLOYEE_ID		number		not null,
   Fecha_Pedido		Date            not null,
   Fecha_Entrega	Date		not null,
   Fecha_Envio		Date			,	
   Id_Compania_Envios	number		not null,
   Valor_Envio		number(6,2)	not null,
   Id_Destinatario	number		not null,
   Forma_Pago		varchar2(1)	not null
);


create table DETALLES_PEDIDOS
(
   Id_pedido		number                  not null,
   Id_Producto		number                  not null,
   Precio_Unidad	number(5,2)		not null,
   Cantidad		number			not null,
   Descuento 		number(2,2)		not null
);