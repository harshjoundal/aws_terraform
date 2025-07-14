

variable vpc_cidr {
    description = "value of the CIDR block for the VPC"
    type = string
}


variable "cluster_name" {
    description = "value of the cluster name"
    type = string
}

variable "private_subnet_cidrs" {
    description = "list of private subnets in the VPC"
    type = list(string)
}

variable "availability_zones" {
    description = "list of availability zones to use for the VPC"
    type = list(string)
}

variable "public_subnet_cidrs" {
    description = "value of the public subnets in the VPC"
    type = list(string)
}