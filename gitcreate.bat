@echo off & setlocal
setlocal enableDelayedExpansion
cls

echo CREATE NEW GITHUB REPO AND PUSH CODE FROM CLI
echo.

set GITHUB_USER_FULLNAME="Shubham Gulati"
set /p GITHUB_USER_FULLNAME= Enter Full Name [default is %GITHUB_USER_FULLNAME%]: 

set GITHUB_USER_EMAIL="shubhamgulati91@gmail.com"
set /p GITHUB_USER_EMAIL= Enter Email [default is %GITHUB_USER_EMAIL%]: 

set GITHUB_USER_USERNAME="shubhamgulati91"
set /p GITHUB_USER_USERNAME= Enter Github Username [default is %GITHUB_USER_USERNAME%]: 

set CURRENT_DIR_LOCATION=%~dp0 >nul 2>nul

::set REPO_LOCAL_LOCATION="C:\Users\shgulati\Downloads\create-git-repos-from-cli"
set REPO_LOCAL_LOCATION=%CURRENT_DIR_LOCATION%
set /p REPO_LOCAL_LOCATION= Enter Repo Local Location [default is %REPO_LOCAL_LOCATION%]: 
cd %REPO_LOCAL_LOCATION% >nul 2>nul

for %%I in (.) do set CURRENT_DIR_NAME=%%~nxI

set REPO_NAME=%CURRENT_DIR_NAME%
set /p REPO_NAME= Enter Repo Name [default is %CURRENT_DIR_NAME%]: 

set REPO_DESC=Project: %REPO_NAME%
set /p REPO_DESC= Enter Repo Description [default is "%REPO_DESC%"]: 

cd %REPO_LOCAL_LOCATION% >nul 2>nul
if exist .git rd/q /s .git

echo.
echo. ++ Creating repository and pushing code...

git config --global user.name "%GITHUB_USER_FULLNAME%"
git config --global user.email "%GITHUB_USER_EMAIL%"

git init

if exist README.md del README.md
touch README.md
echo # %REPO_NAME% >> README.md
echo %REPO_DESC% >> README.md
echo.

if not exist .gitignore (
	set ADD_GITIGNORE=n
	set /p ADD_GITIGNORE="Add gitignore? (y/n) [default is '!ADD_GITIGNORE!']: 
	
	if "!ADD_GITIGNORE!" == "y" (
		set GITIGNORE_TEMPLATES_LIST=Maven,Java
		set /p GITIGNORE_TEMPLATES_LIST=Enter gitignore templates to be fetched [default is "!GITIGNORE_TEMPLATES_LIST!"]: 
		echo. ++ Fetching gitignore templates: !GITIGNORE_TEMPLATES_LIST!
		echo.

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

git add . >nul 2>nul

git commit -m "initial commit"
echo.

set JSON_DATA={\"name\": \"%REPO_NAME%\", \"description\": \"%REPO_DESC%\", \"homepage\": \"https://github.com/shubhamgulati91/%REPO_NAME%\", \"private\": false, \"has_issues\": true, \"has_projects\": true, \"has_wiki\": true}
::echo REQUEST DATA: %JSON_DATA%
::echo.

curl -k -u %GITHUB_USER_USERNAME% -X POST -H "Content-Type: application/json" --data "%JSON_DATA%" https://api.github.com/user/repos

git remote add origin git@github.com:%GITHUB_USER_USERNAME%/%REPO_NAME%.git

::echo.
::git remote -v

::echo.
::git status

echo.
git push -u origin master

echo.
echo Repository created and code pushed successfully.
pause
