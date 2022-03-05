snap install docker
groupadd docker
usermod -aG docker azureuser
sleep 10s
docker ps
sleep 5s
chown root:docker /var/run/docker*
