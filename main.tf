provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "9cf71a4e-b126-53b7-f7a6-56ab7da64540"
      secret_id = "dd6d4e79-d0c1-dedf-ef8f-85951c54bab6"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "secret"
  name  = "test-secret"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["Username"]
  }
}
