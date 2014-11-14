echo "Install necessary libraries for guest additions and vagrant"
apt-get -y update
apt-get -y install linux-headers-$(uname -r) build-essential
apt-get clean

echo "Installing Virtualbox guest additions"
apt-get -y install dkms
VBOX_VERSION=$(cat ~/.vbox_version)
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm VBoxGuestAdditions_$VBOX_VERSION.iso

echo "Installing Puppet"
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
apt-get update
apt-get -y install puppet

exit
