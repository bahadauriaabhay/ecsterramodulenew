resource "aws_autoscaling_group" "asg" {
  name                      = var.name
  max_size                  = var.asg_max
  min_size                  = var.asg_min
  health_check_grace_period = 300
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  force_delete              = var.force_delete
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = [module.network.private_subnet_ids1,module.network.private_subnet_ids2]
}

resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "${var.name}-"
  image_id      = "ami-0fe77b349d804e9e6"
  instance_type = "${var.instance_types}"
  security_groups = [aws_security_group.allow_tls.id]
#  associate_public_ip_address = true
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.name} >> /etc/ecs/ecs.config;echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;
EOF
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.name
  lifecycle {
    create_before_destroy = true
  }
}
