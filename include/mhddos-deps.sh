# docker
snap install docker
groupadd docker
usermod -aG docker azureuser
sleep 10s
docker ps
sleep 5s
# bombardier
apt-get update
apt-get install -y golang
mkdir /home/azureuser/gocache
export GOPATH=/home/azureuser/go
export GOCACHE=/home/azureuser/gocache
mkdir /home/azureuser/bombardier_tmp
cd /home/azureuser/bombardier_tmp
go mod init bombardier_tmp
go mod edit -replace github.com/codesenberg/bombardier=github.com/PXEiYyMH8F/bombardier@78-add-proxy-support
go get github.com/codesenberg/bombardier
cd ..
rm -r /home/azureuser/bombardier_tmp
# MHDDoS
chown root:docker /var/run/docker*
apt-get install -y python3-pip
git clone https://github.com/MHProDev/MHDDoS.git /home/azureuser/MHDDoS
cp /home/azureuser/go/bin/bombardier /home/azureuser/MHDDoS/files
sed -i 's/go\/bin\/bombardier/files\/bombardier/g' /home/azureuser/MHDDoS/start.py
sed -i 's/Path\.home()/__dir__/g' /home/azureuser/MHDDoS/start.py
docker build -t local/mhddos /home/azureuser/MHDDoS
ulimit -n 100000

