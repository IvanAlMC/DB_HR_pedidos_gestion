-------------------------------1----------------------------
-- Identificar que empleados terminaron contrato en los años 2021 y 2022
SELECT e.employee_id, e.first_name || e.last_name AS employee_name, c.fecha_fin
FROM rh.employees e JOIN contratos c
ON e.employee_id = c.employee_id
WHERE EXTRACT(YEAR FROM c.fecha_fin) IN (2021, 2022);

-------------------------------2------------------------------
--Que empleados han tenido mas de un contrato en la empresa
SELECT e.employee_id, e.first_name || e.last_name AS employee_name, COUNT(e.employee_id) AS cant_contratos
FROM rh.employees e JOIN contratos c
ON e.employee_id = c.employee_id
HAVING COUNT(e.employee_id) > 1
GROUP BY e.employee_id, e.first_name, e.last_name;

-----------------------------3----------------------------
--Que empleados nacieron, viven y trabajan en el mismo lugar. 
--Mostrar codigo, nombre, apellido, codigos y nombres de los lugares
SELECT e.employee_id, e.first_name, e.last_name, 
        nac.id_lugar AS id_lug_nace, nac.nombre_lugar AS nom_lug_nace, 
        vive.id_lugar AS id_lug_vive, vive.nombre_lugar AS nom_lug_vive,
        trab.id_lugar AS id_lug_trab, trab.nombre_lugar AS nom_lug_trab
FROM employees e JOIN lugares nac 
ON e.cod_lugar_nace = nac.id_lugar
JOIN lugares vive 
ON e.cod_lugar_trabaja = vive.id_lugar
JOIN lugares trab ON e.cod_lugar_trabaja = trab.id_lugar
WHERE e.cod_lugar_nace = e.cod_lugar_vive
AND e.cod_lugar_vive = e.cod_lugar_trabaja;

------------------------------4-------------------------------
--Que empleados nacieron, viven y trabajan en lugares diferentes.
--Mostrar código, nombre, apellido, códigos y nombres de los lugares.
SELECT e.employee_id, e.first_name, e.last_name, 
        nac.id_lugar AS id_lug_nace, nac.nombre_lugar AS nom_lug_nace, 
        vive.id_lugar AS id_lug_vive, vive.nombre_lugar AS nom_lug_vive,
        trab.id_lugar AS id_lug_trab, trab.nombre_lugar AS nom_lug_trab
FROM employees e JOIN lugares nac 
ON e.cod_lugar_nace = nac.id_lugar
JOIN lugares vive 
ON e.cod_lugar_trabaja = vive.id_lugar
JOIN lugares trab ON e.cod_lugar_trabaja = trab.id_lugar
WHERE e.cod_lugar_nace != e.cod_lugar_vive
AND e.cod_lugar_vive != e.cod_lugar_trabaja;

--------------------------------5---------------------------------
--Mostrar las ciudades que pertenecen a Estados Unidos.
SELECT ciudades.id_lugar AS codigo_ciudad, ciudades.nombre_lugar AS ciudad, paises.nombre_lugar AS pais
FROM  lugares ciudades JOIN lugares paises 
ON ciudades.id_padre = paises.id_lugar
WHERE paises.nombre_lugar = 'Estados Unidos';

--------------------------6--------------------------------
--Consulta para identificar los Empleados que tienen contrato a
--término indefinido y además poseen libranzas. (utilizar operadores de
--conjuntos

-- Subconsulta para empleados con contrato a término indefinido
SELECT e.first_name || ' ' || e.last_name AS employee_name, c.id_tipo
FROM rh.employees e JOIN contratos c 
ON e.employee_id = c.employee_id
WHERE c.id_tipo = (SELECT id_tipo 
                    FROM tipo_contrato 
                    WHERE nombre_tipo = 'Contrato a Termino Indefinido')
INTERSECT
-- Subconsulta para empleados con libranzas
SELECT e.first_name || ' ' || e.last_name AS employee_name, c.id_tipo
FROM rh.employees e JOIN contratos c 
ON e.employee_id = c.employee_id
JOIN libranzas l 
ON c.id_contrato = l.id_contrato;



-------------------7------------------------------
--7)Calcular los conceptos de nómina para
--el contrato número 15 y el periodo 19.
SELECT cn.id_concepto, NVL(cn.valor, 0) AS valores,
    CASE
        WHEN cn.ind_sal_hora_c_nc = 'S' THEN ct.salario*cn.porcentaje
        ELSE 0
        END AS por_salario,
    CASE
        WHEN cn.ind_sal_hora_c_nc = 'C' THEN l.valor/l.total_cuotas
        ELSE 0
        END AS por_table,
    CASE
        WHEN cn.ind_sal_hora_c_nc = 'H' THEN ROUND(cn.num_horas*(((ct.salario/30)/8)*cn.porcentaje + (ct.salario/30)/8), 2)
        ELSE 0
        END AS horas_adicionales
FROM (SELECT c.ind_sal_hora_c_nc, n.num_horas, c.porcentaje, n.id_periodo, n.id_contrato, c.id_concepto, n.valor FROM conceptos c JOIN  nomina n
        ON n.id_concepto = c.id_concepto) cn
JOIN contratos ct
ON ct.id_contrato = cn.id_contrato
JOIN libranzas l
ON ct.id_contrato = l.id_contrato
AND cn.id_contrato = 15
AND cn.id_periodo = 19;

-------------------------8------------------------------}
--Consulta que calcule los conceptos de
--nómina para el periodo 26.

SELECT cn.id_contrato, cn.nombre_concepto, cn.id_concepto, NVL(cn.valor, 0) AS valores,
    CASE
        WHEN cn.ind_sal_hora_c_nc = 'S' THEN ct.salario*cn.porcentaje
        ELSE 0
        END AS por_salario,
    CASE
        WHEN cn.ind_sal_hora_c_nc = 'C' THEN l.valor
        ELSE 0
        END AS por_table,
    CASE
        WHEN cn.ind_sal_hora_c_nc = 'H' THEN ROUND(cn.num_horas*(((ct.salario/30)/8)*cn.porcentaje + (ct.salario/30)/8), 2)
        ELSE 0
        END AS horas_adicionales
FROM (SELECT c.ind_sal_hora_c_nc, n.num_horas, c.porcentaje, n.id_periodo, n.id_contrato, c.id_concepto, n.valor , c.nombre_concepto
        FROM conceptos c JOIN  nomina n
        ON n.id_concepto = c.id_concepto) cn
JOIN contratos ct
ON ct.id_contrato = cn.id_contrato
LEFT JOIN libranzas l
ON ct.id_contrato = l.id_contrato
WHERE cn.id_periodo = 26;

------------------------9-------------------------------
--Consulta que identifique por departamento el rango o clasificación de
--los salarios de los empleados. Escriba la consulta utilizando la función analítica
--Rank() y dense_rank() e identifique las ventajas de utilizar una función con
--respecto a la otra.

SELECT employee_id, first_name, last_name, department_id, salary,
        RANK() OVER (PARTITION BY department_id ORDER by salary DESC) AS rank_salary
FROM employees;

SELECT employee_id, first_name, last_name, department_id, salary, 
        DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rank_salary
FROM employees;

--------------10-------------------
--Proponga tres consultas para la base de datos gestión empleado. Elabore los
--scripts correspondientes. Utilice expresiones regulares.


--empleados cuyos apellidos empiecen con la letra "K" y terminen con la letra "g"
SELECT * FROM EMPLOYEES
WHERE REGEXP_LIKE(LAST_NAME, '^K.*g$', 'i'); -- 'i' para que sea case-insensitive

--empleados cuyos números de teléfono tienen el formato 5.###.###.###.
SELECT first_name, last_name, phone_number
FROM employees
WHERE REGEXP_LIKE(phone_number, '^5\.\d{3}\.\d{3}\.\d{3}$');

--empleados cuyo lugar de residencia empiece por "M" y cuyo tipo de contrato contenga la palabra "termino"
SELECT e.first_name, e.last_name, tc.nombre_tipo, l.nombre_lugar
FROM employees e JOIN contratos c 
ON e.employee_id = c.employee_id
JOIN tipo_contrato tc 
ON c.id_tipo = tc.id_tipo
JOIN lugares l
ON e.cod_lugar_vive = l.id_lugar
WHERE REGEXP_LIKE(l.nombre_lugar, '^M', 'i')
AND REGEXP_LIKE(tc.nombre_tipo, 'termino', 'i');


--------------------11---------------------------
--Proponga una consulta con los datos gestión empleado que considere es
--importante y que sería indispensable para la organización.

--Buscar los contratos que esten vijentes, el costo del contrato, el empleado asignado al contrato
--y su fecha de inicio
SELECT e.first_name || ' ' || e.last_name AS employee_name, tc.nombre_tipo AS tipo_contrato, c.salario, c.fecha_inicio
FROM contratos c JOIN employees e 
ON c.employee_id = e.employee_id
JOIN tipo_contrato tc 
ON c.id_tipo = tc.id_tipo
WHERE c.fecha_fin IS NULL;