setenforce 0
getenforce
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/selinux/config
yum update -y
yum  -y install epel-release
yum -y groupinstall "Development Tools"
yum -y install libedit-devel sqlite-devel psmisc gmime-devel ncurses-devel libtermcap-devel sox newt-devel libxml2-devel libtiff-devel audiofile-devel gtk2-devel uuid-devel libtool libuuid-devel subversion kernel-devel kernel-devel-$(uname -r) git kernel-devel crontabs cronie cronie-anacron expect

echo "PS1='\[\033[1;33m\]\u\[\033[1;31m\]@\[\033[1;34m\]\H:\[\033[1;35m\]\w\[\033[1;31m\]$\[\033[0m\] '" >> /etc/bashrc

yum -y install wget vim  net-tools htop
yum install -y mod_ssl libsrtp curl-devel
yum install -y libsrtp-devel
cd /usr/src/
git clone https://github.com/akheron/jansson.git
cd jansson
autoreconf  -i
./configure --prefix=/usr/
make && make install
cd /usr/src/ 
export VER="2.10"
wget https://github.com/pjsip/pjproject/archive/${VER}.tar.gz
tar -xvf ${VER}.tar.gz
cd pjproject-${VER}
./configure CFLAGS="-DNDEBUG -DPJ_HAS_IPV6=1" --prefix=/usr --libdir=/usr/lib64 --enable-shared --disable-video --disable-sound --disable-opencore-amr
make dep
make
make install
ldconfig
cd /usr/src/
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-16-current.tar.gz
tar xvfz asterisk-16-current.tar.gz
rm -f asterisk-16-current.tar.gz
cd asterisk-*
./configure --libdir=/usr/lib64 --with-jansson-bundled
contrib/scripts/install_prereq install
make menuselect
sudo contrib/scripts/get_mp3_source.sh
./configure --libdir=/usr/lib64 --with-jansson-bundled
make
make install
make samples
make config
ldconfig
groupadd asterisk
useradd -r -d /var/lib/asterisk -g asterisk asterisk
usermod -aG audio,dialout asterisk
chown -R asterisk.asterisk /etc/asterisk
chown -R asterisk.asterisk /var/{lib,log,spool}/asterisk
chown -R asterisk.asterisk /usr/lib64/asterisk
;;sudo vim /etc/sysconfig/asterisk
;;AST_USER="asterisk"
;;AST_GROUP="asterisk"
;;$ sudo vim /etc/asterisk/asterisk.conf
;;runuser = asterisk ; The user to run as.
;;rungroup = asterisk ; The group to run as.
-----------------
systemctl restart asterisk
systemctl enable asterisk
