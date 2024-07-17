# Views

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
