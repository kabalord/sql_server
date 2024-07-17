/* 
Para deshabilitar una única constraint:

ALTER TABLE MyTable NOCHECK CONSTRAINT MyConstraint
Y para volver a habilitar la constraint:

ALTER TABLE MyTable CHECK CONSTRAINT MyConstraint
Para deshabilitar todas las constraints de una tabla:

ALTER TABLE MyTable NOCHECK CONSTRAINT ALL
Y para volver a habilitar todas las constraints de una tabla:

ALTER TABLE MyTable CHECK CONSTRAINT ALL
*/

ALTER TABLE NO_RCENO NOCHECK CONSTRAINT NOF01RCENO
ALTER TABLE NO_RCENO CHECK CONSTRAINT NOF01RCENO
 



