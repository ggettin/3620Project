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

sed -i '0,/compute-3/s/compute-3/compute-1/'
sed -i '0,/compute-3/s/compute-3/compute-2/'
sed -i '0,/compute-3/s/compute-3/head/'
sed -i '0,/compute-3/s/compute-3/fat/'
sed -i '0,/compute-3/s/compute-3/scratch/'

hostname > /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts

sed -i '0,/compute-3/s/compute-3/192.168.0.2 compute-1/'
sed -i '0,/compute-3/s/compute-3/192.168.0.3 compute-2/'
sed -i '0,/compute-3/s/compute-3/192.168.0.1 head/'
sed -i '0,/compute-3/s/compute-3/192.168.0.5 fat/'
sed -i '0,/compute-3/s/compute-3/192.168.0.6 scratch/'
sed -i '0,/compute-3/s/compute-3/192.168.0.4 compute-3/'

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
mount 192.168.0.6:/scratch /scratch
mount 192.168.0.1:/var/nfs /var/nfs
df -h
mount
