#!/bin/bash
# Script para verificar se os serviços estão em execução no Ubuntu

# Cores para formatação
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${CYAN}Verificando serviços loctrkd em execução...${NC}"
echo -e "${CYAN}----------------------------------------${NC}"

# Lista de serviços para verificar
services=(
    "loctrkd.collector"
    "loctrkd.storage" 
    "loctrkd.rectifier" 
    "loctrkd.termconfig" 
    "loctrkd.wsgateway"
)

running_count=0

for service in "${services[@]}"; do
    # Verifica se existe um processo com o nome do serviço
    if pgrep -f "python3 -m $service" > /dev/null; then
        echo -e "${GREEN}✓ $service está em execução${NC}"
        pid=$(pgrep -f "python3 -m $service")
        echo -e "  PID: $pid"
        running_count=$((running_count + 1))
    else
        echo -e "${RED}✗ $service NÃO está em execução${NC}"
    fi
done

echo -e "${CYAN}----------------------------------------${NC}"
if [ $running_count -eq 5 ]; then
    echo -e "${GREEN}$running_count de 5 serviços em execução${NC}"
else
    echo -e "${YELLOW}$running_count de 5 serviços em execução${NC}"
fi

# Verificar se a porta 5023 está em uso (porta do collector)
if netstat -tuln | grep ":5023" > /dev/null; then
    echo -e "${GREEN}✓ A porta 5023 está aberta e em uso (Collector)${NC}"
else
    echo -e "${RED}✗ A porta 5023 NÃO está em uso! O collector pode não estar funcionando corretamente.${NC}"
fi

# Verificar se a porta 5049 está em uso (porta do wsgateway)
if netstat -tuln | grep ":5049" > /dev/null; then
    echo -e "${GREEN}✓ A porta 5049 está aberta e em uso (WebSocket Gateway)${NC}"
else
    echo -e "${RED}✗ A porta 5049 NÃO está em uso! O wsgateway pode não estar funcionando corretamente.${NC}"
fi