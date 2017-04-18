cd /root

yum -y install nfs-utils
systemctl enable nfs-server.service
systemctl start nfs-server.service

mkdir /var/nfs
chown nfsnobody:nfsnobody /var/nfs
chmod 755 /var/nfs

echo "/home 192.168.0.2(rw,sync,no_root_squash,no_subtree_check)" > /etc/exports
echo "/home 192.168.0.3(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/home 192.168.0.4(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/home 192.168.0.5(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/home 192.168.0.6(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/opt 192.168.0.2(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/opt 192.168.0.3(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/opt 192.168.0.4(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/opt 192.168.0.5(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/opt 192.168.0.6(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
echo "/var/nfs 192.168.0.2(rw,sync,no_subtree_check)" >> /etc/exports
echo "/var/nfs 192.168.0.3(rw,sync,no_subtree_check)" >> /etc/exports
echo "/var/nfs 192.168.0.4(rw,sync,no_subtree_check)" >> /etc/exports
echo "/var/nfs 192.168.0.5(rw,sync,no_subtree_check)" >> /etc/exports
echo "/var/nfs 192.168.0.6(rw,sync,no_subtree_check)" >> /etc/exports

exportfs -a


#yum install -y environment-modules
#tar -xzvf /users/ggettin/Project/modulefiles.tar.gz
#cp -r modulefiles  /opt/
#source ~/.bashrc
#module use /opt/modulefiles
