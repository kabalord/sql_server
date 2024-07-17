DECLARE @TableName NVARCHAR(128)
DECLARE @ColumnName NVARCHAR(128)
DECLARE @IndexName NVARCHAR(128)
DECLARE @SQL NVARCHAR(MAX)

DECLARE curTables CURSOR FOR
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'

OPEN curTables
FETCH NEXT FROM curTables INTO @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE curColumns CURSOR FOR
    SELECT COLUMN_NAME
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @TableName

    OPEN curColumns
    FETCH NEXT FROM curColumns INTO @ColumnName

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @IndexName = 'IX_' + @TableName + '_' + @ColumnName
        SET @SQL = 'CREATE INDEX ' + @IndexName + ' ON ' + @TableName + '(' + @ColumnName + ')'
        PRINT @SQL -- Este comando imprimirá los comandos CREATE INDEX, puedes quitarlo si prefieres ejecutarlos directamente

        -- Ejecutar el comando CREATE INDEX
        -- EXEC sp_executesql @SQL

        FETCH NEXT FROM curColumns INTO @ColumnName
    END

    CLOSE curColumns
    DEALLOCATE curColumns

    FETCH NEXT FROM curTables INTO @TableName
END

CLOSE curTables
DEALLOCATE curTables