-- ##########################################################################################################
-- Release#:    R1.0
-- Release On:  15 Mar 2010
-- Filename:    Step3.1.MDS_CreateTable.sql
-- Description: SQL Scripts of creating BHS Solution Database [BHSDB] MDS 
--              related objects (table, trigger, foreign keys, etc.
--
--    Tables to be created by this script:
--    =====================================================================================================
--	  Historical Tables:
--	  Remark: Housekeeping (e.g. 3 ~ 6 months) is needed. 	
--    =====================================================================================================
--    01. [MDS_DATA]	  - Working data table used to store the MDS raw alarm data. 
--                          Records in this table is inserted by iFix Alarm OBDC functions.
--                          The INSERT trigger of this table will duplicate the new records into 
--                          historical data table [MDS_LOGS] for MDS raw alarm data logging. the
--                          insert trigger will also produce the new records and save the produced 
--                          alarm data insert to table historical data table [MDS_ALARMS] for 
--                          reporting purpose.
--                          Records in this table will be deleted immediately by its INSERT trigger 
--                          at the end of trigger execution.
--    02. [MDS_LOGS]      - Used to store the MDS raw alarm data. 
--    03. [MDS_ALARMS]    - Used to store the MDS produced alarm data. 
--    04. [MDS_EVENTS]	  - Used to store the MDS produced events data. 
--    05. [MDS_AUDIT_LOGS]- Used to store all pre-defined operator actions invoked from the MSD(Visualisation)
--							application.	                 
--	  06. [MDS_BAG_COUNT] - Used to store the value of bag counter that is implemented in PLC for 
--                          pre-defined locations on the conveyor lines. The data in this table can
--                          be used to compute the bag flow rate.
--    07. [MDS_HBS_DATA] -  Used to store the bag counter values implemented in PLC for different
--                          HBS result baggage. 
--    =====================================================================================================
--	  Working Tables:
--	  Remark: Housekeeping not required. 	
--    =====================================================================================================
--    01. [REPORT_FAULT] - Used to store the full list of MDS equipment fault and event codes that 
--                         will be used for reporting purpose and alarm filtering on the MDS current 
--                         and historical alarm pages.
--    02. [REPORT_FAULT_TYPES] -  Used to store a list of possible fault types used on the [REPORT_FAULT]
--						   table. 
--    03. [MDS_MAINTENANCE_STATUS] - Used to store the motor maintenance values (Current Running 
--                         Hour/Switch Cycle, and Total Accumulated Running Hour/Switch Cycle).
--	  04. [MDS_BAG_COUNTERS] - Use in conjuction with the table [MDS_BAG_COUNT] to provide more information on each bag count id,  
--							so those information can be used in report.
--    =====================================================================================================
--	  Indexes/Foreign Keys/Triggers
--	  Remark: None
--    =====================================================================================================
--    Index to be created by this script:
--    01. [IX_MDS_ALARMS_ALM_TAGNAME] - Index of table [MDS_ALARMS]
--
--    Foreign Keys to be created by this script:
--    01. [FK_FAULT_TYPES]
--    02. [FK_MDS_BAG_COUNT_MDS_BAG_COUNTERS]
--
--    Triggers to be created by this script:
--    01. [INSERT_MDS_DATA] - Insert trigger of table [MDS_DATA]
--                         This trigger does the following:
--						   (1) duplicate the all the incoming records into historical data 
--							   table [MDS_LOGS] for MDS raw alarm data logging;
--						   (2) duplicate all ALARMS records into the historical data table [MDS_ALARMS]
--							   for reporting purpose;
--						   (3) duplicate all EVENTS records into the historical data table [MDS_EVENTS]
--							   for reporting purpose;
--						   (4) duplicate activated & deactivated ALARMS records into the historical
--							   data table [CCTV_MDS_ACTIVATED_ALARMS] & [CCTV_MDS_DEACTIVATED_ALARMS] 
--							   respectivately for further process. This function is enabled if  
--							   the local variable @ENABLE_CCTV_LOG defined on the insert trigger of the  
--							   table [MDS_DATA] is set to 'TRUE'. 	
--    =====================================================================================================
--	  Histories
--	  Remark: None
--    =====================================================================================================
--    R1.0 - Released on 15 Mar 2010.
-- ########################################################################################################

USE [BHSDB]
GO

PRINT 'INFO: STEP3.1 - Creat BHS Solution Database MDS Tables'
PRINT 'INFO: .'
PRINT 'INFO: .'
PRINT 'INFO: .'
GO
PRINT 'INFO: Begining of Drop Existing Tables...'
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MDS_DATA]') AND type in (N'U'))
	DROP TABLE [dbo].[MDS_DATA]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MDS_LOGS]') AND type in (N'U'))
	DROP TABLE [dbo].[MDS_LOGS]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MDS_ALARMS]') AND type in (N'U'))
	DROP TABLE [dbo].[MDS_ALARMS]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[REPORT_FAULT]') AND type in (N'U'))
	DROP TABLE [dbo].[REPORT_FAULT]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[REPORT_FAULT_TYPES]') AND type in (N'U'))
	DROP TABLE [dbo].[REPORT_FAULT_TYPES]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MDS_MAINTENANCE_STATUS]') AND type in (N'U'))
	DROP TABLE [dbo].[MDS_MAINTENANCE_STATUS]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MDS_BAG_COUNT]') AND type in (N'U'))
	DROP TABLE [dbo].[MDS_BAG_COUNT]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MDS_BAG_COUNTERS]') AND type in (N'U'))
	DROP TABLE [dbo].[MDS_BAG_COUNTERS]


PRINT 'INFO: End of Drop Existing Tables.'
GO
PRINT 'INFO: .'
PRINT 'INFO: .'
PRINT 'INFO: .'
GO
PRINT 'INFO: Begining of Creating New Tables...'
GO

/****** Object:  Table [dbo].[MDS_DATA]    Script Date: 10/09/2007 09:13:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MDS_DATA]') AND type in (N'U'))
BEGIN
	PRINT 'INFO: Deleting existing table [MDS_DATA]...'
	DROP TABLE [dbo].[MDS_DATA]
END
GO
PRINT 'INFO: Creating table [MDS_DATA]...'
CREATE TABLE [dbo].[MDS_DATA](
	[ALM_NATIVETIMEIN] [datetime] NULL,
	[ALM_NATIVETIMELAST] [datetime] NULL,
	[ALM_LOGNODENAME] [char](10) NULL,
	[ALM_PHYSLNODE] [char](10) NULL,
	[ALM_TAGNAME] [char](30) NULL,
	[ALM_TAGDESC] [char](40) NULL,
	[ALM_VALUE] [char](40) NULL,
	[ALM_UNIT] [char](13) NULL,
	[ALM_MSGTYPE] [char](11) NULL,
	[ALM_MSGDESC] [char](480) NULL,
	[ALM_MSGID] [uniqueidentifier] NULL,
	[ALM_ALMSTATUS] [char](9) NULL,
	[ALM_ALMPRIORITY] [char](10) NULL,
	[ALM_ALMAREA] [char](500) NULL,
	[ALM_ALMEXTFLD1] [char](80) NULL,
	[ALM_ALMEXTFLD2] [char](80) NULL,
	[ALM_OPNAME] [char](32)  NULL,
	[ALM_OPFULLNAME] [char](80) NULL,
	[ALM_OPNODE] [char](10) NULL,
	[ALM_PERFNAME] [char](32) NULL,
	[ALM_PERFFULLNAME] [char](80) NULL,
	[ALM_PERFBYCOMMENT] [char](170) NULL,
	[ALM_VERNAME] [char](32) NULL,
	[ALM_VERFULLNAME] [char](80) NULL,
	[ALM_VERBYCOMMENT] [char](170) NULL,
	[ALM_DATEIN] [char](12) NULL,
	[ALM_TIMEIN] [char](15) NULL,
	[ALM_DATELAST] [char](12) NULL,
	[ALM_TIMELAST] [char](15) NULL,
	[ALM_ALMAREA1] [char](80) NULL,
	[ALM_ALMAREA2] [char](80) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO


/****** Object:  Table [dbo].[MDS_LOGS]    Script Date: 12/07/2007 09:59:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MDS_LOGS]') AND type in (N'U'))
BEGIN
	PRINT 'INFO: Deleting existing table [MDS_LOGS]...'
	DROP TABLE [dbo].[MDS_LOGS]
END
GO
PRINT 'INFO: Creating table [MDS_LOGS]...'
CREATE TABLE [dbo].[MDS_LOGS](
	[ALM_NATIVETIMEIN] [datetime] NULL,
	[ALM_NATIVETIMELAST] [datetime] NULL,
	[ALM_LOGNODENAME] [varchar](10) NULL,
	[ALM_PHYSLNODE] [varchar](10) NULL,
	[ALM_TAGNAME] [varchar](30) NULL,
	[ALM_TAGDESC] [nvarchar](40) NULL,
	[ALM_VALUE] [varchar](40) NULL,
	[ALM_UNIT] [varchar](13) NULL,
	[ALM_MSGTYPE] [varchar](11) NULL,
	[ALM_MSGDESC] [nvarchar](480) NULL,
	[ALM_MSGID] [uniqueidentifier] NULL,
	[ALM_ALMSTATUS] [varchar](9) NULL,
	[ALM_ALMPRIORITY] [varchar](10) NULL,
	[ALM_ALMAREA] [varchar](500) NULL,
	[ALM_ALMEXTFLD1] [varchar](80) NULL,
	[ALM_ALMEXTFLD2] [varchar](80) NULL,
	[ALM_OPNAME] [varchar](32) NULL,
	[ALM_OPFULLNAME] [varchar](80) NULL,
	[ALM_OPNODE] [varchar](10) NULL,
	[ALM_PERFNAME] [varchar](32) NULL,
	[ALM_PERFFULLNAME] [varchar](80) NULL,
	[ALM_PERFBYCOMMENT] [varchar](170) NULL,
	[ALM_VERNAME] [varchar](32) NULL,
	[ALM_VERFULLNAME] [varchar](80) NULL,
	[ALM_VERBYCOMMENT] [varchar](170) NULL,
	[ALM_DATEIN] [varchar](12) NULL,
	[ALM_TIMEIN] [varchar](15) NULL,
	[ALM_DATELAST] [varchar](12) NULL,
	[ALM_TIMELAST] [varchar](15) NULL,
	[ALM_ALMAREA1] [varchar](80) NULL,
	[ALM_ALMAREA2] [varchar](80) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO


/****** Object:  Table [dbo].[MDS_ALARMS]    Script Date: 11/01/2007 09:22:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MDS_ALARMS]') AND type in (N'U'))
BEGIN
	PRINT 'INFO: Deleting existing table [MDS_ALARMS]...'
	DROP TABLE [dbo].[MDS_ALARMS]
END
GO
PRINT 'INFO: Creating table [MDS_ALARMS]...'
CREATE TABLE [dbo].[MDS_ALARMS](
	[ALM_NATIVETIMEIN] [datetime] NULL,
	[ALM_NATIVETIMELAST] [datetime] NULL,
	[ALM_STARTTIME] [datetime] NULL,
	[ALM_ENDTIME] [datetime] NULL,
	[ALM_LOGNODENAME] [varchar](10) NULL,
	[ALM_PHYSLNODE] [varchar](10) NULL,
	[ALM_TAGNAME] [varchar](30) NULL,
	[ALM_TAGDESC] [nvarchar](40) NULL,
	[ALM_VALUE] [varchar](40) NULL,
	[ALM_UNIT] [varchar](13) NULL,
	[ALM_MSGTYPE] [varchar](11) NULL,
	[ALM_MSGDESC] [nvarchar](480) NULL,
	[ALM_MSGID1] [varchar](80) NULL,
	[ALM_MSGID2] [varchar](80) NULL,
	[ALM_ALMSTATUS] [varchar](9) NULL,
	[ALM_ALMPRIORITY] [varchar](10) NULL,
	[ALM_ALMAREA] [varchar](500) NULL,
	[ALM_ALMEXTFLD1] [varchar](80) NULL,
	[ALM_ALMEXTFLD2] [varchar](80) NULL,
	[ALM_OPNAME] [varchar](32) NULL,
	[ALM_OPFULLNAME] [varchar](80) NULL,
	[ALM_OPNODE] [varchar](10) NULL,
	[ALM_PERFNAME] [varchar](32) NULL,
	[ALM_PERFFULLNAME] [varchar](80) NULL,
	[ALM_PERFBYCOMMENT] [varchar](170) NULL,
	[ALM_VERNAME] [varchar](32) NULL,
	[ALM_VERFULLNAME] [varchar](80) NULL,
	[ALM_VERBYCOMMENT] [varchar](170) NULL,
	[ALM_DATEIN] [varchar](12) NULL,
	[ALM_TIMEIN] [varchar](15) NULL,
	[ALM_DATELAST] [varchar](12) NULL,
	[ALM_TIMELAST] [varchar](15) NULL,
	[ALM_ALMAREA1] [varchar](80) NULL,
	[ALM_ALMAREA2] [varchar](80) NULL,
	[ALM_UNCERTAIN] [int] NOT NULL CONSTRAINT [DF_MDS_ALARMS_ALM_UNCERTAIN]  DEFAULT ((0))
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_MDS_ALARMS_ALM_TAGNAME')
BEGIN
	PRINT 'INFO: Deleting existing INDEX [IX_MDS_ALARMS_ALM_TAGNAME]...';
    DROP INDEX [IX_MDS_ALARMS_ALM_TAGNAME] ON [dbo].[MDS_ALARMS];
END;
GO
PRINT 'INFO: Createing INDEX [IX_MDS_ALARMS_ALM_TAGNAME]...';
CREATE CLUSTERED INDEX [IX_MDS_ALARMS_ALM_TAGNAME] ON [dbo].[MDS_ALARMS] 
(
	[ALM_TAGNAME] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, 
	IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF
) ON [PRIMARY];
GO


/****** Object:  Table [dbo].[MDS_EVENTS]    Script Date: 11/01/2007 09:21:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MDS_EVENTS]') AND type in (N'U'))
BEGIN
	PRINT 'INFO: Deleting existing table [MDS_EVENTS]...'
	DROP TABLE [dbo].[MDS_EVENTS]
END
GO
PRINT 'INFO: Creating table [MDS_EVENTS]...'
CREATE TABLE [dbo].[MDS_EVENTS](
	[ALM_NATIVETIMEIN] [datetime] NULL,
	[ALM_NATIVETIMELAST] [datetime] NULL,
	[ALM_LOGNODENAME] [varchar](10) NULL,
	[ALM_PHYSLNODE] [varchar](10) NULL,
	[ALM_TAGNAME] [varchar](30) NULL,
	[ALM_TAGDESC] [nvarchar](40) NULL,
	[ALM_VALUE] [varchar](40) NULL,
	[ALM_UNIT] [varchar](13) NULL,
	[ALM_MSGTYPE] [varchar](11) NULL,
	[ALM_MSGDESC] [nvarchar](480) NULL,
	[ALM_MSGID] [uniqueidentifier] NULL,
	[ALM_ALMSTATUS] [varchar](9) NULL,
	[ALM_ALMPRIORITY] [varchar](10) NULL,
	[ALM_ALMAREA] [varchar](500) NULL,
	[ALM_ALMEXTFLD1] [varchar](80) NULL,
	[ALM_ALMEXTFLD2] [varchar](80) NULL,
	[ALM_OPNAME] [varchar](32) NULL,
	[ALM_OPFULLNAME] [varchar](80) NULL,
	[ALM_OPNODE] [varchar](10) NULL,
	[ALM_PERFNAME] [varchar](32) NULL,
	[ALM_PERFFULLNAME] [varchar](80) NULL,
	[ALM_PERFBYCOMMENT] [varchar](170) NULL,
	[ALM_VERNAME] [varchar](32) NULL,
	[ALM_VERFULLNAME] [varchar](80) NULL,
	[ALM_VERBYCOMMENT] [varchar](170) NULL,
	[ALM_DATEIN] [varchar](12) NULL,
	[ALM_TIMEIN] [varchar](15) NULL,
	[ALM_DATELAST] [varchar](12) NULL,
	[ALM_TIMELAST] [varchar](15) NULL,
	[ALM_ALMAREA1] [varchar](80) NULL,
	[ALM_ALMAREA2] [varchar](80) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF


/****** Object:  Table [dbo].[MDS_AUDIT_LOGS]    Script Date: 11/01/2007 09:21:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MDS_AUDIT_LOGS]') AND type in (N'U'))
BEGIN
	PRINT 'INFO: Deleting existing table [MDS_AUDIT_LOGS]...'
	DROP TABLE [dbo].[MDS_AUDIT_LOGS]
END
GO
PRINT 'INFO: Creating table [MDS_AUDIT_LOGS]...'
CREATE TABLE [dbo].[MDS_AUDIT_LOGS](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[TIME_STAMP] [datetime] NOT NULL,
	[MSG_DESC] [nvarchar](480) NULL,
	[MSG_TYPE] [nvarchar](50) NULL,
	[OP_NAME] [nvarchar](32) NULL,
	[OP_FULLNAME] [nvarchar](80) NULL,
	[IFIX_NODE] [varchar](15) NULL,
 CONSTRAINT [PK_MDS_AUDIT_LOGS] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF


/****** Object:  Table [dbo].[MDS_BAG_COUNT]    Script Date: 12/11/2009 18:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MDS_BAG_COUNT]') AND type in (N'U'))
BEGIN
	PRINT 'INFO: Deleting existing table [MDS_BAG_COUNT]...'
	DROP TABLE [dbo].[MDS_BAG_COUNT]
END
GO
PRINT 'INFO: Creating table [MDS_BAG_COUNT]...'
CREATE TABLE [dbo].[MDS_BAG_COUNT](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[TIME_STAMP] [datetime] NOT NULL,
	[COUNTER_ID] [varchar](20) NOT NULL,
	[PREVIOUS_COUNT] [int] NOT NULL,
	[CURRENT_COUNT] [int] NOT NULL,
	[DIFFERENT] [int] NOT NULL,
	[IFIX_NODE] [varchar](10) NULL,
 CONSTRAINT [PK_MDS_BAG_COUNT] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[MDS_BAG_COUNTERS]    Script Date: 11/01/2007 09:21:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MDS_BAG_COUNTERS]') AND type in (N'U'))
BEGIN
	PRINT 'INFO: Deleting existing table [MDS_BAG_COUNTERS]...'
	DROP TABLE [dbo].[MDS_BAG_COUNTERS]
END
GO
PRINT 'INFO: Creating table [MDS_BAG_COUNTERS]...'
CREATE TABLE [dbo].[MDS_BAG_COUNTERS](
	[COUNTER_ID] [varchar](20) NOT NULL,
	[SUBSYSTEM] [varchar](20) NOT NULL,
	[LOCATION] [varchar](20) NOT NULL,
	[PLC_ZONE] [varchar](10) NULL,
	[DESCRIPTION] [varchar](50) NULL,
CONSTRAINT [PK_MDS_BAG_COUNTERS] PRIMARY KEY CLUSTERED 
(
	[COUNTER_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
SET ANSI_PADDING OFF

/****** Object:  Table [dbo].[MDS_HBS_DATA]    Script Date: 02/20/2009 13:37:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MDS_HBS_DATA]') AND type in (N'U'))
BEGIN
	PRINT 'INFO: Deleting existing table [MDS_HBS_DATA]...'
	DROP TABLE [dbo].[MDS_HBS_DATA]
END
GO
PRINT 'INFO: Creating table [MDS_HBS_DATA]...'
CREATE TABLE [dbo].[MDS_HBS_DATA](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[TIME_STAMP] [datetime] NOT NULL,
	[PLC_ZONE] [varchar](10) NULL,
	[SUBSYSTEM] [varchar](10) NOT NULL,
	[LOCATION] [varchar](20) NOT NULL,
	[XRAYID] [varchar](20) NOT NULL,
	[SCREEN_LEVEL] [char](1) NOT NULL,
	[RESULT_TYPE] [varchar](1) NOT NULL,
	[PREVIOUS_COUNT] [int] NOT NULL,
	[CURRENT_COUNT] [int] NOT NULL,
	[DIFFERENT] [int] NOT NULL,
	[IFIX_NODE] [varchar](10) NULL,
 CONSTRAINT [PK_MDS_HBS_DATA] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  Table [dbo].[REPORT_FAULT]    Script Date: 11/01/2007 09:21:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[REPORT_FAULT]') AND type in (N'U'))
BEGIN
	PRINT 'INFO: Deleting existing table [REPORT_FAULT]...'
	DROP TABLE [dbo].[REPORT_FAULT]
END
GO
PRINT 'INFO: Creating table [REPORT_FAULT]...'
CREATE TABLE [dbo].[REPORT_FAULT](
	[FAULT_NAME] [varchar](10) NOT NULL,
	[FAULT_DESCRIPTION] [nvarchar](100) NOT NULL,
	[FAULT_TYPE] [varchar](11) NOT NULL,
	[FAULT_USED] [bit] NOT NULL,
	[MDS_USED] [bit] NOT NULL,
	[CCTV_USED] [bit] NOT NULL,
	[TIME_STAMP] [datetime] NOT NULL,
	[HELP_ID] [varchar](20) NULL,
CONSTRAINT [FAULT_PK] PRIMARY KEY CLUSTERED 
(
	[FAULT_NAME] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF



/****** Object:  Table [dbo].[REPORT_FAULT_TYPES]    Script Date: 10/08/2007 13:18:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[REPORT_FAULT_TYPES]') AND type in (N'U'))
BEGIN
	PRINT 'INFO: Deleting existing table [REPORT_FAULT_TYPES]...'
	DROP TABLE [dbo].[REPORT_FAULT_TYPES]
END
GO
PRINT 'INFO: Creating table [REPORT_FAULT_TYPES]...'
CREATE TABLE [dbo].[REPORT_FAULT_TYPES](
	[FAULT_TYPE] [varchar](11) NOT NULL,
	[DESCRIPTION] [varchar](50) NOT NULL,
CONSTRAINT [REPORT_FAULT_TYPES_PK] PRIMARY KEY CLUSTERED 
(
	[FAULT_TYPE] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO



/****** Object:  Table [dbo].[MDS_MAINTENANCE_STATUS]    Script Date: 11/01/2007 09:21:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MDS_MAINTENANCE_STATUS]') AND type in (N'U'))
BEGIN
	PRINT 'INFO: Deleting existing table [MDS_MAINTENANCE_STATUS]...'
	DROP TABLE [dbo].[MDS_MAINTENANCE_STATUS]
END
GO
PRINT 'INFO: Creating table [MDS_MAINTENANCE_STATUS]...'
CREATE TABLE [dbo].[MDS_MAINTENANCE_STATUS](
	[TIME_STAMP] [datetime] NOT NULL,
	[SUBSYSTEM] [varchar](20) NOT NULL,
	[EQUIP_ID] [varchar](20) NOT NULL,
	[PLC_ZONE] [varchar](10) NULL,
	[CURRENT_VALUE] [int] NOT NULL,
	[TOTAL_VALUE] [int] NOT NULL,
	[UNIT] [nvarchar](10) NOT NULL,
	[IFIX_NODE] [varchar](15) NULL,
CONSTRAINT [PK_MDS_MAINTENANCE_STATUS] PRIMARY KEY CLUSTERED 
(
	[SUBSYSTEM] ASC,
	[EQUIP_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
SET ANSI_PADDING OFF


PRINT 'INFO: End of Creating New Tables.'
GO
PRINT 'INFO: .'
PRINT 'INFO: .'
PRINT 'INFO: .'
GO
PRINT 'INFO: Begining of Creating New Foreign Keys...'
GO


/****** Object:  ForeignKey [FK_FAULT_TYPES]    Script Date: 10/08/2007 13:18:36 ******/
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_FAULT_TYPES]') AND parent_object_id = OBJECT_ID(N'[dbo].[FK_FAULT_TYPES]'))
BEGIN
	PRINT 'INFO: Deleting existing ForeignKey [FK_FAULT_TYPES]...'
	ALTER TABLE [dbo].[REPORT_FAULT] DROP CONSTRAINT [FK_FAULT_TYPES]
END
PRINT 'INFO: Creating ForeignKey [FK_FAULT_TYPES]...'
ALTER TABLE [dbo].[REPORT_FAULT]  WITH CHECK ADD  CONSTRAINT [FK_FAULT_TYPES] FOREIGN KEY([FAULT_TYPE])
REFERENCES [dbo].[REPORT_FAULT_TYPES] ([FAULT_TYPE])
GO
ALTER TABLE [dbo].[REPORT_FAULT] CHECK CONSTRAINT [FK_FAULT_TYPES]
GO


/****** Object:  ForeignKey [FK_MDS_HBS_DATA_MDS_HBS_DATA]    Script Date: 10/08/2007 13:18:36 ******/
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MDS_HBS_DATA_MDS_HBS_DATA]') AND parent_object_id = OBJECT_ID(N'[dbo].[FK_MDS_HBS_DATA_MDS_HBS_DATA]'))
BEGIN
	PRINT 'INFO: Deleting existing ForeignKey [FK_MDS_HBS_DATA_MDS_HBS_DATA]...'
	ALTER TABLE [dbo].[MDS_HBS_DATA] DROP CONSTRAINT [FK_MDS_HBS_DATA_MDS_HBS_DATA]
END
PRINT 'INFO: Creating ForeignKey [FK_MDS_HBS_DATA_MDS_HBS_DATA]...'
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[MDS_HBS_DATA]  WITH CHECK ADD  CONSTRAINT [FK_MDS_HBS_DATA_MDS_HBS_DATA] FOREIGN KEY([RESULT_TYPE])
REFERENCES [dbo].[ITEM_SCREEN_RESULT_TYPES] ([TYPE])
GO
ALTER TABLE [dbo].[MDS_HBS_DATA] CHECK CONSTRAINT [FK_MDS_HBS_DATA_MDS_HBS_DATA]
GO


/****** Object:  ForeignKey [FK_MDS_BAG_COUNT_MDS_BAG_COUNTERS]    Script Date: 12/11/2009 18:00:00 ******/
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MDS_BAG_COUNT_MDS_BAG_COUNTERS]') AND parent_object_id = OBJECT_ID(N'[dbo].[FK_MDS_BAG_COUNT_MDS_BAG_COUNTERS]'))
BEGIN
	PRINT 'INFO: Deleting existing ForeignKey [FK_MDS_BAG_COUNT_MDS_BAG_COUNTERS]...'
	ALTER TABLE [dbo].[MDS_BAG_COUNT] DROP CONSTRAINT [FK_MDS_BAG_COUNT_MDS_BAG_COUNTERS]
END
PRINT 'INFO: Creating ForeignKey [FK_MDS_BAG_COUNT_MDS_BAG_COUNTERS]...'
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[MDS_BAG_COUNT]  WITH CHECK ADD  CONSTRAINT [FK_MDS_BAG_COUNT_MDS_BAG_COUNTERS] FOREIGN KEY([COUNTER_ID])
REFERENCES [dbo].[MDS_BAG_COUNTERS] ([COUNTER_ID])
GO
ALTER TABLE [dbo].[MDS_BAG_COUNT] CHECK CONSTRAINT [FK_MDS_BAG_COUNT_MDS_BAG_COUNTERS]
GO



PRINT 'INFO: End of Creating New Foreign Keys.'
GO
PRINT 'INFO: .'
PRINT 'INFO: .'
PRINT 'INFO: .'
GO
PRINT 'INFO: Begining of Creating New Triggers...'
GO

/****** Object:  Trigger [INSERT_MDS_DATA]    Script Date: 10/08/2007 13:18:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[INSERT_MDS_DATA]'))
BEGIN
	PRINT 'INFO: Deleting existing trigger [INSERT_MDS_DATA]...'
	DROP TRIGGER [INSERT_MDS_DATA]
END
GO
PRINT 'INFO: Creating trigger [INSERT_MDS_DATA]...'
GO
CREATE  TRIGGER [dbo].[INSERT_MDS_DATA] ON [dbo].[MDS_DATA]
FOR INSERT
AS
BEGIN
	DECLARE @ENABLE_CCTV_LOG [bit], @CCTV_USED [bit]; 
	DECLARE @CCTV_DEVICE_TYPE [varchar](4), @CCTV_DEVICE_ID [varchar](20), @CCTV_CAMERA_POSITION_ID [varchar](2);
	DECLARE @ALM_NATIVETIMEIN [datetime], @ALM_NATIVETIMELAST [datetime];
	DECLARE @ALM_MSGID [uniqueidentifier];
	DECLARE @ALM_LOGNODENAME [char](10), @ALM_PHYSLNODE [char](10), @ALM_TAGNAME [char](30), 
			@ALM_TAGDESC [char](40), @ALM_VALUE [char](40), @ALM_UNIT [char](13), 
			@ALM_MSGTYPE [char](11), @ALM_MSGDESC [char](480), @ALM_ALMSTATUS [char](9),
			@ALM_ALMPRIORITY [char](10), @ALM_ALMAREA [char](500), @ALM_ALMEXTFLD1 [char](80),
			@ALM_ALMEXTFLD2 [char](80), @ALM_OPNAME [char](32),  @ALM_OPFULLNAME [char](80),
			@ALM_OPNODE [char](10), @ALM_PERFNAME [char](32), @ALM_PERFFULLNAME [char](80),
			@ALM_PERFBYCOMMENT [char](170), @ALM_VERNAME [char](32), @ALM_VERFULLNAME [char](80),
			@ALM_VERBYCOMMENT [char](170), @ALM_DATEIN [char](12), @ALM_TIMEIN [char](15),
			@ALM_DATELAST [char](12), @ALM_TIMELAST [char](15), @ALM_ALMAREA1 [char](80), 
			@ALM_ALMAREA2 [char](80);
	
	-- CCTV Logging can be disabled for those projects that does not have MDS-CCTV interface
	SET @ENABLE_CCTV_LOG = 'FALSE'
	  
	DECLARE INS_Cursor CURSOR FOR 
		SELECT ALM_NATIVETIMEIN, ALM_NATIVETIMELAST, ALM_LOGNODENAME, ALM_PHYSLNODE,
				ALM_TAGNAME, ALM_TAGDESC, ALM_VALUE, ALM_UNIT, ALM_MSGTYPE, ALM_MSGDESC,
				ALM_MSGID, ALM_ALMSTATUS, ALM_ALMPRIORITY, ALM_ALMAREA, ALM_ALMEXTFLD1, 
				ALM_ALMEXTFLD2, ALM_OPNAME, ALM_OPFULLNAME, ALM_OPNODE, ALM_PERFNAME,
				ALM_PERFFULLNAME, ALM_PERFBYCOMMENT, ALM_VERNAME, ALM_VERFULLNAME,
				ALM_VERBYCOMMENT, ALM_DATEIN, ALM_TIMEIN, ALM_DATELAST, ALM_TIMELAST,
				ALM_ALMAREA1, ALM_ALMAREA2 
		FROM INSERTED;
    OPEN INS_Cursor;

    FETCH NEXT FROM INS_Cursor INTO 
				@ALM_NATIVETIMEIN, @ALM_NATIVETIMELAST, @ALM_LOGNODENAME, @ALM_PHYSLNODE, 
				@ALM_TAGNAME, @ALM_TAGDESC, @ALM_VALUE, @ALM_UNIT, @ALM_MSGTYPE, @ALM_MSGDESC,
				@ALM_MSGID, @ALM_ALMSTATUS, @ALM_ALMPRIORITY, @ALM_ALMAREA, @ALM_ALMEXTFLD1, 
				@ALM_ALMEXTFLD2, @ALM_OPNAME, @ALM_OPFULLNAME, @ALM_OPNODE, @ALM_PERFNAME,
				@ALM_PERFFULLNAME, @ALM_PERFBYCOMMENT, @ALM_VERNAME, @ALM_VERFULLNAME,
				@ALM_VERBYCOMMENT, @ALM_DATEIN, @ALM_TIMEIN, @ALM_DATELAST, @ALM_TIMELAST,
				@ALM_ALMAREA1, @ALM_ALMAREA2;

    WHILE @@FETCH_STATUS = 0
    BEGIN
		INSERT INTO MDS_LOGS (
				ALM_NATIVETIMEIN, ALM_NATIVETIMELAST, ALM_LOGNODENAME, ALM_PHYSLNODE,
				ALM_TAGNAME, ALM_TAGDESC, ALM_VALUE, ALM_UNIT, ALM_MSGTYPE, ALM_MSGDESC,
				ALM_MSGID, ALM_ALMSTATUS, ALM_ALMPRIORITY, ALM_ALMAREA, ALM_ALMEXTFLD1,
				ALM_ALMEXTFLD2, ALM_OPNAME, ALM_OPFULLNAME, ALM_OPNODE, ALM_PERFNAME,
				ALM_PERFFULLNAME, ALM_PERFBYCOMMENT, ALM_VERNAME, ALM_VERFULLNAME,
				ALM_VERBYCOMMENT, ALM_DATEIN, ALM_TIMEIN, ALM_DATELAST, ALM_TIMELAST,
				ALM_ALMAREA1, ALM_ALMAREA2) 
		VALUES (
				@ALM_NATIVETIMEIN, @ALM_NATIVETIMELAST, @ALM_LOGNODENAME, @ALM_PHYSLNODE, 
				@ALM_TAGNAME, @ALM_TAGDESC, @ALM_VALUE, @ALM_UNIT, @ALM_MSGTYPE, @ALM_MSGDESC,
				@ALM_MSGID, @ALM_ALMSTATUS, @ALM_ALMPRIORITY, @ALM_ALMAREA, @ALM_ALMEXTFLD1, 
				@ALM_ALMEXTFLD2, @ALM_OPNAME, @ALM_OPFULLNAME, @ALM_OPNODE, @ALM_PERFNAME,
				@ALM_PERFFULLNAME, @ALM_PERFBYCOMMENT, @ALM_VERNAME, @ALM_VERFULLNAME,
				@ALM_VERBYCOMMENT, @ALM_DATEIN, @ALM_TIMEIN, @ALM_DATELAST, @ALM_TIMELAST,
				@ALM_ALMAREA1, @ALM_ALMAREA2);
		  
		IF @ALM_MSGTYPE = 'ALARM'
		BEGIN
			IF @ENABLE_CCTV_LOG = 'TRUE' AND (@ALM_ALMSTATUS = 'CFN' OR @ALM_ALMSTATUS = 'OK')  
			BEGIN
				SELECT @CCTV_USED = 'FALSE', @CCTV_DEVICE_TYPE = NULL, @CCTV_DEVICE_ID = NULL, @CCTV_CAMERA_POSITION_ID = NULL;  
				SET @CCTV_USED = (SELECT [CCTV_USED] FROM [REPORT_FAULT] WHERE [FAULT_NAME]= RTRIM(@ALM_ALMAREA2)); 
				
				IF @CCTV_USED = 'TRUE'
				BEGIN
					SELECT @CCTV_DEVICE_TYPE = [CCTV_DEVICE_TYPE], @CCTV_DEVICE_ID =[CCTV_DEVICE_ID], @CCTV_CAMERA_POSITION_ID = [CCTV_CAMERA_POSITION_ID] 
					FROM [CCTV_EQUIPMENT_MAPPING] 
					WHERE [SUBSYSTEM] = SUBSTRING(RTRIM(@ALM_ALMAREA1), 4, LEN(RTRIM(@ALM_ALMAREA1)) - 3) AND [EQUIPMENT_ID]= RTRIM(@ALM_ALMEXTFLD2); 
				END;
			END;
			
			IF @ALM_ALMSTATUS = 'CFN' 
			BEGIN
				UPDATE MDS_ALARMS SET ALM_UNCERTAIN = 1 
				WHERE (ALM_TAGNAME = RTRIM(@ALM_TAGNAME)) AND (ALM_ENDTIME IS NULL);

				INSERT INTO MDS_ALARMS (
					ALM_NATIVETIMEIN, ALM_NATIVETIMELAST, ALM_STARTTIME, ALM_ENDTIME, 
					ALM_LOGNODENAME, ALM_PHYSLNODE, ALM_TAGNAME, 
					ALM_TAGDESC, ALM_VALUE, ALM_UNIT, ALM_MSGTYPE, 
					ALM_MSGDESC, ALM_MSGID1, ALM_MSGID2, ALM_ALMSTATUS,
					ALM_ALMPRIORITY, ALM_ALMAREA, ALM_ALMEXTFLD1, 
					ALM_ALMEXTFLD2, ALM_OPNAME, ALM_OPFULLNAME, 
					ALM_OPNODE, ALM_PERFNAME, ALM_PERFFULLNAME,
					ALM_PERFBYCOMMENT, ALM_VERNAME, ALM_VERFULLNAME, 
					ALM_VERBYCOMMENT, ALM_DATEIN, ALM_TIMEIN, ALM_DATELAST, 
					ALM_TIMELAST, ALM_ALMAREA1, ALM_ALMAREA2, ALM_UNCERTAIN)
				VALUES (
					@ALM_NATIVETIMEIN, @ALM_NATIVETIMELAST, @ALM_NATIVETIMELAST, NULL, 
					RTRIM(@ALM_LOGNODENAME), RTRIM(@ALM_PHYSLNODE), RTRIM(@ALM_TAGNAME), 
					RTRIM(@ALM_TAGDESC), RTRIM(@ALM_VALUE), RTRIM(@ALM_UNIT), RTRIM(@ALM_MSGTYPE), 
					RTRIM(@ALM_MSGDESC), RTRIM(@ALM_MSGID), NULL, RTRIM(@ALM_ALMSTATUS), 
					RTRIM(@ALM_ALMPRIORITY), RTRIM(@ALM_ALMAREA), RTRIM(@ALM_ALMEXTFLD1), 
					RTRIM(@ALM_ALMEXTFLD2), RTRIM(@ALM_OPNAME), RTRIM(@ALM_OPFULLNAME), 
					RTRIM(@ALM_OPNODE), RTRIM(@ALM_PERFNAME), RTRIM(@ALM_PERFFULLNAME), 
					RTRIM(@ALM_PERFBYCOMMENT), RTRIM(@ALM_VERNAME), RTRIM(@ALM_VERFULLNAME),
					RTRIM(@ALM_VERBYCOMMENT), RTRIM(@ALM_DATEIN), RTRIM(@ALM_TIMEIN), RTRIM(@ALM_DATELAST), 
					RTRIM(@ALM_TIMELAST), SUBSTRING(RTRIM(@ALM_ALMAREA1), 4, LEN(RTRIM(@ALM_ALMAREA1)) - 3), 
					RTRIM(@ALM_ALMAREA2), 0);
				
				IF @ENABLE_CCTV_LOG = 'TRUE' AND @CCTV_USED = 'TRUE' AND (@CCTV_DEVICE_ID IS NOT NULL) AND (@CCTV_DEVICE_TYPE IS NOT NULL) AND (@CCTV_CAMERA_POSITION_ID IS NOT NULL)    	
				BEGIN
				    INSERT INTO CCTV_MDS_ACTIVATED_ALARMS (TIME_STAMP, SUBSYSTEM, EQUIPMENT_ID, ALARM_TYPE, 
						ALARM_DESCRIPTION, CCTV_DEVICE_TYPE, CCTV_DEVICE_ID, CCTV_CAMERA_POSITION_ID)	
					VALUES ( @ALM_NATIVETIMELAST,SUBSTRING(RTRIM(@ALM_ALMAREA1), 4, LEN(RTRIM(@ALM_ALMAREA1)) - 3),
						RTRIM(@ALM_ALMEXTFLD2), RTRIM(@ALM_ALMAREA2), RTRIM(@ALM_MSGDESC),
						@CCTV_DEVICE_TYPE, @CCTV_DEVICE_ID, @CCTV_CAMERA_POSITION_ID );
				END;
			END;
			
			IF @ALM_ALMSTATUS = 'OK'
			BEGIN
				UPDATE MDS_ALARMS SET 
					ALM_NATIVETIMELAST = @ALM_NATIVETIMELAST, 
					ALM_ENDTIME = @ALM_NATIVETIMELAST,
					ALM_MSGID2 = RTRIM(@ALM_MSGID)  
				WHERE 
					ALM_TAGNAME = RTRIM(@ALM_TAGNAME) AND 
					ALM_NATIVETIMEIN = @ALM_NATIVETIMEIN AND 
					ALM_ENDTIME IS NULL AND 
					ALM_UNCERTAIN = 0;
				
				IF @ENABLE_CCTV_LOG = 'TRUE' AND @CCTV_USED = 'TRUE' AND (@CCTV_DEVICE_ID IS NOT NULL) AND (@CCTV_DEVICE_TYPE IS NOT NULL) AND (@CCTV_CAMERA_POSITION_ID IS NOT NULL)    	
				BEGIN
				    INSERT INTO CCTV_MDS_DEACTIVATED_ALARMS (TIME_STAMP, SUBSYSTEM, EQUIPMENT_ID, ALARM_TYPE, 
						CCTV_DEVICE_TYPE, CCTV_DEVICE_ID, CCTV_CAMERA_POSITION_ID)	
					VALUES ( @ALM_NATIVETIMELAST,SUBSTRING(RTRIM(@ALM_ALMAREA1), 4, LEN(RTRIM(@ALM_ALMAREA1)) - 3),
						RTRIM(@ALM_ALMEXTFLD2), RTRIM(@ALM_ALMAREA2),
						@CCTV_DEVICE_TYPE, @CCTV_DEVICE_ID, @CCTV_CAMERA_POSITION_ID );
				END;
			END;
		END;

		IF @ALM_MSGTYPE = 'EVENT'
		BEGIN
			INSERT INTO MDS_EVENTS (
				ALM_NATIVETIMEIN, ALM_NATIVETIMELAST, ALM_LOGNODENAME, ALM_PHYSLNODE,
				ALM_TAGNAME, ALM_TAGDESC, ALM_VALUE, ALM_UNIT, ALM_MSGTYPE, ALM_MSGDESC,
				ALM_MSGID, ALM_ALMSTATUS, ALM_ALMPRIORITY, ALM_ALMAREA, ALM_ALMEXTFLD1,
				ALM_ALMEXTFLD2, ALM_OPNAME, ALM_OPFULLNAME, ALM_OPNODE, ALM_PERFNAME,
				ALM_PERFFULLNAME, ALM_PERFBYCOMMENT, ALM_VERNAME, ALM_VERFULLNAME,
				ALM_VERBYCOMMENT, ALM_DATEIN, ALM_TIMEIN, ALM_DATELAST, ALM_TIMELAST,
				ALM_ALMAREA1, ALM_ALMAREA2) 
			VALUES (
				@ALM_NATIVETIMEIN, @ALM_NATIVETIMELAST, @ALM_LOGNODENAME, @ALM_PHYSLNODE, 
				@ALM_TAGNAME, @ALM_TAGDESC, @ALM_VALUE, @ALM_UNIT, @ALM_MSGTYPE, @ALM_MSGDESC,
				@ALM_MSGID, @ALM_ALMSTATUS, @ALM_ALMPRIORITY, @ALM_ALMAREA, @ALM_ALMEXTFLD1, 
				@ALM_ALMEXTFLD2, @ALM_OPNAME, @ALM_OPFULLNAME, @ALM_OPNODE, @ALM_PERFNAME,
				@ALM_PERFFULLNAME, @ALM_PERFBYCOMMENT, @ALM_VERNAME, @ALM_VERFULLNAME,
				@ALM_VERBYCOMMENT, @ALM_DATEIN, @ALM_TIMEIN, @ALM_DATELAST, @ALM_TIMELAST,
				@ALM_ALMAREA1, @ALM_ALMAREA2);
		END;
	

		FETCH NEXT FROM INS_Cursor INTO 
				@ALM_NATIVETIMEIN, @ALM_NATIVETIMELAST, @ALM_LOGNODENAME, @ALM_PHYSLNODE, 
				@ALM_TAGNAME, @ALM_TAGDESC, @ALM_VALUE, @ALM_UNIT, @ALM_MSGTYPE, @ALM_MSGDESC,
				@ALM_MSGID, @ALM_ALMSTATUS, @ALM_ALMPRIORITY, @ALM_ALMAREA, @ALM_ALMEXTFLD1, 
				@ALM_ALMEXTFLD2, @ALM_OPNAME, @ALM_OPFULLNAME, @ALM_OPNODE, @ALM_PERFNAME,
				@ALM_PERFFULLNAME, @ALM_PERFBYCOMMENT, @ALM_VERNAME, @ALM_VERFULLNAME,
				@ALM_VERBYCOMMENT, @ALM_DATEIN, @ALM_TIMEIN, @ALM_DATELAST, @ALM_TIMELAST,
				@ALM_ALMAREA1, @ALM_ALMAREA2;
	END;

	CLOSE INS_Cursor;
	DEALLOCATE INS_Cursor;

	DELETE FROM [MDS_DATA];
END
GO 


PRINT 'INFO: .'
PRINT 'INFO: .'
PRINT 'INFO: .'
GO
PRINT 'INFO: End of STEP3.1'
GO