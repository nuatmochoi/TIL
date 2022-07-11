variable "server_port" {  
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "elb_port" {  
  description = "The port of ELB"
  type        = number
  default     = 80
}

variable "prefix" {
    description = "The prefix of target group name"
    type = string
    default = "tf-example-lb"
}

variable "asg_prefix" {
    description = "The prefix of asg name"
    type = string
    default = "asg"
}

variable "ami_id" {
  description = "instance ami id"
  type = string
  default = "ami-058165de3b7202099"
}

variable "vpc_id" {
  description = "The id of vpc"
  type = string
  default = "vpc-0dbea152ca9454060"
}
