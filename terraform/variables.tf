variable "ami_id" {
    type = string  
}

variable "number_of_instances" {
    type = number
}

variable "instance_type" {
    type = string
}

variable "ami_key_pair_name" {
    type = string
}

variable "backend_bucket_name" {
    type = string
}
