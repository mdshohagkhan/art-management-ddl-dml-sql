

---Insert sample data into the CustomerType table
INSERT INTO CustomerType
(
	TypeId,TypeName
)
		values
		(1,'Premium'),
		(2,'Regular'),
		(3,'New Customer')

---Insert sample data into the Customer table
INSERT INTO Customer
(
CustomerId,FirstName,LastName,PhoneNumber,ShpAddress,City,Sstate,TypeId
)
		values
		(101,'JACK','COOK','12345','3711 W Franklin','Fresno','Derek',1),
		(102,'TERRY','KIM','23456','12 Daniel Road','Fairfield','Aaron',2),
		(103,'ROY','SMITH','34567','415 E Olive Ave','New York','New York',3)

---Insert sample data into the Artist table
INSERT INTO Artist
(
ArtistId,ArtistFName,ArtistLName
)
		VALUES
		('03','Carol','Chaining'),
		('15','Dennis','Frings')


---Insert sample data into the Art table
INSERT INTO Art
(
ArtId,ArtName,ArtistId
)
		VALUES
		(201,'Laugh with Teeth','03'),
		(202,'South toward Emerald Sea','15'),
		(203,'At the Movies','03')

---Insert sample data into the Invoice table
INSERT INTO Invoice
(
InvoiceId,CustomerId
)
		VALUES 
		(301,101),
		(302,102),
		(303,103)


---Insert sample data into the InvoiceDetail table		
INSERT INTO InvoiceDetail
(
DetailId,InvoiceId,ArtId,Quantity,Price,Discount
) 
		VALUES 
		(501,301,201,1,7000,.10),
		(502,301,202,1,2200,.10),
		(503,301,203,1,5550,.10),
		(504,302,202,1,2200,.08),
		(505,303,201,1,7000,.05)


		USE ArtDB
		GO
		----TOP CLAUSE---
----Select Top 2 Customers by CustomerId
SELECT TOP 2 CustomerId, FirstName, LastName, PhoneNumber, ShpAddress, City, Sstate
FROM Customer
ORDER BY CustomerId;


----Select Top 3 Invoice Details with the Highest Price
SELECT TOP 3 DetailId, InvoiceId, ArtId, Quantity, Price, Discount
FROM InvoiceDetail
ORDER BY Price DESC;

		-----WHERE CLAUSE----

SELECT  CustomerId,FirstName,LastName,PhoneNumber,City
FROM Customer 
WHERE TypeId = 1; 

				-----LOGICAL OPERATOR----

-----AND Operator
SELECT CustomerId,FirstName,LastName,PhoneNumber,City 
FROM Customer
WHERE City = 'Fresno' AND TypeId = 1;

----OR Operator
SELECT CustomerId,FirstName,LastName,PhoneNumber,City 
FROM Customer
WHERE City = 'Fresno' OR TypeId = 2;

----NOT Operator
SELECT CustomerId,FirstName,LastName,PhoneNumber,City 
FROM Customer
WHERE NOT City = 'New York';

----Combining AND, OR, and NOT
SELECT  CustomerId,FirstName,LastName,PhoneNumber,City 
FROM Customer
WHERE (City = 'Fresno' AND TypeId = 1) OR City = 'New York';


----NOT IN Operator
SELECT CustomerId,FirstName,LastName,PhoneNumber,City 
FROM Customer
WHERE TypeId NOT IN (1, 2);


----IS NULL 
SELECT CustomerId,FirstName,LastName,PhoneNumber,City 
FROM Customer
WHERE ShpAddress IS NULL;

----- IS NOT NULL
SELECT CustomerId,FirstName,LastName,PhoneNumber,City 
	FROM Customer
WHERE ShpAddress IS NOT NULL;

		-----IN Operater---
------Using IN to Filter Specific Values
SELECT  CustomerId,FirstName,LastName,PhoneNumber,City
	FROM Customer
WHERE TypeId IN (1, 2, 3);

-----Using IN with Subquery
SELECT InvoiceId,CustomerId 
	FROM Invoice
WHERE CustomerId IN 
	(
	SELECT CustomerId FROM Customer 
	WHERE City IN ('Fresno', 'New York')
	);

------Using IN to Compare a Range of Values
SELECT DetailId,InvoiceId,Price,Quantity,Discount 
	FROM InvoiceDetail
WHERE ArtId IN 
(
201, 202, 203
);

		------BETWEEN Operator-----

---- Using BETWEEN with Numeric Values
SELECT  DetailId,InvoiceId,Price,Quantity,Discount 
	FROM InvoiceDetail
WHERE Price BETWEEN 2000 AND 7000;

----- Combining BETWEEN with Other Operators
SELECT DetailId,InvoiceId,Price,Quantity,Discount  
	FROM InvoiceDetail
	WHERE Price BETWEEN 2000 AND 7000
AND Quantity = 1;

			----LIKE OPERATOR---
SELECT ArtistId,ArtistFName,ArtistLName 
	FROM Artist
WHERE ArtistFName LIKE 'C%' OR ArtistFName LIKE 'D%';



-----ORDER BY CLAUSE
SELECT CustomerId,FirstName,LastName,PhoneNumber,ShpAddress,City,Sstate 
	FROM Customer
ORDER BY City ASC, LastName DESC;

			-----JOIN QUERY----

-----inner join
SELECT Customer.CustomerId, Customer.FirstName, Customer.LastName, Invoice.InvoiceId
	FROM Customer
	INNER JOIN Invoice
ON Customer.CustomerId = Invoice.CustomerId;

----- LEFT JOIN
SELECT Customer.CustomerId, Customer.FirstName, Customer.LastName, Invoice.InvoiceId
	FROM Customer
	LEFT JOIN Invoice
ON Customer.CustomerId = Invoice.CustomerId;

----- RIGHT JOIN
SELECT Invoice.InvoiceId, Customer.CustomerId, Customer.FirstName, Customer.LastName
	FROM Invoice
	RIGHT JOIN Customer
ON Invoice.CustomerId = Customer.CustomerId;

----FULL JOIN
SELECT Customer.CustomerId, Customer.FirstName, Customer.LastName, Invoice.InvoiceId
	FROM Customer
	FULL JOIN Invoice
ON Customer.CustomerId = Invoice.CustomerId;


----CROSS JOIN
SELECT Art.ArtId, Art.ArtName, Artist.ArtistId, Artist.ArtistFName, Artist.ArtistLName
	FROM Art
CROSS JOIN Artist;


-----JOIN Two or More Tables
SELECT Customer.FirstName, Customer.LastName, Invoice.InvoiceId, 
       InvoiceDetail.ArtId, InvoiceDetail.Quantity, InvoiceDetail.Price
FROM Customer
INNER JOIN Invoice
	ON Customer.CustomerId = Invoice.CustomerId
INNER JOIN InvoiceDetail
	ON Invoice.InvoiceId = InvoiceDetail.InvoiceId;


------UNION
SELECT FirstName, LastName 
FROM Customer
	UNION
SELECT ArtistFName, ArtistLName
	FROM Artist;

				-----AGGREGATE FUNCTION-----

----COUNT() Function
SELECT CustomerType.TypeName, 
	COUNT(Customer.CustomerId) AS NumberOfCustomers
	FROM CustomerType
 JOIN Customer ON Customer.TypeId = CustomerType.TypeId
	GROUP BY CustomerType.TypeName;


------SUM() Function
SELECT SUM(Price * Quantity) AS TotalSales
FROM InvoiceDetail;


-----AVG() Function
SELECT AVG(Price) AS AveragePrice
FROM InvoiceDetail;


----- MIN() Function
SELECT MIN(Price) AS MinPrice
FROM InvoiceDetail;


-----MAX() Function
SELECT MAX(Price) AS MaxPrice
FROM InvoiceDetail;


----Using Aggregate Functions with GROUP BY
SELECT Artist.ArtistFName, Artist.ArtistLName, 
	COUNT(Art.ArtId) AS NumberOfArtworks
	FROM Artist
	INNER JOIN Art ON Artist.ArtistId = Art.ArtistId
GROUP BY Artist.ArtistFName, Artist.ArtistLName;


----Using GROUP BY and HAVING with ArtDB
SELECT Artist.ArtistFName, Artist.ArtistLName, AVG(InvoiceDetail.Price) AS AveragePrice
	FROM Artist
	JOIN Art ON Artist.ArtistId = Art.ArtistId
	JOIN InvoiceDetail ON Art.ArtId = InvoiceDetail.ArtId
	GROUP BY Artist.ArtistFName, Artist.ArtistLName
HAVING AVG(InvoiceDetail.Price) > 3000;


			-----ROLLUP OPERATOR---
SELECT i.CustomerId, Art.ArtistId, SUM(InvoiceDetail.Price) AS TotalSales
	FROM Invoice i
	JOIN InvoiceDetail ON i.InvoiceId = InvoiceDetail.InvoiceId
	JOIN Art ON InvoiceDetail.ArtId = Art.ArtId
	GROUP BY i.CustomerId, Art.ArtistId 
WITH ROLLUP;

			--------CUBE OPERATOR----
SELECT i.CustomerId, Art.ArtistId, SUM(InvoiceDetail.Price) AS TotalSales
	FROM Invoice i
	JOIN InvoiceDetail ON i.InvoiceId = InvoiceDetail.InvoiceId
	JOIN Art ON InvoiceDetail.ArtId = Art.ArtId
	GROUP BY i.CustomerId, Art.ArtistId 
WITH CUBE;

			--------GROUPING SETS OPERATOR----
SELECT i.CustomerId, Art.ArtistId, SUM(InvoiceDetail.Price) AS TotalSales
	FROM Invoice i
	JOIN InvoiceDetail ON i.InvoiceId = InvoiceDetail.InvoiceId
	JOIN Art ON InvoiceDetail.ArtId = Art.ArtId
	GROUP BY 
GROUPING SETS (i.CustomerId, Art.ArtistId); 

				------OVER OPERATOR----
SELECT i.CustomerId, i.InvoiceId, SUM(InvoiceDetail.Price)
OVER (PARTITION BY i.CustomerId ORDER BY i.InvoiceId) AS RunningTotal
FROM Invoice i
JOIN InvoiceDetail ON i.InvoiceId = InvoiceDetail.InvoiceId;


				----USING SUBQUERY FOR ArtDB---

------Subquery
SELECT FirstName, LastName, City, PhoneNumber
	FROM Customer
WHERE CustomerId IN 
(
    SELECT DISTINCT Invoice.CustomerId
    FROM Invoice
     JOIN InvoiceDetail ON Invoice.InvoiceId = InvoiceDetail.InvoiceId
     JOIN Art ON InvoiceDetail.ArtId = Art.ArtId
     JOIN Artist ON Art.ArtistId = Artist.ArtistId
    WHERE Artist.ArtistFName = 'Carol' AND Artist.ArtistLName = 'Chaining'
);


			------Correlated Subquery----
------Subquery with EXISTS
SELECT FirstName, LastName
	FROM Customer
WHERE EXISTS 
(
    SELECT 1
    FROM Invoice
    INNER JOIN InvoiceDetail ON Invoice.InvoiceId = InvoiceDetail.InvoiceId
    WHERE Invoice.CustomerId = Customer.CustomerId
);



			-------USING ANY,SOME,ALL KEYWORD FOR ArtDB----

-----ALL KEYWORD
SELECT DetailId,CustomerId,ArtId,Quantity,Price,Discount 
	FROM InvoiceDetail AS I JOIN Invoice AS INV
	ON I.InvoiceId=INV.InvoiceId
WHERE Price > ALL
(
SELECT Price FROM InvoiceDetail WHERE InvoiceId=302
);


------SOME KEYWORD
SELECT FirstName, LastName, SUM(InvoiceDetail.Price * InvoiceDetail.Quantity) AS TotalSpent
FROM Customer
INNER JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
INNER JOIN InvoiceDetail ON Invoice.InvoiceId = InvoiceDetail.InvoiceId
GROUP BY Customer.CustomerId, Customer.FirstName, Customer.LastName
HAVING SUM(InvoiceDetail.Price * InvoiceDetail.Quantity) > SOME 
(
    SELECT SUM(InvoiceDetail.Price * InvoiceDetail.Quantity)
    FROM InvoiceDetail
    GROUP BY InvoiceDetail.InvoiceId
);

------ANY KEYWORD
SELECT FirstName, LastName, SUM(InvoiceDetail.Price * InvoiceDetail.Quantity) AS TotalSpent
	FROM Customer
	INNER JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
	INNER JOIN InvoiceDetail ON Invoice.InvoiceId = InvoiceDetail.InvoiceId
GROUP BY Customer.CustomerId, Customer.FirstName, Customer.LastName
HAVING SUM(InvoiceDetail.Price * InvoiceDetail.Quantity) > ANY 
(
    SELECT SUM(InvoiceDetail.Price * InvoiceDetail.Quantity)
    FROM InvoiceDetail
    GROUP BY InvoiceDetail.InvoiceId
);

------COMMON TABLE EXPRESSIONS(CTE)
WITH CustomerTotalSpent AS 
(
    SELECT Customer.CustomerId, 
           Customer.FirstName, 
           Customer.LastName, 
           SUM(InvoiceDetail.Price * InvoiceDetail.Quantity) AS TotalSpent
    FROM Customer
     JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
     JOIN InvoiceDetail ON Invoice.InvoiceId = InvoiceDetail.InvoiceId
    GROUP BY Customer.CustomerId, Customer.FirstName, Customer.LastName
)
SELECT * 
FROM CustomerTotalSpent
ORDER BY TotalSpent DESC;

-----SELECT INTO,INSERT INTO,DELETE STATEMENT USING IN ArtDB----

-----SELECT INTO STATEMENT
SELECT DetailId,InvoiceId,ArtId,Quantity,Price,Discount 
	INTO InvoiceDetailCopy 
FROM InvoiceDetail

-----INSERT INTO STATEMENT
INSERT INTO Artist ( ArtistId,ArtistFName,ArtistLName)
VALUES 
    (
		13,'Shohag','Khan'
	);
    


-----UPDATE STATEMENT
UPDATE InvoiceDetail
	SET Price = 2400
WHERE ArtId = 203;


-------	DELETE STATEMENT
DELETE FROM InvoiceDetail
WHERE ArtId = 203;


				----MERGE---

USE ArtDB
GO
MERGE INTO InvoiceDetail i
USING InvoiceDetailCopy ic
ON ic.InvoiceId=i.InvoiceId
WHEN MATCHED AND
i.Price IS NOT NULL
THEN UPDATE
SET
i.Discount=ic.Discount
WHEN NOT MATCHED THEN
INSERT
(Quantity,Price,Discount)
VALUES(ic.Quantity,ic.Price,ic.Discount);



		-----CAST----
SELECT ArtId, 
       Price, 
       CAST(Price AS INT) AS PriceAsInt
FROM InvoiceDetail;

		----CONVERT----
SELECT InvoiceId, 
       CustomerId, 
       CONVERT(VARCHAR(10), CustomerId, 103) AS InvoiceDateFormatted
FROM Invoice;

		----TRY_CONVERT---
SELECT ArtId, 
       InvoiceId, 
       TRY_CONVERT(INT, Price) AS ConvertedPrice
FROM InvoiceDetail;


------DATEPART FUNCTION-----
SELECT InvoiceId, 
       CustomerId,
       DATEPART(MONTH,CustomerId ) AS InvoiceMonth,
       DATEPART(DAY, CustomerId) AS InvoiceDay
FROM Invoice;

-----DATENAME FUNCTION----
SELECT InvoiceId, 
       CustomerId,
       DATENAME(MONTH, CustomerId) AS MonthName,
       DATENAME(WEEKDAY, CustomerId) AS WeekdayName
FROM Invoice;

----DATEADD FUNCTION----
SELECT InvoiceId, 
       CustomerId,
       DATEADD(DAY, 30, CustomerId) AS InvoiceDatePlus30Days,
       DATEADD(MONTH, -2, CustomerId) AS InvoiceDateMinus2Months
FROM Invoice;

-----DATEDIFF-----
SELECT InvoiceId, 
       CustomerId,
       DATEDIFF(DAY, CustomerId, GETDATE()) AS DaysDifference,
       DATEDIFF(MONTH, CustomerId, GETDATE()) AS MonthsDifference
FROM Invoice;


-----CASE FUNCTION----
SELECT 
    CustomerId,
    FirstName,
    LastName,
    TypeId,
    CASE TypeId
        WHEN 1 THEN 'Premium'
        WHEN 2 THEN 'Regular'
        WHEN 3 THEN 'New Customer'
        ELSE 'Unknown'
    END AS CustomerType
FROM Customer;


-----IIF FUNCTION-----
SELECT 
    InvoiceId,
    ArtId,
    SUM(Quantity * Price) AS TotalPrice,
    IIf(SUM(Quantity * Price) > 5000, 'High Value', 'Low Value') AS InvoiceCategory
FROM InvoiceDetail
GROUP BY InvoiceId, ArtId;

------CHOOSE FUNCTION----
SELECT 
    CustomerId,
    FirstName,
    LastName,
    TypeId,
    CHOOSE(TypeId, 'Premium', 'Regular', 'New Customer') AS CustomerType
FROM Customer;


----------COALESCE FUNCTION-----
SELECT 
    CustomerId,
    FirstName,
    LastName,
    COALESCE(PhoneNumber, 'N/A') AS PhoneNumber
FROM Customer;

-----ISNULL FUNCTION------
SELECT 
    CustomerId,
    FirstName,
    LastName,
    ISNULL(ShpAddress, 'Address not available') AS ShpAddress
FROM Customer;

-----GROUPING FUNCTION----
SELECT a.ArtName,
       MAX(id.Price) AS MaxPrice,
       MIN(id.Price) AS MinPrice
FROM Art a
INNER JOIN InvoiceDetail id ON a.ArtId = id.ArtId
GROUP BY a.ArtName;



----------RANKING FUNCTION--------

------ROW_NUMBER()----
SELECT 
    ArtId,
    InvoiceId,
    Price,
    ROW_NUMBER() OVER (ORDER BY Price DESC) AS Rank
FROM InvoiceDetail;

---------RANK() Function------
SELECT 
    ArtId,
    InvoiceId,
    Price,
    RANK() OVER (ORDER BY Price DESC) AS Rank
FROM InvoiceDetail;

------DENSE_RANK() Function----
SELECT 
    ArtId,
    InvoiceId,
    Price,
    DENSE_RANK() OVER (ORDER BY Price DESC) AS DenseRank
FROM InvoiceDetail;

------NTILE() Function-----
SELECT 
    ArtId,
    InvoiceId,
    Price,
    NTILE(2) OVER (ORDER BY Price DESC) AS Tile
FROM InvoiceDetail;

------ANALYTIC FUNCTION----

-----FIRST_VALUE()----
SELECT 
    InvoiceDetail.InvoiceId,
    InvoiceDetail.ArtId,
    InvoiceDetail.Price,
    FIRST_VALUE(InvoiceDetail.Price)
	OVER 
	(
	PARTITION BY InvoiceDetail.InvoiceId ORDER BY InvoiceDetail.ArtId
	) AS FirstArtPrice
FROM InvoiceDetail;


-----LAST_VALUE()----
SELECT 
    InvoiceDetail.InvoiceId,
    InvoiceDetail.ArtId,
    InvoiceDetail.Price,
    LAST_VALUE(InvoiceDetail.Price) 
	OVER (PARTITION BY InvoiceDetail.InvoiceId ORDER BY InvoiceDetail.ArtId ) AS LastArtPrice
FROM InvoiceDetail;

-----PERCENT_RANK()----
SELECT 
    InvoiceDetail.ArtId,
    InvoiceDetail.Price,
    PERCENT_RANK() OVER (ORDER BY InvoiceDetail.Price DESC) AS PercentRank
FROM InvoiceDetail;

-----CUME_DIST()----
SELECT 
    InvoiceDetail.ArtId,
    InvoiceDetail.Price,
    CUME_DIST() 
	OVER (ORDER BY InvoiceDetail.Price DESC) AS CumulativeDist
FROM InvoiceDetail;


----- PERCENTILE_CONT()----
SELECT 
    PERCENTILE_CONT(0.5) 
	WITHIN GROUP (ORDER BY Price) OVER () AS MedianPrice
FROM InvoiceDetail;


-----PERCENTILE_DISC()----
SELECT 
    PERCENTILE_DISC(0.5) 
	WITHIN GROUP (ORDER BY Price) OVER () AS DiscreteMedianPrice
FROM InvoiceDetail;









