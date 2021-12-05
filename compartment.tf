resource "oci_identity_compartment" "saas_comp" {
 compartment_id = var.compartment_ocid
 description	= var.compartment_description
 name		= var.compartment_name
 freeform_tags	= var.tags
 enable_delete	= true 
 
 provisioner "local-exec" {
 command = "sleep 30"
 }
}
