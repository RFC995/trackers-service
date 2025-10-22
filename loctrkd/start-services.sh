#!/bin/bash
# Script para iniciar todos os serviços do loctrkd no Ubuntu

# Cores para formatação
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

CONFIG_PATH="$(pwd)/loctrkd.conf"
echo -e "${GREEN}Usando arquivo de configuração:${NC} $CONFIG_PATH"
echo -e "${GREEN}Porta do collector configurada para:${NC} 5023"

# Lista de serviços para iniciar
services=(
    "loctrkd.collector"
    "loctrkd.storage" 
    "loctrkd.rectifier" 
    "loctrkd.termconfig" 
    "loctrkd.wsgateway"
)

# Cria diretório de logs se não existir
mkdir -p logs

# Inicia cada serviço em um terminal separado
for service in "${services[@]}"; do
    echo -e "${GREEN}Iniciando $service...${NC}"
    # Opção 1: Usar gnome-terminal (para ambientes com interface gráfica)
    # gnome-terminal -- bash -c "python3 -m $service -c \"$CONFIG_PATH\"; read -p 'Pressione Enter para fechar...'"
    
    # Opção 2: Executar em background e redirecionar saída para arquivo de log
    python3 -m $service -c "$CONFIG_PATH" > "logs/$service.log" 2>&1 &
    
    # Armazena o PID para uso posterior
    echo $! > "logs/$service.pid"
    echo -e "${YELLOW}Processo iniciado com PID:${NC} $!"
done

echo -e "${GREEN}Todos os serviços foram iniciados!${NC}"
echo -e "${YELLOW}Logs disponíveis em:${NC} $(pwd)/logs/"