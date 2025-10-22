# Script para iniciar todos os serviços do loctrkd
$configPath = Join-Path $PSScriptRoot "loctrkd.conf"
Write-Host "Usando arquivo de configuração: $configPath"
Write-Host "Porta do collector configurada para: 5023"

$services = @(
    "loctrkd.collector",
    "loctrkd.storage", 
    "loctrkd.rectifier", 
    "loctrkd.termconfig", 
    "loctrkd.wsgateway"
)

foreach ($service in $services) {
    Write-Host "Iniciando $service..."
    Start-Process powershell -ArgumentList "-Command", "python -m $service -c `"$configPath`""
}

Write-Host "Todos os serviços foram iniciados!"