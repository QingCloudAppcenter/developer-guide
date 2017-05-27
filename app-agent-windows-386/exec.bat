@REM Copyright (C) 2016 Yunify, Inc.

@REM Script to execute the service such as start/stop application deployed on
@REM QingCloud AppCenter 2.0 platform.

@SETLOCAL EnableDelayedExpansion
@SET AGENT_PATH=C:\Program Files (x86)\QingCloud\App Agent\log
@SET CMD_INFO=%AGENT_PATH%\cmd.info
@SET CMD_LOG=%AGENT_PATH%\cmd.log
@SET APP_LOG=%AGENT_PATH%\app.log

@IF NOT EXIST "%CMD_INFO%" @ENDLOCAL & @SET ERRORLEVEL=0

@FOR /F "tokens=1* delims=:" %%i IN ('type "%CMD_INFO%"') DO @(
	@SET CMD_ID=%%i
	@SET CMD=%%j
	
	@FOR /F "tokens=1-3 delims=/ " %%a IN ('date /t') DO @SET EXEC_DATE=%%a-%%b-%%c
	@ECHO "!EXEC_DATE! !TIME! !CMD_ID! [executing]: !CMD!" >> "%CMD_LOG%" 2>&1
	@SET ERRORLEVEL=0
	CALL !CMD!
	
	@IF !ERRORLEVEL! NEQ 0 @(
		@FOR /F "tokens=1-3 delims=/ " %%a IN ('date /t') DO @SET DONE_DATE=%%a-%%b-%%c
		@ECHO "!DONE_DATE! !TIME! !CMD_ID! [failed]: !CMD!" >> "%CMD_LOG%" 2>&1
		@ENDLOCAL & @SET ERRORLEVEL=1
	) ELSE (
		@FOR /F "tokens=1-3 delims=/ " %%a IN ('date /t') DO @SET DONE_DATE=%%a-%%b-%%c
		@ECHO "!DONE_DATE! !TIME! !CMD_ID! [successful]: !CMD!" >> "%CMD_LOG%" 2>&1
		@ENDLOCAL & @SET ERRORLEVEL=0
	)
)
