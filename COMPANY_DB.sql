
CREATE TABLE Employee
(emp_id INT PRIMARY KEY,
first_name VARCHAR(20),
last_name VARCHAR(20),
birth_date DATE,
sex VARCHAR(1),
salary INT,
super_id INT,
branch_id INT
);

CREATE TABLE branch 
(branch_id INT PRIMARY KEY,
branch_name VARCHAR(20),
mgr_id INT,
mgr_start_date DATE,
FOREIGN KEY(mgr_id) REFERENCES Employee(emp_id)ON DELETE SET NULL
);

ALTER TABLE Employee ADD FOREIGN KEY(super_id) REFERENCES Employee(emp_id);
ALTER TABLE Employee ADD FOREIGN KEY(branch_id) REFERENCES branch(branch_id);

CREATE TABLE client
(
client_id INT PRIMARY KEY,
client_name VARCHAR(20),
branch_id INT,
FOREIGN KEY(branch_id) REFERENCES branch(branch_id)
);

CREATE TABLE works_with
(emp_id INT,
client_id INT,
total_sales INT,
PRIMARY KEY(emp_id,client_id),
FOREIGN KEY(emp_id) REFERENCES Employee(emp_id) ON DELETE CASCADE,
FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier
(branch_id INT,
supplier_name VARCHAR(20),
supply_type VARCHAR(20),
PRIMARY KEY(branch_id,supplier_name),
FOREIGN KEY(branch_id) REFERENCES branch(branch_id)ON DELETE CASCADE
);

INSERT INTO Employee VALUES(100,"David","Wallace",'1967-11-17','M',250000,NULL,NULL),(101,'Jan','Levinson','1961-05-11','F',110000,100,NULL),(102,'Michael','Scott','1964-03-15','M',75000,100,NULL),(103,'Angela','Martin','1971-06-25','F',63000,102,NULL),(104,'Kelly','Kapoor','1980-02-05','F',55000,102,NULL),(105,'Stanley','Hudson','1958-02-19','M',69000,102,NULL),(106,'Josh','Porter','1969-09-05','M',78000,100,NULL),(107,'Andy','Bernard','1973-07-22','M',65000,106,NULL),(108,'Jim','Halpert','1978-10-01','M',71000,106,NULL);

INSERT INTO branch VALUES(1,'Corporate',100,'2006-02-09'),(2,'Scranton',102,'1992-04-06'),(3,'Stampford',106,'1998-02-13');

UPDATE Employee
SET branch_id=1 
WHERE emp_id IN(100,101);

UPDATE Employee
SET branch_id=2 
WHERE emp_id IN(102,103,104,105);


UPDATE Employee
SET branch_id=3 
WHERE emp_id IN(106,107,108);

SELECT * FROM Employee;
SELECT * FROM branch;

INSERT INTO client VALUES(400,'Dunmore Highschool',2),(401,'Lackawana Country',2),(402,'FedEx',3),(403,'John Daly Law, LLC',3),(404,'Scranton Whitepages',2),(405,'Times Newspaper',3),(406,'FedEx',2);
SELECT * FROM client;

INSERT INTO works_with VALUES(105,400,55000),(102,401,267000),(108,402,22500),(107,403,5000),(108,403,12000),(105,404,33000),(107,405,26000),(102,406,15000),(105,406,130000);
SELECT * FROM works_with;

INSERT INTO branch_supplier VALUES(2,'Hammer Mill','Paper'),(2,'Uni-ball','Writing Utensils'),(3,'Patriot Paper','Paper'),(2,'J.T.Forms & Labels','Custom Forms'),(3,'Uni-ball','Writing Utensils'),(3,'Hammer Mill','Paper'),(3,'Stamford Labels','Custom Forms');
SELECT * FROM branch_supplier;






--to get employee names (first+last)
SELECT Employee.first_name+' '+Employee.last_name AS full_name FROM Employee;

--select all employee name order by salary
SELECT *
FROM Employee 
ORDER BY salary DESC;

--find all employees ordered by sex then name
SELECT *
FROM Employee
ORDER BY sex,first_name,last_name ASC;

-- Find first 5 employes in TABLE
--SELECT *
--FROM Employee 
--LIMIT 5;

--FIND FORENAME AND SURNAME OF EMPLOYEE 
SELECT Employee.first_name AS Fore_name,Employee.last_name AS Sur_name FROM Employee;

--FIND OUT ALL DIFFERENT GENDERS IN SEX COLUMN 
SELECT DISTINCT sex 
FROM Employee;




--FUNCTIONS

--1)FIND THE NO OF employees
SELECT COUNT(emp_id) AS Emp_Count FROM Employee;

--2)Count no of supervisors 
SELECT COUNT(super_id) AS super_count FROM Employee;

--3)FIND THE NO OF FEMALE EMP BORN AFTER 1970 
SELECT COUNT(emp_id) AS female_count
FROM Employee
WHERE sex='F' AND birth_date>'1971-01-01';

--4)FIND AVG OF ALL EMPLOYEE SALARY 
SELECT AVG(salary) AS avg_sal FROM Employee;

--5)Find avg salary of male emp 
SELECT AVG(salary) AS male_avg_sal FROM Employee
WHERE sex='M';

--6)Find Sum of all emp salary 
SELECT SUM(salary) AS sal_sum FROM Employee;

--7)FIND OUT HOW MANY MALES AND FEMALES THERE ARE (group by)
SELECT sex,COUNT(sex) 
FROM Employee
GROUP BY sex;

SELECT branch_id,COUNT(branch_id)
FROM Employee
GROUP by branch_id;

--8)sum of total_sales of each employee 
SELECT emp_id,SUM(total_sales)
FROM works_with
GROUP by emp_id;

--9)how much each client has invested 
SELECT client_id,SUM(total_sales) 
FROM works_with
GROUP BY client_id;

--WILDCARDS
-- %->any no of characters AND _ ->one character 

--1)FIND ANY CLIENTS WHO ARE AN LLC 
SELECT *
FROM client 
WHERE client_name LIKE '%LLC';

--2)SELECT SUPPLIER NAME STARTING WITH U 
SELECT supplier_name 
FROM branch_supplier
WHERE supplier_name LIKE 'U%';

--3)FIND ANY BRANCH SUPLIER WHO ARE IN THE LABELS BUSINESS 
SELECT supplier_name
FROM branch_supplier
WHERE supplier_name LIKE '%Labels%';

--4)FIND ANY EMPLOYEE BORN IN OCT(10)
SELECT first_name
FROM Employee
WHERE birth_date LIKE '____-10-%';

--5)FIND ANY CLIENTS WHO ARE SCHOOLS
SELECT client_name
FROM client
WHERE client_name LIKE '%school%';



--UNION 
--USED TO COMBINE RESULTS OF MULTIPLE SELECT STMTS 
--RULES->SAME NO OF COLUMNS AND DATA TYPE
--1)FIND LIST OF EMP AND BRANCH NAMES and client names
SELECT Employee.first_name+' '+Employee.last_name AS Comapny_Names
FROM Employee
union
SELECT branch_name 
FROM branch
union
SELECT client_name
FROM client;

--2)FIND A LIST OF ALL CLIENTS AND BRANCH SUPPLIER NAMES 
SELECT client_name AS Client_and_Supplier,client.branch_id
FROM client
union
SELECT supplier_name,branch_supplier.branch_id
FROM branch_supplier;

--3)FIND ALL LIST MONEY SPENT AND EARNED BY COMPANY 
SELECT salary AS Spent_Earned
FROM Employee
union
SELECT total_sales
FROM works_with;

--JOINS
INSERT INTO branch VALUES(4,'BUffaloo',NULL,NULL);
--1)FIND ALL BRANCHES AND THE NAMES OF THEIR MANAGERS
--INNER JOIN
SELECT Employee.emp_id,Employee.first_name,branch.branch_name
FROM Employee
JOIN branch 
ON Employee.emp_id=branch.mgr_id;

--2)LEFT JOIN
SELECT Employee.emp_id,Employee.first_name,branch.branch_name
FROM Employee
LEFT JOIN branch 
ON Employee.emp_id=branch.mgr_id;

--3)RIGHT JOIN
SELECT Employee.emp_id,Employee.first_name,branch.branch_name
FROM Employee
RIGHT JOIN branch 
ON Employee.emp_id=branch.mgr_id;

--4)FULL JOIN 
SELECT Employee.emp_id,Employee.first_name,branch.branch_name
FROM Employee
FULL JOIN branch 
ON Employee.emp_id=branch.mgr_id;


--NESTED QUERIES
--1)FIND NAMES OF ALL EMP WHO HAVE SOLD OVER 30K TO A SINGLE client
Select Employee.first_name+' '+Employee.last_name as Sold_to_single_client
FROM Employee
WHERE emp_id IN(
Select works_with.emp_id
FROM works_with
WHERE works_with.total_sales>30000);

--2)FIND ALL CLIENTS WHO ARE HANDLED BY THE BRANCH THAT MICHAEL SCOTT MANAGES (ASSUME YK MICHAELS ID)
SELECT client.client_name AS Handled_by_Michael
FROM client
WHERE client.branch_id IN(
SELECT branch.branch_id
FROM branch
WHERE branch.mgr_id IN(
SELECT emp_id 
FROM Employee
WHERE first_name+' '+last_name='Michael Scott'));
