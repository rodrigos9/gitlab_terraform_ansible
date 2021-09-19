variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "us-east-1"
}

variable "instance-type" {
  type    = string
  default = "t2.medium"
}

variable "webserver-port" {
  type    = number
  default = 8080

}