/*Diseño e implementación de funciones definidas
	Funciones definidas por el usuario; son objetos que se utilizan para realizar operaciones especificas y retornar un valor.

Hay dos tipos principales de funciones definidas por el usuario en SQL Server: 

	*-Funciones escalares: Una función escalar devuelve un solo valor basado en los argumentos de entrada. 
	*-Funciones de valor tabla(TVF): devuelven un conjunto de filas(tabla) basado en los parametros de entrada
*/
--Crear un funcion escalar
--Ejemplo de funcion que multiplica dos valores
CREATE OR ALTER FUNCTION MultiplicadorValores(@valor1 INT, @valor2 INT)
RETURNS INT
AS
BEGIN
	--Declarar Variables
	DECLARE @result INT;

	--Logica de la funcion
	SET @result = @valor1 * @valor2;

	--Retorno el resultado
	RETURN @result;

END;

--Llamar la funcion
BEGIN
	DECLARE @resulFunci INT;
	SET @resulFunci = dbo.MultiplicadorValores(4,3);
	PRINT @resulFunci ;
END;

SELECT OrderID, UnitPrice, (UnitPrice * dbo.MultiplicadorValores(4,3)) 'rESULTA'
	FROM [Order Details] 
 
/*
	*-Funciones de tabla: Las funciones de tabla devuelven un conjunto de datos como resultado
		_Funciones de tabla en línea(Inline Table Valued Funtions ITVF); son la que se definen usando la
			clausula 'RETURNS TABLE' y retornan una tabla como resultado, pueden utilizar la clausula 'FROM'
			de una consulta como si fuera una tabla real.
*/


--Funcion que retorna el listado de clientes por Pais
CREATE FUNCTION dbo.ConsultaClientesxCountry(@Country VARCHAR(50))
RETURNS TABLE
AS
RETURN(
	SELECT CustomerID, CompanyName
		FROM Customers
		WHERE Country LIKE '%'+@Country+'%'
);
SELECT * FROM Customers where Country = 'UK';
SELECT * FROM dbo.ConsultaClientesxCountry('UK');



/*		_Funciones de tabla con valores de tabla(Multi-statement Table Valued Funtions MSTVF)
			Son aquellas que se definen utilizando clausula 'RETURNS @variableTabla TABLE y 
				permiten realizar múltiples declaraciones dentro de la función antes de devolver la tabla resultant
*/

select * from Employees
Select * from Orders
Select * from Shippers
--Funcion que retorna tabla con empleado flete facturado por compañia de transporte
CREATE OR ALTER FUNCTION dbo.FleteFacturadoxEmpleado(@CompShipper INT)
RETURNS @FletexEmpleado TABLE
(
	Empleado VARCHAR(200),
	FleteFacturado DECIMAL(10,2),
	Shipper VARCHAR(20)
)
AS
BEGIN
	INSERT INTO  @FletexEmpleado (Empleado, FleteFacturado, Shipper)
	SELECT E.FirstName+' '+E.LastName AS Empleado, SUM(O.Freight) FleteFacturado, S.CompanyName as Shipper
		FROM Orders O
			JOIN Employees E ON O.EmployeeID = E.EmployeeID
			JOIN Shippers S ON O.ShipVia = S.ShipperID
				AND S.ShipperID = @CompShipper 
			GROUP BY E.EmployeeID, S.CompanyName, E.FirstName, E.LastName;
			---OTRAS OPERACIONES aDICIONALES
	RETURN;
END;

SELECT * FROM dbo.FleteFacturadoxEmpleado(3);


/*Alternativas a las funciones
	-Procedimientos Almacenados
	-Vistas
	-Consultas ad hoc son consultas directas

Funciones del Sistema

*-Funciones de Agregacion
	-SUM()
	-AVG()
	-COUNT()
	-MIN()
	-MAX()

*-Funciones de Cadena
	-LEN()
	-SUBSTRING()
	-CONCAT()
	-CHARINDEX()

*-Funciones de Tiempo (Fecha y Hora)
	-GETDATE()
	-DATEDIFF()
	-DATEPART()

*-FUNCIONES LOGICA
	-IF()
	-CASE


*

*/
--Funciones de informacion sobre el entorno de la BD
	--Funcion para obtener informacion del servidor
	SELECT @@VERSION;
	SELECT @@CPU_BUSY;
	SELECT @@SERVERNAME, @@LANGUAGE, @@SPID;

	--Funciones para obtener informacion de configuracion
	SELECT * FROM sys.databases WHERE name = 'Northwind';

	select DB_NAME(), OBJECT_SCHEMA_NAME(5)




/*Consideraciones para implementar las funciones

	1-Rendimiento
	2-Reutilizacion de Codigo
	3-Manejo de Errores
	4-Seguridad
	5-Parametros y Tipos Datos
	6-Complejidad y Legibilidad
	7-Indices y Estadisticas
	8-Uso Responsable
	9-Documentacion
	10-Pruebas*/