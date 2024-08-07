# --Table-Valued Expressions

/*Expresiones de Tabla (Table-Valued Expressions)*/

--1. Funciones de Tabla en Linea (Inline Table-Valued Funtions) ITVF) son funciones que devuelven una tabla como resultado. 
--Creamos una funcion de tabla en linea
CREATE OR ALTER FUNCTION ObtenerProductosMayorPrecio(@PrecioMinimo INT) RETURNS
	TABLE AS RETURN 
		(SELECT ProductName 'Producto', UnitPrice 'Precio',CategoryID 
			FROM Products WHERE UnitPrice > @PrecioMinimo );


select * from ObtenerProductosMayorPrecio(110);

--uso de la funcion de tabla en linea
SELECT C.Categoryname,A.Producto, A.Precio FROM ObtenerProductosMayorPrecio(100) A
	JOIN Categories C ON A.CategoryID = C.CategoryID;

/*Collation

CI (Case Insensitive): Insensible a mayúsculas y minúsculas. Las comparaciones de texto no distinguen entre mayúsculas y minúsculas.
CS (Case Sensitive): Sensible a mayúsculas y minúsculas. Las comparaciones de texto distinguen entre mayúsculas y minúsculas.
AS (Accent Sensitive): Sensible a los acentos. Las comparaciones de texto tienen en cuenta las diferencias entre caracteres acentuados y no acentuados.
AI (Accent Insensitive): Insensible a los acentos. Las comparaciones de texto no tienen en cuenta las diferencias entre caracteres acentuados y no acentuados.
KS (Kana Sensitive): Sensible a los caracteres de Kana en japonés. Las comparaciones de texto tienen en cuenta las diferencias entre caracteres de kana y caracteres de kanji.
KI (Kana Insensitive): Insensible a los caracteres de Kana en japonés. Las comparaciones de texto no tienen en cuenta las diferencias entre caracteres de kana y caracteres de kanji.*/


create or alter FUNCTION ConsultaCliente(@City VARCHAR(50), @Country VARCHAR(50))RETURNS
	TABLE AS RETURN 
		(SELECT CompanyName, ContactName,ContactTitle, City,Country FROM Customers
			WHERE City LIKE '%'+@City+'%' AND Country LIKE '%'+@Country+'%');
SELECT * FROM ConsultaCliente('London', 'UK');


--2. Vistas en Linea (Inline Views)
CREATE VIEW W_ConsultaEmpleados AS 
	SELECT E.TitleOfCourtesy +' '+ E.FirstName+' '+E.LastName 'NombreEmpleado',E.BirthDate,
		T.TerritoryDescription
	FROM Employees E
	JOIN EmployeeTerritories ET ON E.EmployeeID = ET.EmployeeID
	JOIN Territories T ON ET.TerritoryID = T.TerritoryID;

SELECT * FROM W_ConsultaEmpleados;

--3. Tabla derivada; son subconsultas que se pueden utilizar para simplificar y organizar las 
--consultas al encapcular logica mas complejas


--Uso de expresiones comunes de tabla (Common Table Expressions o CTE)
-- permite definir una expresión de tabla temporal y utilizarla en la misma consulta
-- WITH 
--Definir un CTE
WITH CantidadProdProveedor AS(
	SELECT SupplierID, COUNT(*) 'CantidadProductos'
		FROM Products
		GROUP BY SupplierID
)


--Uso del CTE en mi consulta principal
SELECT S.CompanyName, C.CantidadProductos
	FROM CantidadProdProveedor C
	JOIN Suppliers S ON C.SupplierID = S.SupplierID;


-- Cuanto prod a comprado cada Cliente, cual es el producto que mas a comprado(CTE)

WITH CantProdComp AS(
	SELECT O.CustomerID, OD.ProductID,COUNT(OD.Quantity) 'CantProd'
		FROM Orders O
		INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
		GROUP BY O.CustomerID, OD.ProductID	
),
OrdProComp AS(
	SELECT CustomerID, ProductID, CantProd,
	 ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY CantProd DESC) AS position
		FROM CantProdComp 
),
ProdMax AS(
	SELECT CustomerID, OPC.ProductID, P.ProductName, CantProd,position
		FROM OrdProComp OPC
		INNER JOIN Products P ON OPC.ProductID =P.ProductID
		where position = 1
)


SELECT C.CompanyName 'Cliente', P.ProductName 'ProdMaxComprado', COUNT(DISTINCT OD.ProductID) 'CantProdComprados',
	COUNT(OD.Quantity) 'TotalCantProdComprados'
	FROM Orders O
	INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
	INNER JOIN Customers C ON O.CustomerID = C.CustomerID
	INNER JOIN ProdMax P ON O.CustomerID = P.CustomerID
	GROUP BY C.CompanyName,P.ProductName;