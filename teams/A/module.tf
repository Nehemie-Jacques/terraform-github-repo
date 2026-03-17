module "ec2" {
    source = "../../modules/ec2"
    region = "us-east-1"
    ami = "ami-0bb84b8ffd87024d8"
    instance_type = "t2.micro"
}