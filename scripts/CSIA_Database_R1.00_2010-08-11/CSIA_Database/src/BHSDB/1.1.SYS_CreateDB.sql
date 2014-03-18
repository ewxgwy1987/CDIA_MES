-- ##########################################################################
-- Description: SQL Scripts of creating BHS Solution Database [BHSDB].
-- Release#:    R1.0
-- Release On:  15 Mar 2010
-- Filename:    1.1.SYS_CreateDB.sql
-- Histories:
--				R1.0 - Released on 15 Mar 2010.
-- ##########################################################################


PRINT 'STEP 1.1 - Creating BHS Solution Database.'

EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'BHSDB'

USE [master]
GO

/****** Object:  Database [BHSDB]    Script Date: 7/24/2004 4:49:22 PM ******/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'BHSDB')
BEGIN
	PRINT 'WARN: BHS Solution Database has been existed! It will be dropped...'
	DROP DATABASE [BHSDB]
END
GO

/****** Object:  Database [BHSDB]    Script Date: 10/08/2007 13:01:54 ******/
PRINT 'INFO: Creating the new BHS Solution Database...'
CREATE DATABASE [BHSDB] ON  PRIMARY 
( NAME = N'BHSDB', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\BHSDB_New.mdf' , 
		SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'BHSDB_log', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\BHSDB_New_log.LDF' , 
		SIZE = 10240KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
EXEC dbo.sp_dbcmptlevel @dbname=N'BHSDB', @new_cmptlevel=90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BHSDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BHSDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BHSDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BHSDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BHSDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BHSDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [BHSDB] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [BHSDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [BHSDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BHSDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BHSDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BHSDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BHSDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BHSDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BHSDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BHSDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BHSDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BHSDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BHSDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BHSDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BHSDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BHSDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BHSDB] SET  READ_WRITE 
GO
ALTER DATABASE [BHSDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BHSDB] SET  MULTI_USER 
GO
ALTER DATABASE [BHSDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BHSDB] SET DB_CHAINING OFF 

PRINT 'INFO: End of STEP 1.1'

