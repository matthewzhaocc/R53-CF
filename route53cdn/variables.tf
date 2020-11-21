variable "ACM_ARN" {
  type = string
}

variable "Record_Name" {
  type = string
}
variable "Record_FullName" {
    type = string
}
variable "Route53_ID" {
  type = string
}

variable "Record_Value" {
  type = string
}

variable "Default_Root_Object" {
  type    = string
  default = "index.html"
}