# ---- use variables defined in terraform.tfvars file

     variable "tenancy_ocid" {}
     variable "user_ocid" {}
     variable "fingerprint" {}
     variable "private_key_path" {}
     variable "compartment_ocid" {}
     variable "region" {}
     variable "AD" {}
     #variable "BootStrapFile_ol7" {}
     variable "ssh_public_key_file_ol7" {}
     variable "authorized_ips" {}

# ---- provider

provider "oci" {
     region = "${var.region}"
     tenancy_ocid = "${var.tenancy_ocid}"
     user_ocid = "${var.user_ocid}"
     fingerprint = "${var.fingerprint}"
     private_key_path = "${var.private_key_path}"
     }

# ---- ImageOCID

variable "InstanceImageOCID" {
  type = "map"
  default = {
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    // Oracle-provided image "Oracle-Linux-7.5-2018.08.14-0"
    # us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaasez4lk2lucxcm52nslj5nhkvbvjtfies4yopwoy4b3vysg5iwjra"
    us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaa2tq67tvbeavcmioghquci6p3pvqwbneq3vfy7fe7m7geiga4cnxa"
    # eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaakzrywmh7kwt7ugj5xqi5r4a7xoxsrxtc7nlsdyhmhqyp7ntobjwq"
    // uk-london-1 = "ocid1.image.oc1.uk-london-1.aaaaaaaalsdgd47nl5tgb55sihdpqmqu2sbvvccjs6tmbkr4nx2pq5gkn63a"
  }
}