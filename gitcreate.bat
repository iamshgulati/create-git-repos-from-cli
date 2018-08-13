@echo off & setlocal
setlocal enableDelayedExpansion
cls

echo CREATE NEW GITHUB REPO AND PUSH CODE FROM CLI

echo.
echo.
echo. --- ENTER REPOSITORY DETAILS

set CURRENT_DIR_LOCATION=%cd% >nul 2>nul
set REPO_LOCAL_LOCATION=%CURRENT_DIR_LOCATION%
echo.
echo Default Local Repo Location: %REPO_LOCAL_LOCATION%
set /p REPO_LOCAL_LOCATION= Local Repo Location: 
cd %REPO_LOCAL_LOCATION% >nul 2>nul
for %%I in (.) do set CURRENT_DIR_NAME=%%~nxI

set REPO_NAME=%CURRENT_DIR_NAME%
echo.
echo Default Repo Name: %CURRENT_DIR_NAME%
set /p REPO_NAME= Repo Name:  

set REPO_DESC=Project: %REPO_NAME%
echo.
echo Default Repo Description: "%REPO_DESC%"
set /p REPO_DESC= Enter Repo Description: 

cd %REPO_LOCAL_LOCATION% >nul 2>nul
if exist .git rd/q /s .git

echo.
echo. --- ENTER GITHUB USER DETAILS

set GITHUB_USER_FULLNAME="Shubham Gulati"
echo.
echo Default Full Name: %GITHUB_USER_FULLNAME%
set /p GITHUB_USER_FULLNAME= Full Name: 

set GITHUB_USER_EMAIL="shubhamgulati91@gmail.com"
echo.
echo Default Email: %GITHUB_USER_EMAIL%
set /p GITHUB_USER_EMAIL= Enter Email: 

set GITHUB_USER_USERNAME="shubhamgulati91"
echo.
echo Default Github Username: %GITHUB_USER_USERNAME%
set /p GITHUB_USER_USERNAME= Enter Github Username: 

git config --global user.name "%GITHUB_USER_FULLNAME%"
git config --global user.email "%GITHUB_USER_EMAIL%"

echo.
echo. --- INITIALIZING LOCAL REPO

echo.
git init

if not exist README.md (
	echo.
	echo. --- ADDING README.md

	touch README.md
	echo # %REPO_NAME% >> README.md
	echo %REPO_DESC% >> README.md
)

if not exist .gitignore (

	echo.
	echo. --- ADDING GITIGNORE

	set ADD_GITIGNORE=n
	echo.
	set /p ADD_GITIGNORE="Add gitignore? (y/n) [default is '!ADD_GITIGNORE!']: 
	
	if "!ADD_GITIGNORE!" == "y" (
		set GITIGNORE_TEMPLATES_LIST=Maven,Java
		echo.
		set /p GITIGNORE_TEMPLATES_LIST=Enter gitignore templates to be fetched [default is "!GITIGNORE_TEMPLATES_LIST!"]: 
		echo. ++ Fetching gitignore templates: !GITIGNORE_TEMPLATES_LIST!

		touch .gitignore
		for %%a in ("!GITIGNORE_TEMPLATES_LIST:,=" "!") do (
			set TEMPLATE_URL=https://raw.githubusercontent.com/github/gitignore/master/%%~a.gitignore
			echo # Template: %%~a ##################### >> .gitignore
			echo # URL: !TEMPLATE_URL! >> .gitignore
			echo. >> .gitignore
			curl -k !TEMPLATE_URL! >nul 2>nul >> .gitignore
			echo. >> .gitignore
			)
		)
	)
	
echo.
echo. --- STAGING ALL LOCAL CHANGES

echo.
git add . >nul 2>nul
echo. --- STAGING DONE

echo.
echo. --- CREATING INITIAL COMMIT

echo.
git commit -m "initial commit"

echo.
echo. --- CREATING REMOTE REPO ON GITHUB

set JSON_DATA={\"name\": \"%REPO_NAME%\", \"description\": \"%REPO_DESC%\", \"homepage\": \"https://%GITHUB_USER_USERNAME%.github.io/%REPO_NAME%\", \"private\": false, \"has_issues\": true, \"has_projects\": true, \"has_wiki\": true}

echo.
curl -k -u %GITHUB_USER_USERNAME% -X POST -H "Content-Type: application/json" --data "%JSON_DATA%" https://api.github.com/user/repos

echo.
git remote add origin git@github.com:%GITHUB_USER_USERNAME%/%REPO_NAME%.git

echo.
echo. --- PUSHING CODE TO MASTER BRANCH

echo.
git push -u origin master

echo.
echo DONE.

echo.
pause
