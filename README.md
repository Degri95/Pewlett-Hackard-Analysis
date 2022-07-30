# Pewlett-Hackard-Analysis
## Overview
The purpose of this project is to perform a database analysis on Pewlett Hackard. Data was gathered to assist the company with the upcoming ["silver tsunami"](https://amesite.com/blogs/how-will-the-silver-tsunami-affect-industry/), leaving many positions at the company open. I'll determine the number of employees retiring by title, and identify employees who are eligible to participate in the mentorship program.

PostgreSQL and pgAdmin were tools used in our analysis.

## Results

### ERD (Entity Relationship Diagram)
Before the analysis an ERD was constructed to help conceptually design the database we would be working with. Orignally Pewlett Hackard was using CSV files to store all of there data with no [DBMS](https://www.appdynamics.com/topics/database-management-systems#:~:text=Optimizing%20database%20performance-,What%20is%20DBMS%3F,delete%20data%20in%20the%20database.). I used [quickdatabasediagrams](https://www.quickdatabasediagrams.com/) to assemble my ERD.

![Database ERD](/Resources/EmployeeDB.png)

### Schema
After our ERD was created I was able to start assembling a schema. I created tables following along with my ERD and set up the primary and foregin keys to connect the tables.

![Image of schema code](/Resources/Schema.PNG)

After the tables were created I imported the original CSV files into the corresponding tables.

![Image of importing tables](/Resources/Importing.PNG)

### Analysis Results
#### Deliverable 1
Our first deliverable is to retrieve the number of employees retiring by title. The following SQL query was used to select our retring employees (Born between 01-01-1952 and 12-31-1955) and their titles. 

```
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
```
Then the data was filtered to employees in the table that are currently employed with their most recent title.

```
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no ASC, to_date DESC
```

Now we had has a table with an accurate count of employees retiring in the next few years with their current title.

![unique title table](/Resources/unique_titles.PNG)

The count of each title was needed. So the group by function was used to count each title in the new table

```
-- Getting the number of employees by most recent job who are about to retire
SELECT COUNT(title) as "count",
title
INTO retiring_titles
FROM
unique_titles
GROUP BY title
ORDER BY count DESC;
```
Now the count of each title was stored into a new table.

![retiring titles table](/Resources/retiring_titles.PNG)

#### Deliverable 2
The second deliverable is to create a mentorship-eligibility table that holds the current employees who were born beween 01-01-1965 and 12-31-1965 with their most recent title. A query was created to build the table.

```
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
```
![mentor eligibility table](/Resources/mentor_eligibility.PNG)

#### Major Points
- The retiring titles table shows out of a total of 72,458 employees retiring, 50,842 (70.2%) were in a senior role . 36,291 out of the 72,458 had an engineer role (50.1%). 

![retiring titles table](/Resources/retiring_titles.PNG)

- our mentor eligibility table had a count of 1,549. This number is only 2.14% of the employees retiring.

![eligibility count table](/Resources/eligibility_count.PNG)

- out of the 1,549 employees eligible for the mentorship program, 724 (46.7%) are in a senior role. 748 (48.3%) out of the 1,549 employees have an engineering role.

- The ratio of eligible mentors to mentee ratio to would be about 1:47.

## Summary
### How many roles will need to be filled as the "silver tsunami" begins to make an impact?
A total number of 72,458 roles will need to be filled as the silver tsunami begins to hit. 
This number was able to be queried by counting the unique titles table, since it has already been filtered by birth date and if the employee is currently employed.

![retiring count](/Resources/retiring_count.png)

### Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?