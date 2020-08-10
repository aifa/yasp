#Update and install dependencies

sudo yum update -y
sudo yum install git gcc gcc-c++ tmux gmp-devel make tar wget zlib-devel libtool autoconf -y
sudo yum install systemd-devel ncurses-devel ncurses-compat-libs -y

#download and install cabal
wget https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz
tar -xf cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz
rm cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz cabal.sig
mkdir -p ~/.local/bin
mv cabal ~/.local/bin/

#Verify that .local/bin is in your PATH

echo $PATH
#If .local/bin is not in the PATH, you need to add the following line to your .bashrc file

echo export PATH="~/.local/bin:$PATH" >> ~/.bashrc
#and source the file
source .bashrc


#Update cabal

cabal update
#Confirm that you installed cabal version 3.2.0.0.
cabal --version

#ghc
wget https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-deb9-linux.tar.xz
tar -xf ghc-8.6.5-x86_64-deb9-linux.tar.xz
rm ghc-8.6.5-x86_64-deb9-linux.tar.xz
cd ghc-8.6.5
./configure
sudo make install

cd ..

#libsodium
git clone https://github.com/input-output-hk/libsodium
cd libsodium
git checkout 66f017f1
./autogen.sh
./configure
make
sudo make install

cd ..

# update bashrc
echo export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
echo export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH" >> ~/.bashrc

echo export NODE_HOME=$HOME/cnode >> ~/.bashrc
echo export NODE_CONFIG=mainnet>> ~/.bashrc
echo export NODE_URL=cardano-mainnet >> ~/.bashrc
echo export NODE_BUILD_NUM=$(curl https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html | grep -e "build" | sed 's/.*build\/\([0-9]*\)\/download.*/\1/g') >> ~/.bashrc
echo export NETWORK_IDENTIFIER=\"--mainnet\" >> ~/.bashrc

source ~/.bashrc

#download cardano
git clone https://github.com/input-output-hk/cardano-node.git
cd cardano-node
git fetch --all --tags
git checkout tags/1.18.0

cabal build all

sudo cp $(find ~/git/cardano-node/dist-newstyle/build -type f -name "cardano-cli") /usr/local/bin/cardano-cli
sudo cp $(find ~/git/cardano-node/dist-newstyle/build -type f -name "cardano-node") /usr/local/bin/cardano-node

cd ..
