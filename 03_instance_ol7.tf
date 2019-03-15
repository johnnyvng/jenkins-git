# --------- Get the OCID for the more recent for Oracle Linux 7.5 disk image

data "oci_core_images" "OLImageOCID-ol7" {

  compartment_id = "${var.compartment_ocid}"
  operating_system = "Oracle Linux"
  operating_system_version = "7.5"
}




# Create image from exported image via direct access to object store
resource "oci_core_image" "test_image" {
	#Required
	compartment_id = "${var.compartment_ocid}"

	#Optional
	# display_name = "${var.image_display_name}"
	# launch_mode = "${var.image_launch_mode}"
	
	image_source_details {
		source_type = "objectStorageTuple"
		bucket_name = "${oci_objectstorage_bucket.bucket1.name}"
		namespace_name = "${var.oci_objectstorage_namespace}"
		object_name = "${var.ObjectName}" # exported image name
        
		#Optional
		#source_image_type = "${var.source_image_type}"
	}
}


# ------ Create a compute instance from the more recent Oracle Linux 7.5 image

resource "oci_core_instance" "AppServer" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "AppServer"
  hostname_label = "AppServer"
  # image = "ocid1.image.oc1.iad.aaaaaaaa2tq67tvbeavcmioghquci6p3pvqwbneq3vfy7fe7m7geiga4cnxa"
  shape = "VM.Standard2.1"
  subnet_id = "${oci_core_subnet.public-subnet.id}"
  metadata {
    ssh_authorized_keys = "${file(var.ssh_public_key_file_ol7)}"
    #user_data = "${base64encode(file(var.BootStrapFile_ol7))}"
  }

  source_details {
		#Required
		source_id = "${oci_core_image.test_image.id}"
		source_type = "image"

		#Optional
		boot_volume_size_in_gbs = "60"
	}

timeouts {
    create = "30m"
  }
}


# output " Public IP of instance " {
#   value = ["${oci_core_instance.testImage.public_ip}"]
# }

