# sql_server
--obtener cuantos productos ha vendido cada empleado 
select e.EmployeeID, e.FirstName, e.LastName, sum(od.Quantity) as 'cantidad_prod_vendidos', sum((od.UnitPrice*od.Quantity)) as 'venta_total_empleado'
from Employees e
inner join Orders o on e.EmployeeID=o.EmployeeID 
inner join [Order Details] od on o.OrderID=od.OrderID
group by e.EmployeeID, e.FirstName, e.LastName
having sum((od.UnitPrice*od.Quantity)) < 100000;

--cual es el stock de productos por categorias que tiene cada proveedor

select s.CompanyName, c.CategoryName, sum(p.UnitsInStock) as 'Total_Productos', 
min(p.UnitPrice) as 'precio_minimo', 
max(p.UnitPrice) as 'precio_max'
from Suppliers s
inner join Products p on s.SupplierID=p.SupplierID
inner join Categories c on p.CategoryID=c.CategoryID
where UnitPrice > 100
group by s.CompanyName, c.CategoryName
having sum(p.UnitsInStock) != 0
order by 1,2;

