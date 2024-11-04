# Definição das URLs para verificação
$url1 = "https://pje.tjma.jus.br/pje/login.seam"
$url2 = "https://pje2.tjma.jus.br/pje2g/login.seam"

# Definição dos arquivos de log onde os resultados serão armazenados
$logFile1 = "C:\zabbix\Logs\pje_1_log.txt"
$logFile2 = "C:\zabbix\Logs\pje_2_log.txt"

# Função que verifica uma URL e registra os resultados em um arquivo de log
function Check-URL($url, $logFile) {
    $start = Get-Date
    try {
        $response = Invoke-WebRequest -Uri $url -Method Get -UseBasicParsing
        $end = Get-Date
        $latency = ($end - $start).TotalMilliseconds
        $downloadSpeed = $response.RawContentLength / 1024 / $latency * 1000  # KB/s
        $status = $response.StatusCode
        
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logEntries = @(
            "$timestamp|URL=$url",
            "$timestamp|Status=$status",
            "$timestamp|Latency=$latency",
            "$timestamp|DownloadSpeed=$downloadSpeed"
        )
    }
    catch {
        $status = $_.Exception.Response.StatusCode.value__
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logEntries = @(
            "$timestamp|URL=$url",
            "$timestamp|Status=$status",
            "$timestamp|Error=$($_.Exception.Message)"
        )
    }

    $logEntries | ForEach-Object { Add-Content -Path $logFile -Value $_ }
}

# Cria o diretório "Logs" em "C:\zabbix" se ele não existir
New-Item -ItemType Directory -Force -Path "C:\zabbix\Logs"

# Verifica as URLs e registra os resultados nos arquivos de log correspondentes
Check-URL $url1 $logFile1
Check-URL $url2 $logFile2