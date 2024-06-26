# Pivot, Unpivot : Grupos giratorios


CREATE TABLE Ventas(
	Producto VARCHAR(50),
	Enero int,
	Febrero int,
	Marzo int,
	Abril int
	);
	INSERT INTO Ventas VALUES
		('Neveras',12,10,5,20),
		('Lavadoras',45,2,75,2),
		('TV',54,9,50,78);
		
		
select * from Ventas;
	--LISTADO DE PROD CON SU MES Y SU VENTA
	--Nevera, Enero, 12
SELECT Producto,  Mes, Cantidad
	FROM(
		SELECT Producto,Enero,Febrero,Marzo,Abril FROM Ventas) AS fuente
	UNPIVOT(
		Cantidad --Nombre que le queremos dar al valor contenido en la columna orginal
		FOR Mes -- Nombre que le queremos dar a la columna nueva que contendra el nombre de las columnas a unpivot
		IN([Enero],[Febrero],[Marzo],[Abril]) -- Columnas que se convertiran
		) As UnpivotVenta;
