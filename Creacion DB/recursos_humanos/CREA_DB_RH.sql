/*==============================================================*/
/* 					Base de datos Sistema de Informacion Administrativo						*/ 		
/*==============================================================*/

-- Archivo: Crea_BD_RH				
-- Script para crear la BD SIA - Sistema de Informacion Administrativo
-- Author: Ivan Alexis Mancipe Callejas
-- Fecha de Creacion: 23/03/2024

CREATE TABLESPACE data_sia DATAFILE 'C:\oracle\data\ORCL\data_sia.dbf' size 300m;

CREATE USER rh identified by rh DEFAULT TABLESPACE data_sia temporary tablespace temp;

ALTER USER rh DEFAULT TABLESPACE DATA_SIA QUOTA UNLIMITED ON DATA_SIA;

GRANT CONNECT, RESOURCE TO rh;

CONN rh/rh;

@Crea_tablas.sql
@Crea_privilegios.sql
@Crea_restricciones.sql