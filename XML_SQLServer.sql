/*Esquemas XML 
	XML es un lenguaje de marcado que se utiliza para almacenar y transportar datos de manera legible tanto
	para humanos como para maquimas.

	Un esquema XML describe la estructura de los datos XML, incluidos los elementos, atributos, tipos de datos 
	y restricciones.


	**Caracteristis Principales
		*-Marcado Personalizado
		*-Legible para humanos y maquinas
		*-Idenpendiente de Plataforma
		*-Soporte de Unicode
		*-Extensibilidad
ejemplo
	<Estudiante>
		<nombre>Jorge Luis Fonseca Baldrich</nombre>
		<Direccion>
			<Pais>Ecuador</Pais>
			<Departamento>Guayas</Departamento>
			<Ciudad>Guayaquil</Ciudad>
		</Direccion>
	</Estudiante>

**Esquemas XML(XSD)
	Son documentos que describen la estructura y las restricciones de los datos en un documento XML.
	Se utilizan para validar documentos XML y a segurar que cumplan con las reglas
	**Caracteristicas
		*-Declarativo sintaxis declarativa que especifican los elementos, atributos, tipos de datos y restricciones
		*-Tipos de Datos 
		*-Validaciones
		*-Reutilizacion
ejmplo
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xs:element name='Estudiante'>
		<xs:complexType>
			<xs:sequence>
				<xs:element name="Nombre" type="xs:string"/>
				<xs:element name="Direccion">
					<xs:complexType>
						<xs:sequence>
							<xs:element name="Pais" type="xs:string"/>
							<xs:element name="Departamento" type="xs:string"/>
							<xs:element name="Ciudad" type="xs:string"/>
						</xs:sequence>
					</xs:complexType>	
				</xs:element>
				<xs:element name="Telefono" type="xs:int"/>
			</xs:sequence>
		</xs:complexType>
	</xs:element>
</xs:schema>
**XML en SQLServer

	*-Columnas XML, pueden contener documentos XML o fragmentos de XML
	*-Tipos de datos XML, es un tipo de dato que puedo utilizarlo para definir un colunma que valla a almacenar
		un dato XML estructurado.
	*-Consultas XML, nos permiten a traves de las expresiones de XPath recuperar datos especificos dentro de un XML
	*-Indices XML
	*-Manipulacion de datos XML, permite agregar, eliminar, modificar y transformar los datos XML, utilizando
		las funciones integradas de XML ejemplos:
			_modify()
			_nodes()
*/
/*Almacenamiento de datos XML en SQLSErver*/
--Crear campo XML
CREATE TABLE EjmplXML(
	ID INT PRIMARY KEY,
	DatosXML XML
);

--Insertar un dato XML
INSERT INTO EjmplXML (ID,DatosXML)
	VALUES(3,'<Persona>
				<Telefono>4564</Telefono>
				<DocumentoIdentificacion></DocumentoIdentificacion>
				<Nombre>Bony</Nombre>
				<Apellido>Baldrich</Apellido>
				<Ciudad>Cartagena</Ciudad>
			  </Persona>');
delete from EjmplXML where ID =3;
select * from EjmplXML;

/*Esquema XML en SQLServer*/

--*Validacion de XML con esquema XSD
/*Funciones para meno de XML en SQLServer
	-CAST y CONVERT*/
	SELECT DatosXML, CAST(DatosXML AS NVARCHAR(MAX)) 'XML-NVARCHAR' FROM EjmplXML;
	--FOR XML y FOR XML PATH
	SELECT EmployeeID, FirstName, LastName, BirthDate FROM Employees FOR XML AUTO, ROOT('Employees');
	INSERT INTO EjmplXML (ID,DatosXML) 
		VALUES (5,(SELECT EmployeeID, FirstName, LastName, BirthDate FROM Employees FOR XML AUTO, ROOT('Employees')));
	--XML DATA Modification(XQuery)
	UPDATE EjmplXML
		SET DatosXML.modify('insert <Telefono>3172992761</Telefono> into (/Persona)[1]')
		where id = 2;
	--xml.exist() permite verificar la existencia de un nodo especifico dentro del xml
	SELECT DatosXML.exist('/Persona/Ciudad[text()="Cartagena"]') 'Validacion' FROM EjmplXML;
	SELECT DatosXML.exist('/Persona/DocumentoIdentificacion/text()') 'Validacion' FROM EjmplXML;
	--xml.value() extrae el valor de un nodo especifio dentro del XML
	SELECT DatosXML.value('(Persona/Employees[@EmployeeID="4"]/@FirstName)[1]','varchar(50)') NombrePersona 
		FROM EjmplXML;
	

--Se crea un funcion ya que el CONSTRAINT CHECK no permite aplicar metodos XML directamente
CREATE OR ALTER FUNCTION CKXMLDatoInvalido(@Data XML)--DocumentoIdentificacion
RETURNS BIT
AS
	BEGIN
		DECLARE @valido BIT;

		--IF @Data.exist('/Persona[DocumentoIdentificacion and Nombre and Apellido]') = 1
		IF @Data.exist('/Persona/DocumentoIdentificacion/text()') = 1
			SET @valido = 1;
		ELSE
			SET @valido = 0;

		RETURN @valido;
END;

CREATE OR ALTER FUNCTION CKXMLDatoInvalido2(@Data XML)--DocumentoIdentificacion
RETURNS BIT
AS
	BEGIN
		DECLARE @valido BIT;

		--IF @Data.exist('/Persona[DocumentoIdentificacion and Nombre and Apellido]') = 1
		IF @Data.exist('/Persona/Ciudad[text()="Cartagena"]') = 1
			SET @valido = 1;
		ELSE
			SET @valido = 0;

		RETURN @valido;
END;

SELECT DatosXML, dbo.CKXMLDatoInvalido2(DatosXML) FROM EjmplXML
TRUNCATE table EjmplXML;
ALTER TABLE EjmplXML
ADD CONSTRAINT CK_XMLSchema
CHECK(DatosXML IS NULL OR dbo.CKXMLDatoInvalido(DatosXML)=1);

ALTER TABLE EjmplXML DROP CONSTRAINT CK_XMLSchema;
--Esquema en XML
	--Definir un esquema de XML(XSD)
create   XML SCHEMA COLLECTION EsquemaDatosXML AS N'
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xs:element name="Persona">
		<xs:complexType>
			<xs:sequence>
				<xs:element name="Telefono" type="xs:string" minOccurs="0"/>
				<xs:element name="DocumentoIdentificacion" type="xs:string"/>
				<xs:element name="Nombre" type="xs:string"/>
				<xs:element name="Apellido" type="xs:string"/>
				<xs:element name="Ciudad" type="xs:string"/>		
			</xs:sequence>
		</xs:complexType>
	</xs:element>
</xs:schema>';
--atributos para determinar si un elemento es requerido o opcional
	--minOccurs especificar el numero minimo de veces que el elemento debe aparecer
	--maxOccurs especificar el numero maximo de veces que el elemento debe aparecer
	--Eliminar el esquema
	DROP XML SCHEMA COLLECTION EsquemaDatosXML;
	--Asociar el esquema a un columna XML
ALTER TABLE EjmplXML ALTER COLUMN DatosXML XML(EsquemaDatosXML);

--Consultar los schema de una BD
SELECT 
    name AS SchemaName, *
FROM sys.xml_schema_collections;




--*Indices XML
CREATE PRIMARY XML INDEX IX_PK_XML ON EjmplXML (DatosXML);

--*Consulta XML
SELECT DatosXML.value('(/Persona/DocumentoIdentificacion)[1]', 'int') AS DocumentoIdentificacion,
	DatosXML.value('(/Persona/Nombre)[1]', 'varchar(50)') AS Nombre,
	DatosXML.value('(/Persona/Apellido)[1]', 'varchar(50)') AS Apellido,
	DatosXML.value('(/Persona/Ciudad)[1]', 'varchar(50)') AS Ciudad
FROM EjmplXML
	 where DatosXML.value('(/Persona/DocumentoIdentificacion)[1]', 'int') =999999999;


/*Sentencia de T-SQL FOR XML
	Se utiliza para generar resultado de una consulta en SQL en formato XML
	*-SELECT
	*-INSERT
	*-UPDATE
	*-DELETE
	*-REPLACE
	*/
USE Northwind;

SELECT EmployeeID , FirstName, LastName, TitleOfCourtesy, BirthDate
	FROM Employees;

SELECT EmployeeID 'ID', FirstName, LastName, TitleOfCourtesy, BirthDate
	FROM Employees
	FOR XML AUTO, ROOT('Employees');
/* -FOR XML AUTO, indicar a SQLServer que genere automaticamente un documento XML basado en la estructura de la consulta y
	los nombre de las columnas
	-ROOT('Employees'), establece el elemento raiz del documento XML que va a crear

	FOR XML RAW, Devuelve un elemento por cada fila del resultado de la consulta.*/

SELECT EmployeeID, FirstName, LastName, TitleOfCourtesy, BirthDate
	FROM Employees
	FOR XML RAW, ROOT('Employees');

--	FOR XML PATH, construye documentos XML utilizando una estructura basada en rutas
SELECT EmployeeID, FirstName, LastName, TitleOfCourtesy, BirthDate
	FROM Employees
	FOR XML PATH, ROOT('Employees');

--FOR CML EXPLICIT, Ofrece un control preciso sobre la estuctura XMLutilizando un formato explicito
BEGIN
	DECLARE @xmlResultados XML;--Variable que utilizaremos para almacenar el resultado de la consulta

	SELECT @xmlResultados = (
		SELECT *
		FROM(
		SELECT	
			1 AS Tag,--Tag identifica el numero de la etiqueta XML
			NULL AS Parent,--especifica la realcion jeraquica entre las etiquetas, si el valor es NULL indica un elemento raiz
			NULL AS [Employees!1],--[NombreTabla!Alias] especifica el nombre del elemento y opcionalmente un alias para la tabla
			NULL AS [Employees!2!Titulo],
			NULL AS [Employees!2!Nombre],
			NULL AS [Employees!2!Apellido],
			NULL AS [Employees!2!FechaCumpleaños],
			NULL AS [Employees!2!EmployeeID]
			UNION ALL
			SELECT 
			2 AS Tag,
			1 AS Parent,
			NULL AS [Employees!1],
			TitleOfCourtesy, 
			FirstName, 
			LastName, 
			BirthDate, 
			EmployeeID
			FROM Employees) AS t
			FOR XML EXPLICIT);
	SELECT @xmlResultados;
END;