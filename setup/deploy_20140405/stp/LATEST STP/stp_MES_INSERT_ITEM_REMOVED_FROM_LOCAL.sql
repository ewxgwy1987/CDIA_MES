USE [BHSDB_CLT]
GO
/****** Object:  StoredProcedure [dbo].[stp_MES_INSERT_ITEM_REMOVED_FROM_LOCAL]    Script Date: 04-04-2014 12:22:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_MES_INSERT_ITEM_REMOVED_FROM_LOCAL]
	@ITEM_REMOVE ITEM_REMOVED_TABLETYPE READONLY
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO ITEM_REMOVED ([TIME_STAMP], [GID], [LOCATION], [PLC_INDEX], [LICENSE_PLATE]) 
	SELECT TIME_STAMP, GID, LOCATION, PLC_INDEX,LICENSE_PLATE FROM @ITEM_REMOVE

END
