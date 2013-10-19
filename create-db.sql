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
CREATE TABLE EMPLOYERS(
	ID                   decimal(18, 0) IDENTITY(1,1) NOT NULL,
	[1C-ID]              int NULL,
	LastName             nvarchar(50) NOT NULL,
	FirstName            nvarchar(50) NULL,
	MiddleName           nvarchar(50) NULL,
	EXT                  int NULL,
	[Login]              nvarchar(50) NULL,
	Email                nvarchar(50) NULL,
	Sex                  nvarchar(50) NULL,
	Dismissed            tinyint NULL,
	CategoryID           smallint NULL,
	StartDate            smalldatetime NULL,
	EndDate              smalldatetime NULL,
	Organization         smallint NULL,
	Department           smallint NULL,
	PositionID           smallint NULL,
	BirthDate            smalldatetime NULL,
	RegistrationCity     nvarchar(50) NULL,
	RegistrationAddress  nvarchar(100) NULL,
	RegistrationArea     nvarchar(50) NULL,
	RegistrationZipCode  nvarchar(50) NULL,
	PhoneNumber          nvarchar(50) NULL,
	PassportSerNum       nvarchar(50) NULL,
	PassportNumber       nvarchar(50) NULL,
	PassportGiven        nvarchar(100) NULL,
	PassportGivenDate    smalldatetime NULL,
	ForeignPassportExist tinyint NULL,
	Married              tinyint NULL,
	MarriedOn            nvarchar(100) NULL,
	Children             nvarchar(100) NULL,
	Photo                image NULL,
	AwardsID             nvarchar(50) NULL,
 CONSTRAINT PK_EMPLOYERS PRIMARY KEY NONCLUSTERED 
(
	ID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE CLUSTERED INDEX IX_EMPLOYERS ON EMPLOYERS
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

SET ANSI_PADDING OFF
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

ALTER TABLE EMPLOYERS ADD CONSTRAINT DF_EMPLOYERS_CategoryID DEFAULT (2) FOR CategoryID
GO

ALTER TABLE EMPLOYERS ADD CONSTRAINT DF_EMPLOYERS_PositionID DEFAULT (1) FOR PositionID
GO
