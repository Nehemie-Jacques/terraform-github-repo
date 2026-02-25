resource "aws_instance" "web" {
    ami = "ami-00c39f71452c08778"
    instance_type = "t3.micro"

    provisioner "local-exec" {
        command = "echo ${self.private_ip} >> private_ips.txt"
    }
}