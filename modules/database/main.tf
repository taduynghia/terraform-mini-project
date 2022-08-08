//create DB subnet group
resource "aws_db_subnet_group" "labvpcrsddb" {
  name = "labvpcrsddb"
  subnet_ids = [data.aws_subnet.private_subnet_lab_rds[0].id,data.aws_subnet.private_subnet_lab_rds[1].id]
}

//create db instance
resource "aws_db_instance" "LabVPCDBCluster" {
  identifier =  "labvpcdbcluster"//database cluster
  allocated_storage = 10
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.small"
  db_name = "Population"
  username = "admin" //master username
  password = "testingrdscluster" //master password
  db_subnet_group_name = aws_db_subnet_group.labvpcrsddb.name
  vpc_security_group_ids = [data.aws_security_group.LabVPCRDSSG.id]
  skip_final_snapshot = true
  publicly_accessible = false
  backup_retention_period = 5
}

//create db instance read replica
resource "aws_db_instance" "rds_read" {
  identifier = "data-replica"
  replicate_source_db = aws_db_instance.LabVPCDBCluster.identifier
  instance_class = "db.t3.small"
  allocated_storage = 10
  skip_final_snapshot = true
  publicly_accessible = false
  apply_immediately = true
  vpc_security_group_ids = [data.aws_security_group.LabVPCRDSSG.id]
  
}