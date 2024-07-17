--INDICES;  es una estructura que mejora la velocidad de las operaciones de b�squeda en una tabla o vista

/*Tipos de Indices en SQLServer

1- Indice Cl�ster(Agrupado); Define el orden de los datos de una tabla y solo puede existir uno por tabla
2- Indice No Cl�ster(nO Agrupado); No definen el orden de los datos de la tabla, pueden ser mas de uno y mejoran la velocidad
	de las operaciones de busquedas y filtrado.
3- Indice Unicos; Garantizar que no exista duplicidad en la columna o columnas espeficidas, Puede ser Cl�ster o NO Cl�ster
4- Indice Agrupados; Similares a los Indices Cl�ster,no requiere que los datos esten ordenados fisicamente de la misma manera
	Se utiliza a menudo en vistas indexadas
5- Indice de Columna Calculada; se baja en una expresion calculada de una o mas columnas, ya que estan almacenado 
	los resultados	calculados y no los valores originales


Ventajas:
-Mejorar el rendimiento de las consultas (especifica)
-Reduccion en la carga del servidor
-Mejora en la integridad de los datos

Consideraciones:
-Impacto en el rendimiento de escritura
-Uso eficiente de indices
-Monitoreo y mantenimiento*/
SELECT * FROM Products;

CREATE TABLE XX(
	ID INT PRIMARY KEY,
	otro VARCHAR(50)
);