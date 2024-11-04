# Scripts de Monitoramento de URL

Este repositório contém scripts e configurações para monitorar URLs usando o Zabbix. A configuração inclui um script batch do Windows para instalar e configurar o agente Zabbix, um script PowerShell para monitorar URLs e arquivos de configuração do agente Zabbix.

## Conteúdo

1. [Script de Instalação do Agente Zabbix](#script-de-instalação-do-agente-zabbix)
2. [Script de Monitoramento de URL](#script-de-monitoramento-de-url)
3. [Configuração do Agente Zabbix](#configuração-do-agente-zabbix)
4. [Template do Zabbix](#template-do-zabbix)
5. [Configuração de Metadados no Servidor Zabbix](#configuração-de-metadados-no-servidor-zabbix)

## Script de Instalação do Agente Zabbix

O script batch do Windows (`install_zabbix_agent.bat`) realiza as seguintes tarefas:

- Instala o serviço do agente Zabbix
- Configura o serviço para iniciar automaticamente
- Inicia o serviço do agente Zabbix
- Cria uma tarefa agendada para executar o script de monitoramento de URL

### Uso

1. Certifique-se de que os arquivos do agente Zabbix estão localizados em `C:\Zabbix\zabbix_agent-6.0.0-windows-amd64-openssl`
2. Execute o script com privilégios de administrador

## Script de Monitoramento de URL

O script PowerShell (`monitor_script.ps1`) verifica a disponibilidade e o desempenho de duas URLs:

- https://www.google.com
- https://www.uol.com.br

Ele registra as seguintes informações para cada URL:

- Código de status HTTP
- Latência
- Velocidade de download

### Uso

O script foi projetado para ser executado pela tarefa agendada criada no script de instalação. Ele criará arquivos de log em `C:\zabbix\Logs\`.

## Configuração do Agente Zabbix

O arquivo de configuração do agente Zabbix (`zabbix_agentd.conf`) inclui configurações para:

- Localização do arquivo de log
- Nível de depuração
- Configurações de servidor e servidor ativo
- Metadados do host
- Parâmetros de usuário para coletar dados de monitoramento das URLs

### Parâmetros de Usuário

A configuração inclui parâmetros de usuário personalizados para coletar dados dos arquivos de log:

- `google.status`, `google.latency`, `google.downloadspeed`
- `uol.status`, `uol.latency`, `uol.downloadspeed`

## Template do Zabbix

O template Zabbix fornecido (`template_url_monitoring.yaml`) inclui:

- Itens para coletar status, latência e velocidade de download do Google e UOL
- Itens de log desativados para uso futuro
- Marcação apropriada para monitoramento de URLs

### Uso

Importe este template para o seu servidor Zabbix e vincule-o aos hosts que executam os scripts de monitoramento das URLs.

## Configuração de Metadados no Servidor Zabbix

Para configurar metadados no servidor Zabbix, siga estas etapas:

1. **Acesse o Servidor Zabbix:**
   - Faça login na interface web do Zabbix.

2. **Vá para a seção de Hosts:**
   - No menu, clique em **Configuração** e depois em **Hosts**.

3. **Adicione ou Edite um Host:**
   - Para adicionar um novo host, clique em **Criar host**.
   - Para editar um host existente, clique no nome do host.

4. **Configurar Metadados:**
   - Na seção **Metadados**, insira os valores desejados para `HostMetadata`. 
   - Utilize uma string que identifique o host, como `URL-Monitoring`.

5. **Salvar Configurações:**
   - Clique em **Salvar** para aplicar as alterações.

6. **Verifique se o Host está Funcionando:**
   - Após a configuração, verifique se o host aparece como ativo na interface do Zabbix e se os dados estão sendo coletados corretamente.

## Instruções de Configuração

1. Copie os arquivos do agente Zabbix para `C:\Zabbix\zabbix_agent-6.0.0-windows-amd64-openssl`
2. Execute o script `install_zabbix_agent.bat` com privilégios de administrador
3. Coloque o `monitor_script.ps1` em `C:\Zabbix\`
4. Atualize o arquivo `zabbix_agentd.conf` com suas configurações específicas de servidor
5. Importe o template Zabbix para o seu servidor Zabbix
6. Vincule o template aos hosts apropriados
7. Configure os metadados no servidor Zabbix conforme descrito na seção anterior

## Solução de Problemas

- Verifique o arquivo de log do agente Zabbix em `C:\Zabbix\zabbix_agent-6.0.0-windows-amd64-openssl\zabbix_agentd.log` para quaisquer erros
- Verifique se a tarefa agendada está sendo executada corretamente no Agendador de Tarefas
- Certifique-se de que os arquivos de log estão sendo criados e atualizados em `C:\zabbix\Logs\`


