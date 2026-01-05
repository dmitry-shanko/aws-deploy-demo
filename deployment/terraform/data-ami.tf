data "aws_ami" "latest_trade_signals" {
  owners      = ["self"]
  most_recent = true

  filter {
    name   = "name"
    values = ["trade-signals-app-*"]
  }
}
