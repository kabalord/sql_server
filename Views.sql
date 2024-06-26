# Views

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
