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
    echo "Escolha a opção"
    echo "------------------------------------------"
    echo "1. Mysql"
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
        2) echo "Hestia";;
        3) echo "Otrs";;
        4) echo "Zimbra";; 
        5) echo "Postgresql";;
        6) exit ;;
        *) echo "Opção desconhecida." ; echo ; BackupLocal ;;
    esac
} 

Mysql() {
    clear       
    echo "Criando /joy/backup/mysql"
    if [ -d "joy/backup/mysql" ]; then
    echo " Diretorio ja existe, skip"
    BackupLocal
    else
    mkdir joy/backup/mysql
    echo "Diretorio criado"
    sleep 2
    BackupLocal
    fi
}

mkdir -p joy/backup
mkdir -p joy/scripts
mkdir -p joy/storage

Principal


