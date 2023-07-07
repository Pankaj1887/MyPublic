variable "cidr_block" {
    description = "address space"
}

variable "instance_tenancy" {
    description = "instance tenancy"
    default = "default"
}

variable "name" {
    description = "name of the VPC"
}

variable "environment" {
    description = "environment"
}

variable "product" {
    description = "product"
}