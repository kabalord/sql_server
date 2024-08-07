# FuncionesDeDesplazamiento

/*Funciones de desplazamiento
	Mover o cambiar los valores de una columna en un conjunto de resultados
	-LEAD() accede al valor de una columna en la siguiente fila dentro del mismo conjunto de resultados
	-LAG()	accede al valor de una columna en la anterior fila dentro del mismo conjunto de resultados
*/
--LEAD()
--Funcion para el calculo de la edad
CREATE FUNCTION edad(
	--se definen los parametros de entrada
	@fechaNacimiento DATE
)
RETURNS INT --se especifica el tipo de dato a retornar(salida)
AS
BEGIN
	--se declara una variable
	DECLARE @edad INT;
	--Asignar un valor a una variable
	SET @edad = 0;
	--Asignacion por un SELECT
	SELECT @edad = 
		CASE
		WHEN DATEPART(MONTH,GETDATE()) >= DATEPART(MONTH,@fechaNacimiento ) 
			THEN
			CASE
				WHEN DATEPART(DAY,GETDATE()) >= DATEPART(DAY,@fechaNacimiento ) 
				THEN DATEDIFF(YEAR,@fechaNacimiento ,GETDATE())
				ELSE DATEDIFF(YEAR,@fechaNacimiento ,GETDATE()) - 1
			END
		ELSE
			 DATEDIFF(YEAR,@fechaNacimiento ,GETDATE()) - 1
		END
	--Retorno del resultado
	RETURN @edad
END;

-- consumir la funcion
SELECT Empleado,BirthDate,edad,
	LEAD(edad) OVER (ORDER BY Empleado) AS 'edadSiguiente',
	LAG(edad) OVER (ORDER BY Empleado) AS 'edadSAnterior'
	FROM (
	SELECT CONCAT_WS(' ', FirstName, LastName) 'Empleado', BirthDate, dbo.edad(BirthDate) 'edad'
		FROM Employees) x;
SELECT * FROM Employees
--Funcion de desplazamiento con PARTITION BY
SELECT Empleado,BirthDate,edad, Country,
	LEAD(edad) OVER (PARTITION BY Country ORDER BY Empleado) AS 'edadSiguiente',
	LAG(edad) OVER (PARTITION BY Country ORDER BY Empleado) AS 'edadSAnterior'
	FROM (
	SELECT CONCAT_WS(' ', FirstName, LastName) 'Empleado', BirthDate, dbo.edad(BirthDate) 'edad', Country
		FROM Employees) x;

/*Clausula OVER se utiliza para definir una ventana de filas dentro de un conjunto de resultados sobre
los que se aplicaran las funciones analiticas, como las de clasificacion, desplazamiento y agregacion
Componentes prinicipales para la Ventana
*-PARTITION BY Divide el conjunto de resultado en particiones basadas en los valores de una o mas columnas
*-ORDER BY Establece el orden de la filas dentro de cada particion
OVER (PARTITION BY column1, column2, ... ORDER BY column3)
*/

/*Funciones de Clasificacion de Ventanas

	Asignan un rango o numero de filas a cada registro dentro de un conjunto de resultados
basados en un orden especifico*/

/*ROW_NUMBER() asigna un numero unico a cada fila dentro de una particion basandose en el
 orden especificado por la clausula ORDER BY
ROW_NUMBER() OVER ( [PARTITION BY partition_expression, ... ] ORDER BY sort_expression [ASC | DESC], ... ]*/
SELECT * FROM(
SELECT EmployeeID, FirstName, LastName, BirthDate,City,
	ROW_NUMBER() OVER(PARTITION BY City ORDER BY BirthDate DESC) AS RowNum
FROM Employees)X
order by City, RowNum;


 SELECT ProductID, ProductName, QuantityPerUnit, UnitPrice,
	ROW_NUMBER() OVER(ORDER BY UnitPrice DESC) AS RowNum
FROM Products;
/*RANK()		Asigna un rango a cada fila dentro de una particion ordenada. 
	Puede haber empates y los valores consecutivos pueden omitirse
  RANK() OVER ( [PARTITION BY partition_expression, ... ] ORDER BY sort_expression [ASC | DESC], ... ]
 DENSE_RANK()	Similar a RANK(), pero los valores consecutivos no se omiten en caso de empates
 DENSE_RANK() OVER ( [PARTITION BY partition_expression, ... ] ORDER BY sort_expression [ASC | DESC], ... ]
 */
 SELECT CategoryID ,ProductID, ProductName, QuantityPerUnit, UnitPrice,
	DENSE_RANK() OVER(PARTITION BY CategoryID ORDER BY UnitPrice DESC) AS DesRanking,
 	RANK() OVER(PARTITION BY CategoryID ORDER BY UnitPrice DESC) AS Ranking,
	ROW_NUMBER() OVER(PARTITION BY CategoryID ORDER BY UnitPrice DESC) AS RowNum
FROM Products;

 SELECT ProductID, ProductName, QuantityPerUnit, UnitPrice,
	DENSE_RANK() OVER(ORDER BY UnitPrice DESC) AS Ranking
FROM Products;

/*Funciones de Desplazamiento de Ventanas
	Permite acceder a valores de otras filas dentre de una particion en funcion de un orden especifico*/

/*LEAD() permite acceder al valor de una columna en una fila posterior dentro de una particion, segun el orden especificado por la clausula ORDER BY
LEAD(column_expression, offset, default_value) OVER ( [PARTITION BY partition_expression, ... ] ORDER BY sort_expression [ASC | DESC], ... ]
LAG() permite acceder al valor de una columna en una fila anterior dentro de una particion, segun el orden especificado por la clausula ORDER BY
*/
SELECT O.OrderID, O.OrderDate from Orders O ORDER BY O.OrderDate DESC;
select O.OrderID, O.OrderDate,
	LAG(O.OrderID) OVER(ORDER BY O.OrderDate  DESC) AS OrdenAnterior,
	LEAD(O.OrderID) OVER(ORDER BY O.OrderDate  DESC) AS OrdenSiguiente
	from Orders O ;


/*Funciones de Agregacion de Ventanas
SUM(), AVG(), MIN(), MAX()
SUM(column_expression) OVER (PARTITION BY partition_expression ORDER BY sort_expression)
*/
SELECT OD.OrderID, OD.ProductID, OD.Quantity,
	CONCAT(E.FirstName,' ',E.LastName) 'Vendedor', --P.ProductName 'Producto',
	O.OrderDate 'FechaOrden', 
	SUM(OD.Quantity)  OVER(PARTITION BY E.FirstName,E.LastName  ORDER BY O.OrderDate) AS 'CantVenta'
	FROM Orders O
	INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
	--INNER JOIN Products P ON OD.ProductID = P.ProductID
	INNER JOIn Employees E ON O.EmployeeID = E.EmployeeID
	WHERE O.OrderDate ='1996-07-25'
	ORDER BY Vendedor, O.OrderDate;

--con Group by
SELECT 
	CONCAT(E.FirstName,' ',E.LastName) 'Vendedor', --P.ProductName 'Producto',
	O.OrderDate 'FechaOrden', 
	SUM(OD.Quantity)  AS 'CantVenta'
	FROM Orders O
	INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
	--INNER JOIN Products P ON OD.ProductID = P.ProductID
	INNER JOIn Employees E ON O.EmployeeID = E.EmployeeID
	WHERE O.OrderDate ='1996-07-25'
	GROUP BY  O.OrderDate, E.FirstName, E.LastName
	ORDER BY Vendedor, O.OrderDate;




	SELECT DISTINCT--OD.OrderID, OD.ProductID, OD.UnitPrice,
	CONCAT(E.FirstName,' ',E.LastName) 'Vendedor', --P.ProductName 'Producto',
	O.OrderDate 'FechaOrden', 
	SUM(OD.UnitPrice)  OVER(PARTITION BY E.FirstName,E.LastName  ORDER BY O.OrderDate) AS 'Venta',
	AVG(OD.UnitPrice)  OVER(PARTITION BY E.FirstName,E.LastName  ORDER BY O.OrderDate) AS 'VentaAVG',
	MIN(OD.UnitPrice)  OVER(PARTITION BY E.FirstName,E.LastName  ORDER BY O.OrderDate) AS 'VentaMIN',
	MAX(OD.UnitPrice)  OVER(PARTITION BY E.FirstName,E.LastName  ORDER BY O.OrderDate) AS 'VentaMAX',
	COUNT(OD.UnitPrice)  OVER(PARTITION BY E.FirstName,E.LastName  ORDER BY O.OrderDate) AS 'VentaCount'
	FROM Orders O
	INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
	--INNER JOIN Products P ON OD.ProductID = P.ProductID
	INNER JOIn Employees E ON O.EmployeeID = E.EmployeeID;
