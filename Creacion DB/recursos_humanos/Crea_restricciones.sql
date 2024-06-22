/*==============================================================*/
/* 					Base de datos Sistema de Informacion Administrativo						*/ 		
/*==============================================================*/

-- Archivo: Crea_restricciones - RH					
-- Script para crear la BD SIA - Sistema de Informacion Administrativo
-- Autor: Ivan Alexis Mancipe Callejas
-- Fecha de Creacion: 23/03/2024

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
  constraint jobhis_pk_idemp_job_sdate primary key (employee_id, job_id, start_date),
  constraint jobhis_fk_iddep foreign key (department_id) references DEPARTMENTS (departmemt_id),
  constraint jobhis_fk_idemplo foreign key (employee_id) references EMPLOYEES (employee_id),
  constraint jobhis_fk_idjob foreign key (job_id) references JOBS (job_id)
);