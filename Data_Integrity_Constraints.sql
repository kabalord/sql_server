/*Integridad de los datos mediante restrincciones;
	la integridad de los datos se puede garantizar mediante el uso de restricciones. 
	Las restricciones son reglas que se aplican a las columnas de una tabla para garantizar que los datos 
	cumplen con ciertas condiciones
*/

/*01 __ PK - Primary Key Constraint
  -No tener datos duplicados(que sea unico)
  -No acepta valores Nulos
  -Se puede aplicar a una o varias columnas(PK compuesta)*/

  CREATE TABLE Tabla1(
	ID INT PRIMARY KEY,
	Descripcion VARCHAR(50)
	);

  CREATE TABLE Tabla2(
	ID INT,
	Cedula INT,
	Descripcion VARCHAR(50)
	--Defino mi PK compuesta
	CONSTRAINT PK_Tabla2 PRIMARY KEY (ID,Cedula)
	);

/*02 __ FK - Forenign Key Constraint
	-Garantiza la relacion entre dos tablas
	-Asegura que los datos en una columna(FK) coincidan con los valores en otra columna(PK) de la otra tabla
*/

  CREATE TABLE Tabla3(
	ID INT PRIMARY KEY,
	Cedula INT,
	Descripcion VARCHAR(50),
	IDT1 INT DEFAULT 0,
	--Defino mi PK compuesta
	FOREIGN KEY (IDT1) REFERENCES Tabla1(ID)
		--ON DELETE NO ACTION
		--ON UPDATE NO ACTION
	);
/*Cuales son las acciones que puede tener una FK en el caso de DELETE - UPDATE de la tabla principal
*-NO ACTION(accion por defecto); Especifica que no se realizará ninguna acción si se intenta eliminar o actualizar 
		una fila en la tabla principal que tiene filas relacionadas en la tabla secundaria.
	
	FOREIGN KEY (IDT1) REFERENCES Tabla1(ID)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION

*-CASCADE; Elimina o actualiza todos las columnas realcionadas si se elimina o actualiza la tabla principal

	FOREIGN KEY (IDT1) REFERENCES Tabla1(ID)
		ON DELETE CASCADE
		ON UPDATE CASCADE

*-SET NULL; asigna el valor NULL al columna de las tablas relacionadas si elimina el registro o se modifica la columna
	en la tabla principal
	FOREIGN KEY (IDT1) REFERENCES Tabla1(ID)
		ON DELETE SET NULL
		ON UPDATE SET NULL

*SET DEFAULT; Similar al SET NULL pero asigna el la FK el valor predeterminado en lugar del NULL
	FOREIGN KEY (IDT1) REFERENCES Tabla1(ID)
		ON DELETE SET DEFAULT
		ON UPDATE SET DEFAULT*/

/*03 __ CK- Restriccion de Verificacion - CHECK CONSTRAINT;  
	Garantizan que los valores en una columna cumplan con una condición específica.
*/

--Condicionar los precios de la tabla articulos
  CREATE TABLE Tabla4(
	IDArticulo INT PRIMARY KEY,
	Descripcion VARCHAR(50),
	Precio DECIMAL(10,2) CHECK (Precio > 10)
	);

	INSERT INTO Tabla4(IDArticulo,Descripcion,Precio) VALUES(2,'Cervezas',9);

/*04 __ UQ- Restriccion de Unicidad UNIQUE CONSTRAINT; Garantizan que no haya duplicados en una columna o 
	en un conjunto de columnas.*/

  CREATE TABLE Tabla5(
	IDArticulo INT PRIMARY KEY,
	NombreArticulo CHAR(10) UNIQUE,
	Descripcion VARCHAR(50),
	Precio DECIMAL(10,2) CHECK (Precio > 10)
	);

	CREATE TABLE Empleados(
		ID INT PRIMARY KEY,
		Nombre VARCHAR(50),
		Apellido VARCHAR(50),
		Cargo VARCHAR(50),
	CONSTRAINT UQ_NombreApellido UNIQUE (Nombre, Apellido)
	);
/* No Nulo(NOT NULL); asegurar que una columna no puede tener valores nulos*/

/*Acciones para mantener de la Integridad de los datos
 - Diseño de la BD
 - Aplicar las Restricciones PK - FK - CK - UQ -NotNull
 - Transacciones
 - Manejo de los Errores
 - Mantenimiento Regular
 - Seguridad
 - Pruebas
 */

 /*Implementacion de la integradad del dominio de datos
   Garantizar que los valores almacenados en una tabla cumplen con las reglas o restricciones definidas por el 
	dominio de la aplicacion.

   - Restricciones de Verificacion;  permiten especificar condiciones que los datos deben cumplir.
	 Puedes usar estas restricciones para aplicar reglas de dominio específicas en tus columnas.
		CONSTRAINT CHECK*/
CREATE TABLE Estu(
	idEstu INT PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	genero CHAR(1) CHECK(genero in ('M','F','O','X','L')),
	activo BIT DEFAULT 1
);

-- Funciones Escalares: contengan lógica específica del dominio y luego utilizar esas funciones 
-- en restricciones de verificación.
CREATE FUNCTION ValidarCorreo(@email VARCHAR(100))
RETURNS BIT
AS
BEGIN
	DECLARE @valido BIT
	SET @valido = 0

	IF @email LIKE '_%@%.%'
	BEGIN
		SET @valido = 1
	END;

	RETURN @valido
END;

CREATE TABLE Estudiante(
	IdEstudiante INT PRIMARY KEY,
	Email VARCHAR(100) CHECK (dbo.ValidarCorreo(Email) = 1)
);

INSERT INTO Estudiante (IdEstudiante, Email)
	VALUES (2,'BDSQL.co');

SELECT * FROM Estudiante;

/* Desencadenadores o Disparadores o TRIGGERS, con estos podemos aplicar la logica de validacion de dominio
	Son codigos que se ejecutan automaticamente en respuesta a ciertos eventos en una tabla o una vista,
	las operaciones que puede realizar son inserciones, actualizaciones o eliminaciones de registros.*/
select * from Products where UnitsInStock = 0;
UPDATE Products
	SET UnitsInStock = 2
 where UnitsInStock = 0;

 		-- RAISERERROR(mensaje_error, severity, state)
		--severity 0 - 25 donde 0 es no error y 25 el error mas grave
		--state 0 -255
CREATE TRIGGER ValidarUnitsInStock
ON Products
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS(SELECT 1 FROM inserted WHERE UnitsInStock <= 0)
	BEGIN
		ROLLBACK;
		--RAISEERROR('No se permite inventario en negativo', 20, 1);
		THROW 50000, 'No se permite inventario en negativo',1;
	END
END;

BEGIN TRANSACTION
/*UPDATE Products
	SET UnitsInStock = 0
 where ProductID = 1;*/

 INSERT INTO  Products 
	(ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
	VALUES
	('Tequeño',1,1,'Cajas 12Unid', 20.00, 50, 10, 2,0),
	('Empanada',1,1,'Cajas 12Unid', 20.00, 10, 10, 2,0);
	
 COMMIT

