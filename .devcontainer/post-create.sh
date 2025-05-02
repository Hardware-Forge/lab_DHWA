#!/bin/bash
set -xe
 
apt update
DEBIAN_FRONTEND=noninteractive apt install -y \
    curl \
    dbus-x11 \
    git \
    gtkwave \
    iverilog \
    jq \
    python3-pip \
    universal-ctags \
    verilator \
    wget
pip3 install \
    cocotb \
    cocotb-test \
    flake8 \
    isort \
    pytest \
    yapf
 
# Verible
ARCH=$(uname -m)
if [[ $ARCH == "aarch64" ]]
then
    ARCH="arm64"
fi
DIST_ID=$(grep DISTRIB_ID /etc/lsb-release | cut -d'=' -f2)
DIST_RELEASE=$(grep RELEASE /etc/lsb-release | cut -d'=' -f2)
DIST_CODENAME=$(grep CODENAME /etc/lsb-release | cut -d'=' -f2)
VERIBLE_RELEASE=$(curl -s -X GET https://api.github.com/repos/chipsalliance/verible/releases/latest | jq -r '.tag_name')
VERIBLE_TAR=verible-$VERIBLE_RELEASE-linux-static-$ARCH.tar.gz
if [[ ! -f $VERIBLE_TAR ]]
then
    wget https://github.com/chipsalliance/verible/releases/download/$VERIBLE_RELEASE/$VERIBLE_TAR
fi
if [[ ! -f "/usr/local/bin/verible-verilog-format" ]]
then
    tar -C /usr/local --strip-components 1 -xf $VERIBLE_TAR
fi
rm $VERIBLE_TAR

# Inspired from the Dockerfile at https://github.com/starwaredesign/vivado-docker

VIVADO_TAR_FILE=Xilinx_Vivado_SDK_2018.3_1207_2324
VIVADO_VERSION=2018.3

if [[ -f ${VIVADO_TAR_FILE}.tar.gz ]]
then

dpkg --add-architecture i386

apt-get update

apt-get install -y wget build-essential libglib2.0-0 libsm6 libxi6 libxrender1 libxrandr2 libfreetype6 libfontconfig1 locales git gawk iproute2 python3 gcc make net-tools libncurses5 libncurses5-dev tftpd zlib1g-dev libssl-dev flex bison libselinux1 gnupg git-core diffstat chrpath socat xterm autoconf libtool rsync texinfo gcc-multilib zlib1g:i386 lsb-release libtinfo5 dnsutils bc unzip

tar xzf ${VIVADO_TAR_FILE}.tar.gz
./${VIVADO_TAR_FILE}/xsetup --agree XilinxEULA,3rdPartyEULA,WebTalkTerms --batch Install --config ./.devcontainer/install_config.txt
rm -rf ${VIVADO_TAR_FILE}/*
rmdir ${VIVADO_TAR_FILE}

echo "source /opt/Xilinx/Vivado/${VIVADO_VERSION}/settings64.sh" >> /root/.profile

else

echo "Skipping Vivado installation"

fi

# Installation of Gowin Education and related tools for DoHA course

GOWIN_TAR_FILE=Gowin_V1.9.11.01_Education_Linux

if [[ -f ${GOWIN_TAR_FILE}.tar.gz ]]
then

dpkg --add-architecture i386

apt-get install -y minicom libgl1 libnss3 libasound2 libqt5gui5

# Install openFPGALoader from source
if [[ -z $(which openFPGALoader) ]]
then
apt install -y \
  git \
  gzip \
  libftdi1-2 \
  libftdi1-dev \
  libhidapi-hidraw0 \
  libhidapi-dev \
  libudev-dev \
  zlib1g-dev \
  cmake \
  pkg-config \
  make \
  g++

git clone https://github.com/trabucayre/openFPGALoader
cd openFPGALoader
mkdir build
cd build
cmake -DENABLE_UDEV=OFF ..
cmake --build .
make install
cd ../..
rm -rf ./openFPGALoader
fi

# Install Gowin EDA from tar file

if [[ ! -d /opt/Gowin ]]
then
mkdir ./Gowin
tar xzf ${GOWIN_TAR_FILE}.tar.gz -C ./Gowin
mv ./Gowin /opt/Gowin
fi

else

echo "Skipping Gowin installation"

fi

if [[ ! -d neorv32-setups ]]
then
# Install neorv32 enviroment
git clone https://github.com/stnolting/neorv32-setups.git
cd neorv32-setups
git submodule update --init --recursive
cd gowineda/tang-nano-9k/
if [[ -n $(which gw_sh) ]]
then
gw_sh create_project.tcl
fi
cd ../../..
fi

if [[ -f riscv32-gnu-toolchain.tar.gz ]]
then
if [[ ! -d /opt/riscv ]]
then
mkdir /opt/riscv
fi
# extract precompiled toolchain
tar xf riscv32-gnu-toolchain.tar.gz --directory=/opt/riscv
else

# Install riscv-gnu-toolchain from source
git clone https://github.com/riscv/riscv-gnu-toolchain
cd riscv-gnu-toolchain
apt install -y autoconf automake autotools-dev curl python3 python3-pip python3-tomli libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev libslirp-dev
./configure --prefix=/opt/riscv --with-arch=rv32i --with-abi=ilp32
# check if the system has 16 or more gb of ram, if not resort to single core compilation
if [ $(free -g | awk '/^Mem:/{print $2}') -ge 16 ]; then
    make -j$(nproc)
else
    make
fi
cd ..
rm -rf ./riscv-gnu-toolchain
fi

# Change riscv-gnu-toolchain RISCV_PREFIX ?= to riscv32-unknown-elf- inside neorv32-setups/neorv32/sw/common/common.mk
sed -i 's/RISCV_PREFIX ?= .*/RISCV_PREFIX ?= riscv32-unknown-elf-/g' neorv32-setups/neorv32/sw/common/common.mk
