# SP ejemplo

--Cuantas Ordenes de Compra x Cliente
SELECT C.CustomerID, C.CompanyName, COUNT(O.OrderID) 'CantCompras', MAX(O.OrderDate) 'UltimaCompra' FROM
	Orders O
	INNER JOIN Customers C ON O.CustomerID = C.CustomerID
	GROUP BY C.CustomerID, C.CompanyName;

--SP
CREATE OR ALTER PROCEDURE ComprasXCliente
AS
BEGIN
	SELECT C.CustomerID, C.CompanyName, COUNT(O.OrderID) 'CantCompras', MAX(O.OrderDate) 'UltimaCompra' FROM
	Orders O
	INNER JOIN Customers C ON O.CustomerID = C.CustomerID
	GROUP BY C.CustomerID, C.CompanyName;
END;

--Para ejecutar un procedimiento almacenado
--EXEC EXECUTE
EXEC ComprasXCliente;

--Variables de entrada
--Consultar las ordenes por cliente y rango de fecha
SELECT C.CustomerID, C.CompanyName, O.*
	FROM Orders O
	INNER JOIN Customers C ON O.CustomerID = C.CustomerID;

CREATE PROCEDURE SP_ConslOrdenxClientFecha
	--Parametros de entrada
	@ClienteID CHAR(6),
	@FechaDesde DATE,
	@FechaHasta DATE = NULL --parametro no obligatorio se le asigna un valor predetermido
AS
BEGIN
SELECT C.CustomerID, C.CompanyName, O.*
	FROM Orders O
	INNER JOIN Customers C ON O.CustomerID = C.CustomerID
	WHERE C.CustomerID = @ClienteID
		AND O.OrderDate BETWEEN @FechaDesde AND COALESCE(@FechaHasta, GETDATE());
END;


CREATE PROCEDURE SP_ConslOrdenxClientFechaV2
	--Parametros de entrada
	@ClienteID CHAR(6),
	@FechaDesde DATE,
	@FechaHasta DATE = NULL --parametro no obligatorio se le asigna un valor predetermido
AS
BEGIN
IF @FechaHasta IS NULL
	SET @FechaHasta = GETDATE();
SELECT C.CustomerID, C.CompanyName, O.*
	FROM Orders O
	INNER JOIN Customers C ON O.CustomerID = C.CustomerID
	WHERE C.CustomerID = @ClienteID
		AND O.OrderDate BETWEEN @FechaDesde AND @FechaHasta;
END;

EXECUTE SP_ConslOrdenxClientFecha @ClienteID = 'VINET', @FechaDesde = '1996-01-01', @FechaHasta = '1996-12-31'
EXECUTE SP_ConslOrdenxClientFecha @ClienteID = 'VINET', @FechaDesde = '1996-01-01'
EXECUTE SP_ConslOrdenxClientFechaV2 @ClienteID = 'VINET', @FechaDesde = '1996-01-01'

--Procedemiento que retorna un parametro de salida
--Consultar la direccion de un cliente
SELECT C.CustomerID, CONCAT_WS(' - ', C.Country, C.PostalCode) 'Direccion' FROM Customers C

CREATE PROCEDURE SP_DirCliente
	@ClienteID CHAR(5),				--parametro de entrada
	@Direccion VARCHAR(50) OUTPUT	--parametro de salida
AS
BEGIN
--Asignacion de valor directo
--SET @Direccion ='Nueva Direccion';

--Asignacion por consulta
	SELECT @Direccion = CONCAT_WS(' - ', C.Country, C.PostalCode) FROM Customers C
		WHERE C.CustomerID = @ClienteID;
END;
--No lo puedo ejecutar de estar forma porque el espera asiganar el valor que retorna
--EXEC SP_DirCliente @ClienteID= 'ALFKI'
DECLARE @Cliente CHAR(5) = 'VINET';
DECLARE @Result VARCHAR(50);

EXEC SP_DirCliente  @Cliente, @Result OUTPUT;

SELECT @Result AS 'Direccion del Cliente';
