# PITR

1. full backup

 

USE testdb;
GO
BACKUP DATABASE testdb
   TO disk = 'c:\backups\testdb.bak'
   WITH NOINIT,
      NAME = 'Full Backup of testdb';
GO

 

2. backup des journaux de transactions:

 

BACKUP LOG testdb TO DISK = 'C:\backups\testdb_21h.TRN'
GO
BACKUP LOG testdb TO DISK = 'C:\backups\testdb_22h.TRN'
GO

 

...etc

 

3. pour restaurer la bdd en cas de crash à 22h30

 

4. 

RESTORE DATABASE testdb FROM DISK = ‘c:\backups\testdb.bak’
WITH NORECOVERY
GO

 

RESTORE LOG testdb FROM DISK =’C:\backups\testdb_21h.TRN’
WITH NORECOVERY
GO

 

RESTORE LOG testdb FROM DISK =’C:\backups\testdb_22h.TRN’
WITH RECOVERY
GO
