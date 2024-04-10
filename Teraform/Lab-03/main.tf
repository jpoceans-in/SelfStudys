resource "aws_vpc" "rVPC-1" {
  cidr_block = var.pCidrBlockVPC-1
  instance_tenancy = "default"
  tags       = {
    Name = format("%s-%s-VPC-1", var.pProject, var.pEnvironment)
  }
}
resource "aws_vpc" "rVPC-2" {
  cidr_block = var.pCidrBlockVPC-2
  tags       = {
    Name = format("%s-%s-VPC-2", var.pProject, var.pEnvironment)
  }
}