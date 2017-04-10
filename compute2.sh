echo y | yum install libtool openssl-devel libxml2-devel boost-devel gcc gcc-c++
# echo y | yum install git
# git clone https://github.com/adaptivecomputing/torque.git -b 6.0.1 6.0.1
# cd 6.0.1
# ./autogen.sh
# ./configure
# make
# make install
#
# echo "/usr/local/lib" > /etc/ld.so.conf.d/torque.conf
# ldconfig
#
# hostname > /var/spool/torque/server_priv/nodes
# hostname >> /var/spool/torque/server_priv/nodes
# hostname >> /var/spool/torque/server_priv/nodes
# hostname >> /var/spool/torque/server_priv/nodes
# hostname >> /var/spool/torque/server_priv/nodes
# hostname >> /var/spool/torque/server_priv/nodes
#
# sed -i '0,/compute-2/s/compute-2/compute-1/' /etc/hosts
# sed -i '0,/compute-2/s/compute-2/head/' /etc/hosts
# sed -i '0,/compute-2/s/compute-2/compute-3/' /etc/hosts
# sed -i '0,/compute-2/s/compute-2/fat/' /etc/hosts
# sed -i '0,/compute-2/s/compute-2/scratch/' /etc/hosts

mkdir -p /var/nfs
mkdir -p /scratch
mount 192.168.0.1:/home /home
mount 192.168.0.1:/opt /opt
mount 192.168.0.6:/scratch /scratch
mount 192.168.0.1:/var/nfs /var/nfs

df -h
mount

hostname > /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts
hostname >> /etc/hosts

sed -i '0,/compute-2/s/compute-2/192.168.0.2 compute-1/' /etc/hosts
sed -i '0,/compute-2/s/compute-2/192.168.0.1 head/' /etc/hosts
sed -i '0,/compute-2/s/compute-2/192.168.0.4 compute-3/' /etc/hosts
sed -i '0,/compute-2/s/compute-2/192.168.0.5 fat/' /etc/hosts
sed -i '0,/compute-2/s/compute-2/192.168.0.6 scratch/' /etc/hosts
sed -i '0,/compute-2/s/compute-2/192.168.0.3 compute-2/' /etc/hosts

# cp contrib/systemd/trqauthd.service /usr/lib/systemd/system/
# systemctl enable trqauthd.service
# systemctl start trqauthd.service
#
# echo y | ./torque.setup root
# qterm
#
# cp contrib/systemd/pbs_server.service /usr/lib/systemd/system/
# systemctl enable pbs_server.service
# systemctl start pbs_server.service
