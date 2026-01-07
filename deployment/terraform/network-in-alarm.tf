resource "aws_cloudwatch_metric_alarm" "ec2_network_in_zero" {
  alarm_name          = "EC2-${aws_instance.trade_signals.id}-NetworkInZero"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  period              = 300
  threshold           = 1.0

  metric_name = "NetworkIn"
  namespace   = "AWS/EC2"
  statistic   = "Average"

  dimensions = {
    InstanceId = aws_instance.trade_signals.id
  }

  alarm_description  = "There is no Network In activity in last 5 minutes"
  treat_missing_data = "breaching"

  alarm_actions = [
    "arn:aws:sns:ap-southeast-1:491085417493:Boxfuse_Network_Alarm",
    "arn:aws:automate:ap-southeast-1:ec2:reboot"
  ]

  ok_actions = [
    "arn:aws:sns:ap-southeast-1:491085417493:Boxfuse_Network_Alarm"
  ]
}
