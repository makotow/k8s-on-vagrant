# -*- mode: ruby -*-
# vi: set ft=ruby :

boxes = [
    {
        :name => "master",
        :role => :master,
        :eth1 => "192.168.205.10",
        :mem => "4096",
        :cpu => "2"
    },
]

user="vagrant"
group="vagrant"
user_home="/home/vagrant"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.ssh.insert_key = false
  config.vm.synced_folder './setuplog', '/mnt/setuplog', create: true
 
  boxes.each do |opts|
    config.vm.define opts[:name] do |config|
      config.vm.hostname = opts[:name]
 
      config.vm.provider "virtualbox" do |v|
        v.linked_clone = true
        v.customize ["modifyvm", :id, "--memory", opts[:mem]]
        v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
      end

      config.vm.network "private_network", ip: opts[:eth1]
      
      ## os boot strap
      
      config.vm.provision "shell", inline: <<-SHELL
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
        echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list
        mv ~/kubernetes.list /etc/apt/sources.list.d
        apt-get update
        # Install docker if you don't have it already.
        apt-get install -y docker.io kubelet kubeadm kubectl kubernetes-cni apt-transport-https nfs-common jq unzip wget curl
        curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
        systemctl stop ufw
        systemctl disable ufw
        systemctl start rpcbind
        systemctl enable rpcbind
      SHELL
      
      if opts[:role] == :master
      ## master
        config.vm.provision "shell", inline: <<-SHELL
          kubeadm config images pull
          kubeadm init --apiserver-advertise-address=#{opts[:eth1]} --pod-network-cidr=10.244.0.0/16 | tee /mnt/setuplog/kubeadm.log
          sudo -u #{user} mkdir -p #{user_home}/.kube
          cp /etc/kubernetes/admin.conf #{user_home}/.kube/config
          cp /etc/kubernetes/admin.conf /vagrant/conf/admin.conf
          chown #{user}:#{group} #{user_home}/.kube/config
          sysctl net.bridge.bridge-nf-call-iptables=1
          # General user
          sudo -u #{user} -i /vagrant/shell/network-plugin.sh
          # node setup
          sudo -u #{user} -i /vagrant/shell/nodesetup.sh
        SHELL
      end
    end
  end
end
