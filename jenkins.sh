#!/bin/bash

echo "updating..."
sudo yum update -y

echo "upgrading..."
sudo yum upgrade -y

echo "installing gfortran..."
sudo yum install gcc-gfortran -y

echo "installing git"
sudo yum install git -y

echo "installing mysql"
sudo yum install -y wget
wget https://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
sudo yum install -y mysql57-community-release-el7-8.noarch.rpm
sudo yum -y update
sudo yum -y install mysql-server
sudo systemctl start mysqld
sudo systemctl enable mysqld
MYSQL_TEMP_PWD=`sudo cat /var/log/mysqld.log | grep 'A temporary password is generated' | awk -F'root@localhost: ' '{print $2}'`
mysqladmin -u root -p`echo $MYSQL_TEMP_PWD` password 'Passw0rd!'
cat << EOF > .my.cnf
[client]
user=root
password=Passw0rd!
EOF

echo "installing java 11 jdk..."
sudo yum install java-11-openjdk-devel -y

echo "installing unzip..."
sudo yum install unzip -y

echo "installing gradle..."
wget https://services.gradle.org/distributions/gradle-4.8.1-bin.zip
mkdir /opt/gradle
unzip -d /opt/gradle gradle-4.8.1-bin.zip
export PATH=$PATH:/opt/gradle/gradle-4.8.1/bin

echo "CD into ~"
cd ~

echo "installing gitlab server key..."
touch .ssh/known_hosts
ssh-keyscan gitlab.cs.cf.ac.uk >> .ssh/known_hosts
chmod 644 .ssh/known_hosts

echo "installing gitlab deployment key..."
touch gitlab_selfcubric_keypair.key
cat << `EOF` >> gitlab_selfcubric_keypair.key
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAyD0JKOnQOdV5amddQnr4S2LoM2bgHJUqETWf5Et+TZbk5gkk
f9ssh9hBVltaDigOzBECvIOOIuN/XMQfthvwaKJahYtp6mng+8NSfn2DwympVH6e
zq9YSDhcczx8ni0fC6t+r5g9iyYbIi+rBeFWFXRAEFg5erR2453ibIcs/FKTpOnK
y5G0SD44bMc39WakoBIbkqiOfEX6q0jwQE/IoRY6UR1YMQ8EA91pyayP/lR1wyY8
RZtX0wnDUsfe6uwUPE1yBwWtycycGsncFWgG0TcXT1/VgAtUD/SmufziAgrIhxxH
cYec0aNWChJ2Kq5Qm66UyycKJvlobioxvuGdUwIDAQABAoIBABeF7BSNWzPgGzJf
0DnmHlMk3GhldoCFGXsKFK2KHN1ak6teeZY3lkSjKBHQC4VMOWjJusuQnNsGZMju
FVeccqKoKAA2P4wVQiPxbziC4D7GHylY8qkPOkzJqjqzaWRfop0JWYmhVeGJ6Xgb
p3i6XxWIIZqJ8r6ygqD8xEPBoYxGpeVXxsaq9NGYpnAyCDGPXhdIzjXlltM3lBKj
CerrGNnnb4bEA0B8ezjtoUSlP2I/oF5eyVk2+2IYGXkrr5zyDcKOzrL02BR33P+O
FlCVe1EJ8rPXfdotXItSu87peCfmFiKZHkVTYsSg2kWuaxx5Z0S3pxeqr5Jjw1fv
G3Y875kCgYEA7bSbqSoO/ZWmvCcDogyBlBZBt0QFoopXubIHM3Ct3pM/nuJTYID6
O/QPtbBg4GJpKkFwMj9yQrb1abaBNtGRrDgHSyiGvZ5hnWARmQ9GVaJmZ77dXIcb
9j2pQLnGiJH/deeCAYLGsYj/0ubAqzbd100mp7oCrL4IUH2gCnvMYB0CgYEA16Y7
ksT/lqiRTLIDjDbIi/pWzzgh0SavzHRqQI2g7KXJQlixOmf37eNJBnPauyn3pNG1
QB+eq+8bpXr8g5GAFu4kqNJ5Yk9lwlTecDkcvbOC645xDyUvYlIiul7ebmgn2d21
C23iREvgbnim7CP6YPaEm3VNOPbYoS1GPdP6WC8CgYBjwSqeCE94Lghl532H0PXE
Hr7/WOWAe8wq2sJY3Q2qXWMSm2pgEmBxLpA1MErHf6UgnYunGqcpxjwhW/zH85TN
kEnHSb+Z7dCLSdi4wgdDQr71BM1C2lRqtx/DUPM3NwXdBgWx+p7FvHeXm0z5zTG1
++Of+djLg4hbtwyluaRgJQKBgDutLN841OIEU/E9ce3jWywhYtSFXBZc9llF/gFP
MDFMz50knibjjqCuPQ8kEGuq+XUK83WDSo2Z5bStjCN8qE2wKUTuudiS0D4u7j9w
DpwQiTJWgMMIL0yuHh4lErjK6fxIdklrZyovNTRc/xRqAGfE0H2UwIH7DYfM15tU
hfrRAoGAINXc9D42BmdVr/gaGHX2hIhvtk4jmrv1gWx8ZSNZVEkBucIaAmwGQ+ZK
V6HItA3OkU0HI/P2iTGBUps8TxMHxL10QJoRgnEx2mk1sJlhS/jc48kG6Lgdh8tP
1RF7VyIr92w9GOwSXV/SB/kxm0fAX0CtJbEY6CI5NTBd3OtufXI=
-----END RSA PRIVATE KEY-----
`EOF`
chmod 400 gitlab_selfcubric_keypair.key
sudo cp gitlab_selfcubric_keypair.key ../home/centos/

echo "installing gitlab ssh link..."
touch gitlab_ssh_link.txt
cat << `EOF` >> gitlab_ssh_link.txt
git@gitlab.cs.cf.ac.uk:c1722545/cubric.git
`EOF`
chmod 400 gitlab_ssh_link.txt
sudo cp gitlab_ssh_link.txt ../home/centos/

echo "creating instructions txt..."
touch instructions.txt
cat << `EOF` >> instructions.txt
BUILD SCRIPT
mysql -u root -pPassw0rd! < "sql scripts/database creation.sql"
/opt/gradle/gradle-4.8.1/bin/gradle clean
/opt/gradle/gradle-4.8.1/bin/gradle build

CHECKSTYLE PLUGIN
build/reports/checkstyle/*.xml

TEST PLUGIN
build/test-results/test/*.xml

POST BUILD SCRIPT
java -jar build/libs/*.jar
`EOF`
chmod 400 instructions.txt
sudo cp instructions.txt ../home/centos/


echo 'Installing jenkins..'
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins

echo 'Running Jenkins'
sudo systemctl start jenkins.service
sudo systemctl enable jenkins.service

echo 'Jenkins Initial Password...'
cat /var/lib/jenkins/secrets/initialAdminPassword
