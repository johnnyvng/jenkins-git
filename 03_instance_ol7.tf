# --------- Get the OCID for the more recent for Oracle Linux 7.5 disk image

data "oci_core_images" "OLImageOCID-ol7" {

  compartment_id = "${var.compartment_ocid}"
  operating_system = "Oracle Linux"
  operating_system_version = "7.5"
}

 

# ------ Create a compute instance from the more recent Oracle Linux 7.5 image

resource "oci_core_instance" "WebAppSvr01" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "WebAppSvr01"
  hostname_label = "WebAppSvr01"
  image = "ocid1.image.oc1.iad.aaaaaaaa2tq67tvbeavcmioghquci6p3pvqwbneq3vfy7fe7m7geiga4cnxa"
  shape = "VM.Standard1.1"
  subnet_id = "${oci_core_subnet.ProdSubnetA-public-subnet1.id}"
  metadata {
    ssh_authorized_keys = "${file(var.ssh_public_key_file_ol7)}"
    user_data = "${base64encode(file(var.BootStrapFile_ol7))}"
  }

timeouts {
    create = "30m"
  }
}



resource "oci_core_instance" "WebAppSvr02" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "WebAppSvr02"
  hostname_label = "WebAppSvr02"
  image = "ocid1.image.oc1.iad.aaaaaaaa2tq67tvbeavcmioghquci6p3pvqwbneq3vfy7fe7m7geiga4cnxa"
  shape = "VM.Standard1.1"
  subnet_id = "${oci_core_subnet.ProdSubnetB-public-subnet2.id}"
  metadata {
    ssh_authorized_keys = "${file(var.ssh_public_key_file_ol7)}"
    user_data = "${base64encode(file(var.BootStrapFile_ol7))}"
  }

timeouts {
    create = "30m"
  }
}




# ------ Display the public IP of instance

output " Public IP of instance " {
  value = ["${oci_core_instance.WebAppSvr01.public_ip}"]
}


