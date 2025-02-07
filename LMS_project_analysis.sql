-- create table 'branch'

CREATE TABLE brnach(
	branch_id VARCHAR(20) PRIMARY KEY,
	manager_id VARCHAR(10),
	branch_address VARCHAR(50),
	contact_no INT
);

ALTER TABLE brnach
ALTER COLUMN contact_no TYPE VARCHAR(20);

-- create table 'books'

CREATE TABLE books(
	isbn VARCHAR(20) PRIMARY KEY,
	book_title VARCHAR(30),
	category VARCHAR(20),
	rental_price FLOAT,
	status CHAR(10),
	author VARCHAR(25),
	publisher VARCHAR(30)
);

ALTER TABLE books
ALTER COLUMN book_title TYPE VARCHAR(75);

-- create table 'employees'

CREATE TABLE employees(
	emp_id VARCHAR(10) PRIMARY KEY,
	emp_name VARCHAR(30),
	position VARCHAR(30),
	salary FLOAT,
	branch_id VARCHAR(20)
);

-- create table 'issued_status'

CREATE TABLE issued_status(
	issued_id VARCHAR(10) PRIMARY KEY,
	issued_member_id VARCHAR(10),
	issued_book_name VARCHAR(75),
	issued_date DATE,
	issued_book_isbn VARCHAR(20),
	issued_emp_id VARCHAR(10)
);

-- create table 'members'

CREATE TABLE members(
	member_id VARCHAR(10) PRIMARY KEY,
	member_name VARCHAR(20),
	member_address VARCHAR(25),
	reg_date DATE
);

-- create table 'return_status'

CREATE TABLE return_status(
	return_id VARCHAR(10),
	issued_id VARCHAR(10),
	return_book_name VARCHAR(75),
	return_date DATE,
	return_book_isbn VARCHAR(10)
);

-- Foreign KEY

ALTER TABLE issued_status
ADD CONSTRAINT fk_member
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_brnach
FOREIGN KEY (branch_id)
REFERENCES brnach(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

SELECT * FROM books;
SELECT * FROM brnach;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;

-- Project Task

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 
--	'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books
	(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
	('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
	
-- Task 2: Update an Existing Member's Address

UPDATE members
SET member_address = '123 Main St'
WHERE member_id = 'C102';
SELECT * FROM members;

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status WHERE issued_id = 'IS121';
SELECT * FROM issued_status;

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT issued_book_name, issued_emp_id FROM issued_status
WHERE issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

WITH emp_issued_id AS(
	SELECT *
	FROM employees
	FULL OUTER JOIN issued_status
	ON employees.emp_id = issued_status.issued_emp_id
)
SELECT issued_emp_id, emp_name FROM emp_issued_id
GROUP BY issued_emp_id, emp_name
HAVING COUNT(issued_emp_id) > 1;

			--OR

SELECT issued_emp_id, emp_name
FROM employees
FULL OUTER JOIN issued_status
ON employees.emp_id = issued_status.issued_emp_id
GROUP BY issued_emp_id, emp_name
HAVING COUNT(issued_emp_id) > 1;

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt**

CREATE TABLE book_count AS
SELECT b.isbn, b.book_title, COUNT(isd.issued_id) AS no_issued
FROM books AS b
JOIN issued_status AS isd
ON b.isbn =  isd.issued_book_isbn
GROUP BY isbn, book_title;

SELECT * FROM book_count;

-- Task 7. Retrieve All Books in a Specific Category:

SELECT category, COUNT(book_title) FROM books
GROUP BY category;

-- Task 8: Find Total Rental Income by Category:

SELECT category, SUM(rental_price) FROM books
GROUP BY category;

-- Task 9: List Members Who Registered in the Last 180 Days:

SELECT * FROM members
WHERE reg_date < CURRENT_DATE - INTERVAL '180 days';

-- task 10: List Employees with Their Branch Manager's Name and their branch details:

SELECT 
    e1.*,
    b.manager_id,
    e2.emp_name as manager
FROM employees as e1
JOIN  
brnach as b
ON b.branch_id = e1.branch_id
JOIN
employees as e2
ON b.manager_id = e2.emp_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:

CREATE TABLE books_price_greater_than_seven
AS    
SELECT * FROM Books
WHERE rental_price > 7

SELECT * FROM 
books_price_greater_than_seven

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT 
    DISTINCT ist.issued_book_name
FROM issued_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL

/*
Task 13: 
Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/

-- issued_status == members == books == return_status
-- filter books which is return
-- overdue > 30 

SELECT m.member_id, m.member_name, b.book_title, isd.issued_date, rs.return_date
FROM issued_status AS isd
join members AS m
ON  isd.issued_member_id = m.member_id
JOIN books AS bk
ON isd.issued_member_id = bk.isbn
JOIN books AS b
ON isd.issued_member_id = b.isbn
LEFT JOIN 
return_status as rs
ON rs.issued_id = isd.issued_id
WHERE 
    rs.return_date IS NULL
    AND
    (CURRENT_DATE - isd.issued_date) > 30
ORDER BY 1;


/*    
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" 
when they are returned (based on entries in the return_status table).
*/

WHERE issued_book_isbn = '978-0-330-25864-8';
-- IS104

SELECT * FROM books
WHERE isbn = '978-0-451-52994-2';

UPDATE books
SET status = 'no'
WHERE isbn = '978-0-451-52994-2';

SELECT * FROM return_status
WHERE issued_id = 'IS130';

-- 
INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
VALUES
('RS125', 'IS130', CURRENT_DATE, 'Good');
SELECT * FROM return_status
WHERE issued_id = 'IS130';


-- Store Procedures
CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN
    -- all your logic and code
    -- inserting into returns based on users input
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES
    (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT 
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
    
END;
$$
    



-- Testing FUNCTION add_return_records

issued_id = IS135
ISBN = WHERE isbn = '978-0-307-58837-1'

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * FROM return_status
WHERE issued_id = 'IS135';

-- calling function 
CALL add_return_records('RS138', 'IS135', 'Good');



-- calling function 
CALL add_return_records('RS148', 'IS140', 'Good');

/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
*/

CREATE TABLE branch_reports
AS
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as number_book_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
FROM issued_status as ist
JOIN 
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
brnach as b
ON e.branch_id = b.branch_id
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
JOIN 
books as bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY 1, 2;

SELECT * FROM branch_reports;

-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (
	SELECT DISTINCT issued_member_id   
    FROM issued_status
    WHERE issued_date >= CURRENT_DATE - INTERVAL '2 month');
	
SELECT * FROM active_members;

-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

SELECT 
    e.emp_name,
    b.*,
    COUNT(ist.issued_id) as no_book_issued
FROM issued_status as ist
JOIN
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
brnach as b
ON e.branch_id = b.branch_id
GROUP BY 1, 2;


