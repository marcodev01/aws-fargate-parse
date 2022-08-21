output "aws_nat_public_ip_list" {
  value = module.vpc.aws_eip_nat_public_ips
}

output "aws_lb_dns" {
  value = module.alb.aws_lb_dns
}