# Script para verificar se os servi�os est�o em execu��o
# Verifica processos Python que est�o executando os m�dulos loctrkd

Write-Host "Verificando servi�os loctrkd em execu��o..." -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Cyan

$services = @(
    "loctrkd.collector",
    "loctrkd.storage", 
    "loctrkd.rectifier", 
    "loctrkd.termconfig", 
    "loctrkd.wsgateway"
)

$runningCount = 0

foreach ($service in $services) {
    $processes = Get-Process python -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*$service*" }
    if ($processes) {
        Write-Host " $service est� em execu��o" -ForegroundColor Green
        $runningCount++
    } else {
        Write-Host " $service N�O est� em execu��o" -ForegroundColor Red
    }
}

Write-Host "----------------------------------------" -ForegroundColor Cyan
Write-Host "$runningCount de 5 servi�os em execu��o" -ForegroundColor $(if ($runningCount -eq 5) { "Green" } else { "Yellow" })

# Verificar se a porta 5023 est� em uso (porta do collector)
try {
    $portCheck = Get-NetTCPConnection -LocalPort 5023 -ErrorAction SilentlyContinue
    if ($portCheck) {
        Write-Host " A porta 5023 est� aberta e em uso (Collector)" -ForegroundColor Green
    } else {
        Write-Host " A porta 5023 N�O est� em uso! O collector pode n�o estar funcionando corretamente." -ForegroundColor Red
    }
} catch {
    Write-Host " N�o foi poss�vel verificar a porta 5023" -ForegroundColor Red
}

# Verificar se a porta 5049 est� em uso (porta do wsgateway)
try {
    $portCheck = Get-NetTCPConnection -LocalPort 5049 -ErrorAction SilentlyContinue
    if ($portCheck) {
        Write-Host " A porta 5049 est� aberta e em uso (WebSocket Gateway)" -ForegroundColor Green
    } else {
        Write-Host " A porta 5049 N�O est� em uso! O wsgateway pode n�o estar funcionando corretamente." -ForegroundColor Red
    }
} catch {
    Write-Host " N�o foi poss�vel verificar a porta 5049" -ForegroundColor Red
}
