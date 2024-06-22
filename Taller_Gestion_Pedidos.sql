------------------------------1-------------------------------

--Listar nombre, apellido, salario y nombre del departamento, de los empleados cuyo salario
--es mayor que el promedio del salario del departamento al que pertenece el empleado.
--Ordene la consulta en forma descendente por nombre de departamento y ascendente por
--nombre del empleado. Realizar la consulta de tres formas diferentes utilizando WITH, Vista
--en línea y subconsultas correlacionados.
--Rta: 37 registros.

--Con subconsulta
SELECT e.first_name || ' ' || e.last_name AS employee_name, e.salary, d.department_name
FROM rh.employees e JOIN rh.departments d 
ON e.department_id = d.department_id
WHERE e.salary > (  SELECT AVG(e2.salary) 
                    FROM rh.employees e2 
                    WHERE e2.department_id= e.department_id)
ORDER BY d.department_name DESC, e.first_name ASC;

--Con vista en linea
SELECT e.first_name || ' ' || e.last_name AS employee_name, e.salary, d.department_name
FROM rh.employees e JOIN departments d 
ON e.department_id = d.department_id
JOIN (  SELECT e2.department_id, AVG(e2.salary) AS prom_salario_dep
        FROM employees e2
        GROUP BY e2.department_id
) spd 
ON e.department_id = spd.department_id
WHERE e.salary > spd.prom_salario_dep
ORDER BY d.department_name DESC,e.first_name ASC;

--Con WITH
WITH SalarioPromedioDepartamento AS (
    SELECT e.department_id, AVG(e.salary) AS prom_salario_dep
    FROM employees e
    GROUP BY e.department_id
)
SELECT e.first_name || ' ' || e.last_name AS employee_name, e.salary, d.department_name
FROM employees e JOIN departments d 
ON e.department_id = d.department_id
JOIN  SalarioPromedioDepartamento spd 
ON e.department_id = spd.department_id
WHERE e.salary > spd.prom_salario_dep
ORDER BY d.department_name DESC, e.first_name ASC;


-----------------------------------2--------------------------------------

--Elabore una sola consulta, teniendo en cuenta los siguientes aspectos (utilice la tabla
--employees y departmens):
--1. Calcular el valor de la nómina por departamento.
--2. Calcular el promedio de la nómina por departamento o de la consulta anterior.

SELECT d.department_id,d.department_name, SUM(e.salary) AS valor_nomina, AVG(SUM(e.salary)) OVER () AS promedio_nomina_departamento
FROM employees e JOIN departments d 
ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name;


SELECT department_id, department_name, valor_nomina
FROM (  SELECT d.department_id, d.department_name, SUM(e.salary) AS valor_nomina
        FROM employees e JOIN departments d 
        ON e.department_id = d.department_id
        GROUP BY d.department_id, d.department_name
        UNION ALL
        SELECT 0 AS department_id, 'Promedio_Nomina' AS department_name, ROUND(AVG(SUM(e.salary)), 4)
        FROM employees e JOIN departments d 
        ON e.department_id = d.department_id 
        GROUP BY d.department_id, d.department_name) combined_data

---------------------------------3------------------------------------------

--Comparar el valor de la nómina por departamento (primer ítem) con el valor del
--promedio de la nómina (segundo ítem).
--Si el valor de la nómina de un departamento es mayor que el valor promedio de la nómina
--de la empresa, mostrar el nombre del departamento y su valor.
--Realizar la consulta de tres formas diferentes utilizando WITH, Vista en línea y subconsultas
--correlacionados.

--Con subconsulta
SELECT d.department_id, d.department_name, SUM(e.salary) AS valor_nomina
FROM employees e JOIN departments d 
ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name
HAVING SUM(e.salary) > (    SELECT AVG(SUM(e.salary)) 
                            FROM employees e JOIN departments d 
                            ON e.department_id = d.department_id
                            GROUP BY d.department_id);

--Con vista en linea)
SELECT department_id, department_name, valor_nomina
FROM (  SELECT d.department_id, d.department_name, SUM(e.salary) AS valor_nomina, AVG(SUM(e.salary)) AS promedio_nomina
        FROM employees e JOIN departments d 
        ON e.department_id = d.department_id
        GROUP BY d.department_id, d.department_name
) dp
WHERE valor_nomina > promedio_nomina

--Con WITH
WITH prom_salario_dep AS (
    SELECT AVG(valor_nomina) AS promedio_nomina
    FROM (  SELECT SUM(e.salary) AS valor_nomina
            FROM employees e
            GROUP BY e.department_id
    )
)

SELECT ed.department_id, ed.department_name, ed.valor_nomina
FROM (  SELECT d.department_id, d.department_name, SUM(e.salary) AS valor_nomina
        FROM employees e JOIN departments d 
        ON e.department_id = d.department_id
        GROUP BY d.department_id, d.department_name
) ed
JOIN prom_salario_dep psd 
ON ed.valor_nomina > psd.promedio_nomina


------------------------------4---------------------------------------

--Mostrar los empleados jefes que tengan por lo menos un empleado a su cargo. Utilizar la
--clausula EXISTS.

SELECT *
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM employees sub
    WHERE sub.manager_id = e.employee_id
);


--------------------------------------5-------------------------------

--Mostrar los empleados que no tienen subalternos o no son jefes. Utilizar la cláusula NOT
--EXISTS.

SELECT *
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM employees sub
    WHERE sub.manager_id = e.employee_id
);


---------------------------------6---------------------------------

--Consulta que calcule la cantidad de pedidos u ordenes que no tienen representantes de
--ventas.

SELECT COUNT(*) AS cant_pedidos_sin_representante
FROM pedidos
WHERE employee_id IS NULL;


-------------------------7---------------------------------------
--Sentencia que muestre nombre del cliente, nombre del producto, fecha de orden o pedido,
--número de orden y cantidad de productos; para aquellas órdenes cuyas fechas se encuentran
--entre diciembre de 2020 y diciembre de 2021. 

SELECT c.nombre_compañía AS nombre_cliente, p.nombre_producto, pe.fecha_pedido,  pe.id_pedido, dp.cantidad
FROM pedidos pe JOIN clientes c 
ON pe.id_cliente = c.id_cliente
JOIN detalles_pedidos dp 
ON pe.id_pedido = dp.id_pedido
JOIN productos p 
ON dp.id_producto = p.id_producto
WHERE pe.fecha_pedido BETWEEN TO_DATE('2020-12-01', 'YYYY-MM-DD') AND TO_DATE('2021-12-31', 'YYYY-MM-DD');


-------------------------8------------------------------------

--Sentencia que muestre en formato de tabla la relación de pedidos por año y mes.
--Calcular el número de pedidos por año (vertical) y mes (horizontal). Ordenar por año.
--(Implementar la consulta con Decode, Case y Pivot). Utilizar función extract() y función
--to_char().


--Con DECODE
SELECT *
FROM (  SELECT EXTRACT(YEAR FROM fecha_pedido) AS año,
        DECODE(TO_CHAR(fecha_pedido, 'MM'),
                  '01', 'Enero',
                  '02', 'Febrero',
                  '03', 'Marzo',
                  '04', 'Abril',
                  '05', 'Mayo',
                  '06', 'Junio',
                  '07', 'Julio',
                  '08', 'Agosto',
                  '09', 'Septiembre',
                  '10', 'Octubre',
                  '11', 'Noviembre',
                  '12', 'Diciembre') AS mes,
           COUNT(*) AS cantidad_pedidos,
           SUM(COUNT(*)) OVER (PARTITION BY EXTRACT(YEAR FROM fecha_pedido)) AS total_anio
    FROM pedidos
    GROUP BY EXTRACT(YEAR FROM fecha_pedido), TO_CHAR(fecha_pedido, 'MM')
)
PIVOT (
    SUM(cantidad_pedidos)
    FOR mes IN (
        'Enero' AS enero,
        'Febrero' AS febrero,
        'Marzo' AS marzo,
        'Abril' AS abril,
        'Mayo' AS mayo,
        'Junio' AS junio,
        'Julio' AS julio,
        'Agosto' AS agosto,
        'Septiembre' AS septiembre,
        'Octubre' AS octubre,
        'Noviembre' AS noviembre,
        'Diciembre' AS diciembre
    )
)
ORDER BY año;

---Con CASE
SELECT *
FROM (  SELECT EXTRACT(YEAR FROM fecha_pedido) AS año,
           CASE
               WHEN TO_CHAR(fecha_pedido, 'MM') = '01' THEN 'Enero'
               WHEN TO_CHAR(fecha_pedido, 'MM') = '02' THEN 'Febrero'
               WHEN TO_CHAR(fecha_pedido, 'MM') = '03' THEN 'Marzo'
               WHEN TO_CHAR(fecha_pedido, 'MM') = '04' THEN 'Abril'
               WHEN TO_CHAR(fecha_pedido, 'MM') = '05' THEN 'Mayo'
               WHEN TO_CHAR(fecha_pedido, 'MM') = '06' THEN 'Junio'
               WHEN TO_CHAR(fecha_pedido, 'MM') = '07' THEN 'Julio'
               WHEN TO_CHAR(fecha_pedido, 'MM') = '08' THEN 'Agosto'
               WHEN TO_CHAR(fecha_pedido, 'MM') = '09' THEN 'Septiembre'
               WHEN TO_CHAR(fecha_pedido, 'MM') = '10' THEN 'Octubre'
               WHEN TO_CHAR(fecha_pedido, 'MM') = '11' THEN 'Noviembre'
               WHEN TO_CHAR(fecha_pedido, 'MM') = '12' THEN 'Diciembre'
           END AS mes,
           COUNT(*) AS cantidad_pedidos,
           SUM(COUNT(*)) OVER (PARTITION BY EXTRACT(YEAR FROM fecha_pedido)) AS total_anio
    FROM pedidos
    GROUP BY EXTRACT(YEAR FROM fecha_pedido), TO_CHAR(fecha_pedido, 'MM')
)
PIVOT (
    SUM(cantidad_pedidos)
    FOR mes IN (
        'Enero' AS enero,
        'Febrero' AS febrero,
        'Marzo' AS marzo,
        'Abril' AS abril,
        'Mayo' AS mayo,
        'Junio' AS junio,
        'Julio' AS julio,
        'Agosto' AS agosto,
        'Septiembre' AS septiembre,
        'Octubre' AS octubre,
        'Noviembre' AS noviembre,
        'Diciembre' AS diciembre
    )
)
ORDER BY año;


----------------------9------------------------------

--Cantidad de pedidos por forma de pago.

SELECT 
    CASE 
        WHEN forma_pago = 'E' THEN 'EFECTIVO'
        WHEN forma_pago = 'C' THEN 'CREDITO'
        ELSE 'OTRO'
    END AS forma_pago,
    COUNT(*) AS cantidad_pedidos
FROM pedidos
GROUP BY forma_pago;


--------------------10-----------------------------

--Consulta que muestre nombre del cliente, número del pedido y nombre del
--producto, de todas las órdenes realizadas en el año 2021.

SELECT c.nombre_compañía AS nombre_cliente, pe.id_pedido, p.nombre_producto
FROM pedidos pe JOIN clientes c 
ON pe.id_cliente = c.id_cliente
JOIN detalles_pedidos dp 
ON pe.id_pedido = dp.id_pedido
JOIN productos p 
ON dp.id_producto = p.id_producto
WHERE EXTRACT(YEAR FROM pe.fecha_pedido) = 2021;


-------------------------11-------------------------------

--Consultar la cantidad de productos por pedido. Ordene por la cantidad en forma
--descendente. ¿Qué orden tiene la mayor cantidad de productos? 

SELECT id_pedido, COUNT(*) AS cantidad_productos
FROM detalles_pedidos
GROUP BY id_pedido
ORDER BY cantidad_productos DESC;


--------------------------12------------------------------

--Ajuste la sentencia anterior. Consulta que muestre aquellos pedidos con más de 5
--productos.

SELECT id_pedido, COUNT(*) AS cantidad_productos
FROM detalles_pedidos
GROUP BY id_pedido
HAVING COUNT(*) > 5
ORDER BY cantidad_productos DESC;


-----------------------------13------------------------------

-- Consulta que muestre el producto más vendido.

SELECT p.nombre_producto, COUNT(*) AS cantidad_vendida
FROM detalles_pedidos dp JOIN productos p 
ON dp.id_producto = p.id_producto
GROUP BY p.nombre_producto
HAVING COUNT(*) = ( SELECT MAX(cantidad_vendida) 
                    FROM (  SELECT COUNT(*) AS cantidad_vendida 
                            FROM detalles_pedidos 
                            GROUP BY id_producto));


----------------------------14-------------------------------

--Consulta que muestre el producto más pedido o solicitado en las órdenes de compra

SELECT p.nombre_producto, SUM(dp.cantidad) AS total_solicitado
FROM detalles_pedidos dp JOIN productos p 
ON dp.id_producto = p.id_producto
GROUP BY p.nombre_producto
ORDER BY total_solicitado DESC
FETCH FIRST 1 ROW ONLY;


----------------------------15---------------------------------

--Mostrar para cada pedido la forma de pago “EFECTIVO” o “CREDITO” según corresponda al
--dominio mostrado en la tabla.

SELECT id_pedido,
    CASE 
        WHEN forma_pago = 'E' THEN 'EFECTIVO'
        WHEN forma_pago = 'C' THEN 'CREDITO'
        ELSE 'OTRO'
    END AS forma_de_pago
FROM pedidos;


--------------------------16-----------------------------------

--Consulta que imprima la factura de las órdenes. En la factura es necesario relacionar nombre
--del producto, cantidad de productos, total de la factura, nombre del cliente y nombre del
--representante de ventas. (Realice la consulta utilizando tres diferentes sintaxis de joins)


---Con JOIN ON
ACCEPT id_pedido NUMBER PROMPT 'Ingrese el ID del pedido para generar la factura: '

SELECT p.nombre_producto, dp.cantidad, (dp.cantidad * p.precio_por_unidad) AS total_factura, 
        c.nombre_compañía AS nombre_cliente, e.first_name || ' ' || e.last_name AS nombre_representante
FROM detalles_pedidos dp 
JOIN productos p 
ON dp.id_producto = p.id_producto
JOIN pedidos pe 
ON dp.id_pedido = pe.id_pedido
JOIN clientes c 
ON pe.id_cliente = c.id_cliente
JOIN employees e 
ON pe.employee_id = e.employee_id
WHERE pe.id_pedido = &id_pedido;

---Con JOIN Oracle (Where)
ACCEPT id_pedido NUMBER PROMPT 'Ingrese el ID del pedido para generar la factura: '

SELECT p.nombre_producto, dp.cantidad, (dp.cantidad * p.precio_por_unidad) AS total_factura, 
        c.nombre_compañía AS nombre_cliente, e.first_name || ' ' || e.last_name AS nombre_representante
FROM detalles_pedidos dp, productos p, pedidos pe, clientes c, empleados e
WHERE dp.id_producto = p.id_producto
AND dp.id_pedido = pe.id_pedido
AND pe.id_cliente = c.id_cliente
AND pe.id_representante = e.id_empleado;
AND pe.id_pedido = &id_pedido;

--Con INNER JOIN
ACCEPT id_pedido NUMBER PROMPT 'Ingrese el ID del pedido para generar la factura: '

SELECT p.nombre_producto, dp.cantidad, (dp.cantidad * p.precio_por_unidad) AS total_factura, 
        c.nombre_compañía AS nombre_cliente, e.first_name || ' ' || e.last_name AS nombre_representante
FROM detalles_pedidos dp
INNER JOIN productos p 
ON dp.id_producto = p.id_producto
INNER JOIN pedidos pe 
ON dp.id_pedido = pe.id_pedido
INNER JOIN clientes c 
ON pe.id_cliente = c.id_cliente
INNER JOIN employees e 
ON pe.employee_id = e.employee_id
WHERE pe.id_pedido = &id_pedido;


---------------------------17-------------------------------

--Utilice funciones analíticas para consultar el top diez de los productos más vendidos en la
--compañía. (Realice tres sentencias diferentes)

--Con ROW_NUMBER
SELECT nombre_producto, cantidad_vendida, ranking
FROM (  SELECT nombre_producto, SUM(cantidad) AS cantidad_vendida,
           ROW_NUMBER() OVER (ORDER BY SUM(cantidad) DESC) AS ranking
        FROM detalles_pedidos dp
        JOIN productos p 
        ON dp.id_producto = p.id_producto
        GROUP BY nombre_producto
)
WHERE ranking <= 10;

--Con RANK
SELECT nombre_producto, cantidad_vendida, ranking
FROM (  SELECT nombre_producto, SUM(cantidad) AS cantidad_vendida,
           RANK() OVER (ORDER BY SUM(cantidad) DESC) AS ranking
        FROM detalles_pedidos dp
        JOIN productos p 
        ON dp.id_producto = p.id_producto
        GROUP BY nombre_producto
)
WHERE ranking <= 10;

--Con DENSE_RANK
SELECT nombre_producto, cantidad_vendida, ranking
FROM (  SELECT nombre_producto, SUM(cantidad) AS cantidad_vendida,
           DENSE_RANK() OVER (ORDER BY SUM(cantidad) DESC) AS ranking
        FROM detalles_pedidos dp
        JOIN productos p 
        ON dp.id_producto = p.id_producto
        GROUP BY nombre_producto
)
WHERE ranking <= 10;


---------------------18-------------------------------

--Utilice funciones analíticas para consultar el top cinco de los clientes que más facturan en la
--compañía. (Realice tres sentencias diferentes)´

--Con ROW_NUMBER
SELECT nombre_cliente, total_facturado, ranking
FROM (  SELECT c.nombre_compañía AS nombre_cliente, SUM(dp.cantidad * p.precio_por_unidad) AS total_facturado,
           ROW_NUMBER() OVER (ORDER BY SUM(dp.cantidad * p.precio_por_unidad) DESC) AS ranking
        FROM detalles_pedidos dp
        JOIN pedidos pe 
        ON dp.id_pedido = pe.id_pedido
        JOIN clientes c 
        ON pe.id_cliente = c.id_cliente
        JOIN productos p 
        ON dp.id_producto = p.id_producto
        GROUP BY c.nombre_compañía
)
WHERE ranking <= 5;

--Con RANK
SELECT nombre_cliente, total_facturado, ranking
FROM (  SELECT c.nombre_compañia AS nombre_cliente, SUM(dp.cantidad * p.precio) AS total_facturado,
           RANK() OVER (ORDER BY SUM(dp.cantidad * p.precio) DESC) AS ranking
        FROM detalles_pedidos dp
        JOIN pedidos pe 
        ON dp.id_pedido = pe.id_pedido
        JOIN clientes c 
        ON pe.id_cliente = c.id_cliente
        JOIN productos p 
        ON dp.id_producto = p.id_producto
        GROUP BY c.nombre_compañia
)
WHERE ranking <= 5;
