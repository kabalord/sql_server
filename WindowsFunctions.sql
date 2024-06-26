# Windows Functions

/*hacer un reporte de clientes que muestre 
cual es el producto a nivel de cantidad 
que me de el ranking de los productos
y me diga la cantidad comprada 
cuantos productos a adquirido un cliente */

use Northwind

select c.CompanyName, p.ProductName, od.Quantity, 
DENSE_RANK() OVER (PARTITION BY c.CompanyName ORDER BY  p.ProductName  DESC) AS Ranking,
SUM(od.Quantity)  OVER(PARTITION BY c.CompanyName  ORDER BY p.ProductName DESC) AS 'Cantidad'
from Customers c
inner join Orders o on c.CustomerID=o.CustomerID
inner join [Order Details] od on o.OrderID=od.OrderID
inner join Products p on od.ProductID=p.ProductID


--cual es promedio de ventas por años ranking

SELECT year, PromedioVentas,
	DENSE_RANK() OVER (ORDER BY PromedioVentas DESC) AS 'Ranking'
FROM (
SELECT DISTINCT DATEPART(YEAR, OrderDate) AS 'year',
	AVG(B.Quantity * B.UnitPrice) OVER (ORDER BY DATEPART(YEAR, OrderDate)) AS 'PromedioVentas'
FROM Orders A
INNER JOIN [Order Details] B
	ON A.OrderID = B.OrderID
	) A