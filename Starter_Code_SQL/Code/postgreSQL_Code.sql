--Creating the tables 
CREATE TABLE "titles" (
    "title_id" VARCHAR(10)   NOT NULL,
    "title" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR(10)   NOT NULL,
    "dept_name" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);
--For some reason this csv would not import if I included the field lengths. Unsure why?
CREATE TABLE "employees" (
    "emp_no" INTEGER   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" VARCHAR   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" VARCHAR   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(10)   NOT NULL,
    "emp_no" INTEGER   NOT NULL
);

CREATE TABLE "salaries" (
    "emp_no" INTEGER   NOT NULL,
    "salary" INTEGER   NOT NULL
);

CREATE TABLE "dept_emp" (
    "emp_no" INTEGER   NOT NULL,
    "dept_no" VARCHAR(10)   NOT NULL
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

-- Checking to make sure data was imported and will use for future reference to columns and column names
SELECT * FROM departments;
SELECT * FROM titles;
SELECT * FROM employees;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM salaries;

-- 1. List the employee number, last name, first name, sex, and salary of each employee
SELECT employees.emp_no AS "Employee Number", employees.last_name AS "Employee Last Name", 
	employees.first_name AS "Employee First Name", employees.sex AS "Employee Gender", salaries.salary AS "Employee Salary"
FROM employees
JOIN salaries
ON employees.emp_no = salaries.emp_no;
-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name AS "Employee First Name", last_name AS "Employee Last Name", hire_date AS "Employee Hire Date"
FROM employees
WHERE hire_date BETWEEN '1/1/1986' AND '12/31/1986'
ORDER BY hire_date;
-- 3. List the manager of each department along with their department number, 
--    department name, employee number, last name, first name, and department name
SELECT employees.first_name AS "Employee First Name", 
	employees.last_name AS "Employee Last Name", dept_manager.emp_no AS "Emplyee Number", 
	departments.dept_no AS "Department Number", departments.dept_name AS "Department Name"
FROM departments
JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no
JOIN employees
ON dept_manager.emp_no = employees.emp_no;
-- 4. List the department number for each employee along with that employee’s 
--    employee number, last name, first name, and department name.
SELECT departments.dept_no AS "Department Number", dept_emp.emp_no AS "Emplyee Number", 
	employees.last_name AS "Employee Last Name", employees.first_name AS "Employee First Name"
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no;
-- 5. List first name, last name, and sex of each employee whose first name is 
--    Hercules and whose last name begins with the letter B.
SELECT employees.first_name AS "Employee First Name", 
	employees.last_name AS "Employee Last Name", employees.sex AS "Employee Gender"
FROM employees
WHERE first_name = 'Hercules'
AND last_name Like 'B%'
-- 6. List each employee in the Sales department, including their 
--    employee number, last name, and first name.
SELECT departments.dept_name AS "Department Name", employees.emp_no AS "Employee Number", 
	employees.last_name AS "Employee Last Name", employees.first_name AS "Employee First Name"
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';
-- 7. List each employee in the Sales and Development departments, 
--    including their employee number, last name, first name, and department name.
SELECT dept_emp.emp_no AS "Employee Number", employees.last_name AS "Employee Last Name", 
	employees.first_name AS "Employee First Name", departments.dept_name AS "Department Name"
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales' 
OR departments.dept_name = 'Development';
-- 8. List the frequency counts, in descending order, of all the employee last names 
--    (that is, how many employees share each last name).
SELECT last_name AS "Last Name",
COUNT(last_name) AS "Frequency"
FROM employees
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC;