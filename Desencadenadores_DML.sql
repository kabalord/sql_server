/*Desencadenadores DML
	Son objetos de base de datos que se utilizan para automatizar acciones o realizar verificaciones antes o 
	después de que se ejecuten ciertas operaciones de manipulación de datos, como INSERT, UPDATE o DELETE, 
	en una tabla específica.
*/

/*Diseño de desencadenadores DML

	1. Definir el Proposito
		*-Auditar cambios
		*-Aplicar reglas de negocios especificas
		*-Mantener la consistencias de los Datos

	2.-Seleccionar el Momento Adecuado
		*-Antes		(BEFORE)
		*-Despues	(AFTER)

	3.Escribir el Codigo T-SQL
		*Tablas Mágicas: inserted y deleted
			-Tabla inserted:
				_Contiene: Las filas que se están insertando o las nuevas versiones de las filas 
					que se están actualizando.
				_Operaciones Relevantes: INSERT, UPDATE.
			-Tabla deleted:
				_Contiene: Las filas que se están eliminando o las versiones antiguas de las filas 
					que se están actualizando.
				_Operaciones Relevantes: DELETE, UPDATE.


		*-Estrutura de un Desencadenador
*/
		CREATE TRIGGER nombre_desencadenador
		ON nombre_tabla
		AFTER INSERT, UPDATE, DELETE --Especifico el Momento y las Operacion que lo dispara
		AS
		BEGIN
			--Codigo de acciones a realizar
		END;

/*	4.Considerar el Rendimiento
	
	5.Puede manejar Multiples Filas

	6.Probar y Validar

	7.Gestión y Manteniento
	
	
Eventos Permitidos para Disparadores:

-A nivel de tabla: INSERT, UPDATE, DELETE
-A nivel de servidor: CREATE LOGIN, DROP LOGIN, CREATE DATABASE, ALTER DATABASE, entre otros.
*/

select * from Shippers;
CREATE TRIGGER TR_InsertShippers
ON Shippers
AFTER INSERT
AS
BEGIN
	PRINT 'Se inserto un nuevo registro en la tabla de Shippers';
END;

INSERT INTO Shippers (CompanyName, Phone)
	VALUES('Jorge','564656546');
UPDATE Shippers
	set CompanyName ='Jorge'
	where ShipperID =10;

--Verificar la existencia del Desencadenador
SELECT  * FROM sys.triggers where name='TR_InsertShippers';

--Deshabilitar un Trigger
DISABLE TRIGGER TR_InsertShippers ON Shippers;
--Habilitar un Trigger 
ENABLE TRIGGER TR_InsertShippers ON Shippers;

--Modificar un Trigger
ALTER TRIGGER TR_InsertShippers
ON Shippers
AFTER INSERT, UPDATE
AS
BEGIN
	PRINT 'Se inserto un nuevo registro en la tabla de Shippers V2';
END;

--Eliminar un Trigger
DROP TRIGGER TR_Shippers;

/*Consejos Adiconales
	*-Transacciones y Control de Errores
	*-Pruebas Rigurosa
	*-Monitoreo y Mantenimiento*/

--Ejemplo de un Trigger de Auditoria
	--1 Identificar la tabla Auditar
	--2 Crear la tabla Auditoria.
	drop table AuditoriaShippers;
	CREATE TABLE AuditoriaShippers(
		AuditoriaShiID INT IDENTITY(1,1) PRIMARY KEY,
		Operacion varchar(10),
		Tabla varchar(50),
		ShipperID INT,
		AccionRealizada VARCHAR(100),
		Sentecia NVARCHAR(MAX),
		Usuario VARCHAR(100),
		Evento XML,
		FechaAuditoria DATETIME
	);

	--3 Crear el Trigger
	CREATE OR ALTER TRIGGER TR_Shippers
	ON Shippers
	AFTER INSERT, DELETE, UPDATE
	AS
	BEGIN
		BEGIN TRY
			DECLARE @Usuario varchar(100);
			DECLARE @sentencia NVARCHAR(MAX);
			DECLARE @Evento XML;
			DECLARE @Operacion VARCHAR(10);
			

			SET @Usuario = SUSER_NAME();
			SET @Evento = EVENTDATA();--devuelve un Objeto XML que contiene informacion sobre el evento q activo el trigger
			PRINT '1--->'+CONVERT(NVARCHAR(MAX),@Evento);
			--Capturar la Operacion
			SELECT @Operacion = CASE
								WHEN EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) THEN 'UPDATE'
								WHEN EXISTS (SELECT * FROM inserted) THEN 'INSERT'
								WHEN EXISTS (SELECT * FROM deleted) THEN 'DELETE'
								END;


			PRINT '2--->'+@Operacion;
			--Capturar la sentencia ejecutada
			/*SELECT @sentencia = 'INSERT INTO Shippers (ShipperID,CompanyName, Phone) 
									VALUES ('+CONVERT(nvarchar, i.ShipperID)+','+i.CompanyName+','+i.Phone+');'
			FROM inserted i;*/
			IF @Operacion = 'DELETE'
				BEGIN
	
						--Capturar la sentencia ejecutada
					SELECT @sentencia = 'DELETE FROM Shippers WHERE ShipperID = '+CONVERT(nvarchar, i.ShipperID)
					FROM deleted i;

				INSERT INTO AuditoriaShippers(Operacion,Tabla, ShipperID, AccionRealizada, Sentecia, Usuario, Evento, FechaAuditoria)
				SELECT 
					@Operacion,
					'Shippers',
					i.ShipperID, 
					'Se Borro un registro Shippers',
					@sentencia,
					@Usuario,
					@Evento,
					GETDATE()
				FROM  deleted i;
					--Imprimo el contenido de la tabla magina 'deleted'
					SELECT * INTO #TablaMagica FROM deleted;
					SELECT * FROM #TablaMagica;
					DROP TABLE #TablaMagica;
				END
				ELSE
					BEGIN
				SELECT @sentencia = 'INSERT INTO Shippers (ShipperID,CompanyName, Phone) 
											VALUES ('+CONVERT(nvarchar, i.ShipperID)+','+i.CompanyName+','+i.Phone+');'
					FROM inserted i;
					INSERT INTO AuditoriaShippers(Operacion,Tabla, ShipperID, AccionRealizada, Sentecia, Usuario, Evento, FechaAuditoria)
					SELECT 
						@Operacion,
						'Shippers',
						i.ShipperID, 
						'Se '+@Operacion+' un registro Shippers',
						@sentencia,
						@Usuario,
						@Evento,
						GETDATE()
					FROM  inserted i;
						--Imprimo el contenido de la tabla magina 'inserted'
						SELECT * INTO #TablaMagica2 FROM inserted;
						SELECT * FROM #TablaMagica2;
						DROP TABLE #TablaMagica2;
					END;

		PRINT 'EXITO';

		END TRY
		BEGIN CATCH
			PRINT ERROR_MESSAGE();

		END CATCH
	END;



select * from Shippers;
select * from AuditoriaShippers;

delete from Shippers where CompanyName = 'Jorge';

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Shippers';


/*Conceptos Avanzados de los disparadores
	1.-Disparadores Anidados
		-Evitar los bucles infinitos o situacion donde se llamen mutuamente
		-Anidados extensos
	2.Uso de Funciones Inline para acciones comunes
	3.Manejo de Transacciones
	4.Tablas Magicas Deleted e Inserted
	5.Gestion de Errores
	6.Optimizar el rendimeinto
	7.Filtrado de Desencadenadores
		-Por Operaciones (INSERT, DELETE, UPDATE)
		-Por columna Modifica
		-Por condicion especifica
		-Por Usuario o Roles
	8.Seguridad
	9.Pruebas exhaustivas
*/


CREATE OR ALTER TRIGGER TR_AuditarShippers
ON Shippers
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        DECLARE @UsuarioAuditoria VARCHAR(100);
        DECLARE @FechaAuditoria DATETIME;
        DECLARE @Antes XML;
        DECLARE @Despues XML;

        SET @UsuarioAuditoria = SUSER_SNAME();
        SET @FechaAuditoria = GETDATE();

        -- Capturar datos antes y después de la actualización
        SELECT @Antes = (
            SELECT *
            FROM deleted AS D
            FOR XML AUTO, ELEMENTS, ROOT('Antes')
        );

        SELECT @Despues = (
            SELECT *
            FROM inserted AS I
            FOR XML AUTO, ELEMENTS, ROOT('Despues')
        );

        -- Insertar registro de auditoría
        INSERT INTO LogAuditoria (Tabla, Operacion, Detalle, Usuario, Fecha)
        VALUES ('Shippers', 'UPDATE', 
                'Datos antes de la actualización: ' + ISNULL(CONVERT(NVARCHAR(MAX), @Antes), 'No disponible')+ 
                ' Datos después de la actualización: ' + ISNULL(CONVERT(NVARCHAR(MAX), @Despues), 'No disponible'),
                @UsuarioAuditoria, @FechaAuditoria);

        PRINT 'Auditoría de actualización realizada correctamente.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;

CREATE TABLE LogAuditoria(
	idLogAuditoria INT IDENTITY(1,1) PRIMARY KEY,
	Tabla NVARCHAR(10)NOT NULL,
	Operacion NVARCHAR(10)NOT NULL,
	Detalle NVARCHAR(max),
	Usuario VARCHAR(100),
	Fecha DATETIME
);

select * from LogAuditoria