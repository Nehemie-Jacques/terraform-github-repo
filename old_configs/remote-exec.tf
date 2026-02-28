resource "aws_instance" "myec2" {
  ami                    = "ami-04e5276ebb8451442"
  instance_type          = "t3.micro"
  key_name               = "terraform-key"
  vpc_security_group_ids = ["sg-00fa40fd2561ee92b"]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./terraform-key.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo Hello, World! > /tmp/hello.txt",
      "cat /tmp/hello.txt",
      "sudo yum update -y",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx",
    ]
  }

}