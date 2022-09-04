```
> docker-compose -f .\docker-compose.yml up -d --build
```


# How to restore SQL Server database from backup using T-SQL Commands
RESTORE DATABASE command is the most basic and universal way to restore SQL Server backups since T-SQL commands work everywhere whether you type them in SQL Server Management Studio, execute via sqlcmd utility or run from your program. Let’s review what commands are used to restore three types of backup: full, differential, and transaction log backups.

# Restore Full SQL Server database backup
Full backups contain all information necessary to restore your database to the point in time when the backup process had finished. The backup will overwrite your database if such is exist or produce a new SQL Server database. Let’s your full backup is stored in /home/people_full.bak and you want to restore it to people database. You need to execute the following commands:

```sql
RESTORE DATABASE people FROM DISK = '/home/bkp/people_full.bak'
```
If you are going to continue with restoring differential or transaction log backups after that, you need to add the NORECOVERY option. This will leave the backup process in a restoring state and allow you to restore extra differential or transaction log backups.

```sql
RESTORE DATABASE people FROM DISK = '/home/people_full.bak' WITH NORECOVERY
```

# Restore Differential SQL Server database backup
Differential backups contain changes that took place in the database since the last full backup. The last differential backup accumulates all the changes so you don’t need all previous differential backups to restore a database, just the last one. Before restoring the differential backup, and need to restore the last full backup first with the NORECOVERY option and then the last differential backup with the RECOVERY option:
```sql
RESTORE DATABASE people FROM DISK = '/home/people_full.bak' WITH NORECOVERY
GO
RESTORE DATABASE people FROM DISK = '/home/people_diff.dif' WITH RECOVERY
GO
```

# Restore Transaction Log SQL Server database backup
Transaction log backups contain all transactions that took place between the last transaction log backup (or the first full backup) and the moment when the backup process had finished. You have to restore all transaction log backups made after the last differential backup in the same sequence they were made. And, obviously, log backups are restored after you’re done with full and differential backups (Read more about Point-in-time recovery):

```sql
RESTORE DATABASE people FROM DISK = '/home/people_full.bak' WITH NORECOVERY
GO
RESTORE DATABASE people FROM DISK = '/home/people_diff.dif' WITH NORECOVERY
GO
RESTORE LOG people FROM DISK = '/home/people_log1.trn' WITH NORECOVERY
GO
RESTORE LOG people FROM DISK = '/home/people_log2.trn' WITH RECOVERY
GO
```