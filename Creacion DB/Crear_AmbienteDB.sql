/*==============================================================*/
/* Creando el primer Ambiente DB        						*/ 		
/*==============================================================*/

--Archivo: Crea_AmbienteDB.sql
--Este script Crea un ambiente DB para la base de datos SIA
--Autor: Ivan Alexis Mancipe Callejas
--Fecha de Creacion:  23-03-2024
--

--Creando el Tablespace:

CREATE TABLESPACE data_sia DATAFILE 'c:\oracle\data\ORCL\data_sia.dbf' size 300m;


--Creando usuarios:

--Modificar la sesion para que me permita modificar y crear usuarios
alter session set "_ORACLE_SCRIPT"=true;

----------------------rh-----------------------------
CREATE USER rh identified by rh DEFAULT TABLESPACE data_sia temporary TABLESPACE temp;

GRANT CONN, RESOURCE TO rh

CONN rh/rh

CONN system/h1303

ALTER USER rh DEFAULT TABLESPACE DATA_SIA QUOTA UNLIMITED ON DATA_SIA;

conn rh/rh

select tablespace_name from user_tablespaces;

------------------gestion_emp----------------------------------

CREATE USER gestion_emp identified by gesemp DEFAULT TABLESPACE data_sia temporary TABLESPACE temp;

GRANT CONN, RESOURCE TO gestion_emp

CONN gestion_emp/gesemp

CONN system/h1303

ALTER USER gestion_emp DEFAULT TABLESPACE DATA_SIA QUOTA UNLIMITED ON DATA_SIA;

conn gestion_emp/gesemp

select tablespace_name from user_tablespaces;

-------------------pedidos----------------------


CREATE USER pedidos identified by pedidos DEFAULT TABLESPACE data_sia temporary TABLESPACE temp;

GRANT CONN, RESOURCE TO pedidos

CONN pedidos/pedidos

CONN system/h1303

ALTER USER pedidos DEFAULT TABLESPACE DATA_SIA QUOTA UNLIMITED ON DATA_SIA;

conn pedidos/pedidos

select tablespace_name from user_tablespaces;