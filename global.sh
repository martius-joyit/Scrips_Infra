#!/bin/bash

Principal() {
    clear
    echo "Existe backup local ? (sim/nao)" ; read bkp_local
    case $bkp_local in
        sim) BackupLocal ;;
        nao) echo "continua" ;;
        *) echo "Resposta invalida ### use (sim/nao)" ; Principal ;;
    esac
}

BackupLocal() {
    clear
    echo "Escolha a opção (Template Zabbix 01)"
    echo "------------------------------------------"
    echo "1. Mysql "
    echo "2. Hestia"
    echo "3. Otrs"
    echo "4. Zimbra"
    echo "5. Postgresql"
    echo "6. Continuar"
    echo
    echo -n "Qual a opção desejada? "
    read opcao
    case $opcao in
        1) Mysql ;;
        2) Hestia ;;
        3) echo "Otrs";;
        4) echo "Zimbra";; 
        5) echo "Postgresql";;
        6) Template_t01;;
        *) echo "Opção desconhecida." ; echo ; BackupLocal ;;
    esac
    
    
    
    
} 

Dir() {
      
    echo "Criando -p $DIR"
    if [ -d "$DIR" ]; then
    echo " Diretorio ja existe, skip"
    sleep 2
    BackupLocal
    else
    mkdir $DIR
    echo "Diretorio criado"
    sleep 2
    BackupLocal
    fi
}

Mysql() {
    clear       
    DIR=/joy/backup/mysql
    Dir
}

Hestia() {
    clear       
    DIR=/joy/backup/hestia
    Dir
}

Template_t01() {
    clear
    echo -e "\e[36m Fazendo o download dos scripts do template t01 \e[m" 
    echo
    sleep 2
    wget -c -P /joy/scripts/zabbix https://raw.githubusercontent.com/joyitcwb/Scrips_Infra/master/scripts/t01_s001_discovery.sh
    wget -c -P /joy/scripts/zabbix https://raw.githubusercontent.com/joyitcwb/Scrips_Infra/master/scripts/t01_s002_status.sh
    chmod +x /joy/scripts/zabbix/t01_s001_discovery.sh
    chmod +x /joy/scripts/zabbix/t01_s002_status.sh
    echo -e "\e[32m OK \e[m"
    
    echo
    echo -e "\e[36m Atualizando zabbix_agent.conf \e[m" 
    echo
    sleep 2 
    sed -i "4i UserParameter=backup.discovery,/joy/scripts/zabbix/t01_s001_discovery.sh" /etc/zabbix/zabbix_agentd.conf
    sed -i "4i UserParameter=backup.status[*],/joy/scripts/zabbix/t01_s002_status.sh "'$'1"" /etc/zabbix/zabbix_agentd.conf
    sed -i "4i ### Joy IT" /etc/zabbix/zabbix_agentd.conf
    echo -e "\e[32m OK \e[m"

    echo
    echo -e "\e[36m Reiniciando Zabbix Agent \e[m"
    echo
    sleep 2
    # systemctl restart zabbix-agent
    echo -e "\e[32m OK \e[m"
}

OS=`hostnamectl | grep Operating | cut -d: -f2 | cut -d' ' -f2`

echo
echo -e "\e[36m Instalando jq \e[m" 
sleep 2
if [ $OS = "Debian" ]; then
apt-get install jq -y
echo -e "\e[32m OK \e[m"
elif [ $OS = "Centos" ]; then
yum install jq -y
echo -e "\e[32m OK \e[m"
else
echo -e "\e[31m $OS - OS não suportado | Verifique a forma correta de instalar o jq \e[m"
sleep 3
fi

echo
echo -e "\e[36m Criando /joy/backup \e[m" 
sleep 2
mkdir -p /joy/backup
echo -e "\e[32m OK \e[m"

echo
echo -e "\e[36m Criando /joy/scripts \e[m"
sleep 2
mkdir -p /joy/scripts
echo -e "\e[32m OK \e[m"

echo
echo -e "\e[36m Criando /joy/storage \e[m"
sleep 2
mkdir -p /joy/storage
echo -e "\e[32m OK \e[m"
sleep 2


Principal

echo
echo -e "\e[36m Copiando o script global.sh /joy/scripts/global \e[m"
sleep 2
SCRIPT=`pwd`
mkdir -p /joy/scripts/global
cp $SCRIPT/global.sh /joy/scripts/global
echo -e "\e[32m OK \e[m"
sleep 2



