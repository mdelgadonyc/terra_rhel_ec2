//subnets.tf
resource "aws_route_table" "route-table-test" {
  vpc_id = "${aws_vpc.testvpc.id}"
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test-gw.id}"
  }
tags =  {
    Name = "test-env-route-table"
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.testsub.id}"
  route_table_id = "${aws_route_table.route-table-test.id}"
}
