#Create AWS Launch configuration
resource "aws_launch_configuration" "terra-launchconfigDPR" {
  name_prefix = "terra-launchconfig"
  image_id = "${lookup(var.amis, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name = aws_key_pair.generated_key.key_name
  security_groups = [ "${aws_security_group.sg_bastion_host.id}" ]
  associate_public_ip_address = true
  #user_data = "${file("data.sh")}"
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
  lifecycle {
    create_before_destroy = true
  }
}