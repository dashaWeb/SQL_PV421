use UniversityPB_421

-----------------------------
-- Inner Queries (Subqueries)

select * from Students;
select * from Groups;

-- запит, який повертає максимальну оцінку по всіх студентах
select Max(AverageMark)
from Students

-- отримуємо всіх студентів, які мають максимальну оцінку
select *
from Students
where AverageMark = (
			select Max(AverageMark)
			from Students
)
-- отримуємо всі групи, які мають максимальну кі-сть студентів

select g.Name, AVG(s.AverageMark), COUNT(s.Id)
from Students as s join Groups as g on s.GroupId=g.Id
group by g.Name
having COUNT(s.Id) = (
			select top 1 COUNT(s.Id)
			from Students as s join Groups as g on g.Id = s.GroupId
			group by g.Name
			order by COUNT(s.Id) desc
			)

-- отримуємо всі групи, які мають максимальну або мінімальну кі-сть студентів
select g.Name, AVG(s.AverageMark), COUNT(s.Id)
from Students as s join Groups as g on s.GroupId=g.Id
group by g.Name
having COUNT(s.Id) = (
			select top 1 COUNT(s.Id)
			from Students as s join Groups as g on g.Id = s.GroupId
			group by g.Name
			order by COUNT(s.Id) desc
			)
		or
			COUNT(s.Id) = (
			select top 1 COUNT(s.Id)
			from Students as s join Groups as g on g.Id = s.GroupId
			group by g.Name
			order by COUNT(s.Id) 
			)

-- якщо запит повертає декілька значень, для перевірки можна використати оператор IN
--in (1,2,3)
select Id, Name, Birthdate
from Students
where Id in (select Id
	from Students
	where Name like 'C%')

-- показати всіх викладачів, в яких більша половина студентів мають відмінні оцінки

select t2.Id, t2.Name as [Teacher], Avg(s2.AverageMark) as [Mark], Count(s2.Id) as [Students] 
from Teachers as t2 join TeachersGroups as tg2 on t2.Id = tg2.TeacherId
					join Groups as g2 on g2.Id = tg2.GroupId
					join Students as s2 on s2.GroupId = g2.Id 
group by t2.Name, t2.Id
having COUNT(s2.Id) / 2 < (
					select Count(s.Id)
						from Students as s join Groups as g on s.GroupId = g.Id
						join TeachersGroups as tg on g.Id = tg.GroupId
						join Teachers as t on tg.TeacherId = t.Id
						where s.AverageMark >= 7 and t.Id = t2.Id
)




/* Subquery Operators
	- [NOT] EXISTS				  - повертає TRUE якщо запит повернув хоча б один запис
	- [> < >= <= <> =] ANY / SOME - повертає TRUE якщо хоча б одни запис відповідає умові
	- [> < >= <= <> =] ALL		  - повертає TRUE якщо всі записи відповідають умові
*/



/*
...
where/having [NOT] EXISTS (query)
...
*/
select* from Teachers
select * from TeachersGroups
-- показати викладічів, які мають хоча б одну групу
select Id,Name, Phone
from Teachers as t
where EXISTS ( select * from TeachersGroups as tg 
					where tg.TeacherId = t.Id)

-- показати групи, які мають хоча б одного студента з оцінкою 12
select Name
from Groups
where EXISTS (select Id from Students where AverageMark = 11.2 and GroupId = Groups.Id)

select Name from Students where AverageMark = 11.2

-- показати викладачів, які мають хоча б одного студента з іменем 'Sophi'
select Name, Phone
from Teachers
where Exists (
				select s.Id
				from Students as s join Groups as g on g.Id = s.GroupId
				join TeachersGroups as tg on g.Id = tg.GroupId
				where tg.TeacherId = Teachers.Id and s.Name = 'Sophi')
select *
from Students
where Name = 'Sophi'
-- показати групи в яких є хоча б один студент старше 20-ти
select Name
from Groups as g
where EXISTS (select Id
			  from Students as s
			  where DATEDIFF(YEAR, s.BirthDate, GETDATE()) >= 20 AND s.GroupId = g.Id);

/*
...
where/having [> < >= <= <> =] ANY/SOME / ALL (query)
...
*/
-- показати студентів, в яких ім'я співпадає з іменем якогось викладача
select * from Teachers
insert into Teachers
values ('Sophi','2000/02/02','+3805236589')

select Name, Birthdate, Email
from Students
where Name = Some(select Name from Teachers)
-- показати студентів, в яких дата народження більша за дату прийняття на роботу будь-якого викладача
select Name, Birthdate, Email
from Students
where Birthdate > Any(select HireDate from Teachers)

-- показати студентів з ім'ям яке має хоча б одни студент іншої групи
select * from Students
insert into Students
values ('Sophi', 'Tarasenko', 'sophi@gmail.com','2005/03/03',default, 200, default, 1)

select Name, Birthdate, Email
from Students
where Name = Any(select Name from Students as s where s.GroupId <> Students.GroupId)

-- показати студентів в яких оцінка більша за оцінки всіх студентів групи 'New-York'
select s.Name, s.Email, s.AverageMark, g.Name
from Students as s join Groups as g on s.GroupId = g.Id
where AverageMark > ALL (select AverageMark 
							from Students as s2 join Groups as g2 on s2.GroupId = g2.Id
							where g2.Name ='New-York')

-- показати викладачів які були прийняті на роботу раніше дати народження всіх їхніх студентів
select Name, Phone, Hiredate
from Teachers
where HireDate < ALL(
						select s.Birthdate
						from Students as s join Groups as g on s.GroupId = g.Id
											join TeachersGroups as tg on tg.GroupId = g.Id
						where tg.TeacherId = Teachers.Id)


