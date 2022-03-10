snap install docker
groupadd docker
usermod -aG docker azureuser
sleep 10s
docker ps
sleep 5s
chown root:docker /var/run/docker*
apt-get update
apt-get install -y python3-pip
git clone https://github.com/MHProDev/MHDDoS.git /home/azureuser/MHDDoS
docker build -t local/mhddos /home/azureuser/MHDDoS
ulimit -n 100000
