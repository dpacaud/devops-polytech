#VPC
resource "aws_vpc" "vpc_euw3" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.vpc_euw3.id}"
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = "${aws_vpc.vpc_euw3.id}"
  cidr_block              = "10.0.20.0/24"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id                  = "${aws_vpc.vpc_euw3.id}"
  cidr_block              = "10.0.30.0/24"
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = false
}

# DHCP options
resource "aws_vpc_dhcp_options" "vpc_dhcp_options" {
  domain_name_servers = ["AmazonProvidedDNS"]
}

# DHCP association
# the option needs to be associated with the VPC
resource "aws_vpc_dhcp_options_association" "vpc_dhcp_options_association" {
  vpc_id          = "${aws_vpc.vpc_euw3.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.vpc_dhcp_options.id}"
}

# Internet Gateway, required so that instances get access to the Internet
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc_euw3.id}"
}

resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.vpc_euw3.id}"
}

# Internet route via Internet Gateway
resource "aws_route" "internet_route_via_igw" {
  route_table_id         = "${aws_route_table.route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.vpc_euw3.id}"
}

# Internet route via Internet Gateway
resource "aws_route" "internet_route_via_igw" {
  route_table_id         = "${aws_route_table.route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_route_table_association" "subnet_pub_route_table" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.route_table.id}"
}
