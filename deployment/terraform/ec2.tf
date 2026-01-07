resource "aws_instance" "trade_signals" {
  ami                    = data.aws_ami.latest_trade_signals.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.instance_profile
  key_name               = var.key_name

  tags = {
    Name = "trade-signals-app"
    App  = "trade-signals-app"
  }
}

# Attach Elastic IP
resource "aws_eip_association" "trade_signals" {
  instance_id   = aws_instance.trade_signals.id
  allocation_id = "eipalloc-0b91a8669dcb35b07" #TODO - вставить сюда ИД elastic IP

  depends_on = [aws_instance.trade_signals]
}
