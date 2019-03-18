# -------- get the list of available ADs

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}



/* NETWORK */ 

# ------ Create a new VCN

variable "VCN-CIDR" { 
    default = "10.0.0.0/16" 
    }

resource "oci_core_virtual_network" "vcn" {
    cidr_block = "${var.VCN-CIDR}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "vcn"
    dns_label = "dnsvcn"
    }

 

# ------ Create a new Internet Gateway

resource "oci_core_internet_gateway" "IG" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "FFB-internet-gateway"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
}

 

# ------ Create a new Route Table

resource "oci_core_route_table" "ProdRouteTable" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
  display_name = "ProdRouteTable"
  route_rules {
    cidr_block = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.IG.id}"
  }
}

 

# ------ Create a new security list to be used in the new subnet

resource "oci_core_security_list" "ProdSecList-subnet1" {

  compartment_id = "${var.compartment_ocid}"
  display_name = "ProdSecList-subnet1"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
  egress_security_rules = [{
    protocol = "all"
    destination = "0.0.0.0/0"
  }]

 

  ingress_security_rules = [{
    protocol = "6" # tcp
    source = "${var.VCN-CIDR}"
    },

    {
    protocol = "6" //tcp
    source = "0.0.0.0/0"
    tcp_options = {
        "min" = 80
        "max" = 80
        }
    },

    {
    protocol = "6" # tcp
    source = "0.0.0.0/0"
    source = "${var.authorized_ips}"
    tcp_options {
        "min" = 22
        "max" = 22
        }
    }]
}



# ------ Create a public subnet 1 in AD1 in the new VCN

resource "oci_core_subnet" "ProdSubnetA-public-subnet1" {

  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block = "10.0.1.0/24"
  display_name = "ProdSubnetA-public-subnet1"
  dns_label = "subnet1"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
  route_table_id = "${oci_core_route_table.ProdRouteTable.id}"
  security_list_ids = ["${oci_core_security_list.ProdSecList-subnet1.id}"]
  dhcp_options_id = "${oci_core_virtual_network.vcn.default_dhcp_options_id}"
}


# ------ Create a public subnet 2 in AD1 in the new VCN

resource "oci_core_subnet" "ProdSubnetB-public-subnet2" {

  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  cidr_block = "10.0.2.0/24"
  display_name = "ProdSubnetB-public-subnet2"
  dns_label = "subnet2"
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.vcn.id}"
  route_table_id = "${oci_core_route_table.ProdRouteTable.id}"
  security_list_ids = ["${oci_core_security_list.ProdSecList-subnet1.id}"]
  dhcp_options_id = "${oci_core_virtual_network.vcn.default_dhcp_options_id}"
}
