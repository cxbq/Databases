-- Part 1: Basic SELECT Queries

-- Task 1.1
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    department, 
    salary 
FROM employees;

-- Task 1.2
SELECT DISTINCT 
    department 
FROM employees;

-- Task 1.3
SELECT 
    name, 
    budget, 
    CASE 
        WHEN budget > 150000 THEN 'Large'
        WHEN budget BETWEEN 100000 AND 150000 THEN 'Medium'
        ELSE 'Small' 
    END AS budget_category 
FROM projects;

-- Task 1.4
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    COALESCE(email, 'No email provided') AS email 
FROM employees;


-- Part 2: WHERE Clause and Comparison Operators

-- Task 2.1
SELECT * 
FROM employees 
WHERE hire_date > '2020-01-01';

-- Task 2.2
SELECT * 
FROM employees 
WHERE salary BETWEEN 60000 AND 70000;

-- Task 2.3
SELECT * 
FROM employees 
WHERE last_name LIKE 'S%' 
   OR last_name LIKE 'J%';

-- Task 2.4
SELECT * 
FROM employees 
WHERE manager_id IS NOT NULL 
  AND department = 'IT';


-- Part 3: String and Mathematical Functions

-- Task 3.1
SELECT 
    UPPER(CONCAT(first_name, ' ', last_name)) AS employee_name, 
    LENGTH(last_name) AS last_name_length, 
    SUBSTRING(email, 1, 3) AS email_prefix 
FROM employees;

-- Task 3.2
SELECT 
    salary AS annual_salary, 
    ROUND((salary / 12.0), 2) AS monthly_salary, 
    (salary * 0.10) AS raise_amount 
FROM employees;

-- Task 3.3
SELECT 
    CONCAT('Project: ', name, ' - Budget: $', FORMAT(budget, 2), ' - Status: ', status) AS project_details 
FROM projects;

-- Task 3.4
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, 
    EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM hire_date) AS years_with_company 
FROM employees;


-- Part 4: Aggregate Functions and GROUP BY

-- Task 4.1
SELECT 
    department, 
    AVG(salary) AS average_salary 
FROM employees 
GROUP BY department;

-- Task 4.2
SELECT 
    p.name AS project_name, 
    SUM(a.hours_worked) AS total_hours 
FROM projects p
JOIN assignments a ON p.project_id = a.project_id
GROUP BY p.name;

-- Task 4.3
SELECT 
    department, 
    COUNT(employee_id) AS employee_count 
FROM employees 
GROUP BY department 
HAVING COUNT(employee_id) > 1;

-- Task 4.4
SELECT 
    MAX(salary) AS max_salary, 
    MIN(salary) AS min_salary, 
    SUM(salary) AS total_payroll 
FROM employees;


-- Part 5

-- Task 5.1: Combine salary > 65000 and hired after 2020 using UNION
SELECT employee_id, CONCAT(first_name, ' ', last_name) AS full_name, salary 
FROM employees 
WHERE salary > 65000
UNION
SELECT employee_id, CONCAT(first_name, ' ', last_name) AS full_name, salary 
FROM employees 
WHERE hire_date > '2020-01-01';

-- Task 5.2
SELECT employee_id, CONCAT(first_name, ' ', last_name) AS full_name, salary 
FROM employees 
WHERE department = 'IT'
INTERSECT
SELECT employee_id, CONCAT(first_name, ' ', last_name) AS full_name, salary 
FROM employees 
WHERE salary > 65000;

-- Task 5.3
SELECT employee_id 
FROM employees
EXCEPT
SELECT employee_id 
FROM assignments;


-- Part 6: Subqueries

-- Task 6.1
SELECT CONCAT(first_name, ' ', last_name) AS full_name 
FROM employees e 
WHERE EXISTS (
    SELECT 1 
    FROM assignments a 
    WHERE a.employee_id = e.employee_id
);

-- Task 6.2
SELECT CONCAT(first_name, ' ', last_name) AS full_name 
FROM employees 
WHERE employee_id IN (
    SELECT a.employee_id 
    FROM assignments a
    JOIN projects p ON a.project_id = p.project_id
    WHERE p.status = 'Active'
);

-- Task 6.3
SELECT CONCAT(first_name, ' ', last_name) AS full_name, salary 
FROM employees 
WHERE salary > ANY (
    SELECT salary 
    FROM employees 
    WHERE department = 'Sales'
);


-- Part 7: Complex Queries

-- Task 7.1
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS full_name, 
    e.department, 
    (SELECT AVG(a.hours_worked) 
     FROM assignments a 
     WHERE a.employee_id = e.employee_id) AS average_hours,
    RANK() OVER (PARTITION BY e.department ORDER BY e.salary DESC) AS department_salary_rank
FROM employees e;

-- Task 7.2
SELECT 
    p.name AS project_name, 
    SUM(a.hours_worked) AS total_hours, 
    COUNT(DISTINCT a.employee_id) AS assigned_employees 
FROM projects p
JOIN assignments a ON p.project_id = a.project_id
GROUP BY p.name
HAVING SUM(a.hours_worked) > 150;

-- Task 7.3
SELECT 
    e1.department, 
    COUNT(e1.employee_id) AS total_employees, 
    AVG(e1.salary) AS average_salary,
    (SELECT CONCAT(first_name, ' ', last_name) 
     FROM employees e2 
     WHERE e2.department = e1.department 
     ORDER BY salary DESC 
     LIMIT 1) AS highest_paid_employee,
    GREATEST(MAX(e1.salary), 0) AS max_eval_salary,
    LEAST(MIN(e1.salary), 999999) AS min_eval_salary
FROM employees e1
GROUP BY e1.department;