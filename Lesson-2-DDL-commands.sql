-- one line comment
/* more line comment*/






/* DDL (DataDefinition Language)
		CREATE - створення об'єкта
		ALTER - зміна об'єкта
		DROP - видалення об'єкта
*/

create database Academy

use Academy

drop database Academy

-- ім'я_колонки тип_даних обмеження1 обмеження2 
/*
-- обмеження для колонок:
		-- NOT NULL / NULL - дозволяє/забороняє колонці мати значення NULL
		-- UNIQUE - гарантує, що в колонці не буде дублікатів
		-- PRIMARY KEY - первинний ключ, який включає обмеження NOT NULL та UNIQUE
		-- IDENTITY(seed, increment) - встановлює автоінкремент. seed: початкове значення, increment: значення приросту (за замовчуванням 1,1)
		-- DEFAULT(value) - встановлює значення за замовчуванням для колонки, коли значення не вказано
		-- CHECK(condition) - гарантує, що всі значення в колонці будуть відповідати логічній умові
		-- FOREIGN KEY column REFERENCES table(column) - встановлює зовнішній ключ для зв'язку з таблицею
		-- AS - значення в колонці будуть розраховуватися

*/
-- логічні оператори : > < >= <= = <>(!= C#) !< !>
-- логічне і  (&&)  : AND  
-- логічне або (||) : OR

create table Students
(
	Id int primary key identity(1,1),
	[Name] nvarchar(50) NOT NULL check([Name] <> ''),
	Surname nvarchar(50) not null check(Surname <> ''),
	Email varchar(30) not null unique,
	Birthdate date not null check(Birthdate < getdate()), -- getdate() - повертає поточну дату
	AverageMark real null check(AverageMark between 1 and 12), -- AverageMark >= 1 and AverageMark <= 12
	IsDebtor bit not null default(0),
	Lessons int not null default(0) check(Lessons >= 0),
	NonAttendances int not null default(0) check(NonAttendances >= 0),
	Visitings as Lessons - NonAttendances,
	check(NonAttendances <= Lessons)
)

alter table Students
	add NumberPhone char(15) not null default('---------')

alter table Students
	alter Column Name nvarchar(100)

drop table Students

select * from Students

insert into Students 
values
	('Semen','Melnik','semen@gmail.com','2000/4/10',8,default,200,15)



insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Alix', 'Hinstridge', 'ahinstridge0@shinystat.com', '2006/06/29', 2.7, 1, 243, 105);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Raimund', 'Scini', 'rscini1@xing.com', '2004/02/29', 1.8, 1, 295, 81);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Durant', 'McPhaden', 'dmcphaden2@linkedin.com', '2022/01/24', 7.3, 0, 216, 133);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Dilan', 'Cowen', 'dcowen3@businesswire.com', '2001/06/05', 10.4, 1, 237, 3);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Tami', 'Huzzey', 'thuzzey4@howstuffworks.com', '2002/12/10', 6.6, 0, 211, 28);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Brendin', 'Barrs', 'bbarrs5@businessweek.com', '2009/07/13', 10.5, 1, 227, 31);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Daisy', 'Spaducci', 'dspaducci6@columbia.edu', '2020/12/08', 9.0, 0, 255, 58);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Erl', 'Baytrop', 'ebaytrop7@linkedin.com', '2011/12/26', 1.3, 0, 240, 48);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Cary', 'Quartermaine', 'cquartermaine8@nbcnews.com', '2004/07/06', 1.8, 0, 267, 179);
insert into Students (Name, Surname, Email, Birthdate, AverageMark, IsDebtor, Lessons, NonAttendances) values ('Alfredo', 'Rizzone', 'arizzone9@youtube.com', '2002/03/04', 3.7, 0, 293, 152);