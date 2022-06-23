output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.bastion_host.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.bastion_host.id
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

output "vpc_public_subnets" {
  value = var.public_subnets
}

output "vpc_private_subnets" {
  value = var.private_subnets
}

output "security_group_id_for_public_bastion_host" {
  value = aws_security_group.sg_bastion_host.id
}

#output "bucket_name" {
#    description = "Name (id) of the bucket"
#    value = aws_s3_bucket.s3_bucket.id
#}

output "private_key" {
  value     = tls_private_key.myprivatekey.private_key_pem
  sensitive = true
}
#see the private key by:
#terraform output -raw private_key