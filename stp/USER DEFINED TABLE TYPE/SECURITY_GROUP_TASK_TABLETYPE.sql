USE [BHSDB_OKC]
GO

/****** Object:  UserDefinedTableType [dbo].[SECURITY_GROUP_TASK_MAPPING_TABLETYPE]    Script Date: 02-04-2014 2:33:16 PM ******/
CREATE TYPE [dbo].[SECURITY_GROUP_TASK_TABLETYPE] AS TABLE(
	[SECU_GROUP_CODE] [varchar](15) NOT NULL,
	[SECU_TASK_CODE] [varchar](15) NOT NULL,
	[IS_ACTIVE] [bit] NOT NULL
)
GO


