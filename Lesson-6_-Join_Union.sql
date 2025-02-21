-- JOIN operator - використовується для отримання зв'язаних записів з різних таблиць
USE University;
GO

select s.Name, s.Email, s.GroupId, g.Name, g.Id, s.AverageMark
from Students as s, Groups as g
where g.Id = s.GroupId and AverageMark >= 10

select * from Groups
select * from Students

select g.Name as [Group], COUNT(s.Id)
from Groups as g JOIN Students as s ON s.GroupId = g.Id
group by g.Name

-- [INNER] JOIN - повертає всі записи таблиці A, які зв'язані з записами таблиці B
-- показати всіх студентів та їх групи
select s.Name, s.Email, s.AverageMark, g.Name as [Group]
from Students as s INNER JOIN Groups as g ON s.GroupId = g.Id

-- LEFT JOIN - повертає всі записи таблиці A, які зв'язані або не мають зв'язку з записами таблиці B
-- показати всіх студентів та їх групи, а також тих, які не мають групи
select s.Name, s.Email, s.AverageMark, g.Name as [Group]
from Students as s LEFT JOIN Groups as g ON s.GroupId = g.Id

-- показати всіх викладачів та к-сть їхніх груп, а також тих в кого немає жодної групи
select t.Name, COUNT(g.Id)
from Teachers as t LEFT JOIN TeachersGroups as tg ON tg.TeacherId = t.Id
				   LEFT JOIN Groups as g ON tg.GroupId = g.Id
group by t.Name, t.Id

-- LEFT JOIN with NULL FOREIGN KEY - повертає лише записи таблиці A, які не зв'язані з жодним записом таблиці B
-- показати лише студентів які не мають групи
select s.Name, s.Email, s.AverageMark, g.Name as [Group]
from Students as s LEFT JOIN Groups as g ON s.GroupId = g.Id
where s.GroupId IS NULL

-- RIGHT JOIN - повертає всі записи таблиці B, які зв'язані або не мають зв'язку з записами таблиці A
-- показати всіх студентів та їх групи, а також ті групи, які не мають жодного студента
insert into Groups
values ('Ukraine')

select s.Name, s.Email, s.AverageMark, g.Name as [Group]
from Students as s RIGHT JOIN Groups as g ON s.GroupId = g.Id

-- RIGHT JOIN with NULL FOREIGN KEY - повертає лише записи таблиці B, які не зв'язані з жодним записом таблиці A
-- показати лише ті групи, які не мають жодного студента
select s.Name, s.Email, s.AverageMark, g.Name as [Group]
from Students as s RIGHT JOIN Groups as g ON s.GroupId = g.Id
where s.GroupId IS NULL

-- FULL [OUTER] JOIN - повертає записи таблиці A та B, які зв'язані або не мають зв'язку між собою
-- показати всіх студентів, які мають групу або не мають її, а також групи, які не мають жодного студента
select s.Name, s.Email, s.AverageMark, g.Name as [Group]
from Students as s FULL OUTER JOIN Groups as g ON s.GroupId = g.Id

-- FULL [OUTER] JOIN with NULL FOREIGN KEY - повертає лише записи таблиці A та B, які не мають зв'язку між собою
-- показати лише студентів, які не мають групу, а також лише групи, які не мають жодного студента
select s.Name, s.Email, s.AverageMark, g.Name as [Group]
from Students as s FULL OUTER JOIN Groups as g ON s.GroupId = g.Id
where s.GroupId IS NULL




-- UNION - об'єднує декілька запитів в одну результуючу таблицю
--		   при цьому видаляючи дублікати

/*
select ...
UNION [ALL]
select ...
*/

select * from Students

-- показати кількість всіх студентів та їх середній бал
select 'Students Count', COUNT(Id)
from Students
union
select 'Average Mark', AVG(AverageMark)
from Students

-- показати імена студентів та викладачів
select  Name
from Students
union
select  Name
from Teachers

-- показати імена студентів та викладачів, які починаються на літеру 'V'
select Id, Name
from Students
where Name LIKE '[C]%'
--order by Name DESC -- помилка
UNION
select Id, Name
from Teachers
where Name LIKE '[C]%'
order by Name ASC -- сортування об'єднаних запитів дозволяється лише вкінці

-- UNION ALL - об'єднує декілька запитів в одну результуючу таблицю
--			   при цьому дублікати не видаляються
select Id, Name, AverageMark
from Students
where AverageMark >= 10
UNION all
select Id, Name, AverageMark
from Students
where AverageMark >= 7
order by Name
