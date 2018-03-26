# -*- mode: ruby -*-
# vi: set ft=ruby :

boxes = [
    {
        :name => "k8s-master",
        :eth1 => "192.168.205.10",
        :mem => "1024",
        :cpu => "1"
    },
    {
        :name => "k8s-worker1",
        :eth1 => "192.168.205.11",
        :mem => "1024",
        :cpu => "1"
    },
    {
        :name => "k8s-worker2",
        :eth1 => "192.168.205.12",
        :mem => "1024",
        :cpu => "1"
    }
]

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.ssh.insert_key = false

  boxes.each do |opts|
    config.vm.define opts[:name] do |config|
      config.vm.hostname = opts[:name]
 
      config.vm.provider "virtualbox" do |v|
        v.linked_clone = true
        v.customize ["modifyvm", :id, "--memory", opts[:mem]]
        v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
      end

      config.vm.network :private_network, ip: opts[:eth1]
    end
  end

  config.vm.provision "shell", inline: <<-SHELL
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list
    sudo mv ~/kubernetes.list /etc/apt/sources.list.d
    sudo apt-get update
    # Install docker if you don't have it already.
    sudo apt-get install -y docker.io
    apt-get install -y kubelet kubeadm kubectl kubernetes-cni
    apt-get update && apt-get install -y apt-transport-https
  SHELL

end
