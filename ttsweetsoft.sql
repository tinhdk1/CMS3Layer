CREATE DATABASE sweetsoft

go
use sweetsoft
--- Tạo bảng user---- 
go

CREATE TABLE Users( 
	"Id" INT  IDENTITY(1,1) PRIMARY KEY,
	"Name" NVARCHAR(256),
	"Username" VARCHAR(64) ,
	"Password" NTEXT,
	"Admin" TINYINT ,
	"Active" TINYINT,
	"Image" NVARCHAR(500) ,
	"DateCreate" DATE,
	"Role" TINYINT,
	"ModuleId" VARCHAR(100),
	"ModuleName" NVARCHAR(500)
)
GO 
-- giao diện của chương trình ví dụ slider... ---
CREATE TABLE ImageType(
	Id int IDENTITY(1,1) PRIMARY KEY,
	Name nvarchar(50),
	Code varchar(50),
	Active tinyint
)
GO 
-- hình ảnh của bài viết --- 
CREATE TABLE ImagesDetail
(
	Id int IDENTITY(1,1) primary key, 
	Name nvarchar(512) ,
	Image nvarchar(500),
	ImagesId varchar(50),
	Active int ,
	Summary ntext
)
---module admin
CREATE TABLE Module (
	Id INT IDENTITY(1,1) primary key,
	Name NVARCHAR(50),
	Idcha INT NULL DEFAULT NULL,
	Ord TINYINT NULL DEFAULT NULL,
	Icon VARCHAR(50) NULL DEFAULT NULL,
	Link NVARCHAR(100) NULL DEFAULT NULL,
	Active TINYINT NULL DEFAULT NULL
)
create table Roles(
	Id INT IDENTITY (1,1) primary key,
	IdMod INT, 
	IdMenuAd INT,
	IdUser INT,
	IsUpdate tinyint,
	IsDelete tinyint,
	IsView tinyint
)
---Danh mục hình nảh 
CREATE TABLE Advertise(
	Id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Name nvarchar(150),
	Summary nvarchar(500) ,
	Image varchar(255) NULL,
	ImageSmall varchar(255) NULL,
	Width smallint NULL,
	Height smallint NULL,
	Link varchar(255) NULL,
	Target varchar(10) NULL,
	ContentDetail ntext NULL,
	Position smallint NULL,
	PageId int NULL,
	Click int NULL,
	Ord smallint NULL,
	Active tinyint NULL CONSTRAINT DF_Advertise_Active  DEFAULT ((1)),
	Lang varchar(5) NULL,
)
GO
--- Mod Type------
CREATE TABLE Modtype(
	Id int IDENTITY(1,1) PRIMARY KEY,
	Modtype_Name nvarchar(250),
	Modtype_Code nvarchar(250),
	Modtype_Status bit,
	Modtype_Target nvarchar(250),
	Modtype_Filter tinyint

)
GO
--table Modul page
CREATE TABLE Mod(
	Id int IDENTITY(1,1) NOT NULL primary key,
	Mod_Parent int,
	Mod_Name nvarchar(250) ,
	Mod_Code nvarchar(250) ,
	Modtype_ID int ,
	Mod_Url varchar(250),
	Mod_Img nvarchar(250) ,
	Mod_Title [nvarchar](250) ,
	Mod_Key nvarchar(500) ,
	Mod_Meta nvarchar(500) ,
	Mod_Content ntext,
	Mod_Status bit ,
	Mod_Hot bit ,
	Mod_Pos int,
	Mod_Level int,
	Lang varchar(2) NULL,
	Mod_style int NULL,
	Mod_Tag nvarchar(150) NULL,
	Mod_Intro ntext NULL,
	Mod_Same bit NULL,
)
GO
--- Img Type----

create proc sp_ImgType_GetById
	@Id		int
AS
	SELECT * FROM [ImgType] WHERE Id = @Id
GO
CREATE PROCEDURE sp_ImgType_GetById
	@Id		int
AS
	SELECT * FROM ImageType WHERE Id = @Id

GO
CREATE PROCEDURE sp_ImgType_GetByAll
AS
	SELECT * FROM ImageType
GO
CREATE PROCEDURE sp_ImgType_GetByTop
@Top	nvarchar(10),
@Where	nvarchar(200),
@Order	nvarchar(200)
AS
	Declare @SQL as nvarchar(500)
	Select @SQL = 'SELECT top (' + @Top + ') * FROM ImageType'
	if len(@Top) = 0 
		BEGIN
			Select @SQL = 'SELECT * FROM ImageType'
		END
	if len(@Where) >0 
		BEGIN
			Select @SQL = @SQL + ' Where ' + @Where
		END
	if len(@Order) >0
		BEGIN
			Select @SQL = @SQL + ' Order by ' + @Order
		END
	EXEC (@SQL)
GO
create proc sp_ImgType_Insert
	@Name nvarchar(50),
	@Code varchar(50),
	@Active tinyint
AS
	Insert Into ImageType (Name,Code,Active) VALUES (@Name,@Code,@Active)
GO
create proc sp_ImgType_Update
	@Id 	int,
	@Name nvarchar(50),
	@Code varchar(50),
	@Active tinyint
AS
	Update ImageType SET Name = @Name , Code = @Code , Active = @Active Where Id=@Id
GO
create proc sp_ImgType_Delete
	@Id 	int
AS
	Delete ImageType Where Id=@Id
GO
--- ImagesDetail ---
CREATE PROC sp_ImagesDetail_GetById
	@Id int 
AS 
SELECT * FROM ImagesDetail WHERE Id= @Id 
GO

CREATE PROC sp_ImagesDetail_GetByAll
AS
SELECT * FROM ImagesDetail
GO
CREATE  PROCEDURE sp_User_GetByAll
AS
	SELECT * FROM Users
GO
CREATE PROC SP_User_GetById
@Id		int
AS
	SELECT * FROM [Users] WHERE Id = @Id
GO

CREATE PROC sp_ImagesDetail_Delete
	@Id int 
AS
begin 
Delete FROM ImagesDetail where Id= @ID
end 
go

CREATE PROC sp_ImagesDetail_Insert
	@Name nvarchar(512) ,
	@Image nvarchar(500),
	@ImagesId varchar(50),
	@Active int ,
	@Summary ntext
AS
	INSERT INTO ImagesDetail(Name, Image, ImagesId, Active, Summary)
	VALUES(@Name, @Image, @ImagesId, @Active, @Summary)
GO

create PROCEDURE sp_ImagesDetail_Update
	@Id		int,
	@Name		nvarchar(512),
	@Image		ntext,
	@ImagesId		varchar(50),
	@Active		int,
	@Summary ntext
AS
	UPDATE ImagesDetail SET Name = @Name, Image = @Image, ImagesId = @ImagesId, Active = @Active , Summary = @Summary
	 WHERE Id = @Id

GO
CREATE PROC sp_ImagesDetail_Delete
	@Id int 
as 
delete from ImagesDetail where Id= @Id
GO
CREATE PROCEDURE sp_ImagesDetail_GetByTop
@Top	nvarchar(10),
@Where	nvarchar(200),
@Order	nvarchar(200)
AS
	Declare @SQL as nvarchar(500)
	Select @SQL = 'SELECT top (' + @Top + ') * FROM [ImagesDetail]'
	if len(@Top) = 0 
		BEGIN
			Select @SQL = 'SELECT * FROM [ImagesDetail]'
		END
	if len(@Where) >0 
		BEGIN
			Select @SQL = @SQL + ' Where ' + @Where
		END
	if len(@Order) >0
		BEGIN
			Select @SQL = @SQL + ' Order by ' + @Order
		END
	EXEC (@SQL)
--- User------
CREATE PROC sp_User_Insert
	@Name		nvarchar(256),
	@Username		varchar(64),
	@Password		ntext,
	@Admin		tinyint,
	@Active		tinyint,
	@Image		nvarchar(500),
	@DateCreate		date,
	@Role		tinyint,
	@ModuleId		varchar(100),
	@ModuleName		nvarchar(500)
AS
	INSERT INTO [Users]([Name], [Username], [Password], [Admin], [Active], [Image], [DateCreate], [Role], [ModuleId], [ModuleName])
	VALUES(@Name, @Username, @Password, @Admin, @Active, @Image, @DateCreate, @Role, @ModuleId, @ModuleName)
GO
CREATE PROCEDURE sp_User_Update 
	@Id		int,
	@Name		nvarchar(256),
	@Username		varchar(64),
	@Password		ntext,
	@Admin		tinyint,
	@Active		tinyint,
	@Image		nvarchar(500),
	@DateCreate		date,
	@Role		tinyint,
	@ModuleId		varchar(100),
	@ModuleName		nvarchar(500)
AS
begin
	UPDATE Users SET Name = @Name, Username = @Username, Password = @Password, Admin = @Admin, Active = @Active, Image = @Image, DateCreate = @DateCreate, Role = @Role, ModuleId = @ModuleId, ModuleName = @ModuleName
	 WHERE Id = @Id
END
GO
CREATE PROC sp_User_Delete
	@Id int
AS
begin 
DELETE FROM Users WHERE ID= @ID
END 

GO
CREATE PROC sp_User_UpdatePass
	@Id int, 
	@Password ntext
AS
BEGIN 
UPDATE Users SET Password = @Password WHERE Id= @Id
END
GO
create proc sp_User_Update
	@Id		int,
	@Name		nvarchar(256),
	@Username		varchar(64),
	@Password		ntext,
	@Admin		tinyint,
	@Active		tinyint,
	@Image		nvarchar(500),
	@DateCreate		date,
	@Role		tinyint,
	@ModuleId		varchar(100),
	@ModuleName		nvarchar(500)
AS
	UPDATE [Users] SET [Name] = @Name, [Username] = @Username, [Password] = @Password, [Admin] = @Admin, [Active] = @Active, [Image] = @Image, [DateCreate] = @DateCreate, [Role] = @Role, [ModuleId] = @ModuleId, [ModuleName] = @ModuleName
	 WHERE Id = @Id
GO

--- Module --- 
Create proc sp_Module_GetByAll
AS
	SELECT * FROM Module
GO
Create proc sp_Module_GetById
	@Id int
AS
	SELECT * FROM Module where Id= @Id
GO
Create PROCEDURE sp_Module_GetByTop
@Top	nvarchar(10),
@Where	nvarchar(200),
@Order	nvarchar(200)
AS
	Declare @SQL as nvarchar(500)
	Select @SQL = 'SELECT top (' + @Top + ') * FROM Module'
	if len(@Top) = 0 
		BEGIN
			Select @SQL = 'SELECT * FROM Module'
		END
	if len(@Where) >0 
		BEGIN
			Select @SQL = @SQL + ' Where ' + @Where
		END
	if len(@Order) >0
		BEGIN
			Select @SQL = @SQL + ' Order by ' + @Order
		END
	EXEC (@SQL)
GO
CREATE PROCEDURE sp_Module_Getlistmodule
	@ModuleId		varchar(100)	
AS

begin
		select * into #A from dbo.splitstring (@ModuleId)
	select * from Module inner join #A on Module.Id =  #A.Name
		drop table #A
	end
GO

CREATE PROC sp_Module_Insert 
	@Name		nvarchar(50),
	@Idcha		int,
	@Ord		tinyint,
	@Icon		varchar(50),
	@Link		nvarchar(100),
	@Active		tinyint
AS
	INSERT INTO Module(Name, Idcha, Ord, Icon, Link, Active)
	VALUES(@Name, @Idcha, @Ord, @Icon, @Link, @Active)
GO
CREATE PROC sp_Module_Update
	@Id 		int,
	@Name		nvarchar(50),
	@Idcha		int,
	@Ord		tinyint,
	@Icon		varchar(50),
	@Link		nvarchar(100),
	@Active		tinyint
AS
UPDATE Module SET Name = @Name, Idcha = @Idcha, Ord = @Ord, Icon = @Icon, Link = @Link, Active = @Active
	 WHERE Id = @Id
GO
CREATE proc sp_Module_Delete 
	@Id int
AS 
Delete From Module where Id=@Id
-- Role--- 
Create proc sp_Roles_GetByAll
AS
	SELECT * FROM Module
GO
----ModType-----
create proc sp_Modtype_GetByAll
AS
	SELECT * from Modtype
GO
create proc sp_Modtype_GetById
	@Id		int
AS
	SELECT * FROM [Modtype] WHERE Id = @Id
GO
create proc sp_Modtype_GetByAll
	@Id int
AS
	SELECT * from Modtype where Id= @Id
GO
create proc sp_Modtype_Insert
	@Modtype_Name		nvarchar(250),
	@Modtype_Code		nvarchar(250),
	@Modtype_Status		bit,
	@Modtype_Target		nvarchar(250),
	@Modtype_Filter		tinyint
AS
	INSERT INTO Modtype(Modtype_Name, Modtype_Code, Modtype_Status, Modtype_Target, Modtype_Filter)
	VALUES(@Modtype_Name, @Modtype_Code, @Modtype_Status, @Modtype_Target, @Modtype_Filter)
GO
create proc sp_Modtype_Update
	@Id		int,
	@Modtype_Name		nvarchar(250),
	@Modtype_Code		nvarchar(250),
	@Modtype_Status		bit,
	@Modtype_Target		nvarchar(250),
	@Modtype_Filter		tinyint
AS
	UPDATE Modtype SET  Modtype_Name = @Modtype_Name, 
						Modtype_Code = @Modtype_Code, 
						Modtype_Status = @Modtype_Status, 
						Modtype_Target = @Modtype_Target, 
						Modtype_Filter = @Modtype_Filter
	 WHERE Id = @Id
GO

create proc sp_Modtype_Delete
	@Id		int
AS
	DELETE FROM Modtype
	 WHERE Id = @Id
GO
create proc sp_Modtype_GetByTop
@Top	nvarchar(10),
@Where	nvarchar(200),
@Order	nvarchar(200)
AS
	Declare @SQL as nvarchar(500)
	Select @SQL = 'SELECT top (' + @Top + ') * FROM Modtype'
	if len(@Top) = 0 
		BEGIN
			Select @SQL = 'SELECT * FROM Modtype'
		END
	if len(@Where) >0 
		BEGIN
			Select @SQL = @SQL + ' Where ' + @Where
		END
	if len(@Order) >0
		BEGIN
			Select @SQL = @SQL + ' Order by ' + @Order
		END
	EXEC (@SQL)

--Mod----
create proc sp_Mod_GetByAll
	@Lang		varchar(5)
AS
	SELECT * FROM Mod Where Lang = @Lang
GO
create proc sp_Mod_GetById
	@Id int
AS 
	SELECT * From Mod where Id= @Id
GO

create proc sp_Mod_Getlist
	@ModId		varchar(100)
	
AS
begin
		select * into #A from dbo.splitstring (@ModId)
	select * from Mod inner join #A on Mod.Id =  #A.Name
		drop table #A
	end
GO
create proc sp_Mod_GetByTop
@Top	nvarchar(10),
@Where	nvarchar(200),
@Order	nvarchar(200)
AS
	Declare @SQL as nvarchar(500)
	Select @SQL = 'SELECT top (' + @Top + ') * FROM Mod'
	if len(@Top) = 0 
		BEGIN
			Select @SQL = 'SELECT * FROM Mod'
		END
	if len(@Where) >0 
		BEGIN
			Select @SQL = @SQL + ' Where ' + @Where
		END
	if len(@Order) >0
		BEGIN
			Select @SQL = @SQL + ' Order by ' + @Order
		END
	EXEC (@SQL)
GO
create proc sp_Mod_Delete
	@Id int
DELETE From Mod where Id= @Id
GO
create proc sp_Mod_Insert
	@Mod_Parent		int,
	@Mod_Name		nvarchar(250),
	@Mod_Code		nvarchar(250),
	@Modtype_ID		int,
	@Mod_Url		varchar(250),
	@Mod_Img		nvarchar(250),
	@Mod_Title		nvarchar(250),
	@Mod_Key		nvarchar(500),
	@Mod_Meta		nvarchar(500),
	@Mod_Content		ntext,
	@Mod_Status		bit,
	@Mod_Hot		bit,
	@Mod_Pos		int,
	@Mod_Level		int,
	@Lang		varchar(2),
	@Mod_style		int,
	@Mod_Tag		nvarchar(150),
	@Mod_Intro		ntext,
	@Mod_Same		bit
AS
	INSERT INTO Mod(Mod_Parent, Mod_Name, Mod_Code, Modtype_ID, Mod_Url, Mod_Img, Mod_Title, Mod_Key, Mod_Meta, Mod_Content, Mod_Status, Mod_Hot, Mod_Pos, Mod_Level, Lang, Mod_style, Mod_Tag, Mod_Intro ,Mod_Same )
	VALUES(@Mod_Parent, @Mod_Name, @Mod_Code, @Modtype_ID, @Mod_Url, @Mod_Img, @Mod_Title, @Mod_Key, @Mod_Meta, @Mod_Content, @Mod_Status, @Mod_Hot, @Mod_Pos, @Mod_Level, @Lang, @Mod_style, @Mod_Tag, @Mod_Intro , @Mod_Same)
GO
create PROC sp_Mod_Update
	@Id 			int,
	@Mod_Parent		int,
	@Mod_Name		nvarchar(250),
	@Mod_Code		nvarchar(250),
	@Modtype_ID		int,
	@Mod_Url		varchar(250),
	@Mod_Img		nvarchar(250),
	@Mod_Title		nvarchar(250),
	@Mod_Key		nvarchar(500),
	@Mod_Meta		nvarchar(500),
	@Mod_Content		ntext,
	@Mod_Status		bit,
	@Mod_Hot		bit,
	@Mod_Pos		int,
	@Mod_Level		int,
	@Lang		varchar(2),
	@Mod_style		int,
	@Mod_Tag		nvarchar(150),
	@Mod_Intro		ntext,
	@Mod_Same		bit
AS
	Update Mod SET Mod_Parent = @Mod_Parent, 
				   Mod_Name = @Mod_Name, 
				   Mod_Code = @Mod_Code,
				   Modtype_ID= @Modtype_ID,
				   Mod_Url = @Mod_Url,
				   Mod_Img = @Mod_Img,
				   Mod_Title=@Mod_Title, 
				   Mod_Key =@Mod_Key, 
				   Mod_Meta =@Mod_Meta, 
				   Mod_Content =@Mod_Content, 
				   Mod_Status =@Mod_Status, 
				   Mod_Hot =@Mod_Hot , 
				   Mod_Pos =@Mod_Pos, 
				   Mod_Level =@Mod_Level, 
				   Lang =@Lang , 
				   Mod_style =@Mod_style, 
				   Mod_Tag =@Mod_Tag, 
				   Mod_Intro =@Mod_Intro,
				   Mod_Same =@Mod_Same
	Where Id=@Id
GO
create proc sp_Mod_GetByType
@Top	nvarchar(10),
@Where	nvarchar(200),
@Order	nvarchar(200)
AS
	Declare @SQL as nvarchar(500)
	Select @SQL = 'SELECT top (' + @Top + ') * from Mod join Modtype on Mod.Modtype_ID=Modtype.Id'
		
	if len(@Top) = 0 
		BEGIN
			Select @SQL = 'SELECT * from Mod join Modtype on Mod.Modtype_ID=Modtype.Id'
		END
	if len(@Where) >0 
		BEGIN
			Select @SQL = @SQL + ' Where ' + @Where
		END
	if len(@Order) >0
		BEGIN
			Select @SQL = @SQL + ' Order by ' + @Order
		END
	EXEC (@SQL)
GO
---Advertise---
create proc sp_Advertise_Delete
	@Id		int
AS
	DELETE FROM Advertise
	 WHERE Id = @Id
GO
create proc sp_Advertise_GetByAll
	@Lang		varchar(5)
AS
	SELECT * FROM Advertise Where Lang = @Lang Order by Id desc
GO
create proc sp_Advertise_GetById
	@Id		int
AS
	SELECT * FROM Advertise WHERE Id = @Id
GO
create proc sp_Advertise_GetByMod
@Top	nvarchar(10),
@Where	nvarchar(200),
@Order	nvarchar(200)
AS
	Declare @SQL as nvarchar(500)
	Select @SQL = 'SELECT top (' + @Top + ') * from Advertise join Mod on Mod.Id = Advertise.PageId'
	if len(@Top) = 0 
		BEGIN
			Select @SQL = 'SELECT * from Advertise join Mod on Mod.Id = Advertise.PageId'
		END
	if len(@Where) >0 
		BEGIN
			Select @SQL = @SQL + ' Where ' + @Where
		END
	if len(@Order) >0
		BEGIN
			Select @SQL = @SQL + ' Order by ' + @Order
		END
	EXEC (@SQL)
GO

create proc sp_Advertise_GetByTop
@Top	nvarchar(10),
@Where	nvarchar(200),
@Order	nvarchar(200)
AS
	Declare @SQL as nvarchar(500)
	Select @SQL = 'SELECT top (' + @Top + ') * FROM Advertise'
	if len(@Top) = 0 
		BEGIN
			Select @SQL = 'SELECT * FROM Advertise'
		END
	if len(@Where) >0 
		BEGIN
			Select @SQL = @SQL + ' Where ' + @Where
		END
	if len(@Order) >0
		BEGIN
			Select @SQL = @SQL + ' Order by ' + @Order
		END
	EXEC (@SQL)
GO
create proc sp_Advertise_GetByType
@Top	nvarchar(10),
@Where	nvarchar(200),
@Order	nvarchar(200)
AS
	Declare @SQL as nvarchar(500)
	Select @SQL = 'SELECT top (' + @Top + ') * FROM Advertise select * from Advertise join ImageType on Advertise.Position=ImageType.Id'
	if len(@Top) = 0 
		BEGIN
			Select @SQL = 'SELECT * FROM Advertise select * from Advertise join ImageType on Advertise.Position=ImageType.Id'
		END
	if len(@Where) >0 
		BEGIN
			Select @SQL = @SQL + ' Where ' + @Where
		END
	if len(@Order) >0
		BEGIN
			Select @SQL = @SQL + ' Order by ' + @Order
		END
	EXEC (@SQL)
GO
create proc sp_Advertise_Insert
	@Name		nvarchar(150),
	@Image		varchar(255),
	@ImageSmall		varchar(255),
	@Summary		nvarchar(500),
	@Width		smallint,
	@Height		smallint,
	@Link		varchar(255),
	@Target		varchar(10),
	@ContentDetail		ntext,
	@Position		smallint,
	@PageId		int,
	@Click		int,
	@Ord		smallint,
	@Active		tinyint,
	@Lang		varchar(5)
AS
	INSERT INTO Advertise(Name, Image, ImageSmall,Summary, Width, Height, Link, Target, ContentDetail, Position, PageId, Click, Ord, Active, Lang)
	VALUES(@Name, @Image, @ImageSmall,@Summary, @Width, @Height, @Link, @Target, @ContentDetail, @Position, @PageId, @Click, @Ord, @Active, @Lang)
GO
create proc sp_Advertise_Update
	@Id 		int,
	@Name		nvarchar(150),
	@Image		varchar(255),
	@ImageSmall		varchar(255),
	@Summary		nvarchar(500),
	@Width		smallint,
	@Height		smallint,
	@Link		varchar(255),
	@Target		varchar(10),
	@ContentDetail		ntext,
	@Position		smallint,
	@PageId		int,
	@Click		int,
	@Ord		smallint,
	@Active		tinyint,
	@Lang		varchar(5)
AS
	Update  Advertie  SET	Name =@Name, 
							Image =@Image, 
							ImageSmall =@ImageSmall,
							Summary =@Summary, 
							Width =@Width, 
							Height =@Height, 
							Link =@Link, 
							Target =@Target, 
							ContentDetail =@ContentDetail, 
							Position =@Position, 
							PageId =@PageId, 
							Click =@Click, 
							Ord =@Ord, 
							Active =@Active, 
							Lang =@Lang
			Where Id=@Id 
GO
			
			---------------Code tạo bảng bài viết---------------------------------------------------------
create table BaiViet
(
	MaBaiViet int IDENTITY(1,1) primary key NOT NULL,
	TenBaiViet nvarchar(100) NOT NULL,
	NoiDung nvarchar(max) NOT NULL,
	TieuDe nvarchar(1000) NOT NULL,
	Anh nvarchar(max) NULL,
	ThuTu int NOT NULL,
	HienThi bit NULL,
	MaDM int NULL foreign key references DanhMuc(MaDM)
)

---------------------Thêm mới bài viết----------------------------------------
create proc sp_BaiViet_Insert
@TenBaiViet nvarchar(100),
@NoiDung nvarchar(Max)=null,
@TieuDe nvarchar(1000),
@Anh nvarchar(Max)=null,
@ThuTu int,
@HienThi bit,
@MaDM int
AS 
BEGIN
	if(not exists(select * from BaiViet where @TenBaiViet=TenBaiViet))
	begin
	insert into BaiViet(TenBaiViet,NoiDung,TieuDe,Anh,ThuTu,HienThi,MaDM) values (@TenBaiViet,@NoiDung,@TieuDe,@Anh,@ThuTu,@HienThi,@MaDM)
	end
END
----------------Sửa bài viết-------------------------------------------------
create proc sp_BaiViet_Update
@MaBaiViet int,
@TenBaiViet nvarchar(100),
@NoiDung nvarchar(Max)=null,
@TieuDe nvarchar(1000),
@Anh nvarchar(Max)=null,
@ThuTu int,
@HienThi bit,
@MaDM int
AS
BEGIN
	update BaiViet 
	set TenBaiViet=@TenBaiViet,NoiDung=@NoiDung,TieuDe=@TieuDe,Anh=@Anh,ThuTu=@ThuTu,HienThi=@HienThi,MaDM=@MaDM
	where MaBaiViet=@MaBaiViet

END
----------------Xóa bài viết-------------------------------------------------
create proc sp_BaiViet_Delete
@MaBaiViet int
AS
BEGIN
	delete from BaiViet where MaBaiViet=@MaBaiViet
END
----------------Lấy danh sách bài viết---------------------------------------

create proc sp_ThongTinBaiViet
AS
BEGIN
	select MaBaiViet,SUBSTRING( TenBaiViet,1,20) as TenBaiViet,SUBSTRING( TieuDe,1,20) as TieuDe, SUBSTRING( NoiDung,1,20) as NoiDung, Anh, bv.ThuTu, bv.HienThi, TenDM from BaiViet bv join DanhMuc dm on bv.MaDM=dm.MaDM order by bv.ThuTu
END


--------------Lấy danh sách bài viết theo mã bài viết---------------------------------

create proc sp_ThongTinBaiViet_MaBV
@MaBaiViet int
AS
BEGIN
	select * from BaiViet 
	where MaBaiViet=@MaBaiViet
END