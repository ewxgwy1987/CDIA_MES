USE [BHSDB_OKC]
GO

/****** Object:  UserDefinedTableType [dbo].[FUNCTION_ALLOC_GANTT_TABLETYPE]    Script Date: 02-04-2014 11:39:26 AM ******/
CREATE TYPE [dbo].[SORTATION_REASON_TABLETYPE] AS TABLE(
    [REASON] [varchar](2) NOT NULL,
	[DESCRIPTION] [nvarchar](100) NOT NULL
)
GO


