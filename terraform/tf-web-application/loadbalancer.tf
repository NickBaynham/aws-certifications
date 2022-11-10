resource "aws_alb" "alb" {
  name            = "web-alb"
  security_groups = [aws_security_group.alb_security_group.id]
  subnets         = [aws_subnet.webserver_subnets.*.id]
  tags = {
    Name = "web-alb"
  }
}

resource "aws_alb_target_group" "alb_group" {
  name     = "web-alb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  stickiness {
    type = "lb_cookie"
  }
  # Alter the destination of the health check to be the login page.
  health_check {
    path = "/login"
    port = 80
  }
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "listener_https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn
  default_action {
    target_group_arn = aws_alb_target_group.alb_group.arn
    type             = "forward"
  }
}

resource "aws_route53_record" "route53_record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "web.${var.route53_hosted_zone_name}"
  type    = "A"
  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = true
  }
}