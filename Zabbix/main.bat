@echo off
setlocal

:: Variáveis
set "agentPath=C:\Zabbix\zabbix_agent-6.0.0-windows-amd64-openssl"
set "configFile=%agentPath%\conf\zabbix_agentd.conf"

:: Verificar se o serviço Zabbix Agent já está instalado
sc query "Zabbix Agent" >nul 2>&1
if %errorlevel% equ 0 (
    echo O serviço Zabbix Agent já está instalado.
    goto startService
)

:: Instalar o serviço do Zabbix Agent
echo Instalando o serviço Zabbix Agent...
"%agentPath%\bin\zabbix_agentd.exe" --config "%configFile%" --install

:: Definir o arranque automático
sc config "Zabbix Agent" start= auto

:: Verificar se a instalação foi bem-sucedida
sc query "Zabbix Agent" >nul 2>&1
if %errorlevel% neq 0 (
    echo Erro: A instalação do serviço Zabbix Agent falhou.
    exit /b 1
)

:startService
:: Iniciar o serviço Zabbix Agent
echo Iniciando o serviço Zabbix Agent...
net start "Zabbix Agent"

:: Verificar se o serviço foi iniciado com sucesso
sc query "Zabbix Agent" | findstr /i "RUNNING" >nul
if %errorlevel% equ 0 (
    echo O serviço Zabbix Agent foi iniciado com sucesso.
) else (
    echo Erro: Não foi possível iniciar o serviço Zabbix Agent.
    exit /b 1
)

:: Criar a tarefa agendada
schtasks /create /tn "pje-url-teste" /tr "powershell.exe -ExecutionPolicy Bypass -File C:\Zabbix\monitor_script.ps1" /sc minute /mo 5 /ru SYSTEM

if %errorlevel% equ 0 (
    echo Tarefa "pje-url-teste" criada com sucesso.
) else (
    echo Erro ao criar a tarefa. Código de erro: %errorlevel%
)

echo Instalação do Zabbix Agent e criação da tarefa agendada concluídas com sucesso.
endlocal
exit /b 0
