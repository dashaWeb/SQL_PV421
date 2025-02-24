-- View (представлення) - це обєкт БД, який має зовнішній вигляд таблиці, але на відміну від неї не має своїх власних даних. Представлення лише надає доступ до даних однієї або декількох таблиць, на яких вона базаються

use UniversityPB_421
select * from Students
---- Create View
create view GoodStudents
as
	select Name, Surname, Email, AverageMark
	from Students
	where AverageMark >= 10

select *
from GoodStudents
where Name like '[A-D]%'
---- Alter View
alter view GoodStudents
as
	select Name, Surname, Email,Birthdate, AverageMark
	from Students
	where AverageMark >= 7


alter view GoodStudents(Fullname, Email,Mark)
as
	select Name + ' ' + Surname, Email, AverageMark
	from Students
	where AverageMark >= 10
select * from GoodStudents
where Email like '%.com' and Mark >= 11
--- для view можна вказати деякі параметри
		-- encryption - view буде зберігатися у зашифрованому вигляді
		-- schemabinding - забороняє видалення таблиць, представлень та функцій які використовують дане view
		-- view_metadata - вказує на те, що view в режимі перегладу буде повертати його метадані, тобто інформацію про його структуру, а не записи

create or alter view GoodStudentsWithParams(Fullname, EmailAddress, Mark)
with encryption
as
	select Name + ' ' + Surname, Email, AverageMark 
	from Students
	where AverageMark >= 10
	--order by AverageMark -- забороняється використовувати всередині view

	select * from GoodStudentsWithParams
	order by Mark -- дозволяється використовувати при роботі з view

create or alter view Top3GoodStudents
as
	select top 3 * from GoodStudentsWithParams
	order by Mark desc

select * from Top3GoodStudents
---- Drop view
drop view Top3GoodStudents


create or alter view StudentFullInfo(StudentName, Email, Mark, GroupName)
as
	select s.Name, s.Email, s.AverageMark, g.Name
	from Students as s join Groups as g on s.GroupId = g.Id

select * from StudentFullInfo
order by GroupName

select * from GoodStudents
order by Name

select* from Students

insert into GoodStudents
values ('Denis2','Bondar2','denis2@gmail.com', '2000/02/02',10.5)
-- T-SQL
----- Variables

declare @var int, @a char(5)
select @var = 5, @a = 'Hello'
print 'Value variable @var = ' + convert(char(10),@var)
print 'Value variable @a = ' + @a

declare @MyTable table(Id int not null, number int)
insert @MyTable
select top 5 Id, Lessons
from Students

select * from @MyTable

---- If
declare @a int;
set @a = -5
if @a > 0
	begin
		print 'Positive'
	end
else
	print 'Negative'

if(select Count(Id) from Students) > 50
	begin
		print ' > 50'
	end

if exists(select * from Students where Birthdate between '2005/01/01' and CURRENT_TIMESTAMP)
	begin
		print 'Info about Students'
		select * from Students where Birthdate between '2005/01/01' and CURRENT_TIMESTAMP
	end
if(DATENAME(dw,getdate()) = 'Monday')
	begin
		print 'Monday'
	end

select Name as 'Student Name', AverageMark, Marks = case
								when AverageMark < 7 then 'Bad'
								when AverageMark >= 7 then 'Good'
								end
from Students

select Name, 'Season' = case
				when MONTH(Birthdate) in (6,7,8) then 'Summer'
				when MONTH(Birthdate) in (12,1,2) then 'Winter'
				end
from Students
--=-=-=-=-=-=-=-=-=-=-- Stored Procedures


/*	create proc[edure] name
	@param1 type,
	@param2 type
	as
		code...
*/
create procedure greeting
@username nvarchar(50)
as
	print 'Hello, dear ' + @username


-- invoke procedure: exec[ute] name parameter1, parameter2
execute greeting 'Denis'

-- процедура видаляє студента по email
select* from Students
create proc del__student
@email nvarchar(50)
as
	delete from Students
	where Email = @email
-- invoke procedure
exec del__student 'amcphilip3@gnu.org'

-- процедура змінює оцінку для студента по email
create proc set__mark
@email nvarchar(50),
@new_mark real
as
	update Students
	set AverageMark = @new_mark
	where Email = @email
-- invoke procedure
exec set__mark 'sdwelley5@europa.eu', 11.9

-- процедура повертає середню оцінку студентів групи по імені
create proc get_student_avg_mark
@group_name nvarchar(50),
@avg_mark real output
as
	select @avg_mark = AVG(AverageMark)
		from Students as s join Groups as g on s.GroupId = g.Id
		where g.Name = @group_name
	set @avg_mark = ROUND(@avg_mark,1)

-- invoke procedure with OUTPUT parameters
select * from Groups
declare @result real;
exec get_student_avg_mark 'New-York', @result output
print @result

-- процедура повертає дату народження найстаршого та наймолодшого студента
create proc get__max__min_date
@max_date date output,
@min_date date output
as
	select @max_date = Max(Birthdate), @min_date = Min(Birthdate)
	from Students


-- invoke procedure
declare @date_max date, @date_min date
exec get__max__min_date @date_max output, @date_min output
select @date_max as 'The oldest Student Birthdate', @date_min as 'The Youngest Student'


----------------------------
-- процедура, яка повертає студентів які мають середній бал в переданому діапазоні
create proc sp_students_by_mark
@mark_from int,
@mark_to int = @mark_from
as
	select Name + ' ' + Surname as [Full Name], Email, AverageMark
	from Students
	where AverageMark between @mark_from and @mark_to
	order by AverageMark desc

exec sp_students_by_mark 7,8