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

alter table JOBS add (
  constraint jobs_pk_idjob primary key (job_id)
);

alter table EMPLOYEES add(
  constraint employess_pk_idempl primary key (employee_Id)
);

alter table DEPARTMENTS add(
  constraint departments_pk_iddep primary key (department_id),
  constraint departments_fk_idmanager foreign key (manager_id) references EMPLOYEES (employee_id)
);

alter table EMPLOYEES add(
  constraint employees_fk_idjob foreign key (job_id) references JOBS (job_id),
  constraint employees_fk_idman foreign key (manager_id) references EMPLOYEES (employee_id),
  constraint employees_fk_iddep foreign key (department_id) references DEPARTMENTS (department_id),
  constraint employees_fk_idlugnac foreign key (Cod_Lugar_Nace) references gestion_emp.lugares(id_lugar),
  constraint employees_fk_idlugviv foreign key (Cod_Lugar_Vive) references gestion_emp.lugares(id_lugar),
  constraint employees_fk_idlugtra foreign key (Cod_Lugar_Trabaja) references gestion_emp.lugares(id_lugar)
);

alter table JOB_HISTORY add (
  constraint jobhis_fk_iddep foreign key (department_id) references DEPARTMENTS (departmemt_id),
  constraint jobhis_fk_idemplo foreign key (employee_id) references EMPLOYEES (employee_id),
  constraint jobhis_fk_idjob foreign key (job_id) references JOBS (job_id)

);

alter table CARGOS add(
   constraint cargos_pk_idcargo primary key (Id_Cargo)
);

alter table CONTACTOS add(
   constraint contactos_pk_idcontacto primary key (Id_Contacto),
   constraint contactos_fk_idcargo foreign key (Id_Cargo) references CARGOS (Id_Cargo)
);

alter table PROVEEDORES add(
   constraint prove_pk_idprov primary key (Id_Proveedor),
   constraint prove_fk_idlugar foreign key (ID_LUGAR) references gestion_emp.LUGARES (Id_Lugar),
   constraint prove_fk_idconta foreign key (ID_CONTACTO) references CONTACTOS (Id_Contacto)
);

alter table CATEGORIAS add(
   constraint categ_pk_idcate primary key (Id_Categoria)
);

alter table PRODUCTOS add(
   constraint product_pk_idprod primary key (Id_producto),
   constraint product_fk_idprovee foreign key (Id_Proveedor) references PROVEEDORES (Id_Proveedor),
   constraint product_fk_idcate foreign key (Id_Categoria) references CATEGORIAS (Id_Categoria),
   constraint product_ck_issuspend check (Suspendido in ('N'/*No*/,'S'/*Si*/))
);

alter table COMPANIA_ENVIOS add(
   constraint compaenv_pk_idcomenv primary key (Id_Compania_Envios)
);

alter table CLIENTES add(
   constraint clientes_pk_idclie primary key (Id_Cliente),
   constraint clientes_fk_idconta foreign key (Id_Contacto) references CONTACTOS (Id_Contacto),
   constraint clientes_fk_idlugar foreign key (Id_Lugar) references GESTION_EMP.LUGARES (Id_Lugar)
);

alter table PEDIDOS add(
   constraint pedidos_pk_idpedi primary key (Id_Pedido),
   constraint pedidos_fk_idclient foreign key (Id_Cliente) references CLIENTES (Id_Cliente),
   constraint pedidos_fk_idemple foreign key (employee_id) references RH.EMPLOYEES (employee_id),
   constraint pedidos_fk_idcomenv foreign key (Id_Compania_Envios) references COMPANIA_ENVIOS (Id_Compania_Envios),
   constraint pedidos_ck_tippago check (Forma_Pago in ('E'/*Efectivo*/,'C'/*Credito*/))
);

alter table DETALLES_PEDIDOS add(
   constraint detped_pk_iddetped primary key (Id_pedido,Id_Producto),
   constraint detped_fk_idpedido foreign key (Id_pedido) references PEDIDOS (Id_pedido),
   constraint detped_fk_idproduc foreign key (Id_Producto) references PRODUCTOS (Id_Producto)
);

ALTER TABLE LUGARES add(
   CONSTRAINT lugares_pk_idlug PRIMARY KEY (Id_Lugar)
);

ALTER TABLE LUGARES add(
   CONSTRAINT lugares_fk_idlugpad FOREIGN KEY (Id_Padre) REFERENCES LUGARES (Id_Lugar),
   CONSTRAINT lugares_ck_tiplug CHECK (Tipo_Lugar in ('P'/*Pais*/,'C'/*Ciudad*/))
);

ALTER TABLE TIPO_CONTRATO add(
   CONSTRAINT tipcontrato_pk_idtipo PRIMARY KEY (Id_TIPO)
);

ALTER TABLE PERIODOS add(
   CONSTRAINT periodos_pk_idperiodo PRIMARY KEY (Id_Periodo)
);

ALTER TABLE CONCEPTOS add(
   CONSTRAINT conceptos_pk_idconcep PRIMARY KEY (Id_Concepto),
   CONSTRAINT conceptos_ck_tipconcep CHECK (Tipo in ('E'/*Egreso*/,'I'/*Ingreso*/)),
   CONSTRAINT conceptos_ck_Indsalhcnc CHECK (ind_sal_hora_c_nc in ('S'/*Salario*/,'H'/*Hora*/,'NC'/*NoCalcular*/,'C'/*Calcular*/))
);

ALTER TABLE CONTRATOS add (
   CONSTRAINT contratos_pk_idcontra PRIMARY KEY ( ID_CONTRATO ),
   CONSTRAINT contratos_fk_idtipcontra FOREIGN KEY ( ID_TIPO ) REFERENCES TIPO_CONTRATO (ID_TIPO),
   CONSTRAINT contratos_fk_employeeid FOREIGN KEY ( EMPLOYEE_ID ) REFERENCES rh.EMPLOYEES (EMPLOYEE_ID)
);

ALTER TABLE LIBRANZAS add (
   CONSTRAINT libranzas_pk_idlibra PRIMARY KEY (ID_LIBRANZA),
   CONSTRAINT libranzas_fk_idcontra FOREIGN KEY (ID_CONTRATO) REFERENCES CONTRATOS (ID_CONTRATO)
);

ALTER TABLE NOMINA ADD ( 
   CONSTRAINT nomina_pk_idctcnpe PRIMARY KEY (ID_CONTRATO, ID_CONCEPTO, ID_PERIODO),
   CONSTRAINT nomina_fk_idcontra FOREIGN KEY (ID_CONTRATO ) REFERENCES CONTRATOS (ID_CONTRATO) ,
   CONSTRAINT nomina_fk_idperio FOREIGN KEY (ID_PERIODO ) REFERENCES PERIODOS ( ID_PERIODO ),
   CONSTRAINT nomina_fk_idconcep FOREIGN KEY (ID_CONCEPTO ) REFERENCES CONCEPTOS ( ID_CONCEPTO )
);