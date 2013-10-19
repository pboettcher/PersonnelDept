SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE POSTS(
	Post_ID        smallint IDENTITY(1,1) NOT NULL,
	Post           nvarchar(100) NULL,
	Related_Dpt_ID smallint NULL
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE ORGANIZATIONS(
	org_id   smallint NOT NULL,
	org_Name nchar(50) NULL
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE EXT(
	ID         int IDENTITY(1,1) NOT NULL,
	EXT        nchar(10) NULL,
	EMPLOYER   int NULL,
	DEPARTMENT smallint NULL,
 CONSTRAINT PK_EXT PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE Employees(
	ID                   decimal(18, 0) IDENTITY(1,1) NOT NULL,
	[1C-ID]              int NULL,
	LastName             nvarchar(50) NOT NULL,
	FirstName            nvarchar(50) NOT NULL,
	MiddleName           nvarchar(50) NOT NULL,
	EXT                  int NOT NULL,
	[Login]              nvarchar(50) NOT NULL,
	Email                nvarchar(50) NOT NULL,
	FemaleSex            bit NOT NULL,
	Fired                bit NOT NULL,
	CategoryID           smallint NOT NULL,
	StartDate            smalldatetime NOT NULL,
	EndDate              smalldatetime NULL,
	Organization         smallint NOT NULL,
	Department           smallint NOT NULL,
	PositionID           smallint NOT NULL,
	BirthDate            smalldatetime NOT NULL,
	RegistrationCity     nvarchar(50) NOT NULL,
	RegistrationAddress  nvarchar(100) NOT NULL,
	RegistrationArea     nvarchar(50) NOT NULL,
	RegistrationZipCode  nvarchar(50) NOT NULL,
	PhoneNumber          nvarchar(50) NOT NULL,
	PassportSerNum       nvarchar(50) NOT NULL,
	PassportNumber       nvarchar(50) NOT NULL,
	PassportGiven        nvarchar(100) NOT NULL,
	PassportGivenDate    smalldatetime NOT NULL,
	ForeignPassportExist tinyint NOT NULL,
	Married              bit NOT NULL,
	MarriedOn            nvarchar(100) NOT NULL,
	Children             nvarchar(100) NOT NULL,
	Photo                image NOT NULL,
	AwardsID             nvarchar(50) NOT NULL,
 CONSTRAINT PK_EMPLOYERS PRIMARY KEY NONCLUSTERED 
(
	ID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE CLUSTERED INDEX IX_EMPLOYERS ON Employees
(
	LastName ASC,
	FirstName ASC,
	MiddleName ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE EMP_CATEGORIES(
	ID       smallint IDENTITY(1,1) NOT NULL,
	CATEGORY varchar(50) NULL
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE DEPARTMENTS(
	dpt_id        smallint IDENTITY(1,1) NOT NULL,
	dpt_parent_id smallint NULL,
	dpt_name      nvarchar(80) NULL,
	dpt_boss      smallint NULL,
 CONSTRAINT [PK_DEPARTMENTS] PRIMARY KEY CLUSTERED 
(
	dpt_id ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE data(
	Col001 nvarchar(40) NULL,
	Col002 datetime NULL,
	Col003 datetime NULL
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE CO(
	ID         int NOT NULL,
	REALNUMBER char(9) NOT NULL,
	CO         char(3) NOT NULL
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE Awards(
	Award_ID smallint IDENTITY(1,1) NOT NULL,
	Award nvarchar(100) NULL
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE ATSLOGS(
	ID            decimal(18, 0) NOT NULL,
	CALL_DATE     datetime NULL,
	CALL_TIME     int NULL,
	EXT           char(3) NULL,
	CO            char(3) NULL,
	CALLED_NUMBER char(20) NULL,
	SOURCE_STRING char(100) NULL
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW view_Birthdays
AS
SELECT     TOP 100 PERCENT *
FROM         EMPLOYERS
WHERE     (DATEPART(dy, GETDATE()) - DATEPART(dy, BirthDate) < 1) AND (DATEPART(dy, GETDATE()) - DATEPART(dy, BirthDate) > - 16) OR
                      (DATEPART(dy, GETDATE()) - DATEPART(dy, BirthDate) > 351)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW view_Awards
AS
SELECT     *
FROM         EMPLOYERS
WHERE     (AwardsID <> '')
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW view_Anniversary
AS
SELECT     TOP 100 PERCENT *
FROM         EMPLOYERS
WHERE     ((DATEPART(year, GETDATE()) - DATEPART(year, BirthDate)) % 5 = 0)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE tabel(
	fio   nvarchar(200) NULL,
	nomer int NULL
) ON [PRIMARY]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE ShowDeptStructure
	@dpt_id smallint=0
AS
SET NOCOUNT ON
CREATE TABLE #DeptStructure (
	ord 		smallint IDENTITY(0,1) not null,
	dpt_id 		smallint not null,
	dpt_lvl 		tinyint not null default(0),
	dpt_name	nvarchar(80) null,
	dpt_boss	smallint null,
	boss_name	nvarchar(80) null)
declare @dpt_parent_id smallint
CREATE TABLE #TmpID (degree int IDENTITY(0,1) not null, [ID] int not null, [LEVEL] tinyint not null default 0)
	insert into #TmpID ([ID]) values (@dpt_id)
IF exists (
	select dpt_id
	from DEPARTMENTS 
	where dpt_parent_id=@dpt_id)
BEGIN
	DECLARE Tree_1_cursor CURSOR LOCAL DYNAMIC OPTIMISTIC FOR
		select dpt_id, dpt_parent_id 
		from DEPARTMENTS 
		where dpt_parent_id=@dpt_id 
		order by dpt_id
	OPEN Tree_1_cursor
	FETCH FROM Tree_1_cursor INTO @dpt_id, @dpt_parent_id
	WHILE @@FETCH_STATUS <> -1
	BEGIN
		insert into #TmpID ([ID],[LEVEL]) values (@dpt_id,1)
IF exists (
	select dpt_id
	from DEPARTMENTS 
	where dpt_parent_id=@dpt_id)
BEGIN
	DECLARE Tree_2_cursor CURSOR LOCAL DYNAMIC OPTIMISTIC FOR
		select dpt_id, dpt_parent_id 
		from DEPARTMENTS 
		where dpt_parent_id=@dpt_id 
		order by dpt_id
	OPEN Tree_2_cursor
	FETCH FROM Tree_2_cursor INTO @dpt_id, @dpt_parent_id
	WHILE @@FETCH_STATUS <> -1
	BEGIN
		insert into #TmpID ([ID],[LEVEL]) values (@dpt_id,2)
IF exists (
	select dpt_id
	from DEPARTMENTS 
	where dpt_parent_id=@dpt_id)
BEGIN
	DECLARE Tree_3_cursor CURSOR LOCAL DYNAMIC OPTIMISTIC FOR
		select dpt_id, dpt_parent_id 
		from DEPARTMENTS 
		where dpt_parent_id=@dpt_id 
		order by dpt_id
	OPEN Tree_3_cursor
	FETCH FROM Tree_3_cursor INTO @dpt_id, @dpt_parent_id
	WHILE @@FETCH_STATUS <> -1
	BEGIN
		insert into #TmpID ([ID],[LEVEL]) values (@dpt_id,3)
IF exists (
	select dpt_id
	from DEPARTMENTS 
	where dpt_parent_id=@dpt_id)
BEGIN
	DECLARE Tree_4_cursor CURSOR LOCAL DYNAMIC OPTIMISTIC FOR
		select dpt_id, dpt_parent_id 
		from DEPARTMENTS 
		where dpt_parent_id=@dpt_id 
		order by dpt_id
	OPEN Tree_4_cursor
	FETCH FROM Tree_4_cursor INTO @dpt_id, @dpt_parent_id
	WHILE @@FETCH_STATUS <> -1
	BEGIN
		insert into #TmpID ([ID],[LEVEL]) values (@dpt_id,4)
IF exists (
	select dpt_id
	from DEPARTMENTS 
	where dpt_parent_id=@dpt_id)
BEGIN
	DECLARE Tree_5_cursor CURSOR LOCAL DYNAMIC OPTIMISTIC FOR
		select dpt_id, dpt_parent_id 
		from DEPARTMENTS 
		where dpt_parent_id=@dpt_id 
		order by dpt_id
	OPEN Tree_5_cursor
	FETCH FROM Tree_5_cursor INTO @dpt_id, @dpt_parent_id
	WHILE @@FETCH_STATUS <> -1
	BEGIN
		insert into #TmpID ([ID],[LEVEL]) values (@dpt_id,5)
IF exists (
	select dpt_id
	from DEPARTMENTS 
	where dpt_parent_id=@dpt_id)
BEGIN
	DECLARE Tree_6_cursor CURSOR LOCAL DYNAMIC OPTIMISTIC FOR
		select dpt_id, dpt_parent_id 
		from DEPARTMENTS 
		where dpt_parent_id=@dpt_id 
		order by dpt_id
	OPEN Tree_6_cursor
	FETCH FROM Tree_6_cursor INTO @dpt_id, @dpt_parent_id
	WHILE @@FETCH_STATUS <> -1
	BEGIN
		insert into #TmpID ([ID],[LEVEL]) values (@dpt_id,6)
IF exists (
	select dpt_id
	from DEPARTMENTS 
	where dpt_parent_id=@dpt_id)
BEGIN
	DECLARE Tree_7_cursor CURSOR LOCAL DYNAMIC OPTIMISTIC FOR
		select dpt_id, dpt_parent_id 
		from DEPARTMENTS 
		where dpt_parent_id=@dpt_id 
		order by dpt_id
	OPEN Tree_7_cursor
	FETCH FROM Tree_7_cursor INTO @dpt_id, @dpt_parent_id
	WHILE @@FETCH_STATUS <> -1
	BEGIN
		insert into #TmpID ([ID],[LEVEL]) values (@dpt_id,7)
IF exists (
	select dpt_id
	from DEPARTMENTS 
	where dpt_parent_id=@dpt_id)
BEGIN
	DECLARE Tree_8_cursor CURSOR LOCAL DYNAMIC OPTIMISTIC FOR
		select dpt_id, dpt_parent_id 
		from DEPARTMENTS 
		where dpt_parent_id=@dpt_id 
		order by dpt_id
	OPEN Tree_8_cursor
	FETCH FROM Tree_8_cursor INTO @dpt_id, @dpt_parent_id
	WHILE @@FETCH_STATUS <> -1
	BEGIN
		insert into #TmpID ([ID],[LEVEL]) values (@dpt_id,8)
IF exists (
	select dpt_id
	from DEPARTMENTS 
	where dpt_parent_id=@dpt_id)
BEGIN
	DECLARE Tree_9_cursor CURSOR LOCAL DYNAMIC OPTIMISTIC FOR
		select dpt_id, dpt_parent_id 
		from DEPARTMENTS 
		where dpt_parent_id=@dpt_id 
		order by dpt_id
	OPEN Tree_9_cursor
	FETCH FROM Tree_9_cursor INTO @dpt_id, @dpt_parent_id
	WHILE @@FETCH_STATUS <> -1
	BEGIN
		insert into #TmpID ([ID],[LEVEL]) values (@dpt_id,9)
/*--this is the begin of the next level
IF exists (
	select dpt_id
	from DEPARTMENTS 
	where dpt_parent_id=@dpt_id)
BEGIN
	DECLARE Tree_5_cursor CURSOR LOCAL DYNAMIC OPTIMISTIC FOR
		select dpt_id, dpt_parent_id 
		from DEPARTMENTS 
		where dpt_parent_id=@dpt_id 
		order by dpt_id
	OPEN Tree_5_cursor
	FETCH FROM Tree_5_cursor INTO @dpt_id, @dpt_parent_id
	WHILE @@FETCH_STATUS <> -1
	BEGIN
		insert into #TmpID ([ID],[LEVEL]) values (@dpt_id,5)
--the break point (paste the next level here!)
		FETCH FROM Tree_5_cursor INTO @dpt_id, @dpt_parent_id
	END
	CLOSE Tree_5_cursor
	DEALLOCATE Tree_5_cursor
END
--this is the end of the next level */
		FETCH FROM Tree_9_cursor INTO @dpt_id, @dpt_parent_id
	END
	CLOSE Tree_9_cursor
	DEALLOCATE Tree_9_cursor
END
		FETCH FROM Tree_8_cursor INTO @dpt_id, @dpt_parent_id
	END
	CLOSE Tree_8_cursor
	DEALLOCATE Tree_8_cursor
END
		FETCH FROM Tree_7_cursor INTO @dpt_id, @dpt_parent_id
	END
	CLOSE Tree_7_cursor
	DEALLOCATE Tree_7_cursor
END
		FETCH FROM Tree_6_cursor INTO @dpt_id, @dpt_parent_id
	END
	CLOSE Tree_6_cursor
	DEALLOCATE Tree_6_cursor
END
		FETCH FROM Tree_5_cursor INTO @dpt_id, @dpt_parent_id
	END
	CLOSE Tree_5_cursor
	DEALLOCATE Tree_5_cursor
END
		FETCH FROM Tree_4_cursor INTO @dpt_id, @dpt_parent_id
	END
	CLOSE Tree_4_cursor
	DEALLOCATE Tree_4_cursor
END
		FETCH FROM Tree_3_cursor INTO @dpt_id, @dpt_parent_id
	END
	CLOSE Tree_3_cursor
	DEALLOCATE Tree_3_cursor
END
		FETCH FROM Tree_2_cursor INTO @dpt_id, @dpt_parent_id
	END
	CLOSE Tree_2_cursor
	DEALLOCATE Tree_2_cursor
END
		FETCH FROM Tree_1_cursor INTO @dpt_id, @dpt_parent_id
	END
	CLOSE Tree_1_cursor
	DEALLOCATE Tree_1_cursor
END
	insert into #DeptStructure (dpt_id, dpt_lvl, dpt_name, dpt_boss, boss_name) 
	select d.dpt_id, t.[level], d.dpt_name, d.dpt_boss, nam=u.LastName+' '+isnull(u.FirstName,'')+' '+isnull(u.MiddleName,'')
	from #TmpID t inner join DEPARTMENTS d on t.[id]=d.dpt_id left outer join EMPLOYERS u on d.dpt_boss=u.[id]
	order by t.degree
select ord, dpt_id, dpt_lvl, dpt_name, dpt_boss, boss_name 
from #DeptStructure 
order by ord
drop table #DeptStructure
drop table #TmpID
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE Request
@Fired bit,
@Women bit,
@Married bit,
@Children bit,
@FIO nvarchar(256)
AS
	SET NOCOUNT ON

	SELECT
		e.id,
		FIO=rtrim(e.LastName)+' '+rtrim(e.FirstName)+' '+rtrim(e.MiddleName),
		e.BirthDate,
		e.FemaleSex,
		c.Category,
		e.StartDate,
		e.EndDate,
		o.Org_Name,
		d.dpt_name,
		p.post
	FROM
		Employees e
		left join emp_categories c on c.id=e.CategoryID
		left join organizations o on o.org_id=e.Organization
		left join departments d on d.dpt_id=e.Department
		left join posts p on p.post_id=e.PositionID
	WHERE
		((@Fired is null) or (@Fired is not null and e.Fired=@Fired)) and
		((@Women is null) or (@Women is not null and e.FemaleSex=@Women)) and
		((@Married is null) or (@Married is not null and e.Married=@Married)) and
		((@Children is null) or (@Children=1 and e.Children not in('','нет')) or (@Children=0 and e.Children in('','нет'))) and
		((IsNull(@FIO, '')='') or (IsNull(@FIO, '')<>'' and (rtrim(e.LastName)+' '+rtrim(e.FirstName)+' '+rtrim(e.MiddleName)) like '%'+@FIO+'%'))
	ORDER BY
		e.LastName,
		e.FirstName,
		e.MiddleName
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE QueryNew2m
AS
	SET NOCOUNT ON

	SELECT
		e.ID,
		FIO=rtrim(e.LastName)+' '+rtrim(e.FirstName)+' '+rtrim(e.MiddleName),
		e.BirthDate,
		e.FemaleSex,
		c.Category,
		e.StartDate,
		e.EndDate,
		o.Org_Name,
		d.dpt_name,
		p.post,
		e.RegistrationCity,
		e.RegistrationAddress,
		e.RegistrationArea,
		e.RegistrationZipCode,
		e.PhoneNumber,
		e.Photo,
		1C-ID,
		x.Ext,
		e.Login,
		e.Email,
		e.Fired,
		e.PassportSerNum,
		e.PassportNumber,
		e.PassportGiven,
		e.PassportGivenDate,
		e.ForeignPassportExist,
		Mate=case when e.Married=0 then 'íåò' when e.Married=1 then e.MarriedOn else '' end,
		e.Children,
		e.AwardsID
	FROM
		Employees e
		left join emp_categories c on c.id=e.CategoryID
		left join organizations o on o.org_id=e.Organization
		left join departments d on d.dpt_id=e.Department
		left join posts p on p.post_id=e.PositionID
		left join ext x on x.id=e.Ext
	WHERE
		e.StartDate>dateadd(month,-2,getdate())
	ORDER BY
		e.LastName,e.FirstName,e.MiddleName
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Процедура показывает сотрудников, принятых на работу не ранее чем месяц назад
CREATE PROCEDURE QueryNew1m
AS
	SET NOCOUNT ON

	SELECT
		e.ID,
		FIO = rtrim(e.LastName)+' '+rtrim(e.FirstName)+' '+rtrim(e.MiddleName),
		e.BirthDate,
		e.FemaleSex,
		c.Category,
		e.StartDate,
		e.EndDate,
		o.Org_Name,
		d.dpt_name,
		p.post,
		e.RegistrationCity,
		e.RegistrationAddress,
		e.RegistrationArea,
		e.RegistrationZipCode,
		e.PhoneNumber,
		e.Photo,
		1C-ID,
		x.Ext,
		e.Login,
		e.Email,
		e.Fired,
		e.PassportSerNum,
		e.PassportNumber,
		e.PassportGiven,
		e.PassportGivenDate,
		e.ForeignPassportExist,
		Mate=case when e.Married=0 then 'íåò' when e.Married=1 then e.MarriedOn else '' end,
		e.Children,
		e.AwardsID
	from
		Employees e
		left join emp_categories c on c.id=e.CategoryID
		left join organizations o on o.org_id=e.Organization
		left join departments d on d.dpt_id=e.Department
		left join posts p on p.post_id=e.PositionID
		left join ext x on x.id=e.Ext
	where
		e.StartDate>dateadd(month,-1,getdate())
	order by
		e.LastName,
		e.FirstName,
		e.MiddleName
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE QueryFir2m
AS
	SET NOCOUNT ON

	SELECT
		e.ID,
		FIO=rtrim(e.LastName)+' '+rtrim(e.FirstName)+' '+rtrim(e.MiddleName),
		e.BirthDate,
		e.FemaleSex,
		c.Category,
		e.StartDate,
		e.EndDate,
		o.Org_Name,
		d.dpt_name,
		p.post,
		e.RegistrationCity,
		e.RegistrationAddress,
		e.RegistrationArea,
		e.RegistrationZipCode,
		e.PhoneNumber,
		e.Photo,
		1C-ID,
		x.Ext,
		e.Login,
		e.Email,
		e.Fired,
		e.PassportSerNum,
		e.PassportNumber,
		e.PassportGiven,
		e.PassportGivenDate,
		e.ForeignPassportExist,
		Mate=case when e.Married=0 then 'íåò' when e.Married=1 then e.MarriedOn else '' end,
		e.Children,
		e.AwardsID
	FROM
		Employees e
		left join emp_categories c on c.id=e.CategoryID
		left join organizations o on o.org_id=e.Organization
		left join departments d on d.dpt_id=e.Department
		left join posts p on p.post_id=e.PositionID
		left join ext x on x.id=e.Ext
	WHERE
		e.EndDate>dateadd(month,-2,getdate())
	ORDER BY
		e.LastName,
		e.FirstName,
		e.MiddleName
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE QueryFir1m
AS
	SET NOCOUNT ON

	SELECT
		e.ID,
		FIO=rtrim(e.LastName)+' '+rtrim(e.FirstName)+' '+rtrim(e.MiddleName),
		e.BirthDate,
		e.FemaleSex,
		c.Category,
		e.StartDate,
		e.EndDate,
		o.Org_Name,
		d.dpt_name,
		p.post,
		e.RegistrationCity,
		e.RegistrationAddress,
		e.RegistrationArea,
		e.RegistrationZipCode,
		e.PhoneNumber,
		e.Photo,
		1C-ID,
		x.Ext,
		e.Login,
		e.Email,
		e.Fired,
		e.PassportSerNum,
		e.PassportNumber,
		e.PassportGiven,
		e.PassportGivenDate,
		e.ForeignPassportExist,
		Mate=case when e.Married=0 then 'íåò' when e.Married=1 then e.MarriedOn else '' end,
		e.Children,
		e.AwardsID
	FROM
		Employees e
		left join emp_categories c on c.id=e.CategoryID
		left join organizations o on o.org_id=e.Organization
		left join departments d on d.dpt_id=e.Department
		left join posts p on p.post_id=e.PositionID
		left join ext x on x.id=e.Ext
	WHERE
		e.EndDate>dateadd(month,-1,getdate())
	ORDER BY
		e.LastName,
		e.FirstName,
		e.MiddleName
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE GetEmployee
@EmployeeID INT
AS
	SET NOCOUNT ON

	SELECT
		FIO=rtrim(e.LastName)+' '+rtrim(e.FirstName)+' '+rtrim(e.MiddleName),
		e.BirthDate,
		e.FemaleSex,
		Sex=CASE WHEN e.FemaleSex=1 THEN 'ж' ELSE 'м' END,
		c.Category,
		e.StartDate,
		e.EndDate,
		o.Org_Name,
		d.dpt_name,
		p.post,
		e.RegistrationCity,
		e.RegistrationAddress,
		e.RegistrationArea,
		e.RegistrationZipCode,
		e.PhoneNumber,
		e.Photo,
		1C-ID,
		e.ID,
		x.Ext,
		e.Login,
		e.Email,
		e.Fired,
		e.PassportSerNum,
		e.PassportNumber,
		e.PassportGiven,
		e.PassportGivenDate,
		e.ForeignPassportExist,
		Mate=case when e.Married=0 then 'нет' when e.Married=1 then e.MarriedOn else '' end,
		e.Children,
		e.AwardsID
	FROM
		Employees e
		left join emp_categories c on c.id=e.CategoryID
		left join organizations o on o.org_id=e.Organization
		left join departments d on d.dpt_id=e.Department
		left join posts p on p.post_id=e.PositionID
		left join ext x on x.id=e.Ext
	WHERE
		e.id=@EmployeeID
GO
ALTER TABLE Employees ADD CONSTRAINT DF_EMPLOYERS_FemaleSex DEFAULT (0) FOR FemaleSex
GO
ALTER TABLE Employees ADD CONSTRAINT DF_EMPLOYERS_CategoryID DEFAULT (2) FOR CategoryID
GO
ALTER TABLE Employees ADD CONSTRAINT DF_EMPLOYERS_PositionID DEFAULT (1) FOR PositionID
GO
