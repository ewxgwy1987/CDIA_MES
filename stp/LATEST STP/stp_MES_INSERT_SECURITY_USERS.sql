USE [BHSDB_OKC]
GO
/****** Object:  StoredProcedure [dbo].[stp_MES_INSERT_SECURITY_GROUP_TASK_MAPPING]    Script Date: 02-04-2014 2:33:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_MES_INSERT_SECURITY_USERS]
	@SECURITY_USERS_TABLETYPE SECURITY_USERS_TABLETYPE READONLY
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM SECURITY_USERS;
	
    INSERT INTO SECURITY_USERS([USER_NAME], [USER_PASSWORD], [AD_USER_GROUP], [COMPANY], [JOB_TITLE], [AIRPORT_BADGE], [IS_ACTIVE], [DESCRIPTION]) 
	SELECT [USER_NAME], [USER_PASSWORD], [AD_USER_GROUP], [COMPANY], [JOB_TITLE], [AIRPORT_BADGE], [IS_ACTIVE], [DESCRIPTION]
    FROM @SECURITY_USERS_TABLETYPE

END
