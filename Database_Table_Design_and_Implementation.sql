-- Diseño e implementacion de tablas
/*Relaciones entre las tablas
*Relacion Uno a Uno (1-1) ; un regitro de la tabla A esta relacionado con un registro de la tabla B
*Relacion Uno a Muchos (1-N)un regitro de la tabla A esta relacionado con muchos registro de la tabla B
*Relacion Muchos a Uno (N-1)Muchos regitro de la tabla A esta relacionado con un registro de la tabla B
*Relacion Muchos a Muchos (N-M)Muchos regitro de la tabla A esta relacionado con Muchos registro de la tabla B*/

CREATE DATABASE Prueba_240110;

USE Prueba_240110;

CREATE TABLE Empleado(
	IdEmpleado INT PRIMARY KEY,
	NomEmpleado VARCHAR(50) NOT NULL,
	FechaNacimiento DATE,
	Activo BIT DEFAULT 1
);

/*Diseño de tablas
	1-Identificarla entidades
	2.1-Relaciones con Otras tablas
	2.2-Normalizacion
	3-Claves Primarias*/
CREATE TABLE Frutas(
	i_IdFruta INT IDENTITY(1,1) PRIMARY KEY,
	v_Fruta VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO Frutas(Fruta) 
	values
	('Fresa');
/*
	4-Tipo de Dato Adecuado
	5-Evitar Campos Calculados
	6-Agregar las Restricciones de Integridad
	7-Normalizacion de Nombres
	8-Indices
	9-Considerar la Escalabilidad
	10-Evitar Columnas Nulas
	11-Documentacion
*/

/*Esquemas de BD; son contenedores logicos que se utilizan para organizar y agrupar objetos de un BD*/
--Crear esquema
CREATE SCHEMA Esquema1;
--
CREATE TABLE Esquema2.Categories(
	IdCategoria INT IDENTITY(1,1) PRIMARY KEY,
	Categoria VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Esquema1.Casos(
	IdCasos INT IDENTITY(1,1) PRIMARY KEY,
	Casos VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Esquema1.amigo(
	IdEmpleado INT PRIMARY KEY,
	NomEmpleado VARCHAR(50) NOT NULL,
	FechaNacimiento DATE,
	Activo BIT DEFAULT 1
);

--Consulta de tablas de un esquema
SELECT TABLE_SCHEMA, TABLE_NAME
	FROM information_schema.tables
	WHERE TABLE_SCHEMA = 'Esquema1';

--Mover una tabla a otro esquema existente
ALTER SCHEMA Esquema2 TRANSFER Esquema1.Casos;

--Eliminar esquema
DROP SCHEMA Esquema1;


select * from Categories;
select * from Esquema2.Categories;
select * from Empleado;
--Modificaciones de una Tabla
--Agregar Columna
ALTER TABLE Empleado ADD Apellido VARCHAR(50);
--Modificar Columna
ALTER TABLE Empleado ALTER COLUMN NomEmpleado VARCHAR(100) NOT NULL;
--Eliminar Columna
ALTER TABLE Empleado DROP COLUMN Activo;
--Eliminar un Constraint
ALTER TABLE Empleado DROP CONSTRAINT DF__Empleado__Activo__0D7A0286;
/* Tipos de Constraints
	-PK Primay Key, clave primaria(no se repite o unica) y no permite valores nulos
	-FK Foreign Key, clave foranea garantiza la relacion entre dos tablas conincidiendo los valores de una
		columna
	-UQ Unique, resticcion unica asegura que los valores en una columna sean unicos y no pueden ser null
	-DF Default, restriccion predeterminada establece un valor por defecto para una columna cuando no
		se proporciona ningun dato durante la insercion
	-CK Check, restriccion de verificacion especifica una condicion que debe cumplirse cuando se inserta
		o actualiza un valor en un columna*/
	
--Crear un Constraint
ALTER TABLE Empleado ADD CONSTRAINT CK_FechaNacimiento CHECK(FechaNacimiento < '01-01-2020');
INSERT INTO Empleado (IdEmpleado, NomEmpleado, FechaNacimiento)
	VALUES(5,'Jomary','02-02-2022');

UPDATE Empleado
	SET FechaNacimiento = '02-02-2022'
	where IdEmpleado=1;
select * from Products;
/*DEFAULT on column UnitPrice	DF_Products_UnitPrice	(n/a)	(n/a)	(n/a)	(n/a)	((0))
DEFAULT on column UnitsInStock	DF_Products_UnitsInStock	(n/a)	(n/a)	(n/a)	(n/a)	((0))
DEFAULT on column UnitsOnOrder	DF_Products_UnitsOnOrder	(n/a)	(n/a)	(n/a)	(n/a)	((0))
FOREIGN KEY	FK_Products_Categories	No Action	No Action	Enabled	Is_For_Replication	CategoryID
 	 	 	 	 	 	REFERENCES Northwind.dbo.Categories (CategoryID)
FOREIGN KEY	FK_Products_Suppliers	No Action	No Action	Enabled	Is_For_Replication	SupplierID
 	 	 	 	 	 	REFERENCES Northwind.dbo.Suppliers (SupplierID)
PRIMARY KEY (clustered)	PK_Products	(n/a)	(n/a)	(n/a)	(n/a)	ProductID*/
select * 
	INTO Products2 
	from Products;




select * from Empleado;
--Inactivar un Constraint
ALTER TABLE Empleado NOCHECK CONSTRAINT CK_FechaNacimiento;
--Reactivar un Constraint
ALTER TABLE Empleado CHECK CONSTRAINT CK_FechaNacimiento;
--Cambiar el nombre de una columna sp_rename
EXEC sp_rename 'Empleado.NomEmpleado', 'Nombre', 'COLUMN';

/*1. Normalización:
Primera Forma Normal (1NF): Asegúrate de que cada columna de la tabla contenga un solo valor, evitando la repetición de datos.

Segunda Forma Normal (2NF): Cumple con 1NF y asegúrate de que cada columna que no sea clave dependa completamente de la clave primaria.

Tercera Forma Normal (3NF): Cumple con 2NF y elimina dependencias transitivas entre las columnas no clave.*/


/**Particion de Datos; dividir una tabla grande en fragmentos mas pequeños llamados particiones**/
--Tipos de particiones
--*Particion por Rango
--*Particion por lista
--*Particion por columna calculada
