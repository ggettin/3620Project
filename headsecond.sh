mkdir -p /scratch
mount 192.168.0.6:/scratch /scratch

df -h
mount

echo y | yum install libtool openssl-devel libxml2-devel boost-devel gcc gcc-c++
echo y | yum install git
git clone https://github.com/adaptivecomputing/torque.git -b 6.0.1 6.0.1
cd 6.0.1
./autogen.sh
./configure
make
make install

echo "/usr/local/lib" > /etc/ld.so.conf.d/torque.conf
ldconfig

hostname > /var/spool/torque/server_priv/nodes
hostname >> /var/spool/torque/server_priv/nodes
hostname >> /var/spool/torque/server_priv/nodes
hostname >> /var/spool/torque/server_priv/nodes
hostname >> /var/spool/torque/server_priv/nodes
hostname >> /var/spool/torque/server_priv/nodes

sed -i '0,/head/s/head/compute-1/'
sed -i '0,/head/s/head/compute-2/'
sed -i '0,/head/s/head/compute-3/'
sed -i '0,/head/s/head/fat/'
sed -i '0,/head/s/head/scratch/'

hostname > /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts

sed -i '0,/head/s/head/192.168.0.2 compute-1/'
sed -i '0,/head/s/head/192.168.0.3 compute-2/'
sed -i '0,/head/s/head/192.168.0.4 compute-3/'
sed -i '0,/head/s/head/192.168.0.5 fat/'
sed -i '0,/head/s/head/192.168.0.6 scratch/'
sed -i '0,/head/s/head/192.168.0.1 head/'

cp contrib/systemd/trqauthd.service /usr/lib/systemd/system/
systemctl enable trqauthd.service
systemctl start trqauthd.service

echo y | ./torque.setup root
qterm

cp contrib/systemd/pbs_server.service /usr/lib/systemd/system/
systemctl enable pbs_server.service
systemctl start pbs_server.service

make packages

yum -y install epel-release
yum -y install sshpass

sshpass -p 65909d1bb725 scp -o StrictHostKeyChecking=no torque-package-mom-linux-x86_64.sh 192.168.0.2:
sshpass -p 65909d1bb725 scp torque-package-clients-linux-x86_64.sh 192.168.0.2:

sshpass -p eec83c091433 scp -o StrictHostKeyChecking=no torque-package-mom-linux-x86_64.sh 192.168.0.3:
sshpass -p eec83c091433 scp torque-package-clients-linux-x86_64.sh 192.168.0.3:

sshpass -p c08ac2b94af8 scp -o StrictHostKeyChecking=no torque-package-mom-linux-x86_64.sh 192.168.0.4:
sshpass -p c08ac2b94af8 scp torque-package-clients-linux-x86_64.sh 192.168.0.4:

sshpass -p cda80dc56065 scp -o StrictHostKeyChecking=no torque-package-mom-linux-x86_64.sh 192.168.0.5:
sshpass -p cda80dc56065 scp torque-package-clients-linux-x86_64.sh 192.168.0.5:

sshpass -p 1f72fd948cab scp -o StrictHostKeyChecking=no torque-package-mom-linux-x86_64.sh 192.168.0.6:
sshpass -p 1f72fd948cab scp torque-package-clients-linux-x86_64.sh 192.168.0.6:

sshpass -p 65909d1bb725 scp contrib/systemd/pbs_mom.service 192.168.0.2:/usr/lib/systemd/system/
sshpass -p eec83c091433 scp contrib/systemd/pbs_mom.service 192.168.0.3:/usr/lib/systemd/system/
sshpass -p c08ac2b94af8 scp contrib/systemd/pbs_mom.service 192.168.0.4:/usr/lib/systemd/system/
sshpass -p cda80dc56065 scp contrib/systemd/pbs_mom.service 192.168.0.5:/usr/lib/systemd/system/
sshpass -p 1f72fd948cab scp contrib/systemd/pbs_mom.service 192.168.0.6:/usr/lib/systemd/system/

sshpass -p 65909d1bb725 ssh root@192.168.0.2 -t './torque-package-mom-linux-x86_64.sh --install; ./torque-package-clients-linux-x86_64.sh --install; ldconfig; systemctl enable pbs_mom.service; systemctl start pbs_mom.service'

sshpass -p eec83c091433 ssh root@192.168.0.3 -t './torque-package-mom-linux-x86_64.sh --install; ./torque-package-clients-linux-x86_64.sh --install; ldconfig; systemctl enable pbs_mom.service; systemctl start pbs_mom.service'

sshpass -p c08ac2b94af8 ssh root@192.168.0.4 -t './torque-package-mom-linux-x86_64.sh --install; ./torque-package-clients-linux-x86_64.sh --install; ldconfig; systemctl enable pbs_mom.service; systemctl start pbs_mom.service'

sshpass -p cda80dc56065 ssh root@192.168.0.5 -t './torque-package-mom-linux-x86_64.sh --install; ./torque-package-clients-linux-x86_64.sh --install; ldconfig; systemctl enable pbs_mom.service; systemctl start pbs_mom.service'

sshpass -p 1f72fd948cab ssh root@192.168.0.6 -t './torque-package-mom-linux-x86_64.sh --install; ./torque-package-clients-linux-x86_64.sh --install; ldconfig; systemctl enable pbs_mom.service; systemctl start pbs_mom.service'

# yum -y install environment-modules
