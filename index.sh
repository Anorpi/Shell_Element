#/bin/bash

#Get eth0's ip address
server_ip=`ifconfig eth0|grep 'inet addr'|awk '{print $2}'|cut -c6-`
echo $server_ip

#Get public ipv4 from public API
server_ip=`curl  -s http://ipecho.net/plain`

#Gennerate a password
client_pass=`< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-12};echo;`
echo $client_pass

#Check a package installed or not
Pythonsetuptools_Status=`yum list python-setuptools|grep "Error"`
if [ "$Pythonsetuptools_Status" != "" ] ;then
        echo "Installing python-setuptools"
        yum -y install python-setuptools > /dev/null 2>&1
else
        echo "Python-setuptools:ok"
fi

#Check a command existed or  not
qrencode --version > /dev/null 2>&1
if [ $? != 0 ]; then
        echo "Installing qrencode"
        yum -y install qrencode > /dev/null 2>&1
else
        echo "qrencode:ok"
fi

#Check user account,must be root
user_name=`whoami`
if [ "$user_name" != "root" ]; then
        echo "Suggest use root account to run this script,exit"
        exit
fi

# Check support Centos 6.x
Support_OS=`cat /etc/issue|grep -E 6\.[0-9]`
if [ "$Support_OS" != "" ] ;then
        echo "System version:ok"
else
        echo "System Not Support,Centos 6.x"
        exit
fi

#Get a timestamp
 ##methmod1
time_stamp_1=`date +%Y%m%d%H%M%S`
 ##methmod2
time_stamp_2=`date +%s`

#Backup file with a timestamp
time_stamp=`date +%Y%m%d%H%M%S`
if [ -f /etc/shadowsocks.json ] ; then
        echo "/etc/shadowsocks.json file exits,rename to shadowsocks.json.bak${time_stamp}"
        mv /etc/shadowsocks.json /etc/shadowsocks.json.bak${time_stamp}
fi

#Allow a tcp port,eg:allow 8388 port can access.
iptables -I INPUT -p tcp --dport 8388 -j ACCEPT

#Check a command execute succeed
service nginx status 
if [ "$?" != "0" ]; then
        echo  "command execute failed."
        exit
else
        echo  "execute success."
fi

#Generate a config file
client_password="sjHF2Assk623"
echo  "{">/etc/shadowsocks.json
echo "    \"server\":\"0.0.0.0\",">>/etc/shadowsocks.json
echo "    \"server_port\":8388,">>/etc/shadowsocks.json
echo "    \"local_address\": \"127.0.0.1\",">>/etc/shadowsocks.json
echo "    \"local_port\":1080,">>/etc/shadowsocks.json
echo "    \"password\":\"$client_password\",">>/etc/shadowsocks.json
echo "    \"timeout\":300,">>/etc/shadowsocks.json
echo "    \"method\":\"aes-256-cfb\",">>/etc/shadowsocks.json
echo "    \"fast_open\": false">>/etc/shadowsocks.json
echo  "}">>/etc/shadowsocks.json

#Base64 encryption 
 ##methmod1:a string
client_base64_1=`echo "thisastring"|base64`
 ##methmod2:use variable
var="string"
client_base64_2=`echo "thisa${var}"|base64`

#Output shadowsocks client QR image,need install qrencode:'yum -y install qrencode'
client_base64=`echo "aes-256-cfb:$client_password@$server_ip:8388"|base64`
echo "ss://$client_base64"| qrencode -o - -t UTF8

#Delete .gz backup files
file_type=gz
file_num=4
old_list=`ls -t $PWD/*.$file_type 2>/dev/null|tail -n +$file_num`
if [ -z "$old_list" ];then
        exit;
else
        rm -rf $old_list
fi

#Selecte pid to kill
pidlists=`ps aux|grep -E "hf_sh*|hf_bri*|hf_lo*|hf_noti*"|awk '{print $2}'`
kill -9 $pidlist

#Loop modify file
for j in {5..24}
do
        echo chean shooter${j}
        #cp  -rf  ./shooter${j}/log ./bak
done

#Loop modify file  
a=(bridge  bridge1 logon noticer fruiter)
for i in ${a[*]}
do
        echo clean $i
        #cp -rf  ./${i}/log ./bak
done



#Touch a new test.txt file with some line.
cat <<EOF>test.txt
#one line
#two line
servername 8.8.8.8
EOF

#another example,append line in text.txt file
cat <<EOF>>test.txt
#just append a new line
EOF
