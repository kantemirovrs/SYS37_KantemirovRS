variable "flow" {
  type    = string
  default = "24-01"
}

variable "cloud_id" {
  type    = string
  default = "b1gcebdv1eqce9n29ma8"
}
variable "folder_id" {
  type    = string
  default = "b1gh9a0ujg13u9tn754g"
}

variable "test" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
}

