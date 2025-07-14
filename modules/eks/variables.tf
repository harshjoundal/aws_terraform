

variable "cluster_name" {
    description = "value of the EKS cluster name"
    type        = string
}


variable cluster_version {
    description = "value of the EKS cluster version"
    type        = string
   
}

variable "vpc_id" {
    description = "value of the VPC ID where the EKS cluster will be created"
    type        = string
}

variable "subnet_ids" {
    description = "list of subnet IDs where the EKS cluster will be created"
    type        = list(string)
  
}

variable "node_groups" {
    description = "value of the EKS node groups configuration"
    type = map(object({
        instance_types = list(string)
        capacity_type = string
        scaling_config = object({
            desired_size = number
            max_size     = number
            min_size     = number
        })
    }))
}