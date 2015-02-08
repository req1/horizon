#!/bin/bash
cd 
mkdir horizon
cd horizon
apt-get update
apt-get upgrade -y
apt-get install -y jq
apt-get install -y unzip
apt-get install -y curl
apt-get install -y openjdk-8-jre
wget http://files.nhzcrypto.org/binaries/hz_v3.8.zip
unzip hz*.zip 
cd hz
IP=$(wget -qO- ifconfig.me/ip)
sed -i s/nhz.myAddress=/nhz.myAddress=$IP/g /root/horizon/hz/conf/nhz-default.properties
chmod +x run.sh
screen -d -m -S hallmarked ./run.sh
echo "WAIT FOR WALLET UP (30 Second)"
echo -ne '[                                     ](0%)\r'
sleep 2
echo -ne '[==>                                  ](5%)\r'
sleep 2
echo -ne '[=====>                               ](10%)\r'
sleep 2
echo -ne '[========>                            ](15%)\r'
sleep 2
echo -ne '[=========>                           ](20%)\r'
sleep 2
echo -ne '[===========>                         ](25%)\r'
sleep 2
echo -ne '[=============>                       ](30%)\r'
sleep 2
echo -ne '[===============>                     ](33%)\r'
sleep 2
echo -ne '[=================>                   ](47%)\r'
sleep 2
echo -ne '[===================>                 ](60%)\r'
sleep 2
echo -ne '[=====================>               ](70%)\r'
sleep 2
echo -ne '[=======================>             ](75%)\r'
sleep 2
echo -ne '[===========================>         ](80%)\r'
sleep 2
echo -ne '[================================>    ](87%)\r'
sleep 2
echo -ne '[==================================>  ](96%)\r'
sleep 2
echo -ne '[=====================================](100%)\r'
echo -ne '\n'
echo "DONE"
sleep 2

TGL=$(date +%Y-%m-%d)
CODE=$(curl -d requestType="markHost" -d host="$IP" -d weight="100" -d date="$TGL" -d secretPhrase="$1" http://127.0.0.1:7776/nhz | jq -r '.hallmark')
sed -i s/nhz.myHallmark=/nhz.myHallmark=$CODE/g /root/horizon/hz/conf/nhz-default.properties
sleep 2
screen -S hallmarked -X quit
iptables -A INPUT -p tcp -d 0/0 -s 0/0 --dport 7774 -j ACCEPT
touch /etc/init.d/auto.sh
echo "#!/bin/bash
iptables -A INPUT -p tcp -d 0/0 -s 0/0 --dport 7774 -j ACCEPT
cd /root/horizon/hz/
screen -d -m -S hallmark ./run.sh"> '/etc/init.d/auto.sh'
chmod +x /etc/init.d/auto.sh
update-rc.d auto.sh defaults
history -c
reboot
exit 0
