-- DSC 333
-- Database example with multiple tables and joins.  

-- DROP DATABASE company_db;

CREATE DATABASE company_db;

USE company_db;

CREATE TABLE IF NOT EXISTS employee (
	emp_id INT PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    dob DATE,
    super_id INT,
    branch_id INT
);

CREATE TABLE IF NOT EXISTS branch (
	branch_id INT PRIMARY KEY,
    branch_loc VARCHAR(30),
    mgr_id INT,
    FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

ALTER TABLE employee
	ADD FOREIGN KEY(branch_id) REFERENCES branch(branch_id)
    ON DELETE SET NULL
;

ALTER TABLE employee
	ADD FOREIGN KEY(super_id) REFERENCES employee(emp_id)
    ON DELETE SET NULL
;

CREATE TABLE client(
	client_id INT PRIMARY KEY,
    client_name VARCHAR(40),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with(
	emp_id INT,
    client_id INT,
    total_rev INT,
    PRIMARY KEY(emp_id, client_id),
    FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

-- Populate database

-- Create New Haven branch with 4 employees
INSERT INTO employee VALUES(1000, 'M1', 'M1', '1999-12-31', NULL, NULL);

INSERT INTO branch VALUES(1, 'New Haven', 1000);

UPDATE employee
	SET branch_id = 1
	WHERE emp_id = 1000;

INSERT INTO employee VALUES(101, 'A', 'A', '1961-05-11', 1000, 1);
INSERT INTO employee VALUES(102, 'B', 'B', '1991-07-21', 1000, 1);
INSERT INTO employee VALUES(103, 'C', 'C', '2000-02-28', 1000, 1);

-- Create Hartford branch with 5 employees
INSERT INTO employee VALUES(1001, 'M2', 'M2', '1992-10-31', NULL, NULL);
INSERT INTO branch VALUES(2, 'Hartford', 1001);

UPDATE employee
	SET branch_id = 2
	WHERE emp_id = 1001;

INSERT INTO employee VALUES(104, 'D', 'D', '1981-05-14', 1001, 2);
INSERT INTO employee VALUES(105, 'E', 'E', '1992-03-22', 1001, 2);
INSERT INTO employee VALUES(106, 'F', 'F', '2001-03-18', 1001, 2);
INSERT INTO employee VALUES(107, 'G', 'G', '2002-01-28', 1001, 2);

-- Create 4 clients, 2 associated with each branch
INSERT INTO client VALUES(1, 'IBM', 1);
INSERT INTO client VALUES(2, 'Google', 1);
INSERT INTO client VALUES(3, 'OpenAI', 2);
INSERT INTO client VALUES(4, 'Meta', 2);

-- Create works_with records

-- Employees from New Haven Branch
INSERT INTO works_with VALUES(101, 1, 10000);
INSERT INTO works_with VALUES(101, 2, 12000);
INSERT INTO works_with VALUES(102, 1, 2000);
INSERT INTO works_with VALUES(102, 2, 7000);
INSERT INTO works_with VALUES(103, 1, 22000);

-- Employees from Hartford Branch
INSERT INTO works_with VALUES(104, 3, 11000);
INSERT INTO works_with VALUES(104, 4, 14000);
INSERT INTO works_with VALUES(105, 3, 6000);
INSERT INTO works_with VALUES(105, 4, 7000);
INSERT INTO works_with VALUES(106, 3, 11000);
INSERT INTO works_with VALUES(106, 4, 9000);
INSERT INTO works_with VALUES(107, 4, 25000);

-- Verify that database is properly populated 

SELECT * FROM employee;

SELECT * FROM branch;

SELECT * FROM client;

SELECT * FROM works_with;

-- JOIN statements

SELECT employee.first_name, employee.last_name, branch.branch_loc
	FROM employee
    JOIN branch ON employee.branch_id = branch.branch_id
    WHERE branch.branch_loc = 'New Haven';

SELECT employee.emp_id, employee.first_name, employee.last_name, works_with.total_rev
	FROM employee
    JOIN works_with ON employee.emp_id = works_with.emp_id
    WHERE works_with.total_rev > 10000;
    



    



