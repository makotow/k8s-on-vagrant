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
    {
        :name => "worker1",
        :role => :worker,
        :eth1 => "192.168.205.11",
        :mem => "4096",
        :cpu => "2"
    },

]

user="vagrant"
group="vagrant"
user_home="/home/vagrant"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
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
      config.vm.provision "shell", path: "shell/common.sh"
      config.vm.provision "shell", path: "shell/dockersetup.sh"
      config.vm.provision "shell", path: "shell/servicesetup.sh"

      if opts[:role] == :master
        ## master
        config.vm.provision :shell do |shell|
          shell.path = "shell/kubeadm.sh"
          shell.args = "#{opts[:eth1]} #{user} #{user_home} #{group}"
        end
      elsif opts[:role] == :worker
        config.vm.provision :shell, path: "shell/genjoin.sh"
        config.vm.provision :shell, path: "shell/join.sh"
      end
    end
  end
end
