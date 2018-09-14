#Swap part
$SUDO dd if=/dev/zero of=/mnt/myswap.swap bs=1M count=4000
$SUDO mkswap /mnt/myswap.swap
$SUDO chmod 0600 /mnt/myswap.swap
$SUDO swapon /mnt/myswap.swap

$SUDO add-apt-repository ppa:bitcoin/bitcoin -y
$SUDO apt-get -y update
$SUDO apt-get -y upgrade
$SUDO apt-get -y dist-upgrade
$SUDO apt-get -y install git curl nano wget pwgen
$SUDO apt-get -y install build-essential libtool automake autoconf autotools-dev autoconf pkg-config libssl-dev libgmp3-dev libevent-dev bsdmainutils libboost-all-dev libzmq3-dev libminiupnpc-dev libdb4.8-dev libdb4.8++-dev
$SUDO apt-get -y update

echo "Done installing";
YOURIP=$(curl -s4 api.ipify.org)
PSS=$(pwgen -1 20 -n)

cd $HOME
echo "Getting magocoin client";
git clone https://github.com/magocoin/magocoin.git
cd magocoin
chmod +x autogen.sh
chmod +x share/genbuild.sh
./autogen.sh
./configure --disable-tests --disable-gui-tests
make
$SUDO make install

echo "In order to proceed with the installation, please paste Masternode genkey by clicking right mouse button. Once masternode genkey is visible in the terminal please hit ENTER.";
read MNKEY

mkdir $HOME/.magocoin

echo "rpcuser=user"                   > /$HOME/.magocoin/magocoin.conf
echo "rpcpassword=$PSS"              >> /$HOME/.magocoin/magocoin.conf
echo "rpcallowip=127.0.0.1"          >> /$HOME/.magocoin/magocoin.conf
echo "maxconnections=500"            >> /$HOME/.magocoin/magocoin.conf
echo "daemon=1"                      >> /$HOME/.magocoin/magocoin.conf
echo "server=1"                      >> /$HOME/.magocoin/magocoin.conf
echo "listen=1"                      >> /$HOME/.magocoin/magocoin.conf
echo "rpcport=22122"                 >> /$HOME/.magocoin/magocoin.conf
echo "externalip=$YOURIP:22123"      >> /$HOME/.magocoin/magocoin.conf
echo "masternodeprivkey=$MNKEY"      >> /$HOME/.magocoin/magocoin.conf
echo "masternode=1"                  >> /$HOME/.magocoin/magocoin.conf
echo " "                             >> /$HOME/.magocoin/magocoin.conf
echo "addnode=149.28.64.95:22123"   >> /$HOME/.magocoin/magocoin.conf
echo "addnode=149.28.98.168:22123"    >> /$HOME/.magocoin/magocoin.conf
echo "addnode=45.76.70.100:22123" >> /$HOME/.magocoin/magocoin.conf


echo "Starting magocoin client";
magocoind --daemon
sleep 5
echo "Syncing...";
until magocoin-cli mnsync status | grep -m 1 '"IsSynced": true'; do sleep 1 ; done > /dev/null 2>&1
echo "Sync complete. You masternode is running!! you can start your masternode later with: magocoind --daemon";111
echo "You can stop your masternode with: magocoin-cli stop"
