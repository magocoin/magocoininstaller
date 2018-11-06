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
$SUDO iptables -I INPUT -p tcp --dport 22123 -j ACCEPT
$SUDO iptables -I INPUT -p udp --dport 22123 -j ACCEPT

echo "Done installing";
YOURIP=$(curl -s4 api.ipify.org)
PSS=$(pwgen -1 20 -n)

cd $HOME
echo "Getting fundamental client";
git clone https://github.com/FDM-DEV/FDM.git
cd FDM
chmod +x autogen.sh
chmod +x share/genbuild.sh
./autogen.sh
./configure --disable-tests --disable-gui-tests
make
$SUDO make install


mkdir $HOME/.FDM

echo "rpcuser=user"                   > /$HOME/.FDM/FDM.conf
echo "rpcpassword=$PSS"              >> /$HOME/.FDM/FDM.conf
echo "rpcallowip=127.0.0.1"          >> /$HOME/.FDM/FDM.conf
echo "maxconnections=500"            >> /$HOME/.FDM/FDM.conf
echo "daemon=1"                      >> /$HOME/.FDM/FDM.conf
echo "server=1"                      >> /$HOME/.FDM/FDM.conf
echo "listen=1"                      >> /$HOME/.FDM/FDM.conf
echo "rpcport=22122"                 >> /$HOME/.FDM/FDM.conf
echo "externalip=$YOURIP:22123"      >> /$HOME/.FDM/FDM.conf
echo " "                             >> /$HOME/.FDM/FDM.conf
echo "addnode=35.231.22.84:22123"   >> /$HOME/.FDM/FDM.conf
echo "addnode=35.196.232.0:22123"    >> /$HOME/.FDM/FDM.conf
echo "addnode=45.77.154.184:22123" >> /$HOME/.FDM/FDM.conf
echo "addnode=144.202.122.39:22123" >> /$HOME/.FDM/FDM.conf
echo "addnode=178.128.179.143:22123" >> /$HOME/.FDM/FDM.conf
echo "addnode=104.248.236.126:22123" >> /$HOME/.FDM/FDM.conf
echo "addnode=68.183.107.253:22123" >> /$HOME/.FDM/FDM.conf
echo "addnode=68.183.103.1604:22123" >> /$HOME/.FDM/FDM.conf
echo "addnode=68.183.107.254:22123" >> /$HOME/.FDM/FDM.conf
echo "addnode=144.202.72.255:22123" >> /$HOME/.FDM/FDM.conf
echo "addnode=45.32.220.255:22123" >> /$HOME/.FDM/FDM.conf


echo "Starting fundamental client";
FDMd --daemon -server
sleep 5
echo "Syncing...";
until FDM-cli mnsync status | grep -m 1 '"IsBlockchainSynced" : true'; do sleep 1 ; done > /dev/null 2>&1
echo "Sync complete. You masternode is running!! you can start your masternode later with: FDMd --daemon";
echo "You can stop your masternode with: FDM-cli stop Y APRENDETE LOS COMANDOS VIEJO PUTO"
