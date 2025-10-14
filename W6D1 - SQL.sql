SHOW databases;

USE AdventureWorksDW;

SHOW tables;
SELECT * 
FROM dimproduct;

DESCRIBE dimproduct;

SELECT ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag
FROM dimproduct;

SELECT ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag
FROM dimproduct
WHERE FinishedGoodsFlag = 1;

SELECT ProductKey, ProductAlternateKey, ModelName, EnglishProductName, ListPrice, StandardCost
FROM dimproduct
WHERE ProductAlternateKey LIKE 'FR%' OR 'BK%';

SELECT ProductKey, ProductAlternateKey, ModelName, EnglishProductName, ListPrice, StandardCost, ListPrice - StandardCost AS Markup
FROM dimproduct
WHERE ProductAlternateKey LIKE 'FR%' OR 'BK%';

SELECT ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag, ListPrice
FROM dimproduct
WHERE FinishedGoodsFlag = 1
AND ListPrice BETWEEN 1000 AND 2000;

SELECT * FROM dimemployee;

DESCRIBE dimemployee;

SELECT EmployeeKey, FirstName, LastName, HireDate, SalesPersonFlag
FROM dimemployee
WHERE SalesPersonFlag = 1;

SELECT * FROM factresellersales;
DESCRIBE factresellersales;

SELECT SalesOrderNumber, SalesOrderLineNumber
, OrderDate
, DueDate
, ShipDate
, ProductKey
, ResellerKey
, PromotionKey
, EmployeeKey
, SalesTerritoryKey
, OrderQuantity
, UnitPrice
, TotalProductCost
, SalesAmount 
, SalesAmount - TotalProductCost AS Profitto
FROM factresellersales
WHERE ProductKey = 597 OR ProductKey = 598 OR ProductKey = 477 OR ProductKey = 214
AND OrderDate >= 20200101;