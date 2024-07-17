/*Índices de Columnstore
	Un índice Columnstore organiza y almacena los datos en columnas en lugar de filas. 

Características clave:
	*-Almacenamiento Columnar
	*-Compresión
	*-Procesamiento de lotes

Ventajas:
	*-Rendimiento Mejorado
	*-Menor Uso de Espacio
	*-Paralelismo
	*-Reduccion de E/S

Desventajas:
	*-Costos de Actualizacion
	*-No ideal par OLTP
	*-Requiere mas memoria

Consideraciones:
	*-Actualizaciones
	*-Compatibilidad
*/

--Crear un indice Columnstore
CREATE TABLE ventas(
	idVenta INT PRIMARY KEY,
	idProducto INT,
	cantidad INT,
	precio DECIMAL(10,2),
	fechaVenta DATE
);

INSERT INTO ventas (idVenta, idProducto, cantidad, precio, fechaVenta)
VALUES
(1,100,10,2000,'2023-05-05'),
(2,101,20,3000,'2023-07-31'),
(3,102,30,4000,'2023-09-08');


--crear un nonclustered columnstore index
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_ventas_columnstore
	ON ventas(idVenta, idProducto, cantidad, precio, fechaVenta);

--Consultar datos agregados
SELECT idProducto, SUM(cantidad) 'CantVendidas', AVG(precio) 'PrecioAVG' 
	from ventas
GROUP BY idProducto;

SELECT ProductID, SUM(Quantity) 'Cantd', AVG(UnitPrice) 'PrecioAVG'
FROM [Order Details]
GROUP BY ProductID;










--En la creacion de una Tabla
CREATE TABLE TablaColumnstore(
	ID INT PRIMARY KEY,
	Descripcion NVARCHAR(150),
	Activo BIT DEFAULT 1,
	-- Otros campos
	INDEX IX_TablaColumnstore CLUSTERED COLUMNSTORE
);

SELECT *
  FROM [Northwind].[dbo].Orders

--Agregar a una tabla existente
CREATE CLUSTERED COLUMNSTORE INDEX IX_RegionColumnstore ON Region;

--Indices Columnstore No Agrupados - NONCLUSTERED
CREATE NONCLUSTERED COLUMNSTORE INDEX IX_OrdesColumnstore ON Orders(OrderID, CustomerID);


/*Consideraciones y/o Acciones a tomar para trabajar con los indices Columnstore
	1-Diseño de la tabla y Indice
		*-Columnas Incluidas
		*-Tipo Indice
			_Agrupado
			_No Agrupado

	2-Creacion o Modificacion del indice
		*-para una modificacion(REORGANIZE); reoraniza un indice no agrupado de columnas almacenadas
			ALTER INDEX IX_nombreIndexColumnstore ON NomTabla REORGANIZE
		Se debe considerar que el REORGANIZE, se utiliza especificamente para indices no agrupaso de columnas almacenadas

	3-Operaciones de Mantemiento
	4-Monitoreo y Optimizacion del Rendimiento
		*-Plan de Ejcucion de Consultas
		*-Rendimiento de las Consultas
	5-Actualizaciones incrementales
	6-Indices de Filtrado 
	7-Monitoreo del Espacio y Compresion

	--Como desactivar y reactivar un indice Columnstore*/
	
	--Desactivarlo los indices Columnstore
	ALTER INDEX ALL ON Region DISABLE;
	
	--Carga datos en la tabla
	
	--Activar los indices Columnstore
	ALTER INDEX ALL ON Region REBUILD;