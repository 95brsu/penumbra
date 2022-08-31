#!/bin/bash


echo "=================================================="
echo -e "\033[0;35m"
echo " ::::    :::  ::     ::  :::::::::   ::::::::   ";
echo " :+:+:   :+: :+:    :+:     :+:     :+:    :+:  ";
echo " :+:+:+  +:+ +:+    +:+     +:+     +:+         ";
echo " +#+ +:+ +#+ +#+    +:+     +:+     +#++:++#++  ";
echo " +#+  +#+#+# +#+    +#+     +#+             +#+ ";
echo " #+#   #+#+# #+#    #+#     #+#     #+#     #+# ";
echo " ###    ####    ####        ##        ######    ";
echo -e "\e[0m"
echo "=================================================="

sleep 2


function line {
  echo "---31.08.2022---------------------------------------------------------------------"
}

function colors {
  GREEN="\e[1m\e[32m"
  RED="\e[1m\e[39m"
  NORMAL="\e[0m"
}


function install_pen {
  rm -rf penumbra 
  apt-get install build-essential pkg-config libssl-dev
  git clone https://github.com/penumbra-zone/penumbra
  cd $HOME/penumbra
  git fetch
  git checkout 027-thyone
  cargo update
  cargo build --quiet --release --bin pcli
}



function build_pd {
cd $HOME/penumbra/
sudo apt-get install clang
cargo build --release --bin pd
cargo run --quiet --release --bin pcli view balance
}


function reset_wallet {
  cd $HOME/penumbra/
  cargo run --quiet --release --bin pcli view reset
}

function rust_update {
  rustup update
  rustup default nightly
}

function tendermint {
  tendermint init full 
  curl -s http://testnet.penumbra.zone:26657/genesis | jq ".result.genesis" > $HOME/.tendermint/config/genesis.json
}

function dannie {
  curl -s http://testnet.penumbra.zone:26657/status | jq ".result.node_info.id"
  grep -A3 pub_key ~/.tendermint/config/priv_validator_key.json
  cd $HOME/penumbra/
  cargo run --release --bin pcli -- validator definition template --file validator.json
  grep -A3 address ~/penumbra/validator.json
}


colors

line
echo -e "${RED}Начинаем обновление Penumbra ${NORMAL}"
line
install_pen
line
reset_wallet
build_pd
line
dannie
line
echo -e "${RED}Скрипт завершил свою работу!!! Если видишь баланс, то все четко, можно Продолжать << nano $HOME/.tendermint/config/config.toml >> << nano validator.json >> ${NORMAL}"
