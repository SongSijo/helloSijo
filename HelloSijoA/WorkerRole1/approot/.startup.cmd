rd "\%ROLENAME%"

start "Azure Environment Monitor" "util\wash.cmd" environment watch change.cmd

if defined DEPLOYROOT_PATH set DEPLOYROOT=%DEPLOYROOT_PATH%
if defined DEPLOYROOT (
	mklink /J "\%ROLENAME%" "%DEPLOYROOT%"
) else (
	mklink /J "\%ROLENAME%" "%ROLEROOT%\approot"
)

set DEPLOYROOT=\%ROLENAME%
set SERVER_APPS_LOCATION=%DEPLOYROOT%

set JAVA_HOME=%DEPLOYROOT%\zulu8.13.0.5-jdk8.0.72-win_x64
set PATH=%JAVA_HOME%\bin;%PATH%
set CATALINA_HOME=%DEPLOYROOT%\apache-tomcat-8.latest
set SERVER_APPS_LOCATION=%CATALINA_HOME%\webapps


cmd /c util\wash.cmd blob download "zulu8.13.0.5-jdk8.0.72-win_x64.zip" "zulu8.13.0.5-jdk8.0.72-win_x64.zip" eclipsedeploy sijojapan "Au3eiexRvDPG0KDIyJdkSlbQnWNJ75bkMITWzLSW+bvgS7+xxp60/UopvtNuCazdH9zto0nGorb/eIc15OhHgw==" "https://core.windows.net"
if not exist "zulu8.13.0.5-jdk8.0.72-win_x64.zip" (
	cmd /c util\wash.cmd file download "http://azure.azulsystems.com/zulu/zulu8.13.0.5-jdk8.0.72-win_x64.zip?eclipse" "zulu8.13.0.5-jdk8.0.72-win_x64.zip"
	if not exist "zulu8.13.0.5-jdk8.0.72-win_x64.zip" exit 0
	cmd /c util\wash.cmd blob upload "zulu8.13.0.5-jdk8.0.72-win_x64.zip" "zulu8.13.0.5-jdk8.0.72-win_x64.zip" eclipsedeploy sijojapan "Au3eiexRvDPG0KDIyJdkSlbQnWNJ75bkMITWzLSW+bvgS7+xxp60/UopvtNuCazdH9zto0nGorb/eIc15OhHgw==" "https://core.windows.net"
) else (
	echo
)
if not exist "zulu8.13.0.5-jdk8.0.72-win_x64.zip" exit 0
cscript /NoLogo util\unzip.vbs "zulu8.13.0.5-jdk8.0.72-win_x64.zip" "%DEPLOYROOT%"
del /Q /F "zulu8.13.0.5-jdk8.0.72-win_x64.zip"
cmd /c util\wash.cmd file download "https://azuredownloads.blob.core.windows.net/tomcat/apache-tomcat-8.latest.zip" "apache-tomcat-8.latest.zip"
if not exist "apache-tomcat-8.latest.zip" exit 0
cscript /NoLogo util\unzip.vbs "apache-tomcat-8.latest.zip" "%DEPLOYROOT%"
del /Q /F "apache-tomcat-8.latest.zip"
if not "%SERVER_APPS_LOCATION%" == "\%ROLENAME%" if exist "HelloWorld.war"\* (echo d | xcopy /y /e /q "HelloWorld.war" "%SERVER_APPS_LOCATION%\HelloWorld.war" 1>nul) else (echo f | xcopy /y /q "HelloWorld.war" "%SERVER_APPS_LOCATION%\HelloWorld.war" 1>nul)
cmd /c util\wash.cmd blob download "HelloSijo.jar" "HelloSijo.jar" eclipsedeploy sijojapan "Au3eiexRvDPG0KDIyJdkSlbQnWNJ75bkMITWzLSW+bvgS7+xxp60/UopvtNuCazdH9zto0nGorb/eIc15OhHgw==" "https://core.windows.net"
if not exist "HelloSijo.jar" exit 0
if not "%SERVER_APPS_LOCATION%" == "\%ROLENAME%" if exist "HelloSijo.jar"\* (echo d | xcopy /y /e /q "HelloSijo.jar" "%SERVER_APPS_LOCATION%\HelloSijo.jar" 1>nul) else (echo f | xcopy /y /q "HelloSijo.jar" "%SERVER_APPS_LOCATION%\HelloSijo.jar" 1>nul)
start "Azure" /D"%CATALINA_HOME%\bin" startup.bat


:: *** This script will run whenever Azure starts this role instance.
:: *** This is where you can describe the deployment logic of your server, JRE and applications 
:: *** or specify advanced custom deployment steps
::     (Note though, that if you're using this in Eclipse, you may find it easier to configure the JDK,
::     the server and the server and the applications using the New Azure Deployment Project wizard 
::     or the Server Configuration property page for a selected role.)

echo Hello World!


@ECHO OFF
set ERRLEV=%ERRORLEVEL%
if %ERRLEV%==0 (echo Startup completed successfully.) else (echo *** Azure startup failed [%ERRLEV%]- exiting...)
timeout 5
exit %ERRLEV%