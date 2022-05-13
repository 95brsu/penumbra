#!/bin/bash

function logo {
  curl -s https://raw.githubusercontent.com/95brsu/tools/main/nuts.sh | bash
}

function line {
  echo "----12.05.2022--------------------------------------------------------------------"
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
  git checkout 015-ersa
  cargo update
  cargo build --quiet --release --bin pcli
}



function build_pd {
cd $HOME/penumbra/
sudo apt-get install clang
cargo build --release --bin pd
cargo run --quiet --release --bin pcli balance
}


function reset_wallet {
  cd $HOME/penumbra/
  cargo run --quiet --release --bin pcli wallet reset
}

function rust_update {
  rustup update
  rustup default nightly
}

function tendermint {
  tendermint init full 
  curl -s http://testnet.penumbra.zone:26657/genesis | jq ".result.genesis" > $HOME/.tendermint/config/genesis.json
}




colors

line
logo
line
echo -e "${RED}Начинаем обновление Penumbra ${NORMAL}"
line
install_pen
line
reset_wallet
build_pd
line
echo -e "${RED}Скрипт завершил свою работу!!! Если видишь баланс, то все четко, можно Продолжать ${NORMAL}"
