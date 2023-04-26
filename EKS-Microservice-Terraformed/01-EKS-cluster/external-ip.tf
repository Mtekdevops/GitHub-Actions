data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  single-workstation-external-cidr = "${chomp(data.http.workstation-external-ip.response_body)}/32"
}

