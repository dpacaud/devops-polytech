resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow all ssh traffic"
  vpc_id      = "${aws_vpc.vpc_euw3.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "http_https" {
  name        = "http_https"
  description = "Allow all http and https traffic"
  vpc_id      = "${aws_vpc.vpc_euw3.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "mysql" {
  name        = "mysql"
  description = "Allow mysql inbound traffic"
  vpc_id      = "${aws_vpc.vpc_euw3.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_subnet.public_subnet.cidr_block}", "${aws_subnet.private_subnet_a.cidr_block}", "${aws_subnet.private_subnet_b.cidr_block}"]
  }
}

resource "aws_security_group" "allow_all_egress" {
  name        = "allow_all_egress"
  description = "Allow all egress traffic"
  vpc_id      = "${aws_vpc.vpc_euw3.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
