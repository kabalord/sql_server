--subconsultas en la clausula where

--cuales son los proveedores que distribuyen los productos comprados por los clientes de la ciudad de londres.

select distinct s.CompanyName
from Suppliers s
inner join Products p on s.SupplierID=p.SupplierID
inner join [Order Details] od on p.ProductId=od.ProductID 
inner join Orders o on od.OrderID=o.OrderID
inner join Customers c on o.CustomerID=c.CustomerID
where c.CustomerID in (select CustomerID from Customers where City='London');


select distinct s.CompanyName
from Suppliers s
inner join Products p on s.SupplierID=p.SupplierID
inner join [Order Details] od on p.ProductId=od.ProductID 
inner join Orders o on od.OrderID=o.OrderID
where o.CustomerID in (select CustomerID from Customers where City='London');



--subconsultas en la clausula from

/*se solicita un reporte que me muestre la orden, el producto y la cantidad,
el precio unitario, el subtotal y el total - el descuento*/

select OrderID, ProductName, Quantity, total.UnitPrice, Discount, 
Subtotal,  sum(total.valor_con_descuento) as 'total_factura_con_descuento'
from
(select OrderID, ProductID, Quantity, UnitPrice, Discount, 
(Quantity*UnitPrice) as 'Subtotal', 
(Quantity * UnitPrice) - ((Quantity * UnitPrice) * Discount) / 100  as 'valor_con_descuento'
from [Order Details]) total
join Products p on total.ProductID=p.ProductID  
group by OrderID, ProductName,Quantity, total.UnitPrice, Discount, Subtotal, valor_con_descuento

/*
total    100%
  x    discount%

subtotal - ((subtotal*discount%) / 100)
*/













SET STATISTICS TIME ON;
SET STATISTICS TIME OFF;


--obtiene la informacion de los tiempos de ejecucion de la ultima consulta
SELECT TOP 1
    total_elapsed_time / 1000.0 AS Total_Elapsed_Time_Seconds,
    execution_count,
    creation_time,
    last_execution_time,
    sqltext.TEXT AS [Query Text]
FROM
    sys.dm_exec_query_stats AS stats
CROSS APPLY
    sys.dm_exec_sql_text(stats.sql_handle) AS sqltext
ORDER BY
    last_execution_time DESC;


