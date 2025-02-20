-- Aggregate Functions
/*
	COUNT() - обчислює кількість записів (працює з символьними та числовими типами)
	SUM()	- обчислює суму всіх значень (працює з числовими типами)
	AVG()	- обчислює середнє значення по всіх записах (працює з числовими типами)
	MIN()	- обчислює мінімальне значення (працює з символьними та числовими типами)
	MAX()	- обчислює максимальне значення (працює з символьними та числовими типами)
*/
select * from Groups
select * from Students
select* from Teachers
select * from TeachersGroups
-- COUNT
select COUNT(Id) as 'Student Count'
from Students

-- при роботі з конкретною колонкою, NULL-значення ігноруються
select COUNT(GroupId) as 'Student Count'
from Students

select Count(Id) as 'Good students'
from Students
where AverageMark >= 10

-- MIN/MAX
select Max(AverageMark) as 'Result'
from Students
where YEAR(Birthdate) <= 2005

select Min(Name) as 'Result'
from Students
-- ROUND() - rounds a number to a specified number of decimal places.
-- FLOOR() - returns the largest integer value that is smaller than or equal to a number.
-- CEILING() - returns the smallest integer value that is larger than or equal to a number.

-- SUM/AVG
select ROUND(AVG(AverageMark),2) as 'Result'
from Students
where YEAR(Birthdate) >= 2002


select COUNT(s.Id) as 'Count of Students', FLOOR(Avg(s.AverageMark)) as 'Average Mark'
from Students as s join Groups as g on s.GroupId = g.Id
where g.Name = 'Delaware'

select Sum(AverageMark) as 'Sum'
from Students

select g.Name, Count(s.Id) as 'Number of students'
from Students as s join Groups as g on s.GroupId = g.Id
group by g.Name

select AverageMark, COUNT(Id), Max(NonAttendances)
from Students
group by AverageMark

select GroupId, COUNT(Id)
from Students
group by GroupId


select AverageMark, Count(Id)
from Students
where year(Birthdate) >= 2003
group by AverageMark

select g.Name, Avg(AverageMark) as AverageMarkGroup
from Students as s join Groups as g on s.GroupId = g.Id
group by g.Name
order by Avg(AverageMark)

select g.Name, Avg(AverageMark) as AverageMarkGroup
from Students as s join Groups as g on s.GroupId = g.Id
group by g.Name
order by AverageMarkGroup

select top 1 g.Name, COUNT(s.Id)
from Students as s join Groups as g on s.GroupId = g.Id
group by g.Name
order by COUNT(s.Id) desc

select g.Name, COUNT(s.Id)
from Students as s join Groups as g on s.GroupId = g.Id
group by g.Name
having COUNT(s.Id) > 10

select g.Name, 
		AVG(s.AverageMark) as 'Group Average Mark',
		Sum(s.AverageMark) as 'Group total Mark',
		Count(s.Id) as 'Count Students'
from Students as s join Groups as g on s.GroupId = g.Id
group by g.Name
having AVG(s.AverageMark) >= 9
order by Sum(s.AverageMark) desc