/* Типи зв'язків:
	- One to One (Один до Одного)
	- One to Many (Один до Багатьох)
	- Many to Many (Багато до Багатьох)
*/

create database UniversityPB_421
use UniversityPB_421


---------------- Groups -----------------
create table Groups
(
	Id int primary key identity(1,1),
	Name nvarchar(50) not null check(Name <> '') unique
)

insert Groups
values	('Dublin'),
		('Delaware'),
		('New-York'),
		('Masachusets')


---------------- Students -----------------
	-- FOREIGN KEY (column) REFERENCES table(column) - встановлює зовнішній ключ для зв'язку з таблицею
create table Students
(
	Id int primary key identity(1,1),
	[Name] nvarchar(50) NOT NULL check([Name] <> ''),
	Surname nvarchar(50) not null check(Surname <> ''),
	Email varchar(30) not null unique,
	Birthdate date not null check(Birthdate < getdate()), -- getdate() - повертає поточну дату
	AverageMark real null check(AverageMark between 1 and 12) default(1), -- AverageMark >= 1 and AverageMark <= 12
	Lessons int not null default(0) check(Lessons >= 0),
	NonAttendances int not null default(0) check(NonAttendances >= 0),
	Visitings as Lessons - NonAttendances,
	GroupId int null references Groups(Id),
	check(NonAttendances <= Lessons)
	/*GroupId int,
	foreign key(GroupId) references Groups(Id),*/
)
select * from Groups

-- при встановленні зв'язку на запис таблиці він повинен існувати, інакше не дозволить

select * from Students

---------------- Teachers -----------------
create table Teachers
(
	Id int primary key identity(1,1),
	Name nvarchar(50) not null,
	HireDate date default(getdate()),
	Phone char(20) null
)
select* from Teachers
-- проміжна таблиця для реалізації зв'язку Many to Many
create table TeachersGroups
(
	TeacherId int references Teachers(Id),
	GroupId int references Groups(Id),
	primary key(TeacherId,GroupId)
)


-- встановлюємо зв'язки між Teachers та Groups
insert into TeachersGroups
values
	(1,1),
	(1,2),
	(2,3),
	(3,3)

-- Multi-table queries (Багатотабличні запити)
-- використовючи фільтрацію WHERE 
select * from TeachersGroups
-- отримуємо певних студентів разом з інформацією про його групу
select s.Name, s.AverageMark, s.GroupId, g.Id, g.Name
from Students as s, Groups as g
where s.GroupId = g.Id
order by g.Id
-- отримуємо ТОП-3 студентів певної групи з найкращою успішністю
select top 3 s.Name, s.AverageMark, s.GroupId, g.Id, g.Name
from Students as s, Groups as g
where s.GroupId = g.Id and g.Name = 'Dublin'
order by s.AverageMark desc

-- отримуємо всіх викладачів та групи в яких вони викладають
select t.Name, t.Phone,g.Name
from Teachers as t, TeachersGroups as tg, Groups as g
where tg.TeacherId = t.Id and tg.GroupId = g.Id and t.Name = 'Gwen Grewes'

-- ті ж самі запити, але використовуючи JOIN

-- JOIN оператор використовуєтся саме для зв'язування записів по зовнішньому ключу
-- FROM table_A JOIN table_B ON table_A.foreignKey = tableB.primaryKey

-- отримуємо певних студентів разом з інформацією про його групу
select s.Name, s.AverageMark, s.GroupId, g.Id, g.Name
from Students as s join Groups as g on s.GroupId = g.Id
where g.Name = 'New-York'
-- отримуємо ТОП-3 студентів певної групи з найкращою успішністю
select top 3 s.Name, s.AverageMark, s.GroupId, g.Id, g.Name
from Students as s join Groups as g on s.GroupId = g.Id
where g.Name = 'New-York' and s.AverageMark >= 7
order by s.AverageMark desc

-- отримуємо всіх викладачів та групи в яких вони викладають
select t.Name, t.Phone,g.Name
from Teachers as t 
			join TeachersGroups as tg on t.Id = tg.TeacherId
			join Groups as g on tg.GroupId = g.Id			
-- отримуємо всіх викладачів певного студента
select t.Name, t.Phone, g.Name
from Students as s 
			join Groups as g on s.GroupId = g.Id
			join TeachersGroups as tg on tg.GroupId = g.Id
			join Teachers as t on tg.TeacherId = t.Id
where s.Name = 'Celisse'

select s.Name, g.Name
from Students as s left join Groups as g on s.GroupId = g.Id

select s.Name, g.Name
from Students as s left join Groups as g on s.GroupId = g.Id
where s.GroupId is null