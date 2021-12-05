#provider variables
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "fingerprint" {}
variable "region" {}

# compartment variables
variable "compartment_ocid" {}
variable "compartment_description" {
 default = "This is SaaS Compartment"
}
variable "compartment_name" {
 default = "saas_comp"
}
variable "tags" {
 type = map
 default = {
   env = "Dev"
   type = "poc"
   org  = "Saas"  
   }
}

# network variables
variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "service_ports" {
     default = [22,443,80]
}

# compute variables
variable "availability_domain_name" {
   default = ""
}

variable "shape" {
   default = "VM.Standard.E2.1.Micro"
}

variable "instance_os" {
  default = "Oracle Linux"
}

variable "linux_os_version" {
  default = "7.9"
}
