-------------------7------------------------------
--7)Calcular los conceptos de nómina para
--el contrato número 15 y el periodo 19.
SELECT cn.id_concepto, cn.nombre_concepto, NVL(cn.valor, 0) AS valores,
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
FROM (SELECT c.ind_sal_hora_c_nc, n.num_horas, c.porcentaje, n.id_periodo, n.id_contrato, c.id_concepto, c.nombre_concepto, n.valor 
        FROM conceptos c JOIN  nomina n
        ON n.id_concepto = c.id_concepto) cn
JOIN contratos ct
ON ct.id_contrato = cn.id_contrato
JOIN libranzas l
ON ct.id_contrato = l.id_contrato
AND cn.id_contrato = 15
AND cn.id_periodo = 19;

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

--------------------11---------------------------
--Proponga una consulta con los datos gestión empleado que considere es
--importante y que sería indispensable para la organización.

--Buscar los contratos que esten vijentes, el costo del contrato, el empleado asignado al contrato
--y su fecha de inicio
SELECT e.first_name || ' ' || e.last_name AS employee_name, c.id_contrato, c.salario, c.fecha_inicio
FROM contratos c JOIN employees e 
ON c.employee_id = e.employee_id
JOIN tipo_contrato tc 
ON c.id_tipo = tc.id_tipo
WHERE c.fecha_fin IS NULL;