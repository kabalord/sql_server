--T-SQL ejemplo

/* T-SQL es al extencion procedural de SQL y se utlizan dentro de SQL para poder 
	escribir los procedimientos	almacenados, Desecadenadores, funciones

-Variables
-Controles de Flujos
-Invocacion a Triggers
-Manejo de Errores TRY..CATCH
-CTE
*/

--Consulta simple
SELECT * FROM Employees WHERE EmployeeID = 8;

--Procedimiento Almacenado
CREATE PROCEDURE ConsultarEmpleados
AS
BEGIN
	SELECT * FROM Employees;
END;



--Parametros
ALTER PROCEDURE ConsultarEmpleados
	@IdEmpleado INT
AS
BEGIN
	SELECT * FROM Employees WHERE EmployeeID = @IdEmpleado;
END;




--Varibles 
ALTER PROCEDURE ConsultarEmpleados
	@IdEmpleado INT
AS
BEGIN
	DECLARE @var INT = 1;

	SELECT @var 'Variable',* FROM Employees WHERE EmployeeID = @IdEmpleado;
END;



--Delimitacion de lotes
--1.- "GO" se utiliza para separar los bloques de comandos en SQlServer
DECLARE @Variable INT;
SET @Variable = 31;
SELECT @Variable;
GO
DECLARE @Variable INT;
SELECT @Variable;

--2.Transacciones
BEGIN TRANSACTION
	select * FROM Region Order by RegionID desc;
	INSERT INTO Region VALUES(15,'China');
	select * FROM Region Order by RegionID desc;
--ROLLBACK TRANSACTION
COMMIT TRANSACTION

--3.BEGIN...END
BEGIN
	DECLARE @Variable INT;
	SET @Variable = 31;
END;
BEGIN
	SELECT @Variable;
END;




--Control de flujo IF	IF..ELSE	CASE	WHILE

CREATE OR ALTER PROCEDURE ConsultarEmpleados
	@IdEmpleado INT
AS
BEGIN
	DECLARE @var INT = 1;
	DECLARE @mensaje VARCHAR(MAX);
	DECLARE @idEmpMax INT;
	SET @mensaje = '';
	SELECT @idEmpMax = MAX(EmployeeID) FROM Employees;

	IF @IdEmpleado < @idEmpMax
	BEGIN
		WHILE @var <= 5
		BEGIN
			SELECT @mensaje = 'Variable-->' + CAST(@var AS varchar(50)) +' '+ CAST(EmployeeID AS varchar(50))+'-'+FirstName+' '+LastName+', ' 
				FROM Employees WHERE EmployeeID = @IdEmpleado+@var;
		
			SET @var = @var + 1;
			PRINT @mensaje;
		END;
	END
	ELSE
		BEGIN
		PRINT 'No existen empleados con ID superior al enviado';
		PRINT 'FIN Else';
		END;
END;

SELECT * FROM Employees
EXEC ConsultarEmpleados 3;

-- IF..ELSE
CREATE OR ALTER  PROCEDURE ConsultarEmpleados
	@IdEmpleado INT
AS
BEGIN
	DECLARE @var INT = 1;
	DECLARE @mensaje VARCHAR(MAX);
	SET @mensaje = '';

	WHILE @var <= 5
	BEGIN
		SELECT @mensaje = 'Variable-->' + CAST(@var AS varchar(50)) +' '+ CAST(EmployeeID AS varchar(50))+'-'+FirstName+' '+LastName+', ' 
			FROM Employees WHERE EmployeeID = @IdEmpleado+@var;
		
		IF 1 = (@var%2)
		BEGIN
			PRINT CAST(@var AS varchar(50)) +' Es Impar';
		END
		ELSE
		BEGIN
			PRINT CAST(@var AS varchar(50)) +' Es  Par';
		END;
		PRINT @mensaje;
		SET @var = @var + 1;
	END;
END;

SELECT * FROM Employees
UPDATE Employees SET TitleOfCourtesy ='Mr.' WHERE EmployeeID >5
--CASE
CREATE OR ALTER PROCEDURE ConsultarEmpleados
	@IdEmpleado INT
AS
BEGIN
	DECLARE @var INT = 1;
	DECLARE @mensaje VARCHAR(MAX);
	SET @mensaje = '';
	DECLARE @TituloCortesia  VARCHAR(20);
	DECLARE @TituFinal VARCHAR(50);

	WHILE @var <= 5
	BEGIN


	SELECT @TituloCortesia = TitleOfCourtesy
			FROM Employees WHERE EmployeeID = @IdEmpleado+@var;
					--CASE
	SELECT @TituFinal = 
		CASE @TituloCortesia
			WHEN 'Ms.' THEN 'Señorita'
			WHEN 'Dr.' THEN 'Doctor'
			WHEN 'Mrs.' THEN 'Señora'
			WHEN 'Mr.' THEN 'Señor'
			ELSE 'Titulo de Cortesia NO DEFINIDO'
		END;

		SELECT @mensaje = 'Variable-->' + CAST(@var AS varchar(50)) +' '+ CAST(EmployeeID AS varchar(50))+'-'+
			CONCAT_WS(' ', @TituFinal,FirstName)+' '+LastName+', ' 
			FROM Employees WHERE EmployeeID = @IdEmpleado+@var;
			
		IF 1 = (@var%2)
		BEGIN
			PRINT CAST(@var AS varchar(50)) +' Es Impar';
		END
		ELSE
		BEGIN
			PRINT CAST(@var AS varchar(50)) +' Es  Par';
		END;
		PRINT @mensaje;
		SET @var = @var + 1;
	END;
END;





ALTER PROCEDURE ConsultarEmpleados2
	@NOMEmpleado VARCHAR(50)
AS
BEGIN
	DECLARE @var INT = 1;

	SELECT @var 'Variable',* FROM Employees WHERE FirstName = @NOMEmpleado;
END;


EXEC ConsultarEmpleados2 'Janet; DELETE FROM Employees WHERE EmployeeID = 1';
--QUOTENAME podemoa agregar delimitadores ea una cadena de texto
--QUOTENAME ( 'cadena', 'delimitador' ) sino se propociona el delimitador el utiliza por defecto los []
SELECT name FROM sys.tables;


select * FROM Northwind.dbo.Employees
--SINONIMOS
--Sinonimo a una Tabla
DROP SYNONYM Trabajadores;
CREATE SYNONYM Trabajadores FOR Northwind.dbo.Employees;
SELECT * from Trabajadores;
CREATE SYNONYM Trabajadores FOR Northwind.dbo.;


CREATE SYNONYM BIAutor FOR Biblioteca.dbo.AUTOR;
select * from BIAutor;
--Sinonimo de un Procedimiento
CREATE SYNONYM Proce002 FOR ConsultarEmpleados;
EXEC Proce002 6;

SELECT * FROM sys.synonyms
--T-SQL Transact-SQL