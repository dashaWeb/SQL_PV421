/*
Triggers types::
	Command : DDL(create, drop, alter), DML(insert, update, delete);
	Invokation time: after, insetead
*/

use UniversityPB_421
select * from Students

------- After ---------
create or alter trigger tg_notify_remove_st
on Students
after delete
as
	print 'Student was deleted'
--invoke trigger
delete from Students
where Id in (1,11)

-- [inserted]
-- [deleted]

create table Archive
(
	Id int identity primary key,
	Message nvarchar(100) not null,
	Date datetime default(getdate()) not null
)
select * from Archive

create or alter trigger tg_new_st_record
on Students
after insert
as
	insert into Archive(Message)
		select 'Student ' + Name + ' ' + Surname + ' was registered'
		from inserted

-- invoke
insert into Students(Name,Surname,Email,Birthdate,AverageMark)
values 
	('Maria','Marinchuk','maria@gmail.com','2000/2/2',10)
select * from Students
select * from Archive

create or alter trigger tg_archive_delete_st
on Students
after delete
as
	insert into Archive(Message)
		select 'Student ' + Name + ' ' + Surname + ' was deleted'
		from deleted

-- invoke
delete from Students
where Id in (2,3)


create or alter trigger tg_archive_update_st
on Students
after update
as
	insert into Archive(Message)
		select 'Student ' + i.Name + ' changed avg mark from ' + cast(d.AverageMark as varchar) + ' to ' + cast(i.AverageMark as varchar)
		from deleted as d join inserted as i on d.Id = i.Id

-- 
update Students
set AverageMark -=1.8
where Id in (5,6)

create or alter trigger tg_deny_young_st
on Students
after insert
as
	if exists(
			select Id
			from inserted 
			where DATEDIFF(YEAR, Birthdate, GETDATE()) < 7)
		begin
			raiserror('Deny insert young student',12,1)
			rollback transaction
		end
insert into Students(Name,Surname,Email,Birthdate,AverageMark)
values 
	('Pavlo','Pavlin','pavlo@gmail.com','2015/2/2',7)

-------
create or alter trigger tg_deny_overflow_group
on Students
after insert
as
	if exists(select Id
				from inserted
				where(select Count(s.Id)
						from Students as s
						where s.GroupId = inserted.GroupId) > 10)
		begin
			raiserror('Deny overflow group',12,1)
			rollback
		end

select g.Id, g.Name, COUNT(s.Id)
from Students as s join Groups as g on s.GroupId = g.Id
group by g.Name, g.Id
-- invoke
insert into Students(Name,Surname,Email,Birthdate,AverageMark,GroupId)
values 
	('Valeria','Valent','valeria@gmail.com','2015/2/2',6,2),
	('Ivan','Ivanov','ivan@gmail.com','2015/2/2',6,1)
	
select* from Students

---------------
create or alter trigger tg_deny_modify_st
on Students
after delete, update
as
	raiserror('Cannot modify or delete student',15,1)
	rollback

update Students
set AverageMark = 12
where Id = 5

delete from Students
where Id = 6

-- disable/enable trigger
disable trigger tg_deny_modify_st on Students
enable trigger tg_deny_modify_st on Students

---- insetead

create or alter trigger tg_deny_old_st
on Students
instead of insert
as
	insert into Students
	select Name,Surname, Email, Birthdate, AverageMark, Lessons, NonAttendances, GroupId
	from inserted
	where DATEDIFF(year, Birthdate, getdate()) < 55
	--------------------------
	insert into Archive(Message)
	select 'Student ' + Name + ' was ignore. Age must be < 55 '
	from inserted
	where DATEDIFF(year, Birthdate, getdate()) >= 55

insert into Students(Name,Surname,Email,Birthdate,AverageMark)
values 
	('Misha','Mishkiv','miha@gmail.com','1955/2/2',6),
	('Ivanka','Ivanova','ivanka@gmail.com','2015/2/2',6)


-------------------------------------------------------------
/* User-Defined Functions
	Returned value:
		scalar-valued function	- повертає скалярне значення (1, 4.7, 'Hello')
		table-valued function	- результатом такої функції є таблиця
			inline table-valued function		 - повертає таблицю за допомогою одного SELECT запиту
			multistatement table-valued function - повертає таблицю, яка містить нові імена та типи колонок
*/

USE University;
GO
---------- Scalar Functions
-- функція завжди повинна повертати якесь значення

-- function that return current month
create function GetCurrentMonth ()
returns int
as
begin
	declare @date date = GETDATE();
	return MONTH(@date);
end;

-- invoke
select dbo.GetCurrentMonth() as 'Current month'
print dbo.GetCurrentMonth()

select *
from Students
where MONTH(BirthDate) = dbo.GetCurrentMonth()

-- returns pow of number
create or alter function Pow (@number bigint, @step int)
returns bigint
as
begin
	declare @i int = 0;
	declare @result bigint = 1;

	while (@i < @step)
	begin
		set @result *= @number;
		set @i += 1;
	end;

	return @result;
end;

-- invoke
print 'Result: ' + cast(dbo.Pow(2, 10) as varchar);

-- summa of two numbers
create or alter function GetSumma(@n1 int, @n2 int = 0)
returns int
as
begin
	declare @res int = @n1 + @n2
	return @res; 
end;

select [dbo].GetSumma(3, default) as 'Result'



-- get students by group name
create function GetStudetns (@group_name nvarchar(50))
returns table
--WITH ENCRYPTION
as
return (
	select s.Id, s.Name, s.Surname, s.Email, s.AverageMark
	from Students as s JOIN Groups as g ON s.GroupId = g.Id
	where g.Name = @group_name
);

-- invoke
select * 
from GetStudetns('New-York')
where Name LIKE '[A-D]%'


-- return students or teachers
create function GetStudentsOrTeachers(@is_teach bit)
returns @elements table 
(
	Id int,
	Name nvarchar(50) NOT NULL
)
as
begin
	if (@is_teach = 1)
		insert into @elements 
			select Id, Name from Teachers
	else
		insert into @elements
			select Id, Name from Students

	return; -- повертає результуючу таблицю
end;

-- invoke
select * from GetStudentsOrTeachers(0)

-- return even numbers from '@from' to '@to'
create or alter function GetEvenNumbers (@from int, @to int)
returns @result table (number int)
as 
begin
	declare @i int = @from
	while (@i <= @to)
	begin
		if (@i % 2 = 0)
			insert into @result
			values (@i);

		set @i += 1;
	end;

	return;
end;

-- invoke
select * from GetEvenNumbers(1, 20)



