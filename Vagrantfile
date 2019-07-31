Vagrant.configure("2") do |config|
  config.vm.define "virtualbox"
  config.vm.box = "geerlingguy/centos7"
  config.vm.network "forwarded_port", guest: 5000, host: 8080
  config.vm.network "private_network", type: "dhcp", nic_type: "virtio"
  config.vm.synced_folder ".", "/shared",
    :mount_options => ["dmode=777,fmode=777"]

  # bootstrap puppet agent install
  config.vm.provision "shell", path: "./puppet_agent.sh"

  config.vm.provision "virtualbox", type: "puppet" do |puppet|
    puppet.module_path = "./site"
  end
end
