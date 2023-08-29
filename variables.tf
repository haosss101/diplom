variable "name" {
  default = "shpakovsky-cluster"
}

variable "instance" {
  default = "t2.micro"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

variable "pub1" {
  default = "10.0.1.0/24"
}

variable "pub2" {
  default = "10.0.2.0/24"
}

variable "priv1" {
  default = "10.0.10.0/24"
}

variable "priv2" {
  default = "10.0.20.0/24"
}

variable "int1" {
  default = "10.0.101.0/24"
}

variable "int2" {
  default = "10.0.202.0/24"
}

variable "azs1" {
  default = "us-east-1a"
}

variable "azs2" {
  default = "us-east-1b"
}

variable "repository_name" {
  default = "shpakovsky-private"
}

variable "arn" {
  default = "arn:aws:iam::097084951758:user/shpakovsky"
}
