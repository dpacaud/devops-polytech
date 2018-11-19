resource "aws_instance" "pma" {
  ami                    = "ami-0ebc281c20e89ba4b"
  key_name               = "test-TD1"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.allow_all_egress.id}", "${aws_security_group.http_https.id}", "${aws_security_group.ssh.id}"]
  subnet_id              = "${aws_subnet.public_subnet.id}"
  ebs_optimized          = false
  monitoring             = false
}
