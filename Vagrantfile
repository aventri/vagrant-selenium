Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.network :forwarded_port, guest:4444, host:4444
  config.vm.network :private_network, type: "dhcp"

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', "off"]
    vb.customize ['modifyvm', :id, '--memory', "512"]
    vb.customize ['modifyvm', :id, '--cpus', "2"]
    vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
  end

  config.vm.provision "shell", path: "setup.sh", privileged: true
end
