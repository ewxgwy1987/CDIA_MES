-- ##########################################################################
-- Release#:    R1.0
-- Release On:  20 Aug 2009
-- Filename:    4.3.RPT_InsertINIData.sql
-- Description: SQL Scripts of Inserting initial data into reporting related tables.
--    Tables in which the initial data need to be inserted:
--    01. [DESTINATION_GROUPING]
--    02. [SUBSYSTEM_GROUPING]
--	  03. [TRACKING_ZONE_GROUPING]
--
-- Histories:
--				R1.0 - Released on 20 Aug 2009.
-- ##########################################################################


USE [BHSDB]
GO


PRINT 'INFO: STEP 4.3 - Insert initial data into reporting related tables.'
PRINT 'INFO: .'
PRINT 'INFO: .'
PRINT 'INFO: .'
GO

PRINT 'INFO: Begining of Deleting Existing Initial Data...'
GO

/* ################################################################################################### */
/* STEP 1: Delect existing records */ 
--PRINT 'INFO: Delete existing records from table [DESTINATION_GROUPING].'
--DELETE FROM [dbo].[DESTINATION_GROUPING]
--PRINT 'INFO: Delete existing records from table [SUBSYSTEM_GROUPING].'
--DELETE FROM [dbo].[SUBSYSTEM_GROUPING]
PRINT 'INFO: Delete existing records from table [TRACKING_ZONE_GROUPING].'
DELETE FROM [dbo].[TRACKING_ZONE_GROUPING]

PRINT 'INFO: End of Deleting Existing Initial Data.'
GO
PRINT 'INFO: .'
PRINT 'INFO: .'
PRINT 'INFO: .'
GO
PRINT 'INFO: Begining of Insert New Initial Data...'
GO



/* Insert data into table [DESTINATION_GROUPING] */
--PRINT 'INFO: Inserting initial records into table [DESTINATION_GROUPING]...'
--INSERT INTO [BHSDB].[dbo].[DESTINATION_GROUPING] ([GROUP_NAME] ,[SUBSYSTEM] ,[LOCATION]) VALUES ('RT01','CA03','CA03-MA')
--INSERT INTO [BHSDB].[dbo].[DESTINATION_GROUPING] ([GROUP_NAME] ,[SUBSYSTEM] ,[LOCATION]) VALUES ('RT02','CA03','CA03-MB')
--INSERT INTO [BHSDB].[dbo].[DESTINATION_GROUPING] ([GROUP_NAME] ,[SUBSYSTEM] ,[LOCATION]) VALUES ('RT03','CA03','CA03-FS01')


/* Insert data into table [SUBSYSTEM_GROUPING] */
--PRINT 'INFO: Inserting initial records into table [SUBSYSTEM_GROUPING]...'
--INSERT INTO [BHSDB].[dbo].[SUBSYSTEM_GROUPING] ([GROUP_NAME], [LOCATION] ,[SUBSYSTEM]) VALUES ('CT01','CT01-21','CT01')
--INSERT INTO [BHSDB].[dbo].[SUBSYSTEM_GROUPING] ([GROUP_NAME], [LOCATION] ,[SUBSYSTEM]) VALUES ('RT01','CT01-23','CT01')
--INSERT INTO [BHSDB].[dbo].[SUBSYSTEM_GROUPING] ([GROUP_NAME], [LOCATION] ,[SUBSYSTEM]) VALUES ('CT02','CT02-21','CT02')



/* Insert data into table [TRACKING_ZONE_GROUPING] */
--PRINT 'INFO: Inserting initial records into table [TRACKING_ZONE_GROUPING]...'

INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])
		VALUES('SS1','SS1-01','SS1')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS1','SS1-02','SS1')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS1','SS1-03','SS1')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS1','SS1-04','SS1')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS1','SS1-05','SS1')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS1','SS1-06','SS1')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS1','SS1-07','SS1')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS2','SS2-01','SS2')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS2','SS2-02','SS2')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS2','SS2-03','SS2')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS2','SS2-04','SS2')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS2','SS2-05','SS2')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS2','SS2-06','SS2')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS2','SS2-07','SS2')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS1L3','SS1L3-12','SS1L3')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS1L3','SS1L3-13','SS1L3')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS1L3','SS1L3-14','SS1L3')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS1L3','SS1L3-15','SS1L3')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS1L3','SS1L3-16','SS1L3')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS2L3','SS2L3-12','SS2L3')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS2L3','SS2L3-13','SS2L3')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS2L3','SS2L3-14','SS2L3')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS2L3','SS2L3-15','SS2L3')
INSERT INTO [dbo].[TRACKING_ZONE_GROUPING] ([GROUP_NAME], [LOCATION],[SUBSYSTEM])	
		VALUES('SS2L3','SS2L3-16','SS2L3')
GO


PRINT 'INFO: End of Insert New Initial Data.'
GO
PRINT 'INFO: .'
PRINT 'INFO: .'
PRINT 'INFO: .'
GO
PRINT 'INFO: End of STEP 4.3'
