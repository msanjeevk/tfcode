# webserver1
resource  "oci_core_instance" "saas_vm1" {
 compartment_id =  oci_identity_compartment.saas_comp.id
 display_name   = "saas_vm1"
 availability_domain = var.availability_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name") : var.availability_domain_name
 shape  = var.shape

 source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.OSImage.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.saas_subnet.id
    assign_public_ip = true
  }
}

resource "local_file" "private_key" {
  content         = tls_private_key.public_private_key_pair.private_key_pem
  filename        = "saas_vm1.pem"
  file_permission = "0600"
}
