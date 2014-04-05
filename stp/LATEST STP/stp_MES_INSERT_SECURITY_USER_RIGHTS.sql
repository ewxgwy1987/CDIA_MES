USE [BHSDB_OKC]
GO
/****** Object:  StoredProcedure [dbo].[stp_MES_INSERT_SECURITY_GROUP_TASK_MAPPING]    Script Date: 02-04-2014 2:33:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_MES_INSERT_SECURITY_USER_RIGHTS]
	@SECURITY_USER_RIGHTS_TABLETYPE SECURITY_USER_RIGHTS_TABLETYPE READONLY
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM SECURITY_USER_RIGHTS;
	
    INSERT INTO SECURITY_USER_RIGHTS([USER_NAME], [SECU_GROUP_CODE]) 
	SELECT [USER_NAME], [SECU_GROUP_CODE]
    FROM @SECURITY_USER_RIGHTS_TABLETYPE

END
