-- ##########################################################################
-- Release#:    R1.0
-- Release On:  08 Jul 2010
-- Filename:    6.1.MES_CreateSTP.sql
-- Description: SQL Scripts of creating SQL Server Agent schedule jobs.
--
--    Schedule jobs to be created by this script:
--    01. stp_MES_GENERATEINHOUSEBSM
--    02. stp_MES_GET_BAG_GID
--    03. stp_MES_GET_COMBO_DATA
--    04. stp_MES_GET_IATA_TAG_LIST
--    05. stp_MES_GET_INHOUSE_BSM
--    06. stp_MES_GET_PROBLEM_LOCATION
--    07. stp_MES_GET_RUSH_LOCATION
--    08. stp_MES_GETFLIGHTALLOC
--    09. stp_MES_GETLASTENCODING
--    10. stp_MES_GETLICENSEPLATE
--    11. stp_MES_GETPESSENGERINFO
--    12. stp_MES_GETREQUIREDINFO
--    13. stp_MES_INSERT_INHOUSE_BSM
--    14. stp_MES_INSERT_ITEM_ENCODED
--    15. stp_MES_INSERT_ITEM_ENCODED_FROM_LOCAL
--    16. stp_MES_INSERT_ITEM_READY
--    17. stp_MES_INSERT_ITEM_READY_FROM_LOCAL
--    18. stp_MES_INSERT_ITEM_REMOVE_FROM_LOCAL
--    19. stp_MES_INSERT_ITEM_REMOVED
--    21. stp_MES_INSERT_MES_EVENT
--    21. stp_MES_INSERT_MES_EVENT_FROM_LOCAL
--    22. stp_MES_UPDATE_ITEM_INHOUSE_BSM
--
--
-- Histories:
--    R1.0 - Released on ?.
-- Remarks:
-- ##########################################################################

PRINT 'INFO: STEP 6.1 - Create MES storeprocedures.'
PRINT 'INFO: .'
PRINT 'INFO: .'
PRINT 'INFO: .'
GO

USE [BHSDB]
GO

/****** Object:  StoredProcedure [dbo].[stp_MES_GETFLIGHTALLOC]    Script Date: 07/08/2010 08:49:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Albert Sun
-- Create date: 24-Jun-2010
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stp_MES_GETFLIGHTALLOC]
	@AIRLINE varchar(3),
	@FLIGHTNO varchar(5)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT AIRLINE AS [Airline], FLIGHT_NUMBER AS [Flight], SDO, [RESOURCE] FROM FLIGHT_PLAN_ALLOC 
		WHERE TIME_STAMP BETWEEN DATEADD(HH,-6, GETDATE()) AND DATEADD(HH,24, GETDATE())
		AND AIRLINE LIKE '%' + @Airline AND FLIGHT_NUMBER LIKE '%' + @FLIGHTNO
		ORDER BY SDO ASC
END
GO
/****** Object:  StoredProcedure [dbo].[stp_MES_GET_INHOUSE_BSM]    Script Date: 07/08/2010 08:49:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Albert Sun
-- Create date: 01-Jul-2010
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stp_MES_GET_INHOUSE_BSM]
	@AIRLINE VARCHAR(5),
	@FLIGHT_NUMBER VARCHAR(5),
	@SDO DATETIME,
	@MES_STATION VARCHAR(16)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @SDO='01-JAN-1900'
	BEGIN
		SELECT [INHOUSEBSM], [AIRLINE], [FLIGHT_NUMBER], [SDO], [DESCRIPTION]
		FROM ITEM_INHOUSE_BSM WHERE [MES_STATION] = @MES_STATION AND [AIRLINE] LIKE '%' + @AIRLINE + '%'
		AND [FLIGHT_NUMBER] LIKE '%' + @FLIGHT_NUMBER + '%'
		ORDER BY [INHOUSEBSM]
	END
	ELSE
	BEGIN
		SELECT [INHOUSEBSM], [AIRLINE], [FLIGHT_NUMBER], [SDO], [DESCRIPTION]
		FROM ITEM_INHOUSE_BSM WHERE [MES_STATION] = @MES_STATION AND [AIRLINE] LIKE '%' + @AIRLINE + '%'
		AND [FLIGHT_NUMBER] LIKE '%' + @FLIGHT_NUMBER + '%' AND SDO = @SDO
		ORDER BY [INHOUSEBSM]
	END
END
GO
/****** Object:  StoredProcedure [dbo].[stp_MES_GET_COMBO_DATA]    Script Date: 07/08/2010 08:49:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Albert Sun
-- Create date: 05-Jul-2010
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stp_MES_GET_COMBO_DATA]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT CODE_DATA = '' 
	UNION ALL
    SELECT CODE_IATA FROM AIRLINES;

	SELECT FLIGHT_NUMBER = ''
	UNION ALL
	SELECT DISTINCT FLIGHT_NUMBER FROM FLIGHT_PLAN_SORTING WHERE [TIME_STAMP] BETWEEN DATEADD(HH,-6,GETDATE()) 
			AND DATEADD(HH,24,GETDATE());

	SELECT SDO = ''
	UNION ALL
	SELECT DISTINCT SDO FROM FLIGHT_PLAN_SORTING WHERE [TIME_STAMP] BETWEEN DATEADD(HH,-6,GETDATE()) 
			AND DATEADD(HH,24,GETDATE());
END
GO
/****** Object:  StoredProcedure [dbo].[stp_MES_GETLASTENCODING]    Script Date: 07/08/2010 08:49:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Albert Sun
-- Create date: 25-Jun-2010
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stp_MES_GETLASTENCODING]
	@MESSTATION varchar(16)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 1 E.LICENSE_PLATE AS LastEncoded, '' AS Reason FROM ITEM_ENCODED E 
		WHERE MES_STATION = @MESSTATION
		ORDER BY TIME_STAMP DESC
END
GO
/****** Object:  StoredProcedure [dbo].[stp_MES_GETREQUIREDINFO]    Script Date: 07/08/2010 08:49:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Albert Sun
-- Create date: 21-Jun-2010
-- Description:	Get all the required information from DB
-- =============================================
CREATE PROCEDURE [dbo].[stp_MES_GETREQUIREDINFO]
	@StationName	VARCHAR(20),
	@Status		INT -- [0 - initialization or 1 - get only changes]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Statecodes AS VARCHAR(200)
	EXEC @StateCodes = dbo.Mes_GETTablechanges @StationName, @Status
	-- AIRLINES
	IF((@Status = 0) OR (PATINDEX('%AIRLINES%', @Statecodes)>0))
	BEGIN
		SELECT [CODE_IATA], [CODE_ICAO], [NAME], [TICKETING_CODE], [DESTINATION], [DESTINATION1]
		FROM AIRLINES
	END
	ELSE
	BEGIN
		SELECT [CODE_IATA], [CODE_ICAO], [NAME], [TICKETING_CODE], [DESTINATION], [DESTINATION1]
		FROM AIRLINES WHERE [CODE_IATA] = ''
	END
	-- BAG INFO
	IF((@Status = 0) OR (PATINDEX('%BAG_INFO%', @Statecodes)>0))
	BEGIN
		SELECT [GID], [LICENSE_PLATE1], [LICENSE_PLATE2], [HBS1_RESULT], [HBS2_RESULT], 
		[HBS3_RESULT], [HBS4_RESULT], [HBS5_RESULT], [RECYLE_COUNT], [LAST_LOCATION], 
		[CREATED_BY], [TIME_STAMP]
		FROM BAG_INFO WHERE [TIME_STAMP] BETWEEN DATEADD(HH,-6,GETDATE()) 
		AND DATEADD(HH,24,GETDATE())
	END 
	ELSE
	BEGIN
		SELECT [GID], [LICENSE_PLATE1], [LICENSE_PLATE2], [HBS1_RESULT], [HBS2_RESULT], 
		[HBS3_RESULT], [HBS4_RESULT], [HBS5_RESULT], [RECYLE_COUNT], [LAST_LOCATION], 
		[CREATED_BY], [TIME_STAMP]
		FROM BAG_INFO WHERE [GID] = ''
	END
	-- BAG SORTING
	IF((@Status = 0) OR (PATINDEX('%BAG_SORTING%', @Statecodes)>0))
	BEGIN
		SELECT [DATA_ID], [TIME_STAMP], [DICTIONARY_VERSION], [SOURCE], [AIRPORT_CODE], [LICENSE_PLATE], [AIRLINE], [FLIGHT_NUMBER], [SDO], [DESTINATION], [TRAVEL_CLASS], [INBOUND_AIRLINE], [INBOUND_FLIGHT_NUMBER], [INBOUND_SDO], [INBOUND_AIRPORT_CODE], [INBOUND_TRAVEL_CLASS], [ONWARD_AIRLINE], [ONWARD_FLIGHT_NUMBER], [ONWARD_SDO], [ONWARD_AIRPORT_CODE], [ONWARD_TRAVEL_CLASS], [NO_PASSENGER_SAME_SURNAME], [SURNAME], [GIVEN_NAME], [OTHERS_NAME], [BAG_EXCEPTION], [CHECK_IN_COUNTER], [CHECK_IN_COUNTER_DESCRIPTION], [CHECK_IN_TIME_STAMP], [CHECK_IN_CARRIAGE_MEDIUM], [CHECK_IN_TRANSPORT_ID], [TAG_PRINTER_ID], [RECONCILIATION_LOAD_AUTHORITY], [RECONCILIATION_SEAT_NUMBER], [RECONCILIATION_PASSENGER_STATUS], [RECONCILIATION_SEQUENCE_NUMBER], [RECONCILIATION_SECURITY_NUMBER], [RECONCILIATION_PASSENGER_PROFILES_STATUS], [RECONCILIATION_TRANSPORT_AUTHORITY], [RECONCILIATION_BAG_TAG_STATUS], [HANDLING_TERMINAL], [HANDLING_BAR], [HANDLING_GATE], [WEIGHT_INDICATOR], [WEIGHT_CHECKED_BAG_NUMBER], [CHECKED_WEIGHT], [UNCHECKED_WEIGHT], [WEIGHT_UNIT], [WEIGHT_LENGTH], [WEIGHT_WIDTH], [WEIGHT_HEIGHT], [WEIGHT_BAG_TYPE_CODE], [GROUND_TRANSPORT_EARLIEST_DELIVERY], [GROUND_TRANSPORT_LATEST_DELIVERY], [GROUND_TRANSPORT_DESCRIPTION], [FREQUENT_TRAVELLER_ID_NUMBER], [FREQUENT_TRAVELLER_TIER_ID], [CORPORATE_NAME], [AUTOMATED_PNR_ADDRESS], [MESSAGE_PRINTER_ID], [INTERNAL_AIRLINE_DATA], [SECURITY_SCREENING_INSTRUCTION], [SECURITY_SCREENING_RESULT], [SECURITY_SCREENING_RESULT_REASON], [SECURITY_SCREENING_RESULT_METHOD], [SECURITY_SCREENING_AUTOGRAPH], [SECURITY_SCREENING_FREE_TEXT], [HIGH_RISK], [HBS_LEVEL_REQUIRED], [CREATED_BY]
		FROM BAG_SORTING WHERE [TIME_STAMP] BETWEEN DATEADD(HH,-6,GETDATE()) 
		AND DATEADD(HH,24,GETDATE())
	END
	ELSE
	BEGIN
		SELECT [DATA_ID], [TIME_STAMP], [DICTIONARY_VERSION], [SOURCE], [AIRPORT_CODE], [LICENSE_PLATE], [AIRLINE], [FLIGHT_NUMBER], [SDO], [DESTINATION], [TRAVEL_CLASS], [INBOUND_AIRLINE], [INBOUND_FLIGHT_NUMBER], [INBOUND_SDO], [INBOUND_AIRPORT_CODE], [INBOUND_TRAVEL_CLASS], [ONWARD_AIRLINE], [ONWARD_FLIGHT_NUMBER], [ONWARD_SDO], [ONWARD_AIRPORT_CODE], [ONWARD_TRAVEL_CLASS], [NO_PASSENGER_SAME_SURNAME], [SURNAME], [GIVEN_NAME], [OTHERS_NAME], [BAG_EXCEPTION], [CHECK_IN_COUNTER], [CHECK_IN_COUNTER_DESCRIPTION], [CHECK_IN_TIME_STAMP], [CHECK_IN_CARRIAGE_MEDIUM], [CHECK_IN_TRANSPORT_ID], [TAG_PRINTER_ID], [RECONCILIATION_LOAD_AUTHORITY], [RECONCILIATION_SEAT_NUMBER], [RECONCILIATION_PASSENGER_STATUS], [RECONCILIATION_SEQUENCE_NUMBER], [RECONCILIATION_SECURITY_NUMBER], [RECONCILIATION_PASSENGER_PROFILES_STATUS], [RECONCILIATION_TRANSPORT_AUTHORITY], [RECONCILIATION_BAG_TAG_STATUS], [HANDLING_TERMINAL], [HANDLING_BAR], [HANDLING_GATE], [WEIGHT_INDICATOR], [WEIGHT_CHECKED_BAG_NUMBER], [CHECKED_WEIGHT], [UNCHECKED_WEIGHT], [WEIGHT_UNIT], [WEIGHT_LENGTH], [WEIGHT_WIDTH], [WEIGHT_HEIGHT], [WEIGHT_BAG_TYPE_CODE], [GROUND_TRANSPORT_EARLIEST_DELIVERY], [GROUND_TRANSPORT_LATEST_DELIVERY], [GROUND_TRANSPORT_DESCRIPTION], [FREQUENT_TRAVELLER_ID_NUMBER], [FREQUENT_TRAVELLER_TIER_ID], [CORPORATE_NAME], [AUTOMATED_PNR_ADDRESS], [MESSAGE_PRINTER_ID], [INTERNAL_AIRLINE_DATA], [SECURITY_SCREENING_INSTRUCTION], [SECURITY_SCREENING_RESULT], [SECURITY_SCREENING_RESULT_REASON], [SECURITY_SCREENING_RESULT_METHOD], [SECURITY_SCREENING_AUTOGRAPH], [SECURITY_SCREENING_FREE_TEXT], [HIGH_RISK], [HBS_LEVEL_REQUIRED], [CREATED_BY]
		FROM BAG_SORTING WHERE [DATA_ID]=''
	END
	-- CHUTE MAPPING
	IF((@Status = 0) OR (PATINDEX('%CHUTE_MAPPING%', @Statecodes)>0))
	BEGIN
		SELECT [CHUTE], [SORTER], [DESTINATION] FROM CHUTE_MAPPING
	END
	ELSE
	BEGIN
		SELECT [CHUTE], [SORTER], [DESTINATION] FROM CHUTE_MAPPING WHERE [CHUTE] = ''
	END
	-- FALLBACK MAPPING
	IF((@Status = 0) OR (PATINDEX('%FALLBACK_MAPPING%', @Statecodes)>0))
	BEGIN
		SELECT [ID], [DESTINATION], [DESCRIPTION], [SYS_ACTION] FROM FALLBACK_MAPPING
	END
	ELSE
	BEGIN
		SELECT [ID], [DESTINATION], [DESCRIPTION], [SYS_ACTION] FROM FALLBACK_MAPPING
		WHERE [ID] = ''
	END
	-- FALLBACK INFO
	IF((@Status = 0) OR (PATINDEX('%FALLBACK_TAG_INFO%', @Statecodes)>0))
	BEGIN
		SELECT [TIME_STAMP], [NO_OF_FALLBACK], [FALLBACK_NO_1], [DESTINATION_1], 
			[FALLBACK_NO_2], [DESTINATION_2], [FALLBACK_NO_3], [DESTINATION_3], [FALLBACK_NO_4], 
			[DESTINATION_4], [FALLBACK_NO_5], [DESTINATION_5], [FALLBACK_NO_6], [DESTINATION_6], 
			[FALLBACK_NO_7], [DESTINATION_7], [FALLBACK_NO_8], [DESTINATION_8], [FALLBACK_NO_9], 
			[DESTINATION_9], [FALLBACK_NO_10], [DESTINATION_10] FROM FALLBACK_TAG_INFO
	END
	ELSE
	BEGIN
		SELECT [TIME_STAMP], [NO_OF_FALLBACK], [FALLBACK_NO_1], [DESTINATION_1], 
			[FALLBACK_NO_2], [DESTINATION_2], [FALLBACK_NO_3], [DESTINATION_3], [FALLBACK_NO_4], 
			[DESTINATION_4], [FALLBACK_NO_5], [DESTINATION_5], [FALLBACK_NO_6], [DESTINATION_6], 
			[FALLBACK_NO_7], [DESTINATION_7], [FALLBACK_NO_8], [DESTINATION_8], [FALLBACK_NO_9], 
			[DESTINATION_9], [FALLBACK_NO_10], [DESTINATION_10] FROM FALLBACK_TAG_INFO
			WHERE [ID]=''
	END
	-- FLIGHT PLAN ALLOC
	IF((@Status = 0) OR (PATINDEX('%FLIGHT_PLAN_ALLOC%', @Statecodes)>0))
	BEGIN
		SELECT [AIRLINE], [FLIGHT_NUMBER], [SDO], [STO], [RESOURCE], [WEEKDAY], [EDO], [ETO], 
		[ADO], [ATO], [IDO], [ITO], [TRAVEL_CLASS], [HIGH_RISK], [HBS_LEVEL_REQUIRED], 
		[EARLY_OPEN_OFFSET], [EARLY_OPEN_ENABLED], [ALLOC_OPEN_OFFSET], [ALLOC_OPEN_RELATED], 
		[ALLOC_CLOSE_OFFSET], [ALLOC_CLOSE_RELATED], [RUSH_DURATION], [SCHEME_TYPE], 
		[CREATED_BY], [TIME_STAMP], [HOUR], [IS_MANUAL_CLOSE], [IS_CLOSED] 
		FROM FLIGHT_PLAN_ALLOC WHERE [TIME_STAMP] BETWEEN DATEADD(HH,-6,GETDATE()) 
		AND DATEADD(HH,24,GETDATE())
	END
	ELSE
	BEGIN
		SELECT [AIRLINE], [FLIGHT_NUMBER], [SDO], [STO], [RESOURCE], [WEEKDAY], [EDO], [ETO], 
		[ADO], [ATO], [IDO], [ITO], [TRAVEL_CLASS], [HIGH_RISK], [HBS_LEVEL_REQUIRED], 
		[EARLY_OPEN_OFFSET], [EARLY_OPEN_ENABLED], [ALLOC_OPEN_OFFSET], [ALLOC_OPEN_RELATED], 
		[ALLOC_CLOSE_OFFSET], [ALLOC_CLOSE_RELATED], [RUSH_DURATION], [SCHEME_TYPE], 
		[CREATED_BY], [TIME_STAMP], [HOUR], [IS_MANUAL_CLOSE], [IS_CLOSED] 
		FROM FLIGHT_PLAN_ALLOC WHERE [AIRLINE] = ''
	END
	-- FUNCTION ALLOC GANTT
	IF((@Status = 0) OR (PATINDEX('%FUNCTION_ALLOC_GANTT%', @Statecodes)>0))
	BEGIN
		SELECT [TIME_STAMP], [FUNCTION_TYPE], [RESOURCE], [ALLOC_OPEN_DATETIME], 
		[ALLOC_CLOSE_DATETIME], [IS_CLOSED], [EXCEPTION]
		FROM FUNCTION_ALLOC_GANTT
	END
	ELSE
	BEGIN
		SELECT [TIME_STAMP], [FUNCTION_TYPE], [RESOURCE], [ALLOC_OPEN_DATETIME], 
		[ALLOC_CLOSE_DATETIME], [IS_CLOSED], [EXCEPTION]
		FROM FUNCTION_ALLOC_GANTT WHERE [TIME_STAMP] = ''
	END
	-- FUNCTION ALLOC LIST
	IF((@Status = 0) OR (PATINDEX('%FUNCTION_ALLOC_LIST%', @Statecodes)>0))
	BEGIN
		SELECT [TIME_STAMP], [FUNCTION_TYPE], [RESOURCE], [IS_ENABLED], 
			[SYS_ACTION] FROM FUNCTION_ALLOC_LIST
	END
	ELSE
	BEGIN
		SELECT [TIME_STAMP], [FUNCTION_TYPE], [RESOURCE], [IS_ENABLED], 
			[SYS_ACTION] FROM FUNCTION_ALLOC_LIST WHERE [TIME_STAMP] = ''
	END
	-- FUNCTION TYPES
	IF((@Status = 0) OR (PATINDEX('%FUNCTION_TYPES%', @Statecodes)>0))
	BEGIN
		SELECT [TYPE], [GROUP], [DESCRIPTION], [IS_ALLOCATED], [IS_ENABLED] FROM FUNCTION_TYPES
	END
	ELSE
	BEGIN
		SELECT [TYPE], [GROUP], [DESCRIPTION], [IS_ALLOCATED], [IS_ENABLED] FROM FUNCTION_TYPES
		WHERE [TYPE]=''
	END
	-- SYS CONFIG
	IF((@Status = 0) OR (PATINDEX('%SYS_CONFIG%', @Statecodes)>0))
	BEGIN
		SELECT [SYS_KEY], [SYS_VALUE], [DEFAULT_VALUE], [LAST_VALUE], [DESCRIPTION], 
		[VALUE_TOKEN], [SYS_ACTION], [GROUP_NAME], [ORDER_FLAG], [IS_ENABLED] FROM SYS_CONFIG
	END
	ELSE
	BEGIN
		SELECT [SYS_KEY], [SYS_VALUE], [DEFAULT_VALUE], [LAST_VALUE], [DESCRIPTION], 
		[VALUE_TOKEN], [SYS_ACTION], [GROUP_NAME], [ORDER_FLAG], [IS_ENABLED] FROM SYS_CONFIG
		WHERE [SYS_KEY] = ''
	END
END
GO
/****** Object:  StoredProcedure [dbo].[stp_MES_GETPESSENGERINFO]    Script Date: 07/08/2010 08:49:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Albert Sun
-- Create date: 28-Jun-2010
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stp_MES_GETPESSENGERINFO]
	@LicensePlate varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT LICENSE_PLATE AS [Tag No.], AIRLINE AS [Airline], FLIGHT_NUMBER AS [Flight No.], 
			SDO, TRAVEL_CLASS AS [Travel Class], 
			CAST(NO_PASSENGER_SAME_SURNAME AS VARCHAR(MAX)) + 
			CASE WHEN LEN(LTRIM(RTRIM(SURNAME))) > 0 THEN ' ' + SURNAME ELSE '' END + 
			CASE WHEN LEN(LTRIM(RTRIM(GIVEN_NAME)))>0 THEN ' ' + GIVEN_NAME ELSE '' END + 
			CASE WHEN LEN(LTRIM(RTRIM(OTHERS_NAME))) > 0 THEN ' ' + OTHERS_NAME ELSE '' END AS
			[Passenger Name], DESTINATION
		FROM BAG_SORTING WHERE LICENSE_PLATE LIKE '%' + @LicensePlate
END
GO
/****** Object:  StoredProcedure [dbo].[stp_MES_GETLICENSEPLATE]    Script Date: 07/08/2010 08:49:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Albert Sun
-- Create date: 30-Jun-2010
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stp_MES_GETLICENSEPLATE]
	@BAG_GID VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @LICENSE_PLATE VARCHAR(10)
    SELECT @LICENSE_PLATE = ISNULL(LICENSE_PLATE1, LICENSE_PLATE2) FROM BAG_INFO WHERE GID = @BAG_GID
    
    SELECT @LICENSE_PLATE
END
GO
/****** Object:  StoredProcedure [dbo].[stp_MES_GET_BAG_GID]    Script Date: 07/08/2010 08:49:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Albert Sun
-- Create date: 30-Jun-2010
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stp_MES_GET_BAG_GID]
	@LICENSE_PLATE VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @BAG_GID VARCHAR(10)
    
    SELECT @BAG_GID = GID FROM BAG_INFO WHERE ((LICENSE_PLATE1 = @LICENSE_PLATE) OR (LICENSE_PLATE2 = @LICENSE_PLATE))
    
    SELECT @BAG_GID
END
GO
/****** Object:  StoredProcedure [dbo].[stp_MES_GENERATEINHOUSEBSM]    Script Date: 07/08/2010 08:49:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Albert Sun
-- Create date: 01-Jul-2010
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stp_MES_GENERATEINHOUSEBSM]
	@FIRST_DIGIT VARCHAR(1),
	@AIRLINE VARCHAR(5),
	@FLIGHT_NUMBER VARCHAR(5),
	@SDO DATETIME,
	@DESCRIPTION VARCHAR(20),
	@MES_STATION VARCHAR(16),
	@NUMBER_RANGE VARCHAR(14),
	@SUBSYSTEM VARCHAR(10),
	@LOCATION VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @AIRLINE_CODE VARCHAR(5)
	DECLARE @LAST_NUMBER VARCHAR(6)
	DECLARE @START VARCHAR(6)
	DECLARE @END VARCHAR(6)
	DECLARE @GENERATED_BSM VARCHAR(10)

	SET @START = SUBSTRING(@NUMBER_RANGE,1, PATINDEX('%,%',@NUMBER_RANGE)-1)
	SET @END = SUBSTRING(@NUMBER_RANGE,PATINDEX('%,%',@NUMBER_RANGE)+1, LEN(@NUMBER_RANGE) - (PATINDEX('%,%',@NUMBER_RANGE)))

	SELECT @AIRLINE_CODE = TICKETING_CODE FROM AIRLINES WHERE CODE_IATA = @AIRLINE

	SELECT @LAST_NUMBER = GENERATED_NUMBER FROM ITEM_INHOUSE_BSM WHERE MES_STATION = @MES_STATION

	SELECT @LAST_NUMBER = CASE WHEN ISNULL(@LAST_NUMBER,'-') = '-' THEN @START
		WHEN @LAST_NUMBER = @END THEN @START
		ELSE CAST(CAST(@LAST_NUMBER AS INT) + 1 AS VARCHAR(6)) END
		
	SET @GENERATED_BSM = @FIRST_DIGIT + @AIRLINE_CODE + RIGHT('000000' + @LAST_NUMBER, 6)

	INSERT INTO MES_EVENT([TIME_STAMP], [GID], [LICENSE_PLATE], [SUBSYSTEM], 
		[LOCATION], [ACTION], [ACTION_DESC], [MES_STATION])
	VALUES(GETDATE(), @GENERATED_BSM, @GENERATED_BSM, @SUBSYSTEM, @LOCATION, 
		'GENINHOUSE', 'GEN INHOUSE TAG', @MES_STATION)
		
	INSERT INTO ITEM_INHOUSE_BSM([INHOUSEBSM], [FIRST_DIGIT], [AIRLINE], [FLIGHT_NUMBER], [SDO], [DESCRIPTION], [MES_STATION], [GENERATED_NUMBER])
		VALUES(@GENERATED_BSM, @FIRST_DIGIT, @AIRLINE, @FLIGHT_NUMBER, @SDO, @DESCRIPTION, @MES_STATION, @LAST_NUMBER)
		
	SELECT @GENERATED_BSM
END
GO
/****** Object:  StoredProcedure [dbo].[stp_MES_GET_IATA_TAG_LIST]    Script Date: 07/08/2010 08:49:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Albert Sun
-- Create date: 02-Jul-2010
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stp_MES_GET_IATA_TAG_LIST]
	@AIRLINE VARCHAR(5),
	@FLIGHT_NUMBER VARCHAR(5),
	@SDO DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @SDO='01-jAN-1900'
	BEGIN
		SELECT [LICENSE_PLATE], [AIRLINE], [FLIGHT_NUMBER], [SDO] FROM BAG_SORTING
		WHERE [AIRLINE] LIKE '%' + @AIRLINE + '%' AND [FLIGHT_NUMBER] LIKE '%' + @FLIGHT_NUMBER + '%'
		ORDER BY [LICENSE_PLATE]
	END
	ELSE
	BEGIN
		SELECT [LICENSE_PLATE], [AIRLINE], [FLIGHT_NUMBER], [SDO] FROM BAG_SORTING
		WHERE [AIRLINE] LIKE '%' + @AIRLINE + '%' AND [FLIGHT_NUMBER] LIKE '%' + @FLIGHT_NUMBER + '%'
		AND SDO = @SDO
		ORDER BY [LICENSE_PLATE]
	END
END
GO
/****** Object:  StoredProcedure [dbo].[stp_MES_GET_RUSH_LOCATION]    Script Date: 07/08/2010 08:49:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Albert Sun
-- Create date: 07-Jul-2010
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stp_MES_GET_RUSH_LOCATION]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT G.[RESOURCE], G.[IS_CLOSED], T.[IS_ENABLED]
	FROM FUNCTION_ALLOC_GANTT G JOIN FUNCTION_TYPES T ON G.FUNCTION_TYPE = T.[TYPE]
	WHERE G.FUNCTION_TYPE = 'RUSH'
END
GO
/****** Object:  StoredProcedure [dbo].[stp_MES_GET_PROBLEM_LOCATION]    Script Date: 07/08/2010 08:49:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Albert Sun
-- Create date: 07-Jul-2010
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[stp_MES_GET_PROBLEM_LOCATION]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT G.[RESOURCE], G.[IS_CLOSED], T.[IS_ENABLED]
	FROM FUNCTION_ALLOC_GANTT G JOIN FUNCTION_TYPES T ON G.FUNCTION_TYPE = T.[TYPE]
	WHERE G.FUNCTION_TYPE = 'PROB'
END
GO

/****** Object:  UserDefinedFunction [dbo].[MES_GETTABLECHANGES]    Script Date: 07/08/2010 09:00:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Albert Sun
-- Create date: 21-Jun-2010
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[MES_GETTABLECHANGES]
(
	@StationName VARCHAR(20),
	@UpdateStatus int
)
RETURNS VARCHAR(200)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @StateCodes VARCHAR(200)
	SELECT @StateCodes = coalesce(@StateCodes + ',', '') + STATE_CODE 
		FROM CHANGE_MONITORING WHERE SAC_OWS = @StationName AND IS_CHANGED = @UpdateStatus

	-- Return the result of the function
	RETURN @StateCodes

END

GO

PRINT 'INFO: End of Creating MES storeprocedure.'
GO
PRINT 'INFO: .'
PRINT 'INFO: .'
PRINT 'INFO: .'
GO
