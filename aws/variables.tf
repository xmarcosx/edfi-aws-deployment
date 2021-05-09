variable "AWS_REGION" {
    type = string
}

variable "PG_PASSWORD" {
    type = string
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
