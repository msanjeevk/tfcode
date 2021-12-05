#vcn
resource "oci_core_vcn" "saas_vcn" {
  compartment_id  = oci_identity_compartment.saas_comp.id
  display_name    = "saas_vcn"
  cidr_block      = var.vcn_cidr
}

# DHCP Options
resource "oci_core_dhcp_options" "saas_dhcp_options" {
  compartment_id  = oci_identity_compartment.saas_comp.id
  vcn_id          = oci_core_vcn.saas_vcn.id
  display_name   = "saas_dhcp_options"

  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  options {
    type                = "SearchDomain"
    search_domain_names = ["foggykitchen.com"]
  }
}

# internet gateway
resource "oci_core_internet_gateway" "saas_igw" {
  compartment_id  = oci_identity_compartment.saas_comp.id
  display_name    = "saas_igw"
  vcn_id          = oci_core_vcn.saas_vcn.id
}
# routing table
resource "oci_core_route_table" "saas_rt" {
  compartment_id  = oci_identity_compartment.saas_comp.id
  display_name    = "saas_rt"
  vcn_id          = oci_core_vcn.saas_vcn.id
  route_rules {
     destination = "0.0.0.0/0" 
     destination_type = "CIDR_BLOCK"
     network_entity_id = oci_core_internet_gateway.saas_igw.id
   }
}
# security list
resource "oci_core_security_list" "saas_sl" {
  compartment_id  = oci_identity_compartment.saas_comp.id
  display_name    = "saas_sl"
  vcn_id          = oci_core_vcn.saas_vcn.id
  
  egress_security_rules {
     protocol = "6" 
     destination = "0.0.0.0/0"
  }
  
  dynamic "ingress_security_rules" {
  for_each = var.service_ports
  content {
     protocol = "6" 
     source   = "0.0.0.0/0"
     tcp_options {
       min = ingress_security_rules.value
       max = ingress_security_rules.value
     }
   }
  }
 
  ingress_security_rules {
     protocol = "6"
     source   = var.vcn_cidr
  }

}
# subnet
resource "oci_core_subnet" "saas_subnet" {
  compartment_id  = oci_identity_compartment.saas_comp.id
  display_name    = "saas_subnet"
  vcn_id          = oci_core_vcn.saas_vcn.id
  route_table_id  = oci_core_route_table.saas_rt.id
  security_list_ids = [oci_core_security_list.saas_sl.id]
  dhcp_options_id   = oci_core_dhcp_options.saas_dhcp_options.id
  cidr_block        = var.subnet_cidr 
}
