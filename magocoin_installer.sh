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
echo "addnode=104.248.25.183:22123" >> /$HOME/.FDM/FDM.conf
echo "addnode=142.93.99.196:22123" >> /$HOME/.FDM/FDM.conf
echo "addnode=165.227.105.10:22123" >> /$HOME/.FDM/FDM.conf
echo "addnode=209.97.153.36:22123" >> /$HOME/.FDM/FDM.conf
echo "addnode=142.93.99.196:22123" >> /$HOME/.FDM/FDM.conf
echo "addnode=167.99.168.8:22123" >> /$HOME/.FDM/FDM.conf
echo "addnode=138.197.14.77:22123" >> /$HOME/.FDM/FDM.conf
echo "addnode=206.189.180.208:22123" >> /$HOME/.FDM/FDM.conf
echo "whitelist=104.248.25.183" >> /$HOME/.FDM/FDM.conf
echo "whitelist=142.93.99.196" >> /$HOME/.FDM/FDM.conf
echo "awhitelist=165.227.105.10" >> /$HOME/.FDM/FDM.conf
echo "whitelist=209.97.153.36" >> /$HOME/.FDM/FDM.conf
echo "whitelist=142.93.99.196" >> /$HOME/.FDM/FDM.conf
echo "whitelist=167.99.168.8" >> /$HOME/.FDM/FDM.conf
echo "whitelist=138.197.14.77" >> /$HOME/.FDM/FDM.conf
echo "whitelist=206.189.180.208" >> /$HOME/.FDM/FDM.conf

echo "Starting fundamental client";
FDMd --daemon -server
sleep 5
echo "Syncing...";
until FDM-cli mnsync status | grep -m 1 '"IsBlockchainSynced" : true'; do sleep 1 ; done > /dev/null 2>&1
echo "Sync complete. You masternode is running!! you can start your masternode later with: FDMd --daemon";
echo "You can stop your masternode with: FDM-cli stop Y APRENDETE LOS COMANDOS VIEJO PUTO"
