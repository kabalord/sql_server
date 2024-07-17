/*BEGIN TRY
    -- Bloque de código donde se realiza una operación potencialmente peligrosa
END TRY
BEGIN CATCH
    -- Manejo del error, acciones a tomar en caso de error
END CATCH*/
--SELECT * FROM Employees where EmployeeID = 1;
--select LEN('Miranda de Jesus')

--Divicion entre cero
CREATE OR ALTER PROCEDURE ValidaDivCero
	 @num1 INT,
	 @num2 INT
AS
BEGIN
	DECLARE @Result INT;
	BEGIN TRY
		SELECT @Result = @num1/@num2;
		PRINT CONCAT_WS(' ','El resultado de la division de', CONCAT_WS(' / ',@num1,@num2), 'es',@Result);
		PRINT 'FINAL SIN ERROR'
	END TRY
	BEGIN CATCH
		--PRINT 'Error el divisor no puede ser cero';
		PRINT CONCAT_WS(' ', 'ERROR: En la linea',ERROR_LINE(),'se te presento el error',ERROR_MESSAGE(),'Comunicalo al administrador del sistema');
	END CATCH
END;

EXEC ValidaDivCero 10, 3;
--Captura de informacion del Error
/*ERROR_MESSAGE(): Retorna el mensaje de error generado.
ERROR_NUMBER(): Retorna el número de error.
ERROR_STATE(): Retorna el estado del error.
	0: Este valor indica que no se ha proporcionado un estado específico para el error. 
		Puede ocurrir en algunos casos en los que el estado no está definido o no es aplicable.
	1: Es común ver este valor en muchos errores de usuario y errores de sistema generales. 
		Indica que no hay un estado específico asociado con el error.
	10: Algunos errores relacionados con la sintaxis o la ejecución de comandos pueden devolver este valor como estado.
	11-19: Estos valores de estado se utilizan a menudo para proporcionar información específica sobre el error. 
		Pueden indicar, por ejemplo, problemas de restricciones de clave, errores de conversión de tipos de datos, etc.
	20-25: Estos valores de estado se utilizan para indicar errores graves que pueden detener la ejecución del lote de comandos o la transacción. 
		Por ejemplo, un estado de 25 podría indicar una violación de restricción de clave única que detiene la ejecución de una instrucción.
ERROR_SEVERITY(): Retorna la gravedad del error.
	Gravedad 0-10: Errores informativos.
	Gravedad 11-16: Errores de advertencia que no detienen la ejecución.
	Gravedad 17-25: Errores graves que detienen la ejecución de la instrucción.
ERROR_LINE(): Retorna el número de línea en el que ocurrió el error.*/
select 10/0;


--Divicion entre cero
CREATE OR ALTER PROCEDURE ValidaDivCeroV2
	 @num1 INT,
	 @num2 INT
AS
BEGIN
BEGIN TRANSACTION;
	DECLARE @Result INT;
	BEGIN TRY
		SELECT @Result = @num1/@num2;
		PRINT CONCAT_WS(' ','El resultado de la division de', CONCAT_WS(' / ',@num1,@num2), 'es',@Result);
		COMMIT TRANSACTION;
		PRINT 'FINAL SIN ERROR'
	END TRY
	BEGIN CATCH
	-- Si se produce un error, deshacer la transacción
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		--PRINT 'Error el divisor no puede ser cero';
		PRINT CONCAT_WS(' ', 'ERROR: En la linea',ERROR_LINE(),'se te presento el error',ERROR_MESSAGE(),'Comunicalo al administrador del sistema');
	END CATCH
END;

EXEC ValidaDivCeroV2 10, 0;


SELECT * FROM Categories;
SELECT * FROM Region;
SELECT LEN('Prueba de errores en un SP donde logro validar que controle el tamaño del campo');
--SP que controla el registo de una categoria y la actualizacion de una region
EXEC RegCat_ModReg 'Prueba de erro', 'Descripcion', 1, 'Prueba de errores en un SP donde logro validar que controle el tamaño del campo';
CREATE OR ALTER PROCEDURE RegCat_ModReg
	@CategName NVARCHAR(20),--max 15
	@CateDesc NVARCHAR(MAX), 
	@RegId	INT,
	@RegDesc NVARCHAR(50),--max 50
	@CatePictu IMAGE = NULL
AS
BEGIN
	--DECLARACION DE VARIABLES

	--Iniciamos la Transaccion
	BEGIN TRANSACTION;

	--Iniciar el bloque de control de errores
	BEGIN TRY
		--Incluir el codigo que es puediera generar errores
		INSERT INTO Categories (CategoryName,Description,Picture) VALUES
			(@CategName,@CateDesc,@CatePictu);

		UPDATE Categories
			SET CategoryName = @RegDesc 
		WHERE CategoryID = @RegId;

		UPDATE Region
			SET RegionDescription = @RegDesc 
		WHERE RegionID = @RegId;



		--Si todo esta ok se cierra la transaccion
		COMMIT;
	END TRY
	BEGIN CATCH
	-- Si se produce un error, deshacer la transacción
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		PRINT CONCAT_WS(' ', 'ERROR: En la linea',ERROR_LINE(),'se te presento el error',ERROR_MESSAGE(),'Comunicalo al administrador del sistema');
	END CATCH

END;

ALTER TABLE Region ALTER COLUMN RegionDescription NVARCHAR(50) NOT NULL;










BEGIN TRY
	DECLARE @CANTEMP INT;--Declarar una variable
    BEGIN TRANSACTION
	-- Realizar operaciones dentro de la transacción
	UPDATE Employees 
		SET Title = 'Bogota'
	where EmployeeID = 1;

	UPDATE Employees 
		SET FirstName = 'Miranda de Jesus'
	where EmployeeID = 1;

	--Elimar empleados de Seattle
	/*SELECT @CANTEMP =  COUNT(*) FROM EmployeesA where City ='Seattle';
	PRINT 'La cantidad es: '+CAST(@CANTEMP AS CHAR(2));--Convertir a caracter un entero
							--CONVERT(CHAR(2),@CANTEMP)*/
	IF (SELECT COUNT(*) FROM Employees where City ='Caracas') > 0
		DELETE Employees  where City ='Caracas';
	ELSE
		PRINT 'No existian empleados de la Ciudad de Caracas';

	-- Confirmar la transacción
	COMMIT TRANSACTION;
	PRINT 'Actualizaciones realizadas Correctamente';
END TRY
BEGIN CATCH
    -- Si se produce un error, deshacer la transacción
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
	--ELSE
		--operacion a ejecutar si la condicion da como resultado FALSE

	--Mensaje del error
	PRINT 'Se produjo un error porque el valor del FirtName es mayor a 10 caracteres-->'+ERROR_MESSAGE();
END CATCH








