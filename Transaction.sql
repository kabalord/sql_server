
/*Propiedades:
	ACID (Atomicity, Consistency, Isolation, Durability)
  BEGIN TRANSACTION
  Controlar
  *COMMIT
  *ROLLBACK
  -SAVEPOINT



Exclusivo (X)
Compartido (S)
Actualización (U)
Intento (I)
Diagrama ( Sch
Actualización masiva (BU)


  Tipos de Bloqueo:
  -Bloqueo de Lectura (Compartido)
  -Bloqueo de Escritura (Exclusivo)
  -Bloqueo de Actualizacion
  -Bloqueo de Intencion
  -Bloqueo de Schema
  */

  /*Consulta de transacciones abiertas*/
SELECT
    *
FROM
    sys.dm_tran_active_transactions;

SELECT * FROM Employees where EmployeeID = 1;
BEGIN TRANSACTION
	UPDATE Employees 
		SET LastName = 'Marina'
	where EmployeeID = 1;
 COMMIT;
 ROLLBACK;







SELECT * FROM Employees where EmployeeID IN(1,2);

BEGIN TRANSACTION
	UPDATE Employees 
		SET Title = 'Alex'
	where EmployeeID = 1;

	SAVE TRANSACTION Savepoint1;
	UPDATE Employees 
		SET Title = 'Miguel'
	where EmployeeID = 1;

	UPDATE Employees 
		SET Title = 'TOMAS'
	where EmployeeID = 2;
COMMIT TRANSACTION;
ROLLBACK TRANSACTION Savepoint1;

--Consulta de bloqueos
SELECT *
FROM sys.dm_tran_locks;

--Trasancciones encadenadas
SELECT * FROM Region;
ALTER TABLE Region ALTER COLUMN RegionDescription nchar(20) NOT NULL;

BEGIN TRANSACTION
	INSERT INTO Region (RegionID, RegionDescription)
		VALUES
		(4, 'Caracas'),(8,'Francia'),(6,'Bogota');
	SAVE TRANSACTION P1;
	BEGIN TRANSACTION
		UPDATE Region
			SET RegionDescription = 'Venezuela' where RegionID in (1,2,3);
	COMMIT TRANSACTION;

	BEGIN TRANSACTION
		DELETE Region WHERE RegionID in(20,21,22,23);
	COMMIT TRANSACTION;
	ROLLBACK TRANSACTION P1;

COMMIT TRANSACTION;
