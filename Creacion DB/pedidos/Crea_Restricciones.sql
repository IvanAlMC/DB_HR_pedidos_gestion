/*======================================*/
/* Bases de Datos de Sistema de Informacion Administrativo - SIA.            /
/*======================================*/

-- Archivo: crea_Restricciones.sql
--Este script Crea las restricciones de la Base SIA
--Autor: Ivan Alexis Mancipe Callejas
--Fecha de Creacion:  23-03-2024

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