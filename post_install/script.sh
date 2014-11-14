DEFAULT_USER="vagrant"

echo "Install necessary libraries for guest additions and vagrant"
apt-get -y update
apt-get -y upgrade
apt-get -y install linux-headers-$(uname -r) build-essential
apt-get clean

echo "Installing Virtualbox guest additions"
apt-get -y install dkms
VBOX_VERSION=$(cat ~/.vbox_version)
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm VBoxGuestAdditions_$VBOX_VERSION.iso

echo "Setup sudo to allow no-password sudo for 'admin group'"
groupadd -r admin
usermod -a -G admin $DEFAULT_USER
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

echo "Installing Puppet"
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
apt-get update
apt-get -y install puppet

exit
