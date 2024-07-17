--SQL Server es un sistema de gestion de bases de datos relacional (RDBMS)

/*Componentes que podemos encontrar en SQL Server

1-Database Engine: Motor Principal gestionar el almacenamiento, procesamiento y seguridad de los datos

2-Herramientas de Desarrollo: 
	SSMS-SQL Sever Management Studio: facilita la creacion, modificacion, mantenimiento, moniterio de un BD 
	mediante la interfaz grafica

3-Integration Services (SSIS) es un componente que se utiliza para resolver problemas empresariales complejos al copiar o 
	descargar archivos, extraer y transformar datos de diversas fuentes de datos para posterior cargarlos en uno o varios destinos.
	Elementos Paquete de Integration Services, Flujo de Control, Flujo de Datos, Conexiones, Tranformaciones, variables y parametros
				manejo de Eventos, Registro y manejo de Errores, Implementacion y Ejecucion, Catalogo de SSIS

4-Analysis Services (SSAS) No premite construir Analisis de Datos y de soluciones de intelegia empresarial
	Tecnologias principales 
		//Cubos Multidimensionales
		*-Dimensiones(tiempo, ubicacion, productos) y Medidas(Ventas, Costos, Stop y/o cantidades)
		*-Cubos
		*-Jerarquias
		*-MDX(Multidimesional Expressions)

		//Modelos Tabulares
		*-Tablas y Columnas
		*-Relaciones
	    * DAX (Data Analysisi Expressions)

		//Casos Comunes
		*-Analisis de Ventas
		*-Inteligencia Empresarial
		*-Analisis de Rendimiento
		*-Prediccion Y planificacion

5-Reporting Services(SSRS) se enfoca en la generacion y entrega de informes visuales 
	Caracteristicas
	*-Diseñar Informes
	*-Fuentes de Datos
	*-Parametrizacion
	*-Programacion de Informes
	*-Suscripciones y Entrega
	
	//Casos Comunes
	_Informes Financieros
	_Tableros de Control
	_Informes de Ventas
	_Reportes de Recursos Humanos

6-Herramientas de Seguridad para gestionar la seguridad, a traves de procesos de autenticacion, autorizacion y cifrado de los datos


Version de SqlServer
	- Express
	- Standard
	- Enterprise
	- Developer
	- Azure SQL Database
*/
--Consultar el usuario con que estoy ejecutando
SELECT SUSER_NAME() 'usuario',  ORIGINAL_LOGIN() 'login';

SELECT dp.permission_name, dp.state_desc, dp.class_desc, OBJECT_NAME(dp.major_id) AS object_name, 
	d.name AS grantee_name
FROM sys.database_permissions dp
JOIN sys.database_principals d ON dp.grantee_principal_id = d.principal_id
WHERE d.name = 'ingjorge'; -- Reemplaza 'nombre_de_usuario' con el nombre del usuario que deseas verificar

--Asignar todos los permisos
SELECT * FROM sys.server_principals WHERE name = 'JORLUFONBAL-ASU\User';
ALTER ROLE db_owner ADD MEMBER [JORLUFONBAL-ASU\User];


--Consulta de los usuarios loales en el servidor de SqlServer
SELECT name, type_desc, create_date
FROM sys.server_principals
WHERE type_desc IN ('WINDOWS_LOGIN', 'SQL_LOGIN');

-- Consulta roles de servidor para un usuario
SELECT 
    SP.name AS UserName,
    SRP.name AS RoleName
FROM 
    sys.server_role_members SRM
JOIN 
    sys.server_principals SP ON SRM.member_principal_id = SP.principal_id
JOIN 
    sys.server_principals SRP ON SRM.role_principal_id = SRP.principal_id
WHERE 
    SP.name = 'ingjorge';

-- Consulta roles de base de datos para un usuario
SELECT 
    DP.name AS UserName,
    DRP.name AS RoleName
FROM 
    sys.database_role_members DRM
JOIN 
    sys.database_principals DP ON DRM.member_principal_id = DP.principal_id
JOIN 
    sys.database_principals DRP ON DRM.role_principal_id = DRP.principal_id
WHERE 
    DP.name = 'pruebaBD';


SELECT * FROM Region;
ALTER LOGIN sa WITH PASSWORD ='j0RLUNFONbal'
--Crear un Usuario
	--Crear un usuario de Windows
	--CREATE LOGIN [DOMINIO\Usuario] FROM WINDOWS;
	CREATE LOGIN [JORLUFONBAL-ASU\xx] FROM WINDOWS;

	--Creacion un Usuario de SQLServer
	CREATE LOGIN pruebaBD WITH PASSWORD ='pruebaBD';
	CREATE USER pruebaBD FOR LOGIN pruebaBD;


USE Northwind;
CREATE LOGIN ColombiaBD WITH PASSWORD = '03012024';
CREATE LOGIN Venezuela WITH PASSWORD = 'Ven123';
CREATE USER ingjorge FOR LOGIN ColombiaBD;




SELECT name FROM sys.sql_logins WHERE name= 'ColombiaBD';--Consulta existencia de usuario o Rol
SELECT * FROM sys.database_permissions where grantee_principal_id = USER_ID();

--Crear un Rol 
CREATE ROLE soloLectura;
--Asignar permiso a un ROL a una tabla
GRANT SELECT ON OBJECT::Employees TO soloLectura;

--Asignar el rol a un usuario
ALTER ROLE soloLectura ADD MEMBER [ingjorge];

--Asignacion de permisos directo a un usuario
GRANT SELECT ON Region TO ingjorge;

GRANT SELECT, INSERT, UPDATE, DELETE ON nombretabla TO nomUsuario;

-- Rol con todos los permisos de BD db_owner
ALTER ROLE db_owner ADD MEMBER ingjorge;

--Procedmiento de SQlServer para agregar un usuaro a un rol
--EXEC sp_addrolemember 'rol','miembro';
EXEC sp_addrolemember 'soloLectura','pruebaBD';
EXEC sp_droprolemember 'soloLectura','pruebaBD';

--Revocar permisos a un usuario
REVOKE INSERT ON Region TO ingjorge;

--QUITAR todos los permisos(uSO CON CUIDADO)
DENY SELECT ON Employees TO ingjorge;
REVOKE SELECT ON Employees TO ingjorge;

GRANT SELECT ON Employees TO ingjorge;
/*7.Tecnologias Emergente*/