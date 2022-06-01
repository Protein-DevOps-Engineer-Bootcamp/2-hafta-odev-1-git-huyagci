# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
    # Box Settings #

    # Define base image of the machine
    config.vm.box = "ubuntu/focal64"
  
    # Provider Settings #

    # Use virtualbox as a VM provider
    config.vm.provider "virtualbox" do |vb|
  
      # Virtual machine resources
      vb.memory = 4096
      vb.cpus = 2
  
      # Virtual machine name
      vb.name = "week-2-assignment-huyagci"
    end
  
    # Synced Folder Settings

    # Mount specified host paths to virtual machine
    config.vm.synced_folder "./shared", "/opt"
  
    # Provision Settings

    # Execute given script on boot
    config.vm.provision "shell", path: "./shared/scripts/bootstrap.sh"
  end