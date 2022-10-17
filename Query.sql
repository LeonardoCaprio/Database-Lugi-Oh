USE LugiOh

--SOAL 1
SELECT
	CustomerName, CustomerGender, CustomerPhone, CustomerAddress
FROM Customer
WHERE CustomerName LIKE '%l%'

--SOAL 2
SELECT 
	CustomerName,
	CustomerGender,
	CustomerPhone,
	CustomerAddress,
	[Transaction Month] = DATENAME(MONTH,TransactionDate)
FROM Customer c
	JOIN HeaderTransaction ht ON c.CustomerID = ht.CustomerID
WHERE c.CustomerID LIKE 'CU002'

--SOAL 3
SELECT
	[CardName] = LOWER(CardName),
	CardElement,
	CardLevel,
	CardAttack,
	CardDefense,
	[Total Transaction] = CAST(COUNT(TransactionID) AS VARCHAR) + ' time(s)'
FROM DetailTransaction dt
	JOIN Cards c ON dt.CardsID = c.CardsID
WHERE CardElement LIKE 'Dark'
GROUP BY LOWER(CardName), CardElement, CardLevel, CardAttack, CardDefense

--SOAL 4
SELECT 
	CardName, 
	CardElement,
	[Total Price] = SUM(CardPrice),
	[Total Transaction] = CAST(COUNT(ht.TransactionID) AS VARCHAR) + ' time(s)'
FROM HeaderTransaction ht 
	JOIN DetailTransaction dt ON ht.TransactionID = dt.TransactionID
	JOIN Cards c ON dt.CardsID = c.CardsID
WHERE DATEDIFF(MONTH,TransactionDate, '2017-12-31') > 8 
GROUP BY CardName, CardElement
UNION
SELECT 
	CardName, 
	CardElement,
	[Total Price] = SUM(CardPrice),
	[Total Transaction] = CAST(COUNT(ht.TransactionID) AS VARCHAR) + ' time(s)'
FROM HeaderTransaction ht 
	JOIN DetailTransaction dt ON ht.TransactionID = dt.TransactionID
	JOIN Cards c ON dt.CardsID = c.CardsID
WHERE CardPrice > 500000 
GROUP BY CardName, CardElement

--SOAL 5
SELECT
	CustomerName,
	CustomerGender,
	[CustomerDOB] = CONVERT(VARCHAR,CustomerDOB,107)
FROM Customer
WHERE CustomerID IN
	(
		SELECT CustomerID
		FROM HeaderTransaction
		WHERE DAY(TransactionDate) = 5
	)

--SOAL 6
SELECT 
	CardName,
	[Type] = UPPER(CardTypeName),
	CardElement,
	[Total Card] = CAST(Quantity AS VARCHAR) + ' Cards',
	[Total Price] = Quantity*CardPrice
FROM DetailTransaction dt
	JOIN Cards c ON dt.CardsID = c.CardsID
	JOIN CardType ct ON c.CardTypeID = ct.CardTypeID,
	(
		SELECT 
			[Average Price Card] = AVG(CardPri.[Card Price])
		FROM
		(
			SELECT 
				[Card Price] = SUM(CardPrice)
			FROM Cards
			GROUP BY CardsID
		)AS CardPri
	)AS AvgPriCard
WHERE CardPrice < AvgPriCard.[Average Price Card] AND CardElement = 'Dark'
ORDER BY Quantity ASC

--SOAL 7
CREATE VIEW DragonDeck
AS
SELECT 
	[Monster Card] = SUBSTRING(CardName, 1, CHARINDEX(' ',CardName)-1),
	CardTypeName,
	CardElement,
	CardLevel,
	CardAttack,
	CardDefense
FROM Cards c
	JOIN CardType ct ON c.CardTypeID = ct.CardTypeID
WHERE CardTypeName = 'Dragon'

SELECT * FROM DragonDeck

--SOAL 8
CREATE VIEW MayTransaction
AS
SELECT 
	CustomerName,

	[Customer Phone] = REPLACE(CustomerPhone, '8', 'x'),
	StaffName,
	StaffPhone,
	TransactionDate,
	[Sold Card] = SUM(Quantity)
FROM Customer c
	JOIN HeaderTransaction ht ON c.CustomerID = ht.CustomerID
	JOIN DetailTransaction dt ON ht.TransactionID = dt.TransactionID
	JOIN Staff s ON ht.StaffID = s.StaffID
WHERE MONTH(TransactionDate) = 5 AND CustomerGender = 'Female'
GROUP BY CustomerName, REPLACE(CustomerPhone, '8', 'x'), StaffName, StaffPhone, TransactionDate

SELECT * FROM MayTransaction

--SOAL 9
ALTER TABLE Staff
ADD StaffSalary INT
ALTER TABLE Staff
ADD CONSTRAINT Check_Salary CHECK(StaffSalary > 100000)

SELECT * FROM Staff

--Test Alter Tabel
INSERT INTO Staff VALUES
('ST010', 'Leonardo Caprio', 'Male', '082215467894', 'Jalan Palmerah', CAST(N'2002-06-22' AS Date), 50000)
INSERT INTO Staff VALUES
('ST010', 'Leonardo Caprio', 'Male', '082215467894', 'Jalan Palmerah', CAST(N'2002-06-22' AS Date), 150000)
--Test Alter Tabel

--SOAL 10 
UPDATE Cards
SET CardPrice = CardPrice + 200000
FROM DetailTransaction dt
	JOIN Cards c ON dt.CardsID = c.CardsID
	JOIN CardType ct ON c.CardTypeID = c.CardTypeID
WHERE CardTypeName = 'Divine-Beast' AND Quantity > 10 

SELECT 
	c.CardsID
	CardTypeName,
	CardPrice,
	Quantity
FROM DetailTransaction dt
	JOIN Cards c ON dt.CardsID = c.CardsID
	JOIN CardType ct ON c.CardTypeID = c.CardTypeID
WHERE Quantity > 10 AND CardTypeName = 'Divine-Beast'

