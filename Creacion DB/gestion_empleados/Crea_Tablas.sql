/*==============================================================*/
/* Crear Tablas      											*/ 		
/*==============================================================*/

-- Archivo: Crea_tablas.sql
--Este script Crea las tablas del modelo
--Autor: Ivan Alexis Mancipe Callejas
--Fecha de Creacion:  23-03-2024
--

create table LUGARES(
	ID_LUGAR 	 	number    		not null,
	ID_PADRE	 	number    		null	,
	NOMBRE_LUGAR 	varchar2(20) 	not null,
	TIPO_LUGAR   	varchar2(1)  	null
);

create table TIPO_CONTRATO(
	ID_TIPO     number    		not null,
	NOMBRE_TIPO varchar2(50) 	not null
);

create table PERIODOS(
	ID_PERIODO number not null,
	mes        number not null,
	anio       number not null
);

create table CONCEPTOS(
	ID_CONCEPTO   		number	     not null,
	NOMBRE_CONCEPTO    	varchar2(50) not null,
	TIPO        		varchar2(1)  not null,
	PORCENTAJE  		number(4,2)  	     ,
	IND_SAL_HORA_C_NC 	varchar2(2)  		 ,
    DESCRIPCCION        varchar2(100) 
);

create table CONTRATOS(
	ID_CONTRATO  number	   	 not null,
	EMPLOYEE_ID  number	   		 	 ,
	ID_TIPO      number	     not null,
	FECHA_INICIO date        not null,
	FECHA_FIN    date        		 ,
	SALARIO      number(8,2) not null
);

create table LIBRANZAS(
	ID_LIBRANZA 	number	    not null,
	ID_CONTRATO  	number 		not null,
	VALOR        	number	 	not null,
	FECHA_INICIAL   date        not null,
	TOTAL_CUOTAS 	number	    not null,
	CUOTA_ACTUAL 	number   
);

create table NOMINA(
	ID_CONTRATO number	     not null,
	ID_CONCEPTO number 	     not null,
	ID_PERIODO  number	     not null,
	VALOR       number(10,2) 		 ,
	NUM_HORAS   number	     
);