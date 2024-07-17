/*Tablas Temporales: Son tablas que existen temporalmente durante la session de la conexion que las crea o mientras se ejecuta
	una transaccion especifica.

--Tipos de mesas temporales:
#temporalLocal: son visibles solo para la sesion de BD actual o la que la creo y se eliminan auotmaticamente al
	finaliza la conexion del usuario o cuando se cierre la sesion que la creo(actual).

##temporalGlobal:son visibles para todas las sesion de BD y se eliminan auotmaticamente al
	finaliza la conexion del usuario o cuando se cierre la sesion que la creo(actual). 

*/
--Tabla temporal local
CREATE TABLE #TEMLOCAL(
	id int,
	nombre nvarchar(50)
);


INSERT INTO #TEMLOCAL(id,nombre) 
	VALUES(1,'Jorge'),(2,'Tomas');

UPDATE #TEMLOCAL set nombre = 'Luis' where id = 2;
select * from #TEMLOCAL;

--Tabla temporal global
CREATE TABLE ##TEMLOCAL(
	id int,
	nombre nvarchar(50)
);
select * from ##TEMLOCAL;

