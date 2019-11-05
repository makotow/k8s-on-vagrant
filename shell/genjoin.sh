#!/usr/bin/env bash

rm /vagrant/shell/join.sh
touch /vagrant/shell/join.sh
chmod +x /vagrant/shell/join.sh
echo "#!//usr/bin/env bash" > /vagrant/shell/join.sh
grep -A 2 "kubeadm join" /vagrant/setuplog/kubeadm.log >> /vagrant/shell/join.sh
