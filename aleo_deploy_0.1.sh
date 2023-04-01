#!/bin/bash
##v0.1
GN_COL='\033[0;32m'
lGN_COL='\033[0;92m'
R_COL='\033[0;31m'
lR_COL='\033[0;91m'
Y_COL='\033[0;33m'
lY_COL='\033[0;93m'
B_COL='\033[0;34m'
lB_COL='\033[0;96m'
W_COL='\033[0m'
####################Создание переменной адреса кошелька

read -p "Вставьте значение переменной адреса кошелька (aleo18kj46jjqk...): " WALLETADDRESS
if [ -z $WALLETADDRESS ]; then
	echo -e "${R_COL}Внимание! Значение не может быть пустым! Повторите ввод переменной!${W_COL}"
	read -p "Вставьте значение переменной адреса кошелька (aleo18kj46jjqk...): " WALLETADDRESS
  exit 0
fi
echo -e "\n${GN_COL}Успешное создание перменной адреса кошелька!\n ${lB_COL}WALLETADDRESS: ${WALLETADDRESS}${W_COL}\n"

####################Создание переменной приватного ключа кошелька

read -p "Вставьте значение приватного ключа кошелька: " PRIVATEKEY
if [ -z $PRIVATEKEY ]; then
	echo -e "${R_COL}Внимание! Значение не может быть пустым! Повторите ввод переменной!${W_COL}"
	read -p "Вставьте значение приватного ключа кошелька: " PRIVATEKEY
  exit 0
fi
echo -e "\n${GN_COL}Успешное создание перменной приватного ключа кошелька!\n ${lB_COL}PRIVATEKEY: ${PRIVATEKEY}${W_COL}\n"

####################Создание переменной RECORD

read -p "Вставьте значение переменной RECORD: " RECORD
if [ -z $RECORD ]; then
	echo -e "${R_COL}Внимание! Значение не может быть пустым! Повторите ввод переменной!${W_COL}"
	read -p "Вставьте значение переменной RECORD: " RECORD
  exit 0
fi
echo -e "\n${GN_COL}Успешное создание перменной RECORD!\n ${lB_COL}RECORD: ${RECORD}${W_COL}\n"

####################Выполнение скрипта deploy

cd $HOME
mkdir demo_deploy_Leo_app && cd demo_deploy_Leo_app
APPNAME=smartcontract_"${WALLETADDRESS:4:6}"
echo -e "$APPNAME"
leo new "${APPNAME}"
cd "${APPNAME}" && leo run && cd -
PATHTOAPP=$(realpath -q $APPNAME)
echo -e "$PATHTOAPP"
cd $PATHTOAPP && cd ..
snarkos developer deploy "${APPNAME}.aleo" --private-key "${PRIVATEKEY}" --query "https://vm.aleo.org/api" --path "./${APPNAME}/build/" --broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" --fee 600000 --record "${RECORD}"
cd $HOME
echo -e "Успешный деплой контракта!"
