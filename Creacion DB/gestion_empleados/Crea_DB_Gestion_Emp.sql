/*==============================================================*/
/* 					Base de datos Sistema de Informacion Administrativo						*/ 		
/*==============================================================*/

-- Archivo: Crea_BD_Gestion_emp					
-- Script para crear la BD SIA - Sistema de Informacion Administrativo
-- Autor: Ivan Alexis Mancipe Callejas
-- Fecha de Creacion: 23/03/2024

CREATE USER gestion_emp identified by gesemp DEFAULT TABLESPACE data_sia temporary tablespace temp;

ALTER USER gestion_emp DEFAULT TABLESPACE DATA_SIA QUOTA UNLIMITED ON DATA_SIA;

GRANT CONNECT, RESOURCE TO gestion_emp;

CONN gestion_emp/gestion_emp

@Crea_tablas.sql
@Crea_privilegios.sql
@Crea_restricciones.sql