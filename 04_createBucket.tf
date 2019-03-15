variable "oci_objectstorage_namespace" {
    default = "gse00014917"
}

resource "oci_objectstorage_bucket" "bucket1" {
  compartment_id = "${var.compartment_ocid}"
  namespace      = "${var.oci_objectstorage_namespace}"
  name           = "tf-example-bucket"
  access_type    = "NoPublicAccess"
}

data "oci_objectstorage_bucket_summaries" "buckets1" {
  compartment_id = "${var.compartment_ocid}"
  namespace      = "${var.oci_objectstorage_namespace}"

  filter {
    name   = "name"
    values = ["${oci_objectstorage_bucket.bucket1.name}"]
  }
}

output buckets {
  value = "${data.oci_objectstorage_bucket_summaries.buckets1.bucket_summaries}"
}