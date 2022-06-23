resource "aws_eip" "nat" {
  vpc = true
  instance = "${aws_instance.bastion_host.id}"
}
resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.main-public-1.id}"
  depends_on = [
    aws_internet_gateway.terra_gateway
  ]
}

resource "aws_route_table" "out_route_for_private" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gateway.id}"
  }
  tags = {
    Name = "Route for internet for private by NAT"
  }
}

resource "aws_route_table_association" "rtprv1" {
  subnet_id = "${aws_subnet.main-private-1.id}"
  route_table_id = "${aws_route_table.out_route_for_private.id}"
}
resource "aws_route_table_association" "rtprv2" {
  subnet_id = "${aws_subnet.main-private-2.id}"
  route_table_id = "${aws_route_table.out_route_for_private.id}"
}
resource "aws_route_table_association" "rtprv3" {
  subnet_id = "${aws_subnet.main-private-3.id}"
  route_table_id = "${aws_route_table.out_route_for_private.id}"
}