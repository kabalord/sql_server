--# Procedimientos almacenados

/*Procedimientos Almacenados; son un conjunto de instrucciones SQL que se almacenan en el servidor y 
	se pueden ejecutar de manera repetitiva.*/
--Declaración de Parámetros
CREATE PROCEDURE Nomprocedimiento
	@Param1 TipoDato,
	@Param2 TipoDato,
	@......
	@ParaSalida TipoDato OUTPUT--parametro de salida
AS
BEGIN
	--Cuerpo de mi Procedimiento
END;

--Declaración de Variables Locales
DECLARE @Variables1 TipoDato;
DECLARE @Variables2 TipoDato;

--Sentencias SQL
-- Todas las sentencias DML,  CRUD
	INSERT, SELECT, UPDATE, DELETE 
--	DDL es frecuente que se utilice para elementos temporales
	CREATE, DROP, TRUNCATE, ALTER

--Control de Flujo
--Evaluaciones de condiciones IF, ELSE, WHILE, CASE
IF condicion
	BEGIN
		--Operaciones si la condicion es verdadera
	END
ELSE
	BEGIN
		--Operaciones si la condicion es falsa
	END;

--Manejo de Errores
BEGIN TRY
	--Incluir todas las instrucciones que puedan generar error
	INSERT
	UPDATE
	DELETE
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	--Se ejecuto solo si se presenta un error dentro del bloque TRY
	--Funciones para conecer el error
	ERROR_NUMBER(), ERROR_MESSAGE()......
	--Su funcion es permitir realizar funciones adicionales una vez se presente un error en el bloque TRY
END CATCH;

/*Transacciones, agrupa un conjunto de operaciones en un Unidad logica de trabajo permitiendo que se ejecuten
	con exito todas las operaciones o que ninguna de ella realice cambios 
	ACID
	Atomicidad	Consistencia Aislamiento Durabilidad*/
	COMMIT para guardar, si todo esta OK
	ROLLBACK para reversar, si se presento un fallo

	BEGIN TRANSACTION;
		--Operaciones de SQL
	COMMIT TRANSACTION; ROLLBACK TRANSACTION; 




select * from [Order Details]
select * from Region

ALTER PROCEDURE ConsultarVentaProducto
	@Producto VARCHAR(50)
AS
BEGIN
	BEGIN TRANSACTION;

	BEGIN TRY
	SELECT P.ProductName, SUM(OD.Quantity)*AVG(OD.UnitPrice) 'Venta'
		FROM Products P
		INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
		WHERE P.ProductName = @Producto
		GROUP BY P.ProductName;
		INSERT INTO  Region (RegionID,RegionDescription)
			values((SELECT MAX(RegionID)+1 FROM Region), @Producto);
		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		PRINT 'Se presento error en la consulta: '+ERROR_MESSAGE();
	END CATCH;
END;

EXEC ConsultarVentaProducto @Producto = 'KJFSDHDAJKJKSADHFJKSKJHFKJSAHKJFHKJSAHKJFHKJSDHFJKHSDJKHFKJSDHKJHFKJSHKJFHSDJKHFJKHSKJHFJKSDHKJDFHKJSDHKJFHKJSHDFJK';
/*Ejecutar procedimientos almacenados
--EXEC
--EXECUTE
--CALL
*/
