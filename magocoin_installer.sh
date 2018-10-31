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
$SUDO apt-get install autoconf
$SUDO apt-get -y install build-essential libtool automake autoconf autotools-dev autoconf pkg-config libssl-dev libgmp3-dev libevent-dev bsdmainutils libboost-all-dev libzmq3-dev libminiupnpc-dev libdb4.8-dev libdb4.8++-dev
$SUDO apt-get -y update
$SUDO iptables -I INPUT -p tcp --dport 32123 -j ACCEPT
$SUDO iptables -I INPUT -p udp --dport 32123 -j ACCEPT

echo "Done installing";
YOURIP=$(curl -s4 api.ipify.org)
PSS=$(pwgen -1 20 -n)

cd $HOME
echo "Getting fundamental client";
git clone https://github.com/FDM-DEV/fundamental.git
cd fundamental
chmod +x autogen.sh
chmod +x share/genbuild.sh
./autogen.sh
./configure --disable-tests --disable-gui-tests
make
$SUDO make install

echo ${GREEN}"In order to proceed with the installation, ${RED}please paste Masternode genkey by clicking right mouse button. Once masternode genkey is visible in the terminal please hit ENTER.";
read MNKEY

mkdir $HOME/.fundamental

echo "rpcuser=user"                   > /$HOME/.fundamental/fundamental.conf
echo "rpcpassword=$PSS"              >> /$HOME/.fundamental/fundamental.conf
echo "rpcallowip=127.0.0.1"          >> /$HOME/.fundamental/fundamental.conf
echo "maxconnections=500"            >> /$HOME/.fundamental/fundamental.conf
echo "daemon=1"                      >> /$HOME/.fundamental/fundamental.conf
echo "server=1"                      >> /$HOME/.fundamental/fundamental.conf
echo "listen=1"                      >> /$HOME/.fundamental/fundamental.conf
echo "rpcport=32122"                 >> /$HOME/.fundamental/fundamental.conf
echo "externalip=$YOURIP:32123"      >> /$HOME/.fundamental/fundamental.conf
echo "masternodeprivkey=$MNKEY"      >> /$HOME/.fundamental/fundamental.conf
echo "masternode=1"                  >> /$HOME/.fundamental/fundamental.conf
echo " "                             >> /$HOME/.fundamental/fundamental.conf
echo "addnode=35.231.22.84:32123"   >> /$HOME/.fundamental/fundamental.conf
echo "addnode=35.196.232.0:32123"    >> /$HOME/.fundamentalfundamental.conf
echo "addnode=45.77.154.184:32123" >> /$HOME/.fundamental/fundamental.conf
echo "addnode=144.202.122.39:32123" >> /$HOME/.fundamental/fundamental.conf
echo "addnode=178.128.179.143:32123" >> /$HOME/.fundamental/fundamental.conf
echo "addnode=104.248.236.126:32123" >> /$HOME/.fundamental/fundamental.conf
echo "addnode=68.183.107.253:32123" >> /$HOME/.fundamental/fundamental.conf
echo "addnode=68.183.103.1604:32123" >> /$HOME/.fundamental/fundamental.conf
echo "addnode=68.183.107.254:32123" >> /$HOME/.fundamental/fundamental.conf
echo "addnode=144.202.72.255:32123" >> /$HOME/.fundamental/fundamental.conf
echo "addnode=45.32.220.255:32123" >> /$HOME/.fundamental/fundamental.conf


echo "Starting fundamental client";
fundamentald --daemon
sleep 5
echo "Syncing...";
until fundamental-cli mnsync status | grep -m 1 '"IsBlockchainSynced" : true'; do sleep 1 ; done > /dev/null 2>&1
echo "Sync complete. You masternode is running!! you can start your masternode later with: fundamentald --daemon";
echo "You can stop your masternode with: hfundamental-cli stop"
