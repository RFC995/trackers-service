#!/bin/bash
# Script para parar todos os serviços do loctrkd

# Cores para formatação
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}Parando serviços loctrkd...${NC}"
echo -e "${CYAN}----------------------------------------${NC}"

# Lista de serviços
services=(
    "loctrkd.collector"
    "loctrkd.storage" 
    "loctrkd.rectifier" 
    "loctrkd.termconfig" 
    "loctrkd.wsgateway"
)

for service in "${services[@]}"; do
    # Tenta encontrar o PID do processo
    pid=$(pgrep -f "python3 -m $service")
    
    if [ -n "$pid" ]; then
        echo -e "${GREEN}Parando $service (PID: $pid)...${NC}"
        kill $pid
        echo -e "${GREEN}✓ Serviço $service parado${NC}"
    else
        echo -e "${RED}✗ Serviço $service não estava em execução${NC}"
    fi
    
    # Remove o arquivo PID se existir
    if [ -f "logs/$service.pid" ]; then
        rm "logs/$service.pid"
    fi
done

echo -e "${CYAN}----------------------------------------${NC}"
echo -e "${GREEN}Todos os serviços foram parados!${NC}"