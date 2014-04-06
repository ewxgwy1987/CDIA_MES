USE [BHSDB]
GO
/****** Object:  StoredProcedure [dbo].[stp_SAC_CHECKMUAVAILABILITY]    Script Date: 21/02/2014 09:31:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[stp_SAC_CHECKMUAVAILABILITY] 
	@DESTINATION CHAR(4),
	@DEST_DESCR VARCHAR(10),
	@LOCATION CHAR(4),
	@ORGREASON VARCHAR(2),
	@ORGREASON_DESCR VARCHAR(100),
	@RETVAL VARCHAR(4) OUTPUT,
	@REASON VARCHAR(2) OUTPUT,
	@RETVAL_DESCR VARCHAR(10) OUTPUT,
	@REASON_DESCR VARCHAR(100) OUTPUT 
AS
DECLARE
    @RESOURCE VARCHAR(10),
    @SUBSYSTEM VARCHAR(10),
    @LOCATION_NAME VARCHAR(20),
    @COUNT INT,
    @COUNT2 INT,
    @RECIRCULATE BIT
BEGIN
    SET @RETVAL = ''
    
    SELECT @RESOURCE = DESTINATION FROM DESTINATIONS WHERE LOCATION_ID = @DESTINATION 
    SELECT @SUBSYSTEM = SUBSYSTEM, @LOCATION_NAME = LOCATION FROM LOCATIONS WHERE LOCATION_ID = @LOCATION 
    
    -- STEP 1 : IF BAG'S CURRENT LOCATION IS AT MANUAL ENCODING STATION. 
    --          MAP IT TO THE NEAREST MAIN LINE IN ORDER TO CHECK AVAILABILITY OF IT'S ASSIGNED DESTINATION
    IF @SUBSYSTEM = 'ME1'
       BEGIN 
          SET @SUBSYSTEM = 'ML1' 
       END
    ELSE IF @SUBSYSTEM = 'ME2'
       BEGIN 
          SET @SUBSYSTEM = 'ML2'
       END 
    ELSE IF @SUBSYSTEM = 'ME3'
       BEGIN 
          SET @SUBSYSTEM = 'ML4' 
       END
        
    -- STEP 2 : CHECK DESTINATION AVAILABILITY EXCEPT MES. THIS IS BECAUSE AS LONG IT IS UNKNOWN / ERROR BAG IT WILL STILL GO TO MES, NO OTHER WAYS IT CAN PROCEED TO.
    IF (@RESOURCE != 'MES')
		BEGIN
		    
		    -- CHECK WHETHER IS BAG NOT ABLE DIVERT TO THE DESTINATION AT DIVERSION POINT.
		    IF EXISTS(SELECT * FROM DESTINATION_CHUTE_MAPPING WHERE LOCATION_ID = @LOCATION)
		       BEGIN
		            SELECT @SUBSYSTEM=SUBSYSTEM,@LOCATION_NAME=LOCATIONS,@RECIRCULATE=RECIRCULATE FROM DESTINATION_CHUTE_MAPPING WHERE LOCATION_ID = @LOCATION
		            
					-- CHECK MU AVAILABILITY 
					SELECT @COUNT = COUNT(*) FROM DESTINATION_CHUTE_MAPPING A INNER JOIN DESTINATIONS B ON (A.DESTINATION = B.DESTINATION)
					WHERE A.DESTINATION = @RESOURCE AND 
						  A.SUBSYSTEM IN (SELECT PATH FROM DESTINATION_PATH_MAPPING WHERE SUBSYSTEM = @SUBSYSTEM) AND 
						 (SELECT COUNT(STATUS) FROM DESTINATION_CHUTE_MAPPING   
						  WHERE DESTINATION = @RESOURCE AND SUBSYSTEM = A.SUBSYSTEM AND [STATUS] = '2') = 0 AND
						  B.IS_AVAILABLE = 1
					
					-- CHECK ABILITY TO RECIRCULATE TO THE SAME DESTINATION THROUGH THE NEXT DIVERSION POINT OR ATR
					IF @RECIRCULATE = 0
					   BEGIN
					       SET @COUNT = 0 
					   END
		       END
		    ELSE 
		       BEGIN
		            -- CHECK MU AVAILABILITY
					SELECT @COUNT = COUNT(*) FROM DESTINATION_CHUTE_MAPPING A INNER JOIN DESTINATIONS B ON (A.DESTINATION = B.DESTINATION)
					WHERE A.DESTINATION = @RESOURCE AND 
						  A.SUBSYSTEM IN (SELECT PATH FROM DESTINATION_PATH_MAPPING WHERE SUBSYSTEM = @SUBSYSTEM) AND 
						 (SELECT COUNT(STATUS) FROM DESTINATION_CHUTE_MAPPING   
						  WHERE DESTINATION = @RESOURCE AND SUBSYSTEM = A.SUBSYSTEM AND [STATUS] = '2') = 0 AND
						  B.IS_AVAILABLE = 1
		       END   
		           
			-- IF DESTINATION IS AVAILABLE, RETURN THE ASSIGNED DESTINATION
			IF (@COUNT > 0)
			   BEGIN
			      SET @REASON = @ORGREASON
				  SET @REASON_DESCR = @ORGREASON_DESCR 
				  SET @RETVAL = @DESTINATION
				  SET @RETVAL_DESCR = @DEST_DESCR  
		          
				  RETURN 0 
			   END 
			ELSE -- ELSE RETURN DUMP DISCHARGE DESTINATION
			   BEGIN 
			      SET @REASON = '15'
			      
				  SELECT @RETVAL = LOCATION_ID, @RETVAL_DESCR = B.DESTINATION, @REASON_DESCR = (SELECT SR.DESCRIPTION FROM SORTATION_REASON SR WHERE SR.REASON = @REASON)  
				  FROM FUNCTION_ALLOC_LIST A INNER JOIN DESTINATIONS B ON (A.[RESOURCE] = B.DESTINATION) 
				  WHERE FUNCTION_TYPE = 'DUMP' AND IS_ENABLED = 1
		          
				  RETURN 0
			   END   
		END
	ELSE 
	    BEGIN
	        SET @REASON = @ORGREASON 
	        SET @REASON_DESCR = @ORGREASON_DESCR
			SET @RETVAL = @DESTINATION
			SET @RETVAL_DESCR = @DEST_DESCR

	        
	        RETURN 0
	    END	   
END
