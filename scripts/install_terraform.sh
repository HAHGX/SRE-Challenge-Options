#!/bin/bash
# se deja este archivo como default ya que localmente trabajamos con Mac OS

# Verificar si Homebrew está instalado
if ! command -v brew &> /dev/null
then
    echo "Homebrew no está instalado. Instalando..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Instalar Terraform
if ! command -v terraform &> /dev/null
then
    echo "Terraform no está instalado. Instalando..."
    brew install terraform
fi