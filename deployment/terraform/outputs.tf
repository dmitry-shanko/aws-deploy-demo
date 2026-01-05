output "instance_id" {
  value = aws_instance.trade_signals.id
}

output "public_ip" {
  value = aws_instance.trade_signals.public_ip
}

output "private_ip" {
  value = aws_instance.trade_signals.private_ip
}
