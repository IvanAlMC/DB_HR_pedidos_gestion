/*======================================*/
/* Bases de Datos Gestion Empleados.     /
/*======================================*/

-- Archivo: crea_Restricciones_gestion_emp
-- Este script Crea las restricciones de la Base de Datos Gestion Empleados
-- Autor: Ivan Alexis Mancipe Callejas
--Fecha de Creación:  23-03-2024

-- 

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