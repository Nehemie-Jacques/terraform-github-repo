data "aws_ec2_instance_type" "myinstance" {
    instance_type = "t3.micro"
}


output "instance_type" {
  value = data.aws_ec2_instance_type.myinstance.instance_type
}

resource "aws_instance" "myec2" { 
  ami = "ami-0f34c5ae932e6f0e4"
  instance_type = data.aws_ec2_instance_type.myinstance.instance_type

  lifecycle {

    precondition {
        condition = data.aws_ec2_instance_type.myinstance.free_tier_eligible 
        error_message = "The selected instance type is not eligible for the free tier."
    }

    postcondition {
        condition = aws_instance.myec2.instance_type == data.aws_ec2_instance_type.myinstance.instance_type
        error_message = "The instance type does not match the expected value."
    }
  }
}
}