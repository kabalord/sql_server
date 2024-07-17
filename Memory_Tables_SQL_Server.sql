/*Tablas optimizadas para la memoria

	 Son estructuras de datos que se almacenan completamente en la memoria, a diferencia de las tablas 
	 tradicionales que se almacenan en disco.

**Ventajas:
	*-Alto rendimiento
	*-Menor uso de E/S
	*-Escalabilidad
	*-Optimizacion de concurrencia
	*-Menos bloqueos
	*-Durabilidad y Persistencia
	*-Mejoras en el procesamiento de transacciones

**Desventajas:
	*-Requisitos de memoria
	*-Limitaciones de Caracteristicas
	*-Limitaciones de funcionalidad
	*-Costo de mantenimiento

**Funcionamiento Interno en el Motor de BD
	*-Almacenamiento en Memoria(RAM)
	*-Control de Concurrencia(MVCC)
	*-Checkpoint y Log
	*-Compilacion Nativa
**Versiones de SQL Server que soportan la tablas en memoria(Ninguna de la version Gratuitas lo soporta)
	*-SQL Server 2014: Enterprise, Developer y Evaluation
	*-SQL Server 2016 y 2017: Enterprise, Developer y Evaluation
		Standard y Web soporta pero con ciertas limitaciones en cuanto al tamaño maximo de la memoria
			y el numero de indices soportados
	*-SQL Server 2019: Enterprise(Sin ninguna limitacion), Developer, Evaluation, Standard
		Standard soporta pero con ciertas limitaciones en cuanto al tamaño maximo de la memoria(32GB)
			y el numero de indices soportados(2GB)
	*-SQL Server 2022: Enterprise(Sin ninguna limitacion), Developer, Evaluation, Standard
		Standard soporta pero con ciertas limitaciones en cuanto al tamaño maximo de la memoria(32GB)
			y el numero de indices soportados(2GB)
	
**Estructura:
	-- Creación de una tabla optimizada para la memoria en SQL Server 2019
	CREATE TABLE dbo.MiTablaOptimizadaParaMemoria
	(
		ID INT IDENTITY PRIMARY KEY,
		Nombre NVARCHAR(100),
		Edad INT
	)
	WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);	
*/
--Ejemplo tabla optimizada en memoria para pedidos de una tienda online
CREATE TABLE DetallePedidos(
	ID INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
	PedidoID INT,
	ProductoID INT,
	Cantidad INT,
	Precio MONEY,
	INDEX ix_PedidoID NONCLUSTERED (PedidoID),
	INDEX ix_ProductoID NONCLUSTERED (ProductoID)
)WITH (MEMORY_OPTIMIZED = ON);

--Ajuste en la BD para trabajar con la Tablas optimizadas
--(Requerido) Tener desactivado el AUTO_CLOSE; para evitar que SQLServer cierre automaticamente la BD 
--despues de que todas las conexiones a la misma se hayan cerrado 
ALTER DATABASE Northwind
SET AUTO_CLOSE OFF;

--1_Crear un grupo de archivos optimizados para la memoria
ALTER DATABASE Northwind
ADD FILEGROUP TablasOptimizadasNorthwind CONTAINS MEMORY_OPTIMIZED_DATA;

--2_Agregar un contenedor al grupo de archivos optimizado para memoria
ALTER DATABASE Northwind
ADD FILE(NAME = 'NombreArchivo_TablasOptimizadasNorthwind', FILENAME = 'D:\TablasOptimizadasNorthwind')
	TO FILEGROUP TablasOptimizadasNorthwind;

SELECT SERVERPROPERTY ('IsHadrEnabled');  
/*Habilitar Always On Availability 
	Abre el "SQL Server Configuration Manager".
	Navega hasta las "Herramientas de SQL Server Services".
	Selecciona la instancia de SQL Server donde deseas habilitar Always On Availability Groups.
	Haz clic derecho en la instancia y selecciona "Propiedades".
	En la ventana de propiedades, ve a la pestaña "Always On High Availability".
	Marca la casilla que dice "Enable Always On Availability Groups".
	Haz clic en "Apply" (Aplicar) y luego en "OK" para cerrar la ventana de propiedades.*/



/**Consideraciones adicionales
	*-Monitoreo de memoria
	*-Índices
	*-Durabilidad SCHEMA_ONLY, SCHEMA_AND_DATA(garantiza la persistencia)
	*-Tamaño de las tablas
	*-Uso adecuado
	*-Migracion y Compatibilidad
*/


/*Procedimientos Almacenados Compilados de Forma Nativa
	Son una extensión de la funcionalidad de los procedimientos almacenados en SQL Server. 
	A diferencia de los procedimientos almacenados tradicionales, que se interpretan y ejecutan en tiempo de 
	ejecución, los procedimientos almacenados compilados de forma nativa se compilan en código máquina nativo 
	durante la creación o modificación del procedimiento almacenado

***Ventajas
	*-Rendimiento mejorado
	*-Menor sobrecarga de interpretación
	*-Optimización de código
	*-Mejora de la escalabilidad

***Desventajas
	*-Limitaciones de funcionalidad
	*-Mayor complejidad de desarrollo
	*-Gestion de Errores
	*-Tamaño del procedimiento almacenado

**Funcionamiento interno en el motor de BD
	*-Compilacion a Codigo nativo
	*-Manejo de concurrencia(MVCC)
	*-Optimizacion en Planes de Ejecucion

***Estructura
	CREATE PROCEDURE dbo.MyNativelyCompiledSP
	WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
	AS
	BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = N'us_english')
		-- Lógica del procedimiento almacenado aquí
	END;

***Consideraciones adicionales
	*-Compatibilidad
		-Funciones Escalares Definidas por el Usuario(UDF)
		-Operaciones Dinamicas(EXECUTE, sp_executesql, construcciones dinamicas de consultas SQL)
		-Funciones de Fecha y Hora No deterministas GETDATE(), SYSDATETIME()
	*-Deuracion
	*-Configuracion del Servidor
	*-Planificacion y Pruebas
*/

--Sistema de Registro de Evaluacion con procedimiento que me saca el promedio de Calificaciones
CREATE DATABASE AulaMatriz;
USE AulaMatriz;
--DROP TABLE Calificaciones
CREATE TABLE Calificaciones(
	ID_estudiante INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
	Nombre_estudiante VARCHAR(100) NOT NULL,
	Calificacion INT NOT NULL DEFAULT 0
)WITH (MEMORY_OPTIMIZED = ON);

INSERT INTO  Calificaciones (Nombre_estudiante,Calificacion)
	VALUES
	('Jorge',8),('Luis',5),('Tomas',9),('Alejandro',10),('Felipe',6),('Ruben',4),('Maria',5),
	('Jorge',8),('Luis',5),('Tomas',9),('Alejandro',10),('Felipe',6),('Ruben',4),('Maria',5);

--Procedimiento almacenado de forma nativa
CREATE PROCEDURE CalcularAvgCalicaciones
WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = N'us_english')
	-- Lógica del procedimiento almacenado aquí
	DECLARE @promedio FLOAT;

	SELECT @promedio = AVG(Calificacion * 1.0)
		FROM Calificaciones;

	SELECT @promedio AS PromedioCalificaciones;
END;





/*Consideraciones adicionales
	*-Compatibilidad de la base de datos
	*-Monitorización del rendimiento
	*-Uso adecuado
*/
