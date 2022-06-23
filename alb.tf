#Create AWS Load Balancer

resource "aws_lb" "alb-tf" {
  name = "nginx-alb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-security-group.id]
  subnets            = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id, aws_subnet.main-public-3.id]

  tags = {
    Name = "ApplicationLoadBalancer-tf"
  }
}

resource "aws_lb_target_group" "frontend-target-group" {
  name = "alb-target-group"
  port = 8080
  protocol = "HTTP"
  vpc_id = "${aws_vpc.main_vpc.id}"
}

resource "aws_lb_target_group_attachment" "frontend-attachment-1" {
  target_group_arn = "${aws_lb_target_group.frontend-target-group.arn}"
  target_id = "${aws_instance.bastion_host.id}"
  port = 8080
}

# Create ALB Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb-tf.arn
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend-target-group.arn
  }
}