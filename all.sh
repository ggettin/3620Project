sudo su

tar -zxvf tcl8.5.19-src.tar.gz
cd tcl8.5.19/unix
./configure --prefix=/usr/local/tcl --enable-threads
make && make install

#(cd back to Project)
cd /Project

yum -y install libX11-devel

tar -zxvf tk8.5.19-src.tar.gz
cd tk8.5.19/unix
./configure --prefix=/usr/local/tk --with-tcl=/usr/local/tcl/lib
make && make install
echo "/usr/local/tcl/lib" >> /etc/ld.so.conf.d/tclx-x86_64.conf
echo "/usr/local/tk/lib" >> /etc/ld.so.conf.d/tclx-x86_64.conf
/sbin/ldconfig

#(cd back to Project)
cd /Project

tar -zxvf modules3.2.10.tar.gz
cd modules-3.2.10
./configure --with-module-path=/opt/modulefiles
make && make install

#vi /usr/local/Modules/3.2.10/init/.modulespath

sed -i 's/#//' /usr/local/Modules/3.2.10/init/.modulespath
sed -i 's/^/#/' /usr/local/Modules/3.2.10/init/.modulespath
sed -i 's/#\/opt\//\/opt\//' /usr/local/Modules/3.2.10/init/.modulespath

#Code below must be created at /etc/profile.d/modules.sh

echo '#----------------------------------------------------------------------#' > /etc/profile.d/modules.sh
echo '# system-wide profile.modules                                          #' >> /etc/profile.d/modules.sh
echo '# Initialize modules for all sh-derivative shells                      #' >> /etc/profile.d/modules.sh
echo '#----------------------------------------------------------------------#' >> /etc/profile.d/modules.sh
echo 'trap "" 1 2 3' >> /etc/profile.d/modules.sh
echo 'case "$0" in' >> /etc/profile.d/modules.sh
echo '-bash|bash|*/bash) . /usr/local/Modules/default/init/bash ;;' >> /etc/profile.d/modules.sh
echo '-ksh|ksh|*/ksh) . /usr/local/Modules/default/init/ksh ;;' >> /etc/profile.d/modules.sh
echo '-zsh|zsh|*/zsh) . /usr/local/Modules/default/init/zsh ;;' >> /etc/profile.d/modules.sh
echo '*) . /usr/local/Modules/default/init/sh ;; # sh and default for scripts' >> /etc/profile.d/modules.sh
echo 'esac' >> /etc/profile.d/modules.sh
echo 'trap 1 2 3' >> /etc/profile.d/modules.sh

cd /Project

mkdir /opt/software/
mkdir /opt/software/gmp
mkdir /opt/software/mpc
mkdir /opt/software/mpfr
mkdir /opt/software/gcc
mkdir /opt/software/openmpi

#(gmp)
tar -zxvf gmp-4.3.2.tar.gz
cd gmp-4.3.2
./configure --prefix=/opt/software/gmp
make && make install

cd /Project

#(mpfr)
tar -zxvf mpfr-2.4.2.tar.gz
cd mpfr-2.4.2
./configure --prefix=/opt/software/mpfr --with-gmp=/opt/software/gmp
make && make install

cd /Project

#(mpc)
tar -zxvf mpc-0.8.1.tar.gz
cd mpc-0.8.1
./configure --prefix=/opt/software/mpc --with-gmp=/opt/software/gmp --with-mpfr=/opt/software/mpfr
make && make install

cd /Project

#(gcc)
wget http://mirrors-usa.go-parts.com/gcc/releases/gcc-5.3.0/gcc-5.3.0.tar.gz

./configure --prefix=/opt/software/mpc --with-gmp=/opt/software/gmp --with-mpfr=/opt/software/mpfr --with-mpc=/opt/software/mpc --enable-multilib

mkdir /opt/modulefiles/

cp /Project/ourmodulefiles/* /opt/modulefiles

