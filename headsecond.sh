cd /root

mkdir -p /scratch
mount 192.168.0.6:/scratch /scratch

headPass="88349650cae7"
compute1Pass="5701dcdd86d7"
compute2Pass="8d3efa89e083"
compute3Pass="d984550214f5"
fatPass="c960ae8b5cf4"
scratchPass="64c24bb2b1e9s"

df -h
mount

tar -xzvf /Project/job_events.tar.gz
mkdir /scratch/asg4
cp -r /Project/job_events /scratch/asg4/

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

sed -i '0,/head/s/head/compute-1/' /etc/hosts
sed -i '0,/head/s/head/compute-2/' /etc/hosts
sed -i '0,/head/s/head/compute-3/' /etc/hosts
sed -i '0,/head/s/head/fat/' /etc/hosts
sed -i '0,/head/s/head/scratch/' /etc/hosts

hostname > /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts

sed -i '0,/head/s/head/192.168.0.2 compute-1/' /etc/hosts
sed -i '0,/head/s/head/192.168.0.3 compute-2/' /etc/hosts
sed -i '0,/head/s/head/192.168.0.4 compute-3/' /etc/hosts
sed -i '0,/head/s/head/192.168.0.5 fat/' /etc/hosts
sed -i '0,/head/s/head/192.168.0.6 scratch/' /etc/hosts
sed -i '0,/head/s/head/192.168.0.1 head/' /etc/hosts

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

sshpass -p $compute1Pass scp -o StrictHostKeyChecking=no torque-package-mom-linux-x86_64.sh 192.168.0.2:
sshpass -p $compute1Pass scp torque-package-clients-linux-x86_64.sh 192.168.0.2:

sshpass -p $compute2Pass scp -o StrictHostKeyChecking=no torque-package-mom-linux-x86_64.sh 192.168.0.3:
sshpass -p $compute2Pass scp torque-package-clients-linux-x86_64.sh 192.168.0.3:

sshpass -p $compute3Pass scp -o StrictHostKeyChecking=no torque-package-mom-linux-x86_64.sh 192.168.0.4:
sshpass -p $compute3Pass scp torque-package-clients-linux-x86_64.sh 192.168.0.4:

sshpass -p $fatPass scp -o StrictHostKeyChecking=no torque-package-mom-linux-x86_64.sh 192.168.0.5:
sshpass -p $fatPass scp torque-package-clients-linux-x86_64.sh 192.168.0.5:

sshpass -p $scratchPass scp -o StrictHostKeyChecking=no torque-package-mom-linux-x86_64.sh 192.168.0.6:
sshpass -p $scratchPass scp torque-package-clients-linux-x86_64.sh 192.168.0.6:

sshpass -p $compute1Pass scp contrib/systemd/pbs_mom.service 192.168.0.2:/usr/lib/systemd/system/
sshpass -p $compute2Pass scp contrib/systemd/pbs_mom.service 192.168.0.3:/usr/lib/systemd/system/
sshpass -p $compute3Pass scp contrib/systemd/pbs_mom.service 192.168.0.4:/usr/lib/systemd/system/
sshpass -p $fatPass scp contrib/systemd/pbs_mom.service 192.168.0.5:/usr/lib/systemd/system/
sshpass -p $scratchPass scp contrib/systemd/pbs_mom.service 192.168.0.6:/usr/lib/systemd/system/

sshpass -p $compute1Pass ssh root@192.168.0.2 -t './torque-package-mom-linux-x86_64.sh --install; ./torque-package-clients-linux-x86_64.sh --install; ldconfig; systemctl enable pbs_mom.service; systemctl start pbs_mom.service'

sshpass -p $compute2Pass ssh root@192.168.0.3 -t './torque-package-mom-linux-x86_64.sh --install; ./torque-package-clients-linux-x86_64.sh --install; ldconfig; systemctl enable pbs_mom.service; systemctl start pbs_mom.service'

sshpass -p $compute3Pass ssh root@192.168.0.4 -t './torque-package-mom-linux-x86_64.sh --install; ./torque-package-clients-linux-x86_64.sh --install; ldconfig; systemctl enable pbs_mom.service; systemctl start pbs_mom.service'

sshpass -p $fatPass ssh root@192.168.0.5 -t './torque-package-mom-linux-x86_64.sh --install; ./torque-package-clients-linux-x86_64.sh --install; ldconfig; systemctl enable pbs_mom.service; systemctl start pbs_mom.service'

sshpass -p $scratchPass ssh root@192.168.0.6 -t './torque-package-mom-linux-x86_64.sh --install; ./torque-package-clients-linux-x86_64.sh --install; ldconfig; systemctl enable pbs_mom.service; systemctl start pbs_mom.service'

# yum -y install environment-modules
