USE [BHSDB_OKC]
GO

/****** Object:  UserDefinedTableType [dbo].[FUNCTION_ALLOC_GANTT_TABLETYPE]    Script Date: 02-04-2014 11:39:26 AM ******/
CREATE TYPE [dbo].[DESTINATION_CHUTE_MAPPING_TABLETYPE] AS TABLE(
    [DESTINATION] [varchar](10) NOT NULL,
	[SUBSYSTEM] [varchar](10) NOT NULL,
	[LOCATIONS] [varchar](20) NOT NULL,
	[STATUS] [varchar](2) NOT NULL,
	[RECIRCULATE] [bit] NOT NULL,
	[LOCATION_ID] [varchar](4) NULL
)
GO


