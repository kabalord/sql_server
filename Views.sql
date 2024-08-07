--# Views

/*Diseño e implementación de vistas

	Una vista es una consulta almacenada que se puede utilizar como una tabla virtual. 
	Las vistas permiten a los usuarios y desarrolladores acceder y manipular los datos de una manera más estructurada
	y simplificada

Creación de Vistas
	CREATE VIEW nombre_vista AS
		SELECT columnas
		FROM tablas
		WHERE condiciones;

*/

--Productos y Categoria
CREATE VIEW W_CantProdCategoria AS
SELECT C.CategoryName, COUNT(P.ProductID) 'CantProd', AVG(P.UnitPrice) 'PrecioPromedio'
	FROM Products P
		JOIN Categories C ON P.CategoryID = C.CategoryID
		GROUP BY C.CategoryName
			Having AVG(P.UnitPrice) < 30;

--Consultar un vista
SELECT * FROM W_CantProdCategoria;

SELECT C.CategoryID, w.CategoryName, C.Description, w.CantProd
	FROM Categories C 
	JOIN W_CantProdCategoria w ON C.CategoryName = w.CategoryName

--Actualizar Vista
--CREATE OR ALTER VIEW W_CantProdCategoria AS
ALTER VIEW W_CantProdCategoria AS
SELECT c.CategoryID,C.CategoryName, COUNT(P.ProductID) 'CantProd', AVG(P.UnitPrice) 'PrecioPromedio'
	FROM Products P
		JOIN Categories C ON P.CategoryID = C.CategoryID
		GROUP BY c.CategoryID,C.CategoryName
			Having AVG(P.UnitPrice) < 50;

--Eliminar Vista
DROP VIEW W_CantProdCategoria;


--Eliminar Vista
DROP VIEW W_CantProdCategoria;

--Tipos de Vistas Normales y Indexadas(materializadas)

/*Vista Normal
	Es una consulta almacenada que puede ser tratada como una tabla virtual y no almacena datos fisicamente, 
	almacena la definicion de la consulta que se ejecuta cada vez que se accede a la vista*/

/*Vista Indexadas(Materializadas)
	Es una vista que almacena fisicamente los resultados de la consulta en el disco, 
		permite un acceso mas rapido a los datos precomputados
		Caracteristicas
		-Almacenamiento fisico
		-Rendemiento mejorado
		-Actualizacion automatica SQlServer actualiza automaticamente la vista indexada cuando se actualizan 
			los datos de las tablas subyacentes
			*/
--Creacion de un vista Indexada
CREATE or ALTER VIEW W_Categoria_Indexada 
	WITH SCHEMABINDING
	AS
SELECT c.CategoryID,C.CategoryName, COUNT_BIG(P.ProductID) 'CantProd', 
	SUM(P.UnitPrice) as 'PrecioTotal',
	COUNT_BIG(*) AS ContAll
	FROM dbo.Products P
		JOIN dbo.Categories C ON P.CategoryID = C.CategoryID
		WHERE P.UnitPrice < 50
		GROUP BY c.CategoryID,C.CategoryName;

--Crear el inidice unico agrupado en la vista
CREATE UNIQUE CLUSTERED INDEX idx_W_Categoria_Indexada
	ON dbo.W_Categoria_Indexada (CategoryID, CategoryName);

SELECT
	CategoryID, CategoryName, CantProd,
	PrecioTotal/NULLIF(CantProd,0) AS 'PrecioAVG'
FROM dbo.W_Categoria_Indexada;

/*Elementos Prohibidos en una Vista Indexada
	1. Elementos de Agregacion y Agrupacion
		-No se pueden usar funciones de agregacion (AVG, MIN, MAX, STDEV, VAR)
		-Solo permite SUM, COUNT_BIG pero no en combinacion
		-GROUP BY es permitido, pero no el HAVING
		-No puedo usar DISTINCT
	2. Uniones y subconsultas
		-La subconsultas, incluyendo subconsultas correlacionas no estan permitidas
		-No se permiten UNION, UNION ALL, EXCEPT ni INTERSECT
    3. Clausulas y Funciones
		-TOP y OFFSET-FETCH no esta permitido
		-ORDER BY solo se permite con TOP si no se utiliza en la vista base
		-no se permiten funciones escalares definidas por el usuario
		-no se permite columnas computadas que son deterministicas
	4. Otros
		-Las columnas TEXT, NTEXT, IMAGE, VACHAR(MAX), NVARCHAR(MAX), VARBINARY(MAX), XML, CLR
		-Las tablas temporales y tablas variables no pueden ser referenciadas
		-Las vistas distribuidas (referencias a tablas en otros BD) no esta permitido

Elementos Obligatorios 
	1. Uso de SCHEMANBINDING
	2. Incluir COUNT_BIG(*) si la vista contiene agregaciones este debe se un campo mas de la consulta
	4. Todas las tablas y objetos deben ser referenciados con nombres de dos partes (esquema.nombre)*/


/*Consideraciones Adicionales para el redimiento:
	*-Complejidad de la Vista
	*-Materialización
	*-Índices
	*-Estadísticas
	*-Filtrado en la Vista
	*-Recursos del Servidor
	*-Caching
	*-Actualización de Datos
	*-Uso Responsable
*/


use Northwind

--saber cuantas ordenes per shipper 
create view total_ordenes as 
select s.ShipperID, s.CompanyName , count(o.OrderID) as 'total_ordenes'
from Orders o
inner join Shippers s on o.ShipVia=s.ShipperID
group by s.ShipperID, s.CompanyName;

select * from total_ordenes;

--ahora  verificando cada compañia de que pais despacho la orden
alter view total_ordenes as 
select s.ShipperID, s.CompanyName, o.ShipCountry, count(o.OrderID) as 'total_ordenes'
from Orders o
inner join Shippers s on o.ShipVia=s.ShipperID
group by s.ShipperID, s.CompanyName, o.ShipCountry;

select * from total_ordenes;

drop view total_ordenes;
