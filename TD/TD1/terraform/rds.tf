resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = ["${aws_subnet.private_subnet_a.id}", "${aws_subnet.private_subnet_b.id}"]
}

resource "aws_db_instance" "rds_master_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = "rds-master-db"
  name                 = "rds_master_db"
  username             = "admin"
  password             = "unpasswordsuperlongettressecure"
  parameter_group_name = "default.mysql5.7"

  db_subnet_group_name   = "${aws_db_subnet_group.rds_subnet_group.name}"
  vpc_security_group_ids = ["${aws_security_group.mysql.id}"]
  deletion_protection    = false
  skip_final_snapshot    = true
}
