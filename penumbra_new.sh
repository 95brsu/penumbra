#!/bin/bash

while true
do

# Logo


# Menu

PS3='Выберете опцию: '
options=(
"Установить ноду"
"Проверить логи(в разработке!)"
"Проверить баланс"
"Вывести список валидаторов"
"Отправить файл"
"Делегация"
"Задать имя"
"Выход")
select opt in "${options[@]}"
do
case $opt in

"Установить ноду")
echo "============================================================"
echo "Установка версии от 25.09.2022"
echo "============================================================"

rm -rf penumbra 
apt-get install build-essential pkg-config libssl-dev
git clone https://github.com/penumbra-zone/penumbra
cd $HOME/penumbra
git fetch
git checkout 030-isonoe
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

"Отправить файл")

cd $HOME/penumbra && cargo run --release --bin pcli -- validator definition upload --file validator.json && cd ..


break
;;

"Делегация")

echo "============================================================"
echo "Введите количество токенов:"
echo "============================================================"
read PENUMBRA_MONETA

echo "============================================================"
echo "Введите валопер адрес:"
echo "============================================================"
read PENUMBRA_VALOPER

cd $HOME/penumbra && cargo run --release --bin pcli transaction delegate ${PENUMBRA_MONETA}penumbra --to ${PENUMBRA_VALOPER} && cd ..


break
;;


"Задать имя")

echo "============================================================"
echo "Задате имя:"
echo "============================================================"
read PENUMBRA_NODENAME
echo export PENUMBRA_NODENAME=${PENUMBRA_NODENAME} >> $HOME/.bash_profile
source ~/.bash_profile
sed '4c\"name": "$PENUMBRA_NODENAME"' $HOME/penumbra/validator.json
sleep 10
break
;;

"Выход")
exit
;;
*) echo "Неправильная опция $REPLY";;
esac
done
done
