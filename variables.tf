variable "region" {
    type    = string
    description = "Defininfo uma região - us-east-1"
    default = "us-east-1"
}

variable "shard_credentials_file" {
    type = string
    default = "~/.aws/credentials"
}

variable "profile" {
    type = string
    default = "infra"
}

variable "availability_zone" {
    type = string
    default = "us-east-1a"
}

variable "ami" {
    type = string
    default = "ami-09e67e426f25ce0d7"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}