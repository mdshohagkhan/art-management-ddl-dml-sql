--Project Name:ArtDB----
--NAME:MD SHOHAG MIAH---
--ID:1286017---

USE master
GO
--Create DataBase with ldf and mdf file(IF exists and then Delete)
IF DB_ID('ArtDB') IS NOT NULL
DROP DATABASE ArtDB
GO
--Create DataBase with ldf and mdf file
CREATE DATABASE ArtDB

ON
(
Name = 'ArtDB_Data_01',
FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ArtDB_Data_02.mdf',
Size= 25 Mb,
Maxsize= 100 Mb,
FileGrowth = 5%
)
LOG ON
(
Name = 'ArtDB_Log_01',
FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ArtDB_Log_02.ldf',
Size= 2 Mb,
Maxsize= 25 Mb,
FileGrowth = 1%
)


--Use the ArtDB database
USE ArtDB
GO

--Create a table for CustomerType
CREATE TABLE CustomerType
(
		TypeId int primary key not null,
		TypeName varchar(15) not null
);

--Create a table for Customer
CREATE TABLE Customer 
(
		CustomerId int primary key not null,
		FirstName varchar (10) not null,
		LastName varchar (10) not null,
		PhoneNumber varchar(11) not null,
		ShpAddress varchar (25)  null,
		City varchar (10) not null,
		Sstate varchar (10) not null,
		TypeId int not null References CustomerType(TypeId)
);

--Create a table for Artist
CREATE TABLE Artist
(
		ArtistId char(5) primary key not null,
		ArtistFName varchar(15) not null,
		ArtistLName varchar(15) not null,
);


--Create a table for Art
CREATE TABLE Art 
(
		ArtId int primary key not null,
		ArtName varchar (30) not null,
		ArtistId char(5) not null References Artist(ArtistId)
);

--CREATE NONCLUSTERED INDEX

CREATE NONCLUSTERED INDEX IX_Art_ArtName ON Art(ArtName)
--Justify--
--EXEC sp_helpindex Art

--Create a table for Invoice
CREATE TABLE Invoice
(
		InvoiceId int not null primary key,
		CustomerId int not null References Customer(CustomerId)
);

--Create a table for InvoiceDetail
CREATE TABLE InvoiceDetail
(
		DetailId int not null,
		InvoiceId int not null References Invoice(InvoiceId) ON DELETE CASCADE ON UPDATE CASCADE,
		ArtId int not null References Art(ArtId) ON DELETE CASCADE ON UPDATE CASCADE,
		Quantity int not null,
		Price decimal(8,4) not null,
		Discount decimal(8,4) not null,
		PRIMARY KEY(DetailId,InvoiceId)
);

---Create Procedure for ArtDB-----
		use ArtDB
		GO

CREATE PROC spSelectInsertUpdateDeleteOutputReturnArtist
@statement INT=0,
@ArtistId char(2),
@ArtistFName varchar(15),
@ArtistLName varchar(15),
@outputname varchar(20) output,
@countArtist int

AS
BEGIN
IF @statement=1
BEGIN
SELECT ArtistId,ArtistFName,ArtistLName FROM Artist
END

IF @statement=2
BEGIN
BEGIN TRY
BEGIN TRAN
INSERT INTO Artist VALUES(@ArtistId,@ArtistFName,@ArtistLName)
COMMIT TRAN
END TRY
BEGIN CATCH
SELECT ERROR_LINE()errline,ERROR_MESSAGE()errmessage,ERROR_NUMBER()errnumber,ERROR_PROCEDURE()errprocedure
ROLLBACK TRAN
END CATCH
END

IF @statement=3
BEGIN
UPDATE Artist SET ArtistFName=@ArtistFName WHERE ArtistId=@ArtistId
END

IF @statement=4
BEGIN
DELETE FROM Artist WHERE ArtistId=@ArtistId
END

IF @statement=5
BEGIN
SELECT @outputname=ArtistFName FROM Artist WHERE ArtistId=@ArtistId
END

IF @statement=6
BEGIN
SELECT @countArtist=COUNT(*) FROM Artist WHERE ArtistId=@ArtistId
RETURN @countArtist
END
END

--Calling for Procedure----

EXEC spSelectInsertUpdateDeleteOutputReturnArtist'1','','','','',''

EXEC spSelectInsertUpdateDeleteOutputReturnArtist'2','12','Shohag','khan','',''

EXEC spSelectInsertUpdateDeleteOutputReturnArtist'3','12','Shohel','','',''

EXEC spSelectInsertUpdateDeleteOutputReturnArtist'4','12','','','',''

DECLARE @outputname varchar(20) 
EXEC spSelectInsertUpdateDeleteOutputReturnArtist'5','03','','',@outputname OUTPUT,''
PRINT @outputname

DECLARE @countArtist int
EXEC @countArtist= spSelectInsertUpdateDeleteOutputReturnArtist'6','15','','','',''
SELECT ('RETURN VALUE')+CONVERT(varchar,@countArtist) AS RETURNVALUE


------Create a view for ArtDB----

--WITH ENCRYPTION
CREATE VIEW vw_CustomerInvoiceDetailsEncrypted
WITH ENCRYPTION
AS
SELECT 
    C.CustomerId,
	C.FirstName,
	C.LastName,
	C.PhoneNumber,
	C.ShpAddress,
    C.City,
    C.Sstate,
    IT.TypeName AS CustomerType,
    I.InvoiceId
	FROM 
    Customer C
JOIN 
    CustomerType IT ON C.TypeId = IT.TypeId
JOIN 
    Invoice I ON C.CustomerId = I.CustomerId

	--jastify for Encryption---
	SELECT * FROM vw_CustomerInvoiceDetailsEncrypted
	

----WITH SCHEMABINDING
CREATE VIEW vw_CustomerInvoiceDetailsSchemabinding
WITH SCHEMABINDING
AS
SELECT 
    C.CustomerId,
	C.FirstName,
	C.LastName,
	C.PhoneNumber,
	C.ShpAddress,
    C.City,
    C.Sstate,
    IT.TypeName AS CustomerType,
    I.InvoiceId
	FROM 
    dbo.Customer C
JOIN 
   dbo.CustomerType IT ON C.TypeId = IT.TypeId
JOIN 
    dbo.Invoice I ON C.CustomerId = I.CustomerId
	

	--jastify for SCHEMABINDING----
	EXEC sp_helptext vw_CustomerInvoiceDetailsEncrypted


	
--SCALAR VALUES FUNCTION--


CREATE FUNCTION dbo.fn_GetCustomerTypeName
(
    @CustomerId INT
)
RETURNS VARCHAR(15)
AS
BEGIN
DECLARE @TypeName VARCHAR(15);

SELECT @TypeName = ct.TypeName
FROM Customer c
INNER JOIN CustomerType ct ON c.TypeId = ct.TypeId
WHERE c.CustomerId = @CustomerId;

RETURN @TypeName;
END;


---------------calling-----------
	SELECT dbo.fn_GetCustomerTypeName(101) AS CustomerType;


--------table valued function---------------------

CREATE FUNCTION GetCustomerInfoByStates(@Sstate varchar(10))
RETURNS TABLE
AS
RETURN
	SELECT CustomerId,FirstName,LastName,PhoneNumber,Sstate
	FROM Customer 
	WHERE Sstate=@Sstate
	GO

----------calling---------
	SELECT * FROM GetCustomerInfoByStates('Derek')

----------------Multistatement-------------

--Multi-statement function----
CREATE FUNCTION fnMultistatements(@Amount money)
RETURNS @dueTable TABLE
(
Price decimal (8,4),
Discount decimal (8,4),
Due money
)
AS
BEGIN
INSERT INTO @dueTable
SELECT Quantity,Price,Price-Discount AS Due
FROM InvoiceDetail
WHERE Price-Discount >=@Amount
RETURN
END
GO

-----------Justify-----------
	SELECT * FROM fnMultistatements(2000)


	----Cursor  for ArtDB

DECLARE @ArtId INT, @ArtName VARCHAR(30), @ArtistId CHAR(5);
DECLARE ArtCursor CURSOR FOR

SELECT ArtId, ArtName, ArtistId
	FROM Art;
	OPEN ArtCursor;
FETCH NEXT FROM ArtCursor INTO @ArtId, @ArtName, @ArtistId;

WHILE @@FETCH_STATUS = 0
BEGIN
    
    PRINT 'ArtId: ' + CAST(@ArtId AS VARCHAR) + ', ArtName: ' + @ArtName + ', ArtistId: ' + @ArtistId;
	FETCH NEXT FROM ArtCursor INTO @ArtId, @ArtName, @ArtistId;
END
CLOSE ArtCursor;
DEALLOCATE ArtCursor;
GO


--Create a Trigger for ArtDB

---After Trigger
CREATE TRIGGER trg_AfterInsert_InvoiceDetail
ON InvoiceDetail
AFTER INSERT
AS
BEGIN
    DECLARE @ArtId INT, @Quantity INT;
    SELECT @ArtId = ArtId, @Quantity = Quantity
    FROM inserted;
END; 


--Create the INSTEAD OF Trigger for UPDATE

CREATE TRIGGER trg_InsteadOfUpdate
ON Art
INSTEAD OF UPDATE

AS
BEGIN
IF (SELECT COUNT(*) FROM inserted) > 1
BEGIN
RAISERROR('You cannot update more than one record at a time in the Art table.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END

UPDATE Art
SET ArtName = i.ArtName, ArtistId = i.ArtistId
FROM inserted i
WHERE Art.ArtId = i.ArtId;
END;

 --Create the INSTEAD OF Trigger for DELETE

 CREATE TRIGGER trg_InsteadOfDelete
ON Art
INSTEAD OF DELETE

AS
BEGIN
IF (SELECT COUNT(*) FROM deleted) > 1
BEGIN
RAISERROR('You cannot delete more than one record at a time from the Art table.', 16, 1);
ROLLBACK TRANSACTION;
RETURN;
END

DELETE FROM Art
WHERE ArtId IN (SELECT ArtId FROM deleted);
END;





