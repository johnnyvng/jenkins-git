variable "CustomImage" {
  default = "/Users/jnguyent/Downloads/CustomImage"
}

variable "ObjectName" {
	default = "LocalImage"
}

# Upload the local image to the bucket
resource "oci_objectstorage_object" "test_object" {
	#Required
	bucket = "${oci_objectstorage_bucket.bucket1.name}"
	source = "${var.CustomImage}"
	namespace = "${var.oci_objectstorage_namespace}"
	object = "${var.ObjectName}"
}