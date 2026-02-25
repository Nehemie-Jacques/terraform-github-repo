resource "aws_instance" "myec2" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t3.micro"
  count         = 3

  tags = {
    Name = "MyEC2Instance-${count.index + 1}"
  }
}

resource "aws_iam_user" "this" {
  name = "my-iam-user-${count.index + 1}"
  count = 3
}

variable "list_of_users" {
  type = list(string)
  default = ["user1", "user2", "user3"]
}