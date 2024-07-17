---**********************Dise�o de estrategias de �ndice optimizadas***********************-

/*Estrategias de Gesti�n de �ndices
	1-Monitoreo del Rendimiento
	2-Analisis de Uso de Indices
	3-Mantenimiento regular de los indices
	4-Evaluacion de Impacto
	5-Indexacion Selectiva
	6-Implementacion de Indices Cubrientes(incluyentes) INCLUDE, agregar columnas que seran utilizadas en la clausula
		SELECT, WHERE o ORDER BY
	7-Gestion del espacio de almacenamiento
	8-Realizacion de Pruebas de Rendimiento
	9-Documentacion y Seguimiento
   10-Capacitacion y Mejora Continua
*/
--Indice Cubrientes(incluyentes) 
select FirstName, PostalCode from Employees WHERE EmployeeID in(2,3,4,7) and Region = 'WA' order by FirstName;
CREATE INDEX IX_FirstName ON Employees (FirstName);

select ProductName, UnitsInStock from Products WHERE CategoryID = 2 and UnitPrice >20;
CREATE NONCLUSTERED INDEX IX_Cubriente
	ON Products (CategoryID,UnitPrice) INCLUDE (ProductName, UnitsInStock);
CREATE NONCLUSTERED INDEX IX_Cubriente2
	ON Products (CategoryID) INCLUDE (ProductName, UnitsInStock,UnitPrice);

	DROP INDEX IX_Cubriente ON Products;

--Vista para hacer seguimiento a los indices
SELECT * FROM sys.dm_db_index_usage_stats

/*Planes de Ejecucion
	 Son representaciones detalladas de c�mo el motor de SQL Server ejecutar� una consulta espec�fica. 
	 Proporcionan informaci�n sobre c�mo se acceder�n y manipular�n los datos, qu� operadores se utilizar�n y 
	 c�mo se realizar�n las operaciones de filtrado, ordenaci�n y uni�n. 
*/
SELECT p.ProductID,p.ProductName,--c.CategoryName 'cCategoryName',
f.CategoryName 'fCategoryName'
	FROM Products p
		LEFT  JOIN Categories f ON f.CategoryID= p.CategoryID
		RIGHT  JOIN Categories c ON c.CategoryID=f.CategoryID
		where p.ProductName like 'c%'
		order by p.ProductID;

UPDATE STATISTICS Categories;
UPDATE STATISTICS Products;
/*Algunos conceptos clave relacionados con los planes de ejecuci�n
	*-Plan de Ejecuci�n: Un plan de ejecuci�n es una representaci�n gr�fica o en formato XML del plan 
		que el optimizador de consultas ha creado para ejecutar una consulta espec�fica.

	*-Compilaci�n de Consultas:Antes de ejecutar una consulta, SQL Server pasa por un proceso de compilaci�n 
		en el cual el motor de consultas genera un plan de ejecuci�n basado en estad�sticas, �ndices 
		y otras consideraciones.

	*-Tipos de Planes:
		**-Plan en Lote (Batch Mode): Utilizado para operaciones que procesan grandes cantidades de datos 
			en paralelo, t�picamente en un almac�n de datos.
		**-Plan en Modo de Fila (Row Mode): Utilizado para operaciones de uni�n y filtrado de filas de datos
			de manera secuencial.

	*-Operadores de Ejecucion: El plan de ejecucion esta compuesto por operadores fisicos que representan 
		las acciones especificas que SQLServer realizara para ejecutar una consulta
		Scan (Escaneo):
			Clustered Index Scan: Escaneo de un �ndice agrupado.
			Table Scan: Escaneo de una tabla sin �ndice.

		Seek (B�squeda):
			Index Seek: B�squeda en un �ndice.
			Clustered Index Seek: B�squeda en un �ndice agrupado.

		Lookup (B�squeda Adicional):
			RID Lookup: B�squeda de una fila mediante el identificador de fila (RID).
			Key Lookup: B�squeda de una fila adicional en un �ndice no agrupado utilizando el valor de la clave.

		Sort (Ordenamiento):
			Sort: Ordenamiento de filas seg�n uno o m�s campos.

		Filter (Filtrado):
			Filter: Aplicaci�n de un filtro a las filas.

		Hash Match:
			Hash Match: Operaci�n de combinaci�n utilizando una funci�n hash.

		Nested Loop (Bucle Anidado):
			Nested Loop Join: Operaci�n de combinaci�n que utiliza bucles anidados.

		Merge Join:
			Merge Join: Operaci�n de combinaci�n utilizando operaciones de mezcla.

		Aggregate (Agregaci�n):
			Stream Aggregate: Agregaci�n en una secuencia de datos.
			Hash Match Aggregate: Agregaci�n utilizando una funci�n hash.

		Parallelism (Paralelismo):
			Parallelism: Operaci�n que se ejecuta en paralelo.
*/

/*	Operadores Logicos:describen las operaciones que se realizan en los conjuntos de datos como una union o un
	filtro. Estos operadores pueden traducirse en varios operadores fisicos en el plan de ejecucion*/

/*	Costo Relativo: cada operacion en el plan de ejecucion tiene un costo relativo asociado, que indica la 
	estimacion del optimizador de consultas	sobre el esfuerzo CPU de esa operacion*/

/*Estadisticas y Predicciones: Utiliza las estadisticas de las tablas y columnas relevantes para estimar el num de filas que se procesarar en
	cada operacion y con esto construye el plan de ejecucion*/

/*Ejecucion en Paralelo: la ejcucion simulanea utilizando varios subprocesos y acelerando el rendimiento*/

--Asistente de Optimizacion de Consulta(Query Optimization Advisor) Database Engine Tuning Advisor(DTA)
 /*Ayuda a analizar consultas complejas y proporciona sugerencias para mejorar su rendimiento.*/

--Asesor de Indices(Index Tuning Wizard)
/*Ayuda a mejorar el rendimiento de la consulta mendiante la identificacion de indices faltastes o sugerencias
	para ajustar los indices existente*/






--Consultar estadisticas utilizando la vista de catalogo
-- Obtener todas las estad�sticas para una tabla espec�fica
SELECT
    s.name AS Estadistica,
    c.name AS Columna,
    sc.stats_id,
    --sc.no_recompute,
    st.* -- Otras columnas disponibles en sys.stats y sys.stats_columns
FROM
    sys.stats AS st
JOIN
    sys.stats_columns AS sc ON st.object_id = sc.object_id AND st.stats_id = sc.stats_id
JOIN
    sys.columns AS c ON sc.object_id = c.object_id AND sc.column_id = c.column_id
JOIN
    sys.tables AS t ON st.object_id = t.object_id
JOIN
    sys.schemas AS s ON t.schema_id = s.schema_id
WHERE
    t.name = 'Products';--Nombre de la tabla a consultar

--Actualizar todas las estadisticas para una tabla
UPDATE STATISTICS Products;


-- Obtener informaci�n sobre todas las estad�sticas de la base de datos
SELECT
    s.name AS Esquema,
    t.name AS Tabla,
    st.name AS Estadistica,
    st.no_recompute,
    st.auto_created,
    st.user_created,
    sc.stats_id,
    sc.column_id,
    c.name AS Columna
FROM
    sys.stats AS st
JOIN
    sys.stats_columns AS sc ON st.object_id = sc.object_id AND st.stats_id = sc.stats_id
JOIN
    sys.columns AS c ON sc.object_id = c.object_id AND sc.column_id = c.column_id
JOIN
    sys.tables AS t ON st.object_id = t.object_id
JOIN
    sys.schemas AS s ON t.schema_id = s.schema_id;

