apt-get update
apt-get install -y python3-pip
git clone https://github.com/MHProDev/MHDDoS.git /home/azureuser/MHDDoS
pip install -r /home/azureuser/MHDDoS/requirements.txt
ulimit -n 100000
