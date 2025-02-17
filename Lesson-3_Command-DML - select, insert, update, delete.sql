use Academy

select * from Students

/* DML (Data Manipulation Language — мова управління даними)
   До цієї категорії входять наступні SQL команди:
		SELECT - отримання певної інформації з таблиці
		INSERT - вставка певних даних в таблицю
		UPDATE - оновлення певних даних
		DELETE - видалення певних даних
*/

/********** Загальний шаблон запиту
	SELECT що саме
	FROM звідки
	додаткові параметри запиту (фільтрація, сортування...)

	SELECT колонка1, колонка2
	FROM таблиця1
	WHERE умова фільтрації
	ORDER BY ключ сортування
*/
-- * - визначає всі колонки таблиці
select *
from Students
-- AS - псевдонім для колонки, таблиці і тд.
select [Name] + ' ' + Surname as 'Full Name', AverageMark * 100 as 'Mark'
from Students

-- CAST, CONVERT - функції перетворення типів
select 'Student ' + Surname + ' has ' + CAST(AverageMark as nvarchar) as 'Student Mark'
from Students

select 'Student ' + Surname + ' has ' + Convert(nvarchar,AverageMark) as 'Student Mark'
from Students

/******** TOP (count) - читає певну кількість елементів **********/
select top 10 *
from Students

/******** PERCENT (count) - читає певну відносну кількість елементів **********/
select top 50 PERCENT *
from Students

-- DISTINCT - фільтрує дублікати по всім полям
select distinct IsDebtor
from Students

create table Groups
(
	Id int primary key identity(1,1),
	Name nvarchar(10) unique not null,
)
insert into Groups
values
	('PD421'),
	('PV421'),
	('PD321'),
	('PV321')

select * from Groups
-- Вибірка записів з декількох таблиць
select Surname, s.Name, g.Name
from Students as s, Groups as g
/* Logical operators: 
		> <		більше / менше
		>= <=	більше рівне / менше рівне
		<> =	рівне / не рівне
		!> !<	не більше / не менше


	logical and(&&): AND
	logical or(||):  OR
*/

/********** WHERE - фільтрує елементи по певній умові **********/
select * 
	from Students
	where IsDebtor = 1

select * 
	from Students
	where AverageMark >= 10
/********** Функції для отримання значення дати
	DAY(date) - повертає день з дати
	MONTH(date) - повертає день з дати
	YEAR(date) - повертає день з дати 
*/

select *
from Students
where MONTH(Birthdate) >= 6 and MONTH(Birthdate) <= 8

/******** [value] BETWEEN [from] AND [to] - перевірка входження значення [value] в діапазон з [from] до [to] **********/
select *
from Students
where MONTH(Birthdate) between 6 and 8
/******** [value] IN (value1, value2...) - перевіряє на рівність значення [value] з одним в дужках **********/
select *
from Students
where MONTH(Birthdate) = 1 or MONTH(Birthdate) = 2 or MONTH(Birthdate) = 12

select *
from Students
where MONTH(Birthdate) in (1,2,12)
/******** [value] LIKE 'pattern' - перевіряє значення [value] на відповідність шаблону
	%	- будь-яка кількість символів
	_	- будь-який один символ
	[]	- будь-який символ, який наявний в дужках
	[^]	- будь-який символ, який НЕ наявний в дужках
*/

select *
from Students
where Name like 'A%'


select *
from Students
where Name like 'a%o'

select *
from Students
where Email like '%@gmail.com'

select *
from Students
where Name like '%a_'

select *
from Students
where Name like '[aoiuye]%'

select *
from Students
where Name like '[aoiuye]%[^aoiuye]'
-- з врахуванням регістру COLLATE Latin1_General_BIN 
select *
from Students
where Name COLLATE Latin1_General_BIN like '[A-D]%'

/******** ORDER BY [key] ASC | DESC - сортування записів по ключу [key] за зростанням ASC (за замовчуванням) або спаданням DESC **********/
select *
from Students
where Name COLLATE Latin1_General_BIN like '[A-D]%'
order by Name DESC, Surname ASC

select *
from Students
where Name COLLATE Latin1_General_BIN like '[A-D]%'
order by IsDebtor ASC, AverageMark
/* UPDATE - оновлення існуючих даних в таблиці
----------------------------------------------
UPDATE tableName
	SET columnName1 = value1,
		columnName2 += value2
		...
	WHERE condition;
*/
update Students
set
	AverageMark += 1,
	Name = 'Stepan'
where Name = 'Semen'

/* DELETE - видалення даних з таблиці
-------------------------------------
DELETE FROM tableName
WHERE condition;
*/
delete from Students
where IsDebtor = 1

delete from Students
where IsDebtor is not null
where IsDebtor is null
