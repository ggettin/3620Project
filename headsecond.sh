cd /root

mkdir -p /scratch
mount 192.168.0.6:/scratch /scratch

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

sshpass -p af4eac0f8b5e scp -o StrictHostKeyChecking=no torque-package-mom-linux-x86_64.sh 192.168.0.2:
sshpass -p af4eac0f8b5e scp torque-package-clients-linux-x86_64.sh 192.168.0.2:

sshpass -p 3c951c2f6025 scp -o StrictHostKeyChecking=no torque-package-mom-linux-x86_64.sh 192.168.0.3:
sshpass -p 3c951c2f6025 scp torque-package-clients-linux-x86_64.sh 192.168.0.3:

sshpass -p e5bbddc0d406 scp -o StrictHostKeyChecking=no torque-package-mom-linux-x86_64.sh 192.168.0.4:
sshpass -p e5bbddc0d406 scp torque-package-clients-linux-x86_64.sh 192.168.0.4:

sshpass -p e9dad3b28f24 scp -o StrictHostKeyChecking=no torque-package-mom-linux-x86_64.sh 192.168.0.5:
sshpass -p e9dad3b28f24 scp torque-package-clients-linux-x86_64.sh 192.168.0.5:

sshpass -p ec6ac153a8df scp -o StrictHostKeyChecking=no torque-package-mom-linux-x86_64.sh 192.168.0.6:
sshpass -p ec6ac153a8df scp torque-package-clients-linux-x86_64.sh 192.168.0.6:

sshpass -p af4eac0f8b5e scp contrib/systemd/pbs_mom.service 192.168.0.2:/usr/lib/systemd/system/
sshpass -p 3c951c2f6025 scp contrib/systemd/pbs_mom.service 192.168.0.3:/usr/lib/systemd/system/
sshpass -p e5bbddc0d406 scp contrib/systemd/pbs_mom.service 192.168.0.4:/usr/lib/systemd/system/
sshpass -p e9dad3b28f24 scp contrib/systemd/pbs_mom.service 192.168.0.5:/usr/lib/systemd/system/
sshpass -p ec6ac153a8df scp contrib/systemd/pbs_mom.service 192.168.0.6:/usr/lib/systemd/system/

sshpass -p af4eac0f8b5e ssh root@192.168.0.2 -t './torque-package-mom-linux-x86_64.sh --install; ./torque-package-clients-linux-x86_64.sh --install; ldconfig; systemctl enable pbs_mom.service; systemctl start pbs_mom.service'

sshpass -p 3c951c2f6025 ssh root@192.168.0.3 -t './torque-package-mom-linux-x86_64.sh --install; ./torque-package-clients-linux-x86_64.sh --install; ldconfig; systemctl enable pbs_mom.service; systemctl start pbs_mom.service'

sshpass -p e5bbddc0d406 ssh root@192.168.0.4 -t './torque-package-mom-linux-x86_64.sh --install; ./torque-package-clients-linux-x86_64.sh --install; ldconfig; systemctl enable pbs_mom.service; systemctl start pbs_mom.service'

sshpass -p e9dad3b28f24 ssh root@192.168.0.5 -t './torque-package-mom-linux-x86_64.sh --install; ./torque-package-clients-linux-x86_64.sh --install; ldconfig; systemctl enable pbs_mom.service; systemctl start pbs_mom.service'

sshpass -p ec6ac153a8df ssh root@192.168.0.6 -t './torque-package-mom-linux-x86_64.sh --install; ./torque-package-clients-linux-x86_64.sh --install; ldconfig; systemctl enable pbs_mom.service; systemctl start pbs_mom.service'

# yum -y install environment-modules
