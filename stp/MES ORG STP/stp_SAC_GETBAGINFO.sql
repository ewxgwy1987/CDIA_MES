USE [BHSDB]
GO
/****** Object:  StoredProcedure [dbo].[stp_SAC_GETBAGINFO]    Script Date: 24/02/2014 02:19:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SC LEONG
-- Create date: 01-NOV-2013
-- Description: To collect bag info based on GID
-- =============================================
ALTER PROCEDURE [dbo].[stp_SAC_GETBAGINFO] 
       @GID varchar(10),
       @SCANNED_STATUS VARCHAR(2) OUTPUT,
       @LICENSE_PLATE1 VARCHAR(10) OUTPUT,
       @LICENSE_PLATE2 VARCHAR(10) OUTPUT,
       @AIRLINE VARCHAR(3) OUTPUT,
       @FLIGHT_NUMBER VARCHAR(5) OUTPUT,
       @SDO VARCHAR(10) OUTPUT,
       @DESTINATION VARCHAR(20) OUTPUT,
       @ENCODEDTYPE VARCHAR(2) OUTPUT 
AS
DECLARE 
       @TYPE VARCHAR(1)
BEGIN
       SET @LICENSE_PLATE1 = NULL 
       SET @LICENSE_PLATE2 = NULL 
       SET @AIRLINE = NULL 
       SET @FLIGHT_NUMBER = NULL 
       SET @SDO = NULL 
       SET @DESTINATION = NULL 
       SET @ENCODEDTYPE = NULL 
       
       SELECT @TYPE = [TYPE] FROM BAG_INFO WHERE GID = @GID  
                
       -- GET DATA FROM ITEM SCANNED TABLE
       IF (@TYPE = 1)
          BEGIN
              SELECT @SCANNED_STATUS = STATUS_TYPE, @LICENSE_PLATE1 = LICENSE_PLATE1, @LICENSE_PLATE2 = LICENSE_PLATE2   
              FROM ITEM_SCANNED 
              WHERE GID = @GID  
          END
       -- GET DATA FROM ITEM ENCODING REQUEST TABLE
       ELSE IF (@TYPE = 2)
          BEGIN
		       
		      
              SELECT @LICENSE_PLATE1 = A.LICENSE_PLATE ,@AIRLINE = A.AIRLINE , @FLIGHT_NUMBER = A.FLIGHT_NUMBER, 
                     @DESTINATION = A.DEST, @ENCODEDTYPE = A.ENCODING_TYPE
              FROM ITEM_ENCODED A
              WHERE GID = @GID   
          END
            
END

