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

sed -i '0,/scratch/s/scratch/compute-1/'
sed -i '0,/scratch/s/scratch/compute-2/'
sed -i '0,/scratch/s/scratch/compute-3/'
sed -i '0,/scratch/s/scratch/fat/'
sed -i '0,/scratch/s/scratch/head/'

hostname > /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts

sed -i '0,/scratch/s/scratch/192.168.0.2 compute-1/'
sed -i '0,/scratch/s/scratch/192.168.0.3 compute-2/'
sed -i '0,/scratch/s/scratch/192.168.0.4 compute-3/'
sed -i '0,/scratch/s/scratch/192.168.0.5 fat/'
sed -i '0,/scratch/s/scratch/192.168.0.1 head/'
sed -i '0,/scratch/s/scratch/192.168.0.6 scratch/'

cp contrib/systemd/trqauthd.service /usr/lib/systemd/system/
systemctl enable trqauthd.service
systemctl start trqauthd.service

echo y | ./torque.setup root
qterm

cp contrib/systemd/pbs_server.service /usr/lib/systemd/system/
systemctl enable pbs_server.service
systemctl start pbs_server.service

mkdir -p /var/nfs
mkdir -p /scratch
mount 192.168.0.1:/home /home
mount 192.168.0.1:/opt /opt

echo "/scratch 192.168.0.2(rw,sync,no_root_squash,no_subtree_check)" > /etc/exports
echo "/scratch 192.168.0.3(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/scratch 192.168.0.4(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/scratch 192.168.0.5(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/scratch 192.168.0.1(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports

mkdir /scratch
chown nfsnobody:nfsnobody /scratch
chmod 755 /scratch

df -h
mount
