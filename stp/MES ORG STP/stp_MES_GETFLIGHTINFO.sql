USE [BHSDB]
GO
/****** Object:  StoredProcedure [dbo].[stp_MES_GETFLIGHTINFO]    Script Date: 13/03/2014 06:47:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SC Leong
-- Create date: 27-01-2014
-- Description:	Get Flight Info to be displayed on MES : Encode by Flight
-- =============================================
ALTER PROCEDURE [dbo].[stp_MES_GETFLIGHTINFO]
	-- Add the parameters for the stored procedure here
	@CARRIER VARCHAR(3),
	@FLIGHT_NO VARCHAR(4),
	@SDO VARCHAR(10)
AS
DECLARE 
    @ERROR VARCHAR(100),
	@COLUMN VARCHAR(3)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT @COLUMN = SYS_VALUE FROM SYS_CONFIG WHERE SYS_KEY = 'ALLOC_OPEN_RELATED'

	SET @ERROR = ''

	IF NOT EXISTS(SELECT * FROM FLIGHT_PLAN_SORTING WHERE AIRLINE = @CARRIER AND FLIGHT_NUMBER = @FLIGHT_NO AND SDO = @SDO)
	   BEGIN
	       SET @ERROR = 'No Flight Information received for Flight # ' + @CARRIER + ' ' + @FLIGHT_NO 

	       SELECT '' AS STD, '' AS ETD, '' AS FLIGHT_DEST, '' AS FLIGHT_STATUS, @ERROR AS ERROR
		   
		   RETURN 0   
	   END
	ELSE IF NOT EXISTS(SELECT * FROM FLIGHT_PLAN_ALLOC WHERE AIRLINE = @CARRIER AND FLIGHT_NUMBER = @FLIGHT_NO AND SDO = @SDO) 
	   BEGIN
	      SET @ERROR = 'No Flight Allocation for Flight # ' + @CARRIER + ' ' + @FLIGHT_NO 
		  
		  SELECT '' AS STD, '' AS ETD, '' AS FLIGHT_DEST, '' AS FLIGHT_STATUS, @ERROR AS ERROR
		   
		  RETURN 0  
	   END    
    ELSE
       BEGIN
	       
		   SELECT A.SDO AS STD, A.EDO AS ETD, A.FINAL_DEST, (SELECT dbo.MES_GETFLIGHTSTATUS(@CARRIER, @FLIGHT_NO, @SDO, A.STO)) AS FLIGHT_STATUS, '' AS ERROR
		   FROM FLIGHT_PLAN_SORTING A
		   WHERE A.AIRLINE = @CARRIER AND A.FLIGHT_NUMBER = @FLIGHT_NO AND SDO = @SDO
	   END
    	 
END
