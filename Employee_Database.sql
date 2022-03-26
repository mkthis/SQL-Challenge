-- Database: Employee_Database

-- DROP DATABASE IF EXISTS "Employee_Database";

CREATE DATABASE "Employee_Database"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
	
CREATE TABLE titles (
	title_id VARCHAR NOT NULL PRIMARY KEY,
	title VARCHAR NOT NULL
); 

CREATE TABLE departments (
	dept_num VARCHAR NOT NULL PRIMARY KEY,
	dept_name VARCHAR NOT NULL
); 

CREATE TABLE employees (
	empl_num integer NOT NULL PRIMARY KEY,
	empl_title VARCHAR NOT NULL,
	date_of_birth VARCHAR NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	sex VARCHAR NOT NULL,
	hire_date VARCHAR NOT NULL,
		FOREIGN KEY (empl_title) REFERENCES titles (title_id)
); 
					
CREATE TABLE salaries (
	empl_num integer NOT NULL,
	salary integer NOT NULL,
		FOREIGN KEY (empl_num) REFERENCES employees(empl_num)
); 

CREATE TABLE department_employee (
	empl_num integer NOT NULL,
	dept_num VARCHAR NOT NULL,
		FOREIGN KEY (empl_num) REFERENCES employees(empl_num),
		FOREIGN KEY (dept_num) REFERENCES departments(dept_num),
		PRIMARY KEY (empl_num, dept_num)
);	
	
CREATE TABLE department_manager (
    dept_num VARCHAR   NOT NULL,
    empl_num integer  NOT NULL,
		FOREIGN KEY (empl_num) REFERENCES employees(empl_num),
		FOREIGN KEY (dept_num) REFERENCES departments(dept_num),
		PRIMARY KEY (empl_num, dept_num)
);

COPY titles
FROM 'C:\Users\Public\data\titles.csv'
DELIMITER ','
CSV HEADER;
	
COPY departments
FROM 'C:\Users\Public\data\departments.csv'
DELIMITER ','
CSV HEADER;

COPY employees
FROM 'C:\Users\Public\data\employees.csv'
DELIMITER ','
CSV HEADER;
	
COPY salaries
FROM 'C:\Users\Public\data\salaries.csv'
DELIMITER ','
CSV HEADER;

COPY department_employee
FROM 'C:\Users\Public\data\dept_emp.csv'
DELIMITER ','
CSV HEADER;

COPY department_manager
FROM 'C:\Users\Public\data\dept_manager.csv'
DELIMITER ','
CSV HEADER;

select * from titles
select * from employees
select * from departments
select * from salaries
select * from department_employee
select * from department_manager

-- List the following details of each employee: 
-- employee number, last name, first name, sex, and salary.
SELECT e.empl_num, e.last_name, e.first_name, e.sex, s.salary
FROM employees as e
INNER JOIN salaries as s
ON e.empl_num = s.empl_num

-- List the first name, last name, and hire date for employees hired in 1986.
SELECT hire_date from employees;

ALTER TABLE employees ALTER COLUMN hire_date TYPE DATE 
using to_date (hire_date, 'MM-DD-YYYY');

SELECT first_name, last_name, hire_date
FROM employees
WHERE (hire_date >= '01-01-1986')
AND (hire_date <= '12-31-1986')

-- List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
SELECT mgr.dept_num, d.dept_name, e.empl_num, e.last_name, e.first_name
FROM employees as e
INNER JOIN department_manager as mgr
ON e.empl_num = mgr.empl_num
INNER JOIN departments as d
ON mgr.dept_num = d.dept_num

-- List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT e.empl_num, e.last_name, e.first_name, d.dept_name
FROM employees as e
INNER JOIN department_employee as de
ON e.empl_num = de.empl_num
INNER JOIN departments as d
ON de.dept_num = d.dept_num

-- List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

-- List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT e.empl_num, e.last_name, e.first_name, d.dept_name
FROM employees as e
INNER JOIN department_employee as de
ON e.empl_num = de.empl_num
INNER JOIN departments as d
ON de.dept_num = d.dept_num
WHERE d.dept_name = 'Sales';

-- List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.empl_num, e.last_name, e.first_name, d.dept_name
FROM employees as e
INNER JOIN department_employee as de
ON e.empl_num = de.empl_num
INNER JOIN departments as d
ON de.dept_num = d.dept_num
WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development';

-- In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name, COUNT (*) as ct
FROM employees 
GROUP BY last_name
ORDER BY ct DESC; 