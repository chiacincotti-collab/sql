SHOW databases;
USE AdventureWorksDW;

SHOW tables;

DESCRIBE dimproduct;

# chiedo di contare le singole product key e poi restituire solo quelle che sono > 1, cioè quelle che non sono univoche. Se è una primary key non ci dovrebbero essere riddondanze.
SELECT dimproduct.ProductKey, COUNT(*) AS quantity
FROM dimproduct
GROUP BY ProductKey
HAVING COUNT(*) > 1; #sono state restuite 0 righe, perchè nessun item è ripetuto più di una volta.

# chiedo di contare i valori nulli. se è una primary key non ci dovrebbero essere valori nulli, quindi dovrebbe restituire 0.
SELECT ProductKey, COUNT(*) AS nulli
FROM dimproduct
GROUP BY ProductKey
HAVING COUNT(*) = 'null' OR COUNT(*) < 1;  #non ci sono valori nulli o con valore 0

# controllare se la combinazione SalesOrderNumber, SalesOrderLineNumber è PK

SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'SalesOrderNumber'
  AND TABLE_SCHEMA = 'AdventureWorksDW';

DESCRIBE factinternetsales;

SELECT SalesOrderNumber, SalesOrderLineNumber, COUNT(*) AS quantity
FROM factinternetsales
GROUP BY SalesOrderNumber, SalesOrderLineNumber
HAVING COUNT(*) > 1;  # non restituisce nessuna riga dove ci sia una combinazione ripetuta dei due campi ---> ogni combinazione è univoca

SELECT SalesOrderNumber, SalesOrderLineNumber
FROM factinternetsales
WHERE SalesOrderNumber IS NULL OR SalesOrderLineNumber IS NULL; #nessuna riga restituita, non ci sono valori nulli ---> è una Primary Key

DESCRIBE factinternetsales;
SELECT *
FROM factinternetsales;

# Conta il numero transazioni SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020.
SELECT SalesOrderLineNumber, OrderDate, COUNT(SalesOrderLineNumber) AS NumOrders
FROM factinternetsales
GROUP BY SalesOrderLineNumber, OrderDate
HAVING OrderDate >= '2020-01-01';

# Calcola il fatturato totale FactResellerSales.SalesAmount), la quantità totale venduta FactResellerSales.OrderQuantity) 
# e il prezzo medio di vendita FactResellerSales.UnitPrice) per prodotto DimProduct) a partire dal 1 Gennaio 2020. 
# Il result set deve esporre pertanto il nome del prodotto (EnglishProductName), il fatturato totale, la quantità totale venduta e il prezzo medio di vendita. 
# I campi in output devono essere parlanti!

SELECT dimproduct.EnglishProductName as Name, 
SUM(factinternetsales.SalesAmount) AS fatt_totale, 
SUM(factinternetsales.OrderQuantity) AS quant_tot, 
AVG(factinternetsales.UnitPrice) AS prezzo_medio,
factinternetsales.OrderDate
FROM dimproduct INNER JOIN factinternetsales ON dimproduct.ProductKey = factinternetsales.ProductKey
GROUP BY dimproduct.EnglishProductName, factinternetsales.OrderDate
HAVING factinternetsales.OrderDate >= '2020-01-01';

# Calcola il fatturato totale FactResellerSales.SalesAmount) e la quantità totale venduta 
# FactResellerSales.OrderQuantity) per Categoria prodotto DimProductCategory)---> EnglishProductCategoryName AS Category. Il result set deve esporre 
# pertanto il nome della categoria prodotto, il fatturato totale e la quantità totale venduta.
#  I campi in output devono essere parlanti!
# ProductCategoryKey PK dimproductcategory
# ProductKey PK dimproduct, FK factinternetsales

SELECT *
FROM factinternetsales; # factinternetsales + DIMPRODUCT ---> mettere il subcategorykey da dimproduct ----> join con dimcategory tramite categorykey
SELECT *
FROM dimproduct;
SELECT *
FROM dimproductcategory;

SELECT d.ProductSubcategoryKey AS categoryKey,
SUM(f.SalesAmount) AS fatturato,
SUM(f.OrderQuantity) AS totale_venduto
FROM dimproduct as d INNER JOIN factinternetsales as f on d.ProductKey = f.ProductKey
GROUP BY d.ProductSubcategoryKey;

WITH jt AS (
 SELECT d.ProductSubcategoryKey AS categoryKey,
SUM(f.SalesAmount) AS fatturato,
SUM(f.OrderQuantity) AS totale_venduto
FROM dimproduct as d INNER JOIN factinternetsales as f on d.ProductKey = f.ProductKey
GROUP BY d.ProductSubcategoryKey
)

SELECT 
c.EnglishProductCategoryName as category,
jt.fatturato,
jt.totale_venduto
FROM dimproductcategory AS c INNER JOIN jt ON c.ProductCategoryKey = jt.categoryKey
GROUP BY c.EnglishProductCategoryName;

# ultimo esercizio

SELECT *
FROM dimgeography; # SalesTerritoryKey, GeographyKey PK

DESCRIBE dimgeography;
# Fai where data, Group by city, Having fatturato > 60k



