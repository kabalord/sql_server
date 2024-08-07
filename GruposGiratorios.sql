-- # Pivot, Unpivot : Grupos giratorios


/*PIVOT se utiliza para transformar filas en columnas. 

SELECT columna1, [pivote_valor1] AS columna_pivote1, [pivote_valor2] AS columna_pivote2, ..., [pivote_valorN] AS columna_pivoteN
FROM
   (SELECT columna1, columna2, ..., valor_para_pivoteo FROM tu_tabla) AS fuente
PIVOT
   (SUM(valor_para_pivoteo) FOR pivote_columna IN ([pivote_valor1], [pivote_valor2], ..., [pivote_valorN])) AS pivote;
*/
SELECT ShipCountry, CustomerID	FROM Orders 
	WHERE CustomerID IN ('VINET','TOMSP','HANAR')
order by ShipCountry;

SELECT ShipCountry, [VINET],[TOMSP],[HANAR],[SUPRD]
	FROM 
	(SELECT ShipCountry, CustomerID	FROM Orders) AS fuente
PIVOT(COUNT(CustomerID) FOR CustomerID IN ([VINET],[TOMSP],[HANAR],[SUPRD])) AS pivote
order by ShipCountry;


/*Clientes-Paises*/
select  CustomerID, Country from Customers;

SELECT CustomerID, [Argentina], [Austria], [Belgium], [Brazil], [Canada], [Denmark], [Finland], [France]
	FROM
	(select  CustomerID, Country from Customers) AS fuente
PIVOT(COUNT(Country) FOR Country IN ([Argentina], [Austria], [Belgium], [Brazil], [Canada], [Denmark], [Finland], [France])) AS pivote;

--UNPIVOT revierte el proceso de PIVOT, transforma columnas en filas 
/*
SELECT [Columna], [Valor]
FROM
   (SELECT <columnas>, [pivote_columna1], [pivote_column2], ..., [pivote_columnaN]
    FROM tu_tabla) AS fuente
UNPIVOT
   ([Valor] FOR [Columna] IN ([pivote_columna1], [pivote_column2], ..., [pivote_columnaN])) AS unpivot;
*/
SELECT CustomerID, Country
	FROM
	(SELECT CustomerID, [Argentina], [Austria], [Belgium], [Brazil], [Canada], [Denmark], [Finland], [France]
	FROM
	(select  CustomerID, Country from Customers) AS fuente
		PIVOT(COUNT(Country) FOR Country 
			IN ([Argentina], [Austria], [Belgium], [Brazil], [Canada], [Denmark], [Finland], [France])) AS pivote
		) AS fuente
UNPIVOT(CountryCode FOR Country IN (Argentina, Austria, Belgium, Brazil, Canada, Denmark, Finland, France)) AS unpivote;

SELECT TitleOfCourtesy 'Categoria', Country, CAST(Extension AS INT) 'Valor'  FROM Employees;
--PIVOT
SELECT Categoria, [USA], [UK]
	FROM (SELECT TitleOfCourtesy 'Categoria', Country, CAST(Extension AS INT) 'Valor'  FROM Employees) as fuente
PIVOT(SUM(Valor) FOR Country IN ([USA], [UK])) as pivote;


--UNPIVOT
SELECT Categoria, Pais, Valor
FROM(
	SELECT Categoria, [USA], [UK]
		FROM (SELECT TitleOfCourtesy 'Categoria', Country, CAST(Extension AS INT) 'Valor'  FROM Employees) as fuente
	PIVOT(SUM(Valor) FOR Country IN ([USA], [UK])) as pivote
) as fuente
UNPIVOT(
	Valor FOR Pais IN ([USA], [UK]))AS unpivote;

select * from Products

CREATE TABLE Ventas(
	Producto VARCHAR(50),
	Enero int,
	Febrero int,
	Marzo int,
	Abril int
	);
	INSERT INTO Ventas VALUES
		('Neveras',12,10,5,20),
		('Lavadoras',45,2,75,2),
		('TV',54,9,50,78);

	select * from Ventas;
	--LISTADO DE PROD CON SU MES Y SU VENTA
	--Nevera, Enero, 12
	SELECT Producto,  Mes, Cantidad
	FROM(
		SELECT Producto,Enero,Febrero,Marzo,Abril FROM Ventas) AS fuente
	UNPIVOT(
		Cantidad --Nombre que le queremos dar al valor contenido en la columna original
		FOR Mes -- Nombre que le queremos dar a la columna nueva que contendra el nombre de las columnas a unpivot
		IN([Enero],[Febrero],[Marzo],[Abril]) -- Columnas que se convertiran
		) As UnpivotVenta;


		select AVG(Febrero), SUM(Enero) from Ventas;
