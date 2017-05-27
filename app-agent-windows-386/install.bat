@ECHO OFF

REM Copyright (C) 2016 Yunify Inc.

REM Script to install packages for preparing image that is deployed on QingCloud
REM AppCenter 2.0 platform.

REM Return info when executing commands

SET QINGCLOUD_DIR=C:\Program Files (x86)\QingCloud
SET AGENT_DIR=%QINGCLOUD_DIR%\App Agent
SET BIN_DIR=%AGENT_DIR%\bin
SET LOG_DIR=%AGENT_DIR%\log
SET CONFD_CONFIG_DIR=%AGENT_DIR%\confd


IF NOT EXIST "%QINGCLOUD_DIR%" MKDIR "%QINGCLOUD_DIR%"
IF NOT EXIST "%AGENT_DIR%" MKDIR "%AGENT_DIR%"
IF NOT EXIST "%BIN_DIR%" MKDIR "%BIN_DIR%"
IF NOT EXIST "%LOG_DIR%" MKDIR "%LOG_DIR%"
IF NOT EXIST "%CONFD_CONFIG_DIR%" MKDIR "%CONFD_CONFIG_DIR%"

ECHO Prepare confd
COPY /Y .\bin\confd.exe "%BIN_DIR%" >nul

ECHO Prepare confd service management
COPY /Y .\bin\nssm.exe "%BIN_DIR%" >nul
"%BIN_DIR%\nssm.exe" install QingCloud_App_Agent "%BIN_DIR%\confd.exe" "--config-file \"%CONFD_CONFIG_DIR%\confd.toml\"" >nul 2>nul
"%BIN_DIR%\nssm.exe" set QingCloud_App_Agent DisplayName "QingCloud App Agent" >nul 2>nul
"%BIN_DIR%\nssm.exe" set QingCloud_App_Agent Start SERVICE_DEMAND_START >nul 2>nul
 
ECHO Prepare confd deamon folders
IF NOT EXIST "%CONFD_CONFIG_DIR%\conf.d" MKDIR "%CONFD_CONFIG_DIR%\conf.d"
IF NOT EXIST "%CONFD_CONFIG_DIR%\templates" MKDIR "%CONFD_CONFIG_DIR%\templates"

ECHO Prepare cmd stuff
COPY /Y .\config\cmd.info.toml "%CONFD_CONFIG_DIR%\conf.d\" >nul
COPY /Y .\config\cmd.info.tmpl "%CONFD_CONFIG_DIR%\templates\" >nul
COPY /Y .\exec.bat "%BIN_DIR%" >nul

ECHO Prepare logrotate conf
COPY /Y .\config\logrotate.ps1 "%BIN_DIR%" >nul
SCHTASKS /create /tn "QingCloud App Logrotate Task" /sc daily /st 03:00:00 /np /f /tr "powershell -executionpolicy bypass -File '%BIN_DIR%\logrotate.ps1'" >nul 2>nul

ECHO Installed successfully

PAUSE