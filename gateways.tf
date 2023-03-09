//gateways.tf
resource "aws_internet_gateway" "test-gw" {
  vpc_id = "${aws_vpc.testvpc.id}"
tags = {
    Name = "test-gw"
  }
}
