Для деплоя нужно:
1) Установить AWS CLI v2:
   brew install awscli
2) Сконфигурировать AWS CLI v2:
   aws configure
   Введёшь:
- AWS Access Key
- Secret Key
- region (ap-southeast-1)
- output format (json)
3) Установить packer:
   brew tap hashicorp/tap
   brew install hashicorp/tap/packer
   packer version - проверка версии
4) Установить terraform:
   brew tap hashicorp/tap
   brew install hashicorp/tap/terraform
   terraform -v - проверка версии
5) Установить jq (для health-check скрипта):
   brew install jq
6) Использовать SSH ключ trade-signals.pem (хранится в Dropbox)
7) В папке с packer провести packer init packer.pkr.hcl для установки плагинов пакера