--Compresion de los Datos, reduce el tamaño de los datos almacenados en una BD

/*
Compresion de Datos a Nivel de Filas: reducir el tamaño de cada fila de datos individualmente. 
	Se puede habilitar durante su creacion o modificar una tabla existen para hablitar la compresion.
1-ROW: comprimirá cada fila individualmente*/
CREATE TABLE nomTabla
(
	id int PRIMARY KEY,
	descripcion varchar(50),
) WITH (DATA_COMPRESSION = ROW);

ALTER TABLE Categories
	REBUILD WITH(DATA_COMPRESSION = ROW);
/*
Compresion de Datos a Nivel de Pagina: reduce el tamaño de la paginas que continen multiples filas de datos
2-PAGE comprimirá grupos de filas llamada paginas*/
CREATE TABLE nomTabla2
(
	id int PRIMARY KEY,
	descripcion varchar(50),
) WITH (DATA_COMPRESSION = PAGE);

/*Consideraciones
	-Impacto en el rendimiento
	-El tipo de edicion de SQL que poseas(La compresion PAGE requiere la edicion Enterprise y ROW si esta en todas las ediciones)
	-Compresion de los Indices

ALTER TABLE Employees
	REBUILD WITH(DATA_COMPRESSION = PAGE);*/

--Analisis para determinar la compresion
-- herramienta sp_estimate_data_compression_savings ; para estimar al ahorro de espacio potencial
EXEC sp_estimate_data_compression_savings 
    @schema_name = 'dbo', 
    @object_name = 'Orders', 
    @index_id = NULL, 
    @partition_number = NULL, 
    @data_compression = 'ROW';
EXEC sp_estimate_data_compression_savings 
    @schema_name = 'dbo', 
    @object_name = 'Orders', 
    @index_id = NULL, 
    @partition_number = NULL, 
    @data_compression = 'PAGE';


