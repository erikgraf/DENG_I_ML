#!/bin/bash
set -e
set -x
	
	ENV_NAME=ML_Base

	sudo echo "SET grub-pc/install_devices /dev/sda" | sudo debconf-communicate
	sudo sed -i -e 's|eoan|focal|g' /etc/apt/sources.list 
	sudo apt-get update -qq
    # sudo apt-get upgrade -qq

	sudo apt-get install -y -qq firefox  
	sudo apt-get install -y -qq open-vm-tools open-vm-tools-desktop
	
	mkdir /home/vagrant/scripts/
	
	# Mini Conda install
	wget -q https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh
	sh Anaconda3-2020.02-Linux-x86_64.sh -b -p /home/vagrant/anaconda > anaconda_log.txt
	rm Anaconda3-2020.02-Linux-x86_64.sh
	echo "export PATH=/home/vagrant/anaconda/bin:$PATH" >> /home/vagrant/.bashrc
	chmod +x /home/vagrant/anaconda/bin/activate
	/home/vagrant/anaconda/bin/activate
	export PATH=/home/vagrant/anaconda/bin:$PATH
	
	/home/vagrant/anaconda/bin/conda init bash
	
	command . /home/vagrant/.bashrc
	
	# Setup Environment
	/home/vagrant/anaconda/bin/conda create -y -q -n $ENV_NAME python=3.7
	echo "source ~/anaconda/etc/profile.d/conda.sh" >> /home/vagrant/.bashrc
	echo "source ~/.bashrc" >> /home/vagrant/.bashrc
    echo "/home/vagrant/anaconda/bin/conda activate $ENV_NAME" >> /home/vagrant/.bashrc	
	
	#/home/vagrant/anaconda/bin/conda install -n $ENV_NAME -y -q -c conda-forge pytesseract
	#/home/vagrant/anaconda/bin/conda install -n $ENV_NAME -y -q -c menpo opencv
	#pip install -qqq opencv-python==3.4.2.17
	#pip install -qqq opencv-contrib-python==3.4.2.17
	
	
	#/home/vagrant/anaconda/bin/conda install -n $ENV_NAME -y -q spacy
	

	
	