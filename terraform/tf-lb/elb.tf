resource "aws_elb" "lb_1" {

  listener {
    name               = "lb_1"
    internal           = false
    load_balancer_type = "application"
    security_groups    = []
    instance_port      = 0
    instance_protocol  = ""
    lb_port            = 0
    lb_protocol        = ""
  }
}