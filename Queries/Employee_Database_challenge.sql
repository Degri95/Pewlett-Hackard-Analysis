-- Deliverable 1
SELECT
e.emp_no,
e.first_name,
e.last_name,
t.title,
t.from_date,
t.to_date
INTO
retirement_titles
FROM
employees AS e
JOIN
titles AS t
ON (e.emp_no = t.emp_no)
WHERE
(e.birth_date BETWEEN '01-01-1952' AND '12-31-1955')
ORDER BY emp_no;

-- SELECT * 
-- FROM retirement_titles

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no ASC, to_date DESC

-- SELECT *
-- FROM unique_titles

-- Getting the number of employees by most recent job who are about to retire
SELECT COUNT(title) as "count",
title
INTO retiring_titles
FROM
unique_titles
GROUP BY title
ORDER BY count DESC;

-- SELECT *
-- FROM retiring_titles

-- Deliverable 2

SELECT DISTINCT ON (e.emp_no) e.emp_no, 
e.first_name,
e.last_name,
e.birth_date,
de.from_date,
de.to_date,
t.title
INTO mentor_eligibility
FROM employees AS e
JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE
de.to_date = '9999-01-01' AND
(e.birth_date BETWEEN '01-01-1965' AND '12-31-1965')
ORDER BY e.emp_no