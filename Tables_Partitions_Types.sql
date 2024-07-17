--Tipos de Particiones
select year(OrderDate) year_pedido, count(*) cantidad_pedido from Orders
group by year(OrderDate) order by year_pedido;

/*1-Particion por Rango; La tabla se divide en particiones basadas en rangos de valores de una columna.*/
select * from Orders where [OrderDate] BETWEEN '1996-01-01' AND  '1996-12-31';--Particionaremos por Año de la Orden

--1.1  Creación de la función de partición (CREATE PARTITION FUNCTION):
CREATE PARTITION FUNCTION ParticionPorAnioOrders (DATETIME)
AS RANGE LEFT FOR VALUES ('1996-01-01', '1997-01-01', '1998-01-01');
SELECT * FROM sys.partition_functions
DROP PARTITION FUNCTION ParticionPorAnioOrders

--1.2 Creación del esquema de partición (CREATE PARTITION SCHEME):
CREATE PARTITION SCHEME EsquemaParticionPorAnioOrders4
AS PARTITION ParticionPorAnioOrders
ALL TO ([PRIMARY]);
DROP PARTITION SCHEME EsquemaParticionPorAnioOrders4

--1.3 Creación de la tabla particionada (CREATE TABLE):
drop TABLE OrdersParticionada3;
CREATE TABLE OrdersParticionada4(
	[OrderID] [int] NOT NULL,
	[CustomerID] [nchar](5) NULL,
	[EmployeeID] [int] NULL,
	[OrderDate] [datetime] NOT NULL,--Columna por la que servira para identificar los rangos de la particion
	[RequiredDate] [datetime] NULL,
	[ShippedDate] [datetime] NULL,
	[ShipVia] [int] NULL,
	[Freight] [money] NULL,
	[ShipName] [nvarchar](40) NULL,
	[ShipAddress] [nvarchar](60) NULL,
	[ShipCity] [nvarchar](15) NULL,
	[ShipRegion] [nvarchar](15) NULL,
	[ShipPostalCode] [nvarchar](10) NULL,
	[ShipCountry] [nvarchar](15) NULL,
	-- Agregar la columna de partición a la clave principal
	CONSTRAINT PK_OrdersParticionada
		PRIMARY KEY (OrderID, OrderDate)
) ON EsquemaParticionPorAnioOrders4(OrderDate);



--Verificar la existencia de la partición:
SELECT * FROM sys.partition_functions;
SELECT * FROM sys.partition_schemes;
SELECT * FROM sys.partitions WHERE object_id = OBJECT_ID('OrdersParticionada4');

--Verificar la distribucion de los datos en las particiones
SELECT 
    t.name AS TableName,
    i.name AS IndexName,
    p.partition_number,
    r.value AS PartitionBoundary,
    p.rows
FROM 
    sys.tables t
JOIN 
    sys.indexes i ON t.object_id = i.object_id
JOIN 
    sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
LEFT JOIN 
    sys.partition_range_values r ON p.partition_number = r.boundary_id AND r.function_id = i.data_space_id
WHERE 
    t.name = 'OrdersParticionada4';


--Cargar los datos del Origen a la particion
INSERT INTO OrdersParticionada4
SELECT * FROM Orders;--830 ROWS


INSERT INTO OrdersParticionada4 (OrderID, [CustomerID], OrderDate)
	VALUES(11078, 'PARTI','1999-01-02')

--Consultar la informacion de las particiones de la tabla
DBCC SHOWPARTITIONS('OrdersParticionada4',1);
DBCC SHOW_STATISTICS('OrdersParticionada3', 'OrderDate');


select * from OrdersParticionada4
where $PARTITION.ParticionPorAnioOrders(OrderDate) = 4;