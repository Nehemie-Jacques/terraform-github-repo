# Configuration AWS - Les credentials doivent être configurés via:# provider "aws" {

# - Variables d'environnement: AWS_ACCESS_KEY_ID et AWS_SECRET_ACCESS_KEY#   region     = "us-east-1"

# - Fichier: ~/.aws/credentials#   # Les credentials AWS doivent être configurés via:

#   # - Variables d'environnement AWS_ACCESS_KEY_ID et AWS_SECRET_ACCESS_KEY

# resource "aws_instance" "myec2" {#   # - Fichier ~/.aws/credentials

#   ami           = "ami-00c39f71452c08778"# }

#   instance_type = "t3.micro"

# resource "aws_instance" "myec2" {

#   tags = {#   ami           = "ami-00c39f71452c08778"

#     Name = "MyFirstEC2Instance"#   instance_type = "t3.micro"

#   }

# }#   tags = {

#     Name = "MyFirstEC2Instance"
#   }
# }
