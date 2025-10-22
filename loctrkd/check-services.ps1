# Script para verificar se os serviços estão em execução
# Verifica processos Python que estão executando os módulos loctrkd

Write-Host "Verificando serviços loctrkd em execução..." -ForegroundColor Cyan
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
        Write-Host " $service está em execução" -ForegroundColor Green
        $runningCount++
    } else {
        Write-Host " $service NÃO está em execução" -ForegroundColor Red
    }
}

Write-Host "----------------------------------------" -ForegroundColor Cyan
Write-Host "$runningCount de 5 serviços em execução" -ForegroundColor $(if ($runningCount -eq 5) { "Green" } else { "Yellow" })

# Verificar se a porta 5023 está em uso (porta do collector)
try {
    $portCheck = Get-NetTCPConnection -LocalPort 5023 -ErrorAction SilentlyContinue
    if ($portCheck) {
        Write-Host " A porta 5023 está aberta e em uso (Collector)" -ForegroundColor Green
    } else {
        Write-Host " A porta 5023 NÃO está em uso! O collector pode não estar funcionando corretamente." -ForegroundColor Red
    }
} catch {
    Write-Host " Não foi possível verificar a porta 5023" -ForegroundColor Red
}

# Verificar se a porta 5049 está em uso (porta do wsgateway)
try {
    $portCheck = Get-NetTCPConnection -LocalPort 5049 -ErrorAction SilentlyContinue
    if ($portCheck) {
        Write-Host " A porta 5049 está aberta e em uso (WebSocket Gateway)" -ForegroundColor Green
    } else {
        Write-Host " A porta 5049 NÃO está em uso! O wsgateway pode não estar funcionando corretamente." -ForegroundColor Red
    }
} catch {
    Write-Host " Não foi possível verificar a porta 5049" -ForegroundColor Red
}
