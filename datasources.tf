#ADs
data "oci_identity_availability_domains" "ADs" {
   compartment_id = var.tenancy_ocid
}
# Images DataSource
data "oci_core_images" "OSImage" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version
  shape                    = var.shape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}
