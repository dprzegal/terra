#resource "aws_iam_user" "terraform_dpr" {
#  name = "terraform_dpr"
#}

resource "aws_s3_bucket" "s3_init_data" {
  bucket = "init-data-playbook-docker-nginx-2022"
  tags = {
    Name = "Bucket to store Ansible playbook.yaml files"
    Description = "S3 bucket for Ansible Playbook for init state of EC2"
  }
}

resource "aws_s3_bucket_acl" "s3_acl" {
  bucket = aws_s3_bucket.s3_init_data.id
  acl = "private"
}

#wrzucamy plik playbook.yaml do bucketa
resource "aws_s3_object" "objects" {
  bucket = aws_s3_bucket.s3_init_data.id
  
# for more files  
#  for_each = fileset("$var.path_to_ansible_files", "*")
#  key = each.value
#  source = "${var.path_to_ansible_files}${each.value}"
#  etag = filemd5("${var.path_to_ansible_files}${each.value}") #filemd5("home/ansible_docker_user/${each.value}")

# for 1 file:
  content = "${var.path_to_ansible_files}playbook.yaml"    #"/home/ansible_docker_user/playbook.yaml"
  key = "playbook.yaml"
  
  acl = "private"
}

# bastion host security group
resource "aws_security_group" "sg_bastion_host" {
  depends_on = [
    aws_vpc.main_vpc,
  ]
  name        = "sg bastion host"
  description = "bastion host security group"
  vpc_id      = "${aws_vpc.main_vpc.id}"

  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH Security Group"
  }
}

resource "aws_instance" "bastion_host" {
  depends_on = [
    aws_security_group.sg_bastion_host,
  ]
  ami = var.amis[var.AWS_REGION]
  instance_type = var.instance_type
  key_name      = "${aws_key_pair.generated_key.key_name}"
  vpc_security_group_ids =  [aws_security_group.sg_bastion_host.id]
  subnet_id = aws_subnet.main-public-1.id
  iam_instance_profile = "${aws_iam_instance_profile.s3-mybucket-role-instanceprofile.name}"
  #user_data = "#!/bin/bash\n"
  user_data = <<EOF
	  #! /bin/bash
    sudo apt-get update
    sudo apt-get install python3-pip -y
    sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo unzip awscliv2.zip
    sudo ./aws/install
    sudo apt-get update
    sudo apt-get install -y ansible
    aws s3 cp s3://init-data-playbook-docker-nginx-2022/playbook.yaml .
    sudo ansible-playbook playbook.yaml
  EOF

  tags = {
    Name = var.instance_BH_name
  }
}