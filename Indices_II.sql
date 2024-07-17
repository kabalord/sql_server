--Indices Apilados, Agrupados y no Agrupados

/*Indexación; el proceso que crea las estructuras de datos adicionales, llamadas indices los cuales son utilizados
	para mejorar la efeciencia de las consultas y busquedas en una BD.*/

/*Indices Agrupados		=	Indice Clúster
  Indice No Aprupado	=	Indice No Clúster
  Indice Apilado		=	Indices Agrupados		=	Indice Clúster*/
  
  SELECT * FROM Employees;

--Indices de una sola columna
--CREATE INDEX idx_tabla_columna ON nomTabla(nomColumna);
CREATE INDEX idx_Customers_Country ON Customers(Country);

--Indices compuestos
--CREATE INDEX idx_tabla_col1_col2 ON nomTabla(nomCol,nomCol2);
CREATE INDEX idx_Employees_TitleOfCourtesy_Title ON Employees(TitleOfCourtesy, Title);

--Indice unico
CREATE UNIQUE INDEX ix_Address ON Employees(Address);
/*Consideraciones Generales
-Uso eficiente
-Impacto en el rendimiento
-Estadisticas*/

/*
Estrategias de Indices para definir si debo aplicar un Indice
	1-Identificar un Problema: verficar las consultas que tengan un bajo rendimiento(demoren mucho ejecucion) o
		que tenga una alta frecuencia.
	2-Analizo los patrones de acceso a los datos: identificar las columnas que se utilizan con mayor frecuencia
		en las clausulas WHERE, JOIN Y ORDER BY
	3-Evalua la selectividad de columnas: selectividad(la proporcion de valores unicos a una columna)
		Selectividad_Columna = # de valores unicos
								--------------------
								# filas totales de la tabla
		Mientras mas cercano a 1 sea la selectiva sueler ser buenas candidatas para indices.
	4-Priorizar consultar criticas: si inicia por las consultas mas utilizadas o aquellas que tengas mayor impacto en 
		rendimeinto(rendimiento, tiempo, frecuencia)

*/
select * from Orders;
--selectividad de ShipCity
SELECT Unicos,Totales, CAST(Unicos AS FLOAT)/Totales * 100 as SELECTIVIDAD FROM
	(select COUNT(distinct ShipCity) As Unicos from Orders) as A,
	(select COUNT(*) As Totales from Orders) B;
/*
Estrategias de Indices optimizadas
	1-Identificacion de Indices necesarios
	2-Seleccionar Indices Cluster y No Cluster
	3-Utilizar Indices Fitrados
	4-Estadisticas Actualizadas
	5-Monitoreo del Rendimiento
	6-Fragmentacion de Indices(Corregir)
	7-Pruebas de Rendimiento
	8-Seguimiento y Ajuste Continuo
*/




ALTER TABLE Employees ADD Active BIT DEFAULT 1;

SELECT * FROM Employees;
UPDATE Employees
	SET Active=1
	where EmployeeID IN(2,4,6);

--Indice filtrado
CREATE NONCLUSTERED INDEX ix_filtraActivo ON Employees(EmployeeID) WHERE Active = 1;