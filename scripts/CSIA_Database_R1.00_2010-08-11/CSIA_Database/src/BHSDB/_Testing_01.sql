
/*
DECLARE @RC [int];
DECLARE @Status [int];
DECLARE @LicensePlate varchar(10)
DECLARE @BSM_TravelClass varchar(1)
DECLARE @BSM_Exception varchar(10)
DECLARE @FLT_HighRisk varchar(1)
DECLARE @FLT_Exception varchar(10)
SET @LicensePlate = '0617000001';
EXECUTE @RC = [BHSDB].[dbo].[stp_SAC_GETFLIGHTALLOCOFLP] 
   @LicensePlate ,@BSM_TravelClass OUTPUT ,@BSM_Exception OUTPUT ,
   @FLT_HighRisk OUTPUT,@FLT_Exception OUTPUT ,@Status OUTPUT
SELECT @RC AS RC, @Status AS STATUS, @LicensePlate AS LP, @BSM_TravelClass AS BSM_CLASS,
		@BSM_Exception AS BAG_EXCP,@FLT_HighRisk AS FLT_HIGH_RISK,@FLT_Exception AS FLT_EXCP
GO

DECLARE @RC [int];
DECLARE @Status [int];
DECLARE @Airline [varchar](3);
DECLARE @FlightNumber [varchar](5);
DECLARE @SDO [datetime];
DECLARE @FLT_HighRisk varchar(1)
DECLARE @FLT_Exception varchar(10)
SET @Airline = 'SQ';
SET @FlightNumber = '966';
SET @SDO = '2008-Oct-20';
EXECUTE @RC = [BHSDB].[dbo].[stp_SAC_GETFLIGHTALLOCOFFLT] 
   @Airline ,@FlightNumber ,@SDO, @FLT_HighRisk OUTPUT,@FLT_Exception OUTPUT ,@Status OUTPUT
SELECT @RC AS RC, @Status AS STATUS, @Airline AS LP, @FlightNumber AS FLIGHT_NUMBER,
		@SDO AS SDO,@FLT_HighRisk AS FLT_HIGH_RISK,@FLT_Exception AS FLT_EXCP
GO

DECLARE @Airline [varchar](10);
SET @Airline=' 1  ';

IF LEN(LTRIM(RTRIM(@Airline)))=0
	SET @Airline=NULL;

SELECT @Airline;



SELECT * FROM [BHSDB].[dbo].[FLIGHT_PLANS]
SELECT * FROM [BHSDB].[dbo].[FLIGHT_PLAN_SORTING]
SELECT * FROM [BHSDB].[dbo].[FLIGHT_PLAN_ALLOC]

SELECT * FROM [BHSDB].[dbo].[ITEM_REDIRECT]
SELECT * FROM [BHSDB].[dbo].[SORTATION_REASON]


SELECT * FROM [BHSDB].[dbo].[BAGS] 
SELECT * FROM [BHSDB].[dbo].[BAG_SORTING] 
SELECT * FROM [BHSDB].[dbo].[BAG_INFO] 

SELECT * FROM [BHSDB].[dbo].[ITEM_ENCODING_REQUEST] 

SELECT * FROM [BHSDB].[dbo].[ITEM_REMOVED] 
SELECT * FROM [BHSDB].[dbo].[ITEM_DEST_REQUEST] 
SELECT * FROM [BHSDB].[dbo].[SORTATION_REASON]

SELECT * FROM [BHSDB].[dbo].[ITEM_REDIRECT]
SELECT * FROM [BHSDB].[dbo].[ITEM_SCANNED]

SELECT * FROM [BHSDB].[dbo].[AUDIT_LOG]
SELECT * FROM [BHSDB].[dbo].[SYS_CONFIG]  ORDER BY [GROUP_NAME], [IS_ENABLED] ASC

SELECT * FROM [BHSDB].[dbo].[CHANGE_MONITORING]

SELECT * FROM [BHSDB].[dbo].[FUNCTION_TYPE_GROUPS]
SELECT * FROM [BHSDB].[dbo].[FUNCTION_TYPES]
SELECT * FROM [BHSDB].[dbo].[FUNCTION_ALLOC_LIST]
SELECT * FROM [BHSDB].[dbo].[FUNCTION_ALLOC_GANTT]

SELECT * FROM [BHSDB].[dbo].[ITEM_PROCEED_TYPES]
SELECT * FROM [BHSDB].[dbo].[ITEM_LOST]
SELECT * FROM [BHSDB].[dbo].[ITEM_REMOVED]
SELECT * FROM [BHSDB].[dbo].[GID_USED]
SELECT * FROM [BHSDB].[dbo].[ITEM_PROCEEDED]

SELECT * FROM [BHSDB].[dbo].[USERS]
SELECT * FROM [BHSDB].[dbo].[USERS_ROLES]
SELECT * FROM [BHSDB].[dbo].[ROLES]
SELECT * FROM [BHSDB].[dbo].[AIRLINES]
SELECT * FROM [BHSDB].[dbo].[AIRPORTS]
SELECT * FROM [BHSDB].[dbo].[FLIGHTS]
SELECT * FROM [BHSDB].[dbo].[AIRCRAFT_TYPES]
SELECT * FROM [BHSDB].[dbo].[SAC_OWS]
SELECT * FROM [BHSDB].[dbo].[SORTATION_REASON]

SELECT * FROM [BHSDB].[dbo].[SUBSYSTEMS]
SELECT * FROM [BHSDB].[dbo].[LOCATIONS]
SELECT * FROM [BHSDB].[dbo].[DESTINATIONS]
SELECT * FROM [BHSDB].[dbo].[ALLOC_RESOURCES]
SELECT * FROM [BHSDB].[dbo].[FALLBACK_MAPPING]
SELECT * FROM [BHSDB].[dbo].[TEMPLATE_FLIGHT_PLAN_ALLOC]

SELECT * FROM [BHSDB].[dbo].[FALLBACK_MAPPING] WHERE DESTINATION='XJ'

	DECLARE @Group [varchar](5);
	SELECT @Group=[GROUP] FROM [BHSDB].[dbo].[FUNCTION_TYPES] WHERE [TYPE]='XJ';
	IF @Group IS NULL
		PRINT 'Group = NULL'
	ELSE
		PRINT @Group
		
		
DELETE FROM [BHSDB].[dbo].[BAG_SORTING] WHERE [LICENSE_PLATE] =  '3783123456'
DELETE FROM [BHSDB].[dbo].[BAGS] 

DECLARE @LP [varchar] (10)
SELECT @LP = [LICENSE_PLATE] FROM [BAG_SORTING] WHERE [LICENSE_PLATE] = '3783123455'
PRINT ISNULL(@LP,'Test')

DELETE FROM [BHSDB].[dbo].[GID_USED] 
DELETE FROM [BHSDB].[dbo].[ITEM_PROCEEDED] 
DELETE FROM [BHSDB].[dbo].[ITEM_LOST]
DELETE FROM [BHSDB].[dbo].[FLIGHT_PLANS]
DELETE FROM [BHSDB].[dbo].[FLIGHT_PLAN_SORTING] WHERE AIRLINE='SQ' AND FLIGHT_NUMBER='102'
SELECT * FROM [BHSDB].[dbo].[CHANGE_MONITORING]

DELETE FROM [BHSDB].[dbo].[FLIGHT_PLAN_ALLOC]

DELETE FROM [BHSDB].[dbo].[BAG_INFO] 



SELECT * FROM [BAG_INFO]
DELETE FROM [BHSDB].[dbo].[USERS_ROLES]  WHERE [USER_ID]='XJ'
UPDATE [BHSDB].[dbo].[USERS_ROLES] SET [ROLE_ID] = 'PLANNER' WHERE [USER_ID] = 'XJ'
INSERT INTO [BHSDB].[dbo].[USERS_ROLES]  ([USER_ID],[ROLE_ID] ,[TIME_STAMP]) VALUES ('XJ','ADMIN',GETDATE())

DELETE FROM [BHSDB].[dbo].[USERS]  WHERE [ID]='XJ'
UPDATE [BHSDB].[dbo].[USERS] SET [EXPIRY_DATE] = '2009-12-12' WHERE [ID] = 'XJ'
INSERT INTO [BHSDB].[dbo].[USERS]  ([ID],[USER_NAME] ,[USER_IP_ADDR] ,[IP_CHECK] ,[EXPIRY_DATE] ,[CREATED_BY] ,[TIME_STAMP])
     VALUES ('XJ','XuJian',null,'Y',null,'SYS',GETDATE())

DELETE FROM [BHSDB].[dbo].[AIRCRAFT_TYPES]  WHERE [TYPE]='319'
UPDATE [BHSDB].[dbo].[AIRCRAFT_TYPES] SET [DESCRIPTION] = 'China' WHERE [TYPE] = '319'
INSERT INTO [dbo].[AIRCRAFT_TYPES] ([TYPE],[MAX_PAX],[DESCRIPTION]) VALUES ('319','129','Airbus Industrie A319')

DELETE FROM [BHSDB].[dbo].[FLIGHTS]  WHERE [AIRLINE] = 'SQ' AND [FLIGHT_NUMBER]='123'
UPDATE [BHSDB].[dbo].[FLIGHTS] SET [FLIGHT_DESC] = 'China' WHERE [AIRLINE] = 'SQ' AND [FLIGHT_NUMBER]='123'
INSERT INTO [BHSDB].[dbo].[FLIGHTS] ([FLIGHT_NUMBER] ,[AIRLINE] ,[AIRCRAFT_TYPE] ,[FLIGHT_DESC] ,[HIGH_RISK] ,[HBS_LEVEL_REQUIRED])
     VALUES ('123','SQ','319','Test flight','N','N')

DELETE FROM [BHSDB].[dbo].[AIRPORTS]  WHERE [CODE_IATA] = 'DXB'
UPDATE [BHSDB].[dbo].[AIRPORTS] SET [NAME] = 'China' WHERE [CODE_IATA] = 'DXB'
INSERT INTO [dbo].[AIRPORTS] ([CODE_IATA],[CODE_ICAO],[COUNTRY],[CITY],[NAME]) VALUES ('DXB','OMDB','UAE','DUBAI','DUBAI T1 INTERNATIONAL AIRPORT')

DELETE FROM [BHSDB].[dbo].[AIRLINES]  WHERE [CODE_IATA] = 'CA'
UPDATE [BHSDB].[dbo].[AIRLINES] SET [NAME] = 'China' WHERE [CODE_IATA] = 'CA'
INSERT INTO [dbo].[AIRLINES] ([CODE_IATA],[CODE_ICAO] ,[NAME],[TICKETING_CODE]) VALUES ('CA','CCA','Air China','999')

DELETE FROM [BHSDB].[dbo].[ROLES]
UPDATE [BHSDB].[dbo].[ROLES] SET [DESCRIPTION] = 'Admin' WHERE [ID] = 'ADMIN'


DELETE FROM [BHSDB].[dbo].[FUNCTION_ALLOC]
DELETE FROM [BHSDB].[dbo].[FUNCTION_TYPES] WHERE [TYPE]= 'NORD'
UPDATE [BHSDB].[dbo].[FUNCTION_TYPES] SET [DESCRIPTION] = 'No read testing' WHERE [TYPE] = 'NORD'
       
DELETE FROM [BHSDB].[dbo].[SYS_CONFIG] WHERE [SYS_KEY]='AIRLINE_SORT_ENABLED'
INSERT INTO [dbo].[SYS_CONFIG] ([SYS_KEY],[SYS_VALUE],[DEFAULT_VALUE],[LAST_VALUE],
			[DESCRIPTION],[VALUE_TOKEN],[SYS_ACTION],[GROUP_NAME],[ORDER_FLAG],[IS_ENABLED])
     VALUES ('AIRLINE_SORT_ENABLED','FALSE','TRUE','TRUE','Enable or Disable the airline sortation control',
			'TRUE~FALSE','Takes effect immediately.','SControl_Sett','0',1)

UPDATE [BHSDB].[dbo].[SYS_CONFIG] SET [SYS_VALUE] = 'TRUE' WHERE [SYS_KEY] = 'AIRLINE_SORT_ENABLED'
GO




DELETE FROM [BHSDB].[dbo].[CCTV_MDS_ACTIVATED_ALARMS]
DELETE FROM [BHSDB].[dbo].[CCTV_MDS_DEACTIVATED_ALARMS]
DELETE FROM [BHSDB].[dbo].[CCTV_MDS_OUTGOING_ALARMS]
DELETE FROM [BHSDB].[dbo].[CCTV_STATUS]
DELETE FROM [BHSDB].[dbo].[CCTV_DEACTIVATED_ALARMS]

INSERT INTO [BHSDB].[dbo].[CCTV_MDS_ACTIVATED_ALARMS] ([TIME_STAMP] ,[SUBSYSTEM] ,[EQUIPMENT_ID] ,[ALARM_TYPE] ,[ALARM_DESCRIPTION],[CCTV_DEVICE_TYPE] ,[CCTV_DEVICE_ID] ,[CCTV_CAMERA_POSITION_ID])
     VALUES (GETDATE(),'CT1','CT1-03','AA_TRIP','Motor Trip','CAM','0001','01')

INSERT INTO [BHSDB].[dbo].[CCTV_MDS_DEACTIVATED_ALARMS] ([TIME_STAMP] ,[SUBSYSTEM] ,[EQUIPMENT_ID] ,[ALARM_TYPE] ,[CCTV_DEVICE_TYPE] ,[CCTV_DEVICE_ID] ,[CCTV_CAMERA_POSITION_ID])
     VALUES (GETDATE(),'CT1','CT1-03','AA_TRIP','CAM','0001','01')

INSERT INTO [BHSDB].[dbo].[CCTV_MDS_SPOT_COMMANDS] ([CCTV_DEVICE_TYPE] ,[CCTV_DEVICE_ID] ,[CCTV_CAMERA_POSITION_ID])
     VALUES ('CAM','0001','01')

INSERT INTO [BHSDB].[dbo].[CCTV_STATUS] ([CCTV_DEVICE_ID] ,[CCTV_STATUS_TYPE] ,[CCTV_STATUS_DESCRIPTION])
     VALUES ('0002','ALARM','CCTV camera 01 failure')

INSERT INTO [BHSDB].[dbo].[CCTV_DEACTIVATED_ALARMS] ([CCTV_DEVICE_ID])
     VALUES ('0001')
GO

SELECT * FROM [BHSDB].[dbo].[CCTV_MDS_ACTIVATED_ALARMS]
SELECT * FROM [BHSDB].[dbo].[CCTV_MDS_DEACTIVATED_ALARMS]
SELECT * FROM [BHSDB].[dbo].[CCTV_MDS_SPOT_COMMANDS]
SELECT * FROM [BHSDB].[dbo].[CCTV_MDS_OUTGOING_ALARMS]
SELECT * FROM [BHSDB].[dbo].[CCTV_STATUS]
SELECT * FROM [BHSDB].[dbo].[CCTV_DEACTIVATED_ALARMS]



*/
