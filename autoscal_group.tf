#Create AWS Auto Scaling Group
resource "aws_autoscaling_group" "asg_terraDPR" {
  name = "${aws_launch_configuration.terra-launchconfigDPR.name}-asg"
  vpc_zone_identifier  = [
    "${aws_subnet.main-public-1.id}",
    "${aws_subnet.main-public-2.id}",
    "${aws_subnet.main-public-3.id}",
  ]
  launch_configuration = "${aws_launch_configuration.terra-launchconfigDPR.name}"
  min_size             = 2
  desired_capacity     = 3
  max_size             = 3
  health_check_grace_period = 300
  health_check_type    = "EC2"
  force_delete = true
  
  #role_arn = aws_s3_bucket.s3_init_data.arn

  tag {
    key                 = "Name"
    value               = "ec2-instance-asg"
    propagate_at_launch = true
  }

  target_group_arns = [aws_lb_target_group.frontend-target-group.arn]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"

  # Required to redeploy without an outage.
  #lifecycle {
  #  create_before_destroy = true
  #}

}

