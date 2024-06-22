/*==============================================================*/
/* Crear Tablas      											*/ 		
/*==============================================================*/

--Archivo: Crea_tablas.sql
--Este script Crea las tablas del modelo
--Autor: Ivan Alexis Mancipe Callejas
--Fecha de Creacion:  23-03-2024
--

create table JOBS(
	JOB_ID      varchar2(50) not null,
	JOB_TITLE   varchar2(50) not null,
    MIN_SALARY  number               ,
    MAX_SALARY  number               
);

create table JOB_HISTORY(
    EMPLOYEE_ID  number       not null,
    START_DATE   date         not null,
    END_DATE     date         not null,
    JOB_ID       varchar2(50) not null,
    DEPARTMENT_ID number      not null
);

create table DEPARTMENTS(
	DEPARTMENT_ID   number          not null,
	DEPARTMENT_NAME varchar2(30)    not null,
	MANAGER_ID      number       
);

create table EMPLOYEES(
	EMPLOYEE_ID     number          not null,
	FIRST_NAME      varchar2(50)    not null,
    LAST_NAME       varchar2(50)    not null,
    EMAIL           varchar2(50)    not null,
    PHONE_NUMBER    varchar2(50)    not null,
    HIRE_DATE       date            not null,
    JOB_ID          varchar2(50)    not null,
    SALARY          number          not null,
    COMMISSION_PCT  number(3,2)             ,
    MANAGER_ID      number                  ,
    DEPARTMENT_ID   number                  ,
    COD_LUGAR_NACE  number                  ,
    COD_LUGAR_VIVE  number                  ,
    COD_LUGAR_TRABAJA number
);