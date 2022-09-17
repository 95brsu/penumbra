#!/bin/bash

while true
do

# Logo

echo "=================================================="
echo -e "\033[1;37m\"
echo " ::::    :::  ::     ::  :::::::::   ::::::::   ";
echo " :+:+:   :+: :+:    :+:     :+:     :+:    :+:  ";
echo " :+:+:+  +:+ +:+    +:+     +:+     +:+         ";
echo " +#+ +:+ +#+ +#+    +:+     +:+     +#++:++#++  ";
echo " +#+  +#+#+# +#+    +#+     +#+             +#+ ";
echo " #+#   #+#+# #+#    #+#     #+#     #+#     #+# ";
echo " ###    ####    ####        ##        ######    ";
echo -e "\e[0m"
echo "=================================================="

# Menu

PS3='Выберете опцию: '
options=(
"Установить ноду"
"Проверить логи(в разработке!)"
"Проверить баланс"
"Вывести список валидаторов"
"Задать имя ноды"
"Выход")
select opt in "${options[@]}"
do
case $opt in

"Установить ноду")
echo "============================================================"
echo "Установка версии от 17.09.2022"
echo "============================================================"

rm -rf penumbra 
apt-get install build-essential pkg-config libssl-dev
git clone https://github.com/penumbra-zone/penumbra
cd $HOME/penumbra
git fetch
git checkout 029-eukelade
cargo update
cargo build --quiet --release --bin pcli
cd $HOME/penumbra/
cargo run --quiet --release --bin pcli view reset
cd $HOME/penumbra/
sudo apt-get install clang
cargo build --release --bin pd
cargo run --quiet --release --bin pcli view balance
curl -s http://testnet.penumbra.zone:26657/status | jq ".result.node_info.id"
grep -A3 pub_key ~/.tendermint/config/priv_validator_key.json
cd $HOME/penumbra/
cargo run --release --bin pcli -- validator definition template --file validator.json
grep -A3 address ~/penumbra/validator.json

break
;;

"Проверить баланс")

cd $HOME/penumbra && cargo run --release --bin pcli -- view balance


break
;;

"Вывести список валидаторов")

cd $HOME/penumbra && cargo run --release --bin pcli -- query validator list -i && cd ..


break
;;

"Задать имя ноды")
echo "============================================================"
echo "Задате имя:"
echo "============================================================"
read PENUMBRA_NODENAME
echo export PENUMBRA_NODENAME=${PENUMBRA_NODENAME} >> $HOME/.bash_profile
source ~/.bash_profile
sed '4c\"name": "${PENUMBRA_NODENAME}"' $HOME/penumbra/validator.json

break
;;

"Выход")
exit
;;
*) echo "Неправильная опция $REPLY";;
esac
done
done
