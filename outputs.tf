output "aws_eip_nat" {
  value = module.vpc.aws_eip_nat_public_ips
}