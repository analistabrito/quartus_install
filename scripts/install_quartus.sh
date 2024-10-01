#!/bin/bash

# Atualiza o sistema
echo "Atualizando o sistema..."
sudo apt-get update && sudo apt-get upgrade -y

# Cria diretório para armazenar os instaladores
INSTALL_DIR="$HOME/quartus_installation"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Define URLs para download dos instaladores
echo "Lendo os links dos instaladores a partir do arquivo links.txt..."
QUARTUS_URL=$(grep -o 'https://www.intel.com/content/.*quartus-prime-lite.*' ../dependencies/links.txt)
MODELSIM_URL=$(grep -o 'https://www.intel.com/content/.*modelsim-intel.*' ../dependencies/links.txt)

# Verifica se os links foram encontrados
if [ -z "$QUARTUS_URL" ] || [ -z "$MODELSIM_URL" ]; then
    echo "Erro: Não foi possível encontrar os links no arquivo links.txt."
    exit 1
fi

# Baixa os instaladores
echo "Baixando o Quartus Prime Lite..."
wget -c "$QUARTUS_URL" -O quartus_installer.run

echo "Baixando o ModelSim..."
wget -c "$MODELSIM_URL" -O modelsim_installer.run

# Torna os arquivos executáveis
echo "Alterando permissão dos instaladores..."
chmod +x quartus_installer.run modelsim_installer.run

# Instala o Quartus Prime Lite
echo "Instalando o Quartus Prime Lite..."
./quartus_installer.run

# Instala dependências para o ModelSim (32-bit)
echo "Adicionando arquitetura i386 e instalando dependências..."
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 lib32ncurses6 libxft2 libxft2:i386 libxext6 libxext6:i386

# Instala o ModelSim
echo "Instalando o ModelSim..."
./modelsim_installer.run

# Instruções de configuração final
echo "Aponte o caminho do ModelSim no Quartus Prime:"
echo "Vá em Tools > Options > EDA Tool Options e defina o caminho para a pasta 'bin' do ModelSim."

echo "Instalação concluída!"