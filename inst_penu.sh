#!/bin/bash

while true
do

# Logo


# Menu

PS3='Выберете опцию: '
options=(
"Установка rust"
"Обновление пакетов"
"Обновить ноду"
"Установка tendermint"
"Вывести информацию"
"Синхронизация"
"Проверить логи(в разработке!)"
"Проверить баланс"
"Вывести список валидаторов"
"Отправить файл"
"Делегация"
"Задать имя(в разработке!)"
"Выход")
select opt in "${options[@]}"
do
case $opt in

"Установка rust")

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env 

break
;;

"Обновление пакетов")

sudo apt update && sudo apt upgrade -y
sudo apt install make clang pkg-config libssl-dev build-essential tmux -y

break
;;

"Обновить ноду")
echo "============================================================"
echo "Установка версии от 22.11.2022" 036
echo "============================================================"

sudo apt update && sudo apt upgrade -y
sudo apt install make clang pkg-config libssl-dev build-essential tmux -y

rm -rf penumbra 
git clone https://github.com/penumbra-zone/penumbra
cd $HOME/penumbra
git fetch
git checkout 036-iocaste.2
cargo update
cargo build --quiet --release --bin pcli
cd $HOME/penumbra/
cargo run --quiet --release --bin pcli view reset
export RUST_LOG=info
cargo run --quiet --release --bin pcli sync
cd $HOME/penumbra/
sudo apt-get install clang
cargo build --release --bin pd

break
;;


"Установка tendermint")


cd $HOME && git clone https://github.com/tendermint/tendermint.git && cd tendermint
git checkout v0.35.4
make install
tendermint version
tendermint init full
peers="20eb3596354699d5b1952311f7cb4e133ad0b6c1@testnet.penumbra.zone:26656,867a241fe58d03ca711625478706eee2dac17dba@testnet.penumbra.zone:26656"
sed -i.bak -e "s/^persistent-peers =.*/persistent-peers = \"$peers\"/" $HOME/.tendermint/config/config.toml
wget -O $HOME/.tendermint/config/genesis.json "https://raw.githubusercontent.com/penumbra-zone/penumbra/main/testnets/008-philophrosyne/genesis.json"

break
;;

"Вывести информацию")

cd $HOME/penumbra/
cargo run --quiet --release --bin pcli view balance
curl -s http://testnet.penumbra.zone:26657/status | jq ".result.node_info.id"
grep -A3 pub_key ~/.tendermint/config/priv_validator_key.json
cd $HOME/penumbra/
cargo run --release --bin pcli -- validator definition template --file validator.json
grep -A3 address ~/penumbra/validator.json

break
;;

"Синхронизация")

cd $HOME/penumbra/
cargo run --quiet --release --bin pcli sync

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


"Задать имя(в разработке!)")

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
