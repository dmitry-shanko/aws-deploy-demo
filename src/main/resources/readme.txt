Создание AMI образа:
ssh -i trade-signals.pem ec2-user@PUBLIC_IP

sudo dnf update -y
sudo dnf install -y java-17-amazon-corretto

curl -O https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U amazon-cloudwatch-agent.rpm

sudo mkdir -p /var/log/trade-signals-app
sudo chmod 777 /var/log/trade-signals-app