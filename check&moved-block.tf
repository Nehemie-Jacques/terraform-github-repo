check "website_checker" {
    data "http" "website" {
        url = "https://example.com"
    }

    assert {
        condition = data.http.website.status_code == 200
        error_message = "The website is not accessible." 
    }
}

resource "local_file" "foo" {
  content  = "Hi"
  filename = "${path.module}/foo.txt"
}


resource "aws_security_group" "payment_database_firewall" {
  name        = "db_firewall"
}


moved {
  from = aws_security_group.database_firewall
  to   = aws_security_group.payment_database_firewall
}