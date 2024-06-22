select * from user_constraints;

desc user_tables;
select * from user_tables;

desc user_synonyms;
select * from user_synonyms;

select TABLE_NAME, TABLESPACE_NAME;
from user_tables;

desc user_TAB_PRIVS;
select * from user_TAB_PRIVS;


--Aumentar en 15%, el precio por unidad para todos los productos. 
--Muestre el precio por unidad sin y con incremento
SELECT id_producto, precio_por_unidad, precio_por_unidad + precio_por_unidad*0.15 AS nuevo_precio 
FROM productos;


--Realizar una consulta de la tabla productos para determinar cuales categorias tienen por lo
--menos un producto relacionado. Realice la consulta de tres formas con subconsultas, con vista
--en linea y con clausula with

--consulta basica
SELECT c.id_categoria, c.nombre_categoria 
FROM categorias c JOIN productos p
ON c.id_categoria = p.id_categoria 
GROUP BY c.id_categoria, c.nombre_categoria;

--Con subconsulta
SELECT DISTINCT id_categoria, nombre_categoria
FROM categorias
WHERE id_categoria IN (SELECT id_categoria FROM productos);

--Con vista en linea
SELECT DISTINCT ctpd.id_categoria, ctpd.nombre_categoria
FROM (SELECT c.id_categoria, c.nombre_categoria FROM categorias c JOIN productos p
        ON c.id_categoria = p.id_categoria
        GROUP BY c.id_categoria, c.nombre_categoria) ctpd;

--Con clausula with
WITH producto_categorias_with AS (
    SELECT c.id_categoria AS id_categoria, c.nombre_categoria AS nombre_categoria
    FROM categorias c JOIN productos p 
    ON c.id_categoria = p.id_categoria
    GROUP BY c.id_categoria, c.nombre_categoria
)
SELECT * FROM producto_categorias_with;


--Ajustar la primera consulta. Realice el aumento, solo a los productos que 
--pertenecen a la categoria de bebidas
SELECT id_producto, precio_por_unidad, precio_por_unidad + precio_por_unidad*0.15 AS nuevo_precio 
FROM productos
WHERE id_categoria = 1;


--Mostrar en una sola columna el nombre del producto y el nombre de la categoria
SELECT 'el producto ' || p.nombre_producto || ' pertenece a la categoria ' || c.nombre_categoria AS producto_categoria
FROM categorias c JOIN productos p
ON c.id_categoria = p.id_categoria 


--Cantidad de productos que pertenecen a la categoria lacteos. Implemente tres consultas diferentes

--Forma 1: con JOIN y por id_categoria
SELECT c.id_categoria, c.nombre_categoria, COUNT(*) AS cant_productos
FROM categorias c JOIN productos p
ON c.id_categoria = p.id_categoria
WHERE c.id_categoria = 6
GROUP BY c.id_categoria, c.nombre_categoria;

--Forma 2: Uniendo tablas con WHERE y por id_categoria
SELECT c.id_categoria, c.nombre_categoria, COUNT(*) AS cant_productos
FROM categorias c, productos p
WHERE c.id_categoria = p.id_categoria
AND c.id_categoria = 6
GROUP BY c.id_categoria, c.nombre_categoria;

--Forma 3: Por NATURAL JOIN y por nombre_categoria
SELECT id_categoria, nombre_categoria, COUNT(*) AS cant_productos
FROM categorias NATURAL JOIN productos
WHERE nombre_categoria = 'Lácteos'
GROUP BY id_categoria, nombre_categoria;


--Cuantos productos tiene la tabla productos
SELECT count(*) AS cant_productos
FROM productos;


--Mostrar los productos de la categoria 1, 4 y 7
SELECT p.id_producto, p.nombre_producto, c.id_categoria, c.nombre_categoria
FROM categorias c JOIN productos p
ON c.id_categoria = p.id_categoria
WHERE c.id_categoria IN (1, 4, 7);


--Nombres de los productos que aun no han sido pedidos

--Con columna unidades pedidas
SELECT id_producto, nombre_producto
FROM productos
WHERE unidades_pedidas = 0;

--Con union entre productos y detalle_pedidos
SELECT p.id_producto, p.nombre_producto
FROM productos p LEFT JOIN detalles_pedidos dp 
ON p.id_producto = dp.id_producto
WHERE dp.id_producto IS NULL;


--Cantidad de productos por categoría. Mostrar la consulta ordenada de forma 
--descendente por cantidad.
SELECT c.nombre_categoria, COUNT(p.id_producto) AS cant_productos
FROM categorias c JOIN productos p 
ON c.id_categoria = p.id_categoria
GROUP BY c.nombre_categoria
ORDER BY cant_productos DESC;


--Ajuste la consulta anterior para que solo muestre aquellas categorías donde 
--la cantidad de productos es mayor de 10.
SELECT c.nombre_categoria, COUNT(p.id_producto) AS cant_productos
FROM categorias c JOIN productos p 
ON c.id_categoria = p.id_categoria
HAVING COUNT(p.id_producto) > 10
GROUP BY c.nombre_categoria
ORDER BY cant_productos DESC;


--- Cantidad de pedidos que se solicitaron el mismo día de la fecha actual. Realice dos consultas
-- diferentes utilizando también distintas funciones para sacar el día de la fecha.

--con TO_CHAR (tabla)
SELECT id_pedido, fecha_pedido, TO_CHAR(fecha_pedido, 'DD') AS dia_pedido, TO_CHAR(SYSDATE, 'DD') AS dia_actual
FROM pedidos
WHERE TO_CHAR(fecha_pedido, 'DD') = TO_CHAR(SYSDATE, 'DD');

--con TO_CHAR (contar)
SELECT COUNT (*) AS cant_pedidos_diaActual
FROM pedidos
WHERE TO_CHAR(fecha_pedido, 'DD') = TO_CHAR(SYSDATE, 'DD');

--con EXTRACT (tabla)
SELECT id_pedido, fecha_pedido, EXTRACT(DAY FROM fecha_pedido) AS dia_pedido, EXTRACT(DAY FROM SYSDATE) AS dia_actual
FROM pedidos
WHERE EXTRACT(DAY FROM fecha_pedido) = EXTRACT(DAY FROM SYSDATE);

--con EXTRACT (contar)
SELECT COUNT (*) AS cant_pedidos_diaActual
FROM pedidos
WHERE EXTRACT(DAY FROM fecha_pedido) = EXTRACT(DAY FROM SYSDATE);


--Cantidad de pedidos por cada uno de los meses del año. Realizar la consulta utilizando dos
--sentencias diferentes.

-- con EXTRACT
SELECT 
    CASE 
        WHEN EXTRACT(MONTH FROM fecha_pedido) = 1 THEN 'Enero'
        WHEN EXTRACT(MONTH FROM fecha_pedido) = 2 THEN 'Febrero'
        WHEN EXTRACT(MONTH FROM fecha_pedido) = 3 THEN 'Marzo'
        WHEN EXTRACT(MONTH FROM fecha_pedido) = 4 THEN 'Abril'
        WHEN EXTRACT(MONTH FROM fecha_pedido) = 5 THEN 'Mayo'
        WHEN EXTRACT(MONTH FROM fecha_pedido) = 6 THEN 'Junio'
        WHEN EXTRACT(MONTH FROM fecha_pedido) = 7 THEN 'Julio'
        WHEN EXTRACT(MONTH FROM fecha_pedido) = 8 THEN 'Agosto'
        WHEN EXTRACT(MONTH FROM fecha_pedido) = 9 THEN 'Septiembre'
        WHEN EXTRACT(MONTH FROM fecha_pedido) = 10 THEN 'Octubre'
        WHEN EXTRACT(MONTH FROM fecha_pedido) = 11 THEN 'Noviembre'
        ELSE 'Diciembre'
    END AS mes,
    COUNT(*) AS cant_pedidos
FROM pedidos
GROUP BY EXTRACT(MONTH FROM fecha_pedido)
ORDER BY EXTRACT(MONTH FROM fecha_pedido);

--Con TO_CHAR
SELECT TO_CHAR(fecha_pedido, 'Month') AS mes, COUNT(*) AS cant_pedidos
FROM pedidos
GROUP BY TO_CHAR(fecha_pedido, 'Month')
ORDER BY TO_DATE(TO_CHAR(fecha_pedido, 'Month'), 'Month');
