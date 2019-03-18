/* Load Balancer */

resource "oci_load_balancer" "ProdLoadBalancer" {
  shape          = "100Mbps"
  compartment_id = "${var.compartment_ocid}"
  subnet_ids     = [
    "${oci_core_subnet.ProdSubnetA-public-subnet1.id}",
    "${oci_core_subnet.ProdSubnetB-public-subnet2.id}"
  ]
  display_name   = "FFB-LB01"
}

resource "oci_load_balancer_backend_set" "lb-bes1" {
  name             = "lb-bes1"
  load_balancer_id = "${oci_load_balancer.ProdLoadBalancer.id}"
  policy           = "ROUND_ROBIN"

  health_checker {
    port     = "80"
    protocol = "HTTP"
    response_body_regex = ".*"
    url_path = "/"
  }
}


resource "oci_load_balancer_path_route_set" "test_path_route_set" {
    #Required
    load_balancer_id = "${oci_load_balancer.ProdLoadBalancer.id}"
    name = "pr-set1"
    path_routes {
        #Required
        backend_set_name = "${oci_load_balancer_backend_set.lb-bes1.name}"
        path = "/example/video/123"
        path_match_type {
            #Required
            match_type = "EXACT_MATCH"
        }

    }
}

resource "oci_load_balancer_hostname" "hostname1" {
    #Required
    hostname = "app.example.com"
    load_balancer_id = "${oci_load_balancer.ProdLoadBalancer.id}"
    name = "hostname1"
}

resource "oci_load_balancer_hostname" "hostname2" {
    #Required
    hostname = "app2.example.com"
    load_balancer_id = "${oci_load_balancer.ProdLoadBalancer.id}"
    name = "hostname2"
}

resource "oci_load_balancer_listener" "lb-listener1" {
  load_balancer_id         = "${oci_load_balancer.ProdLoadBalancer.id}"
  name                     = "http"
  default_backend_set_name = "${oci_load_balancer_backend_set.lb-bes1.id}"
  hostname_names           = ["${oci_load_balancer_hostname.hostname1.name}", "${oci_load_balancer_hostname.hostname2.name}"]
  port                     = 80
  protocol                 = "HTTP"
  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
}

resource "oci_load_balancer_listener" "lb-listener2" {
  load_balancer_id         = "${oci_load_balancer.ProdLoadBalancer.id}"
  name                     = "https"
  default_backend_set_name = "${oci_load_balancer_backend_set.lb-bes1.id}"
  port                     = 443
  protocol                 = "HTTP"

#   ssl_configuration {
#     certificate_name        = "${oci_load_balancer_certificate.lb-cert1.certificate_name}"
#     verify_peer_certificate = false
#   }
}

resource "oci_load_balancer_backend" "lb-be1" {
  load_balancer_id = "${oci_load_balancer.ProdLoadBalancer.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes1.id}"
  ip_address       = "${oci_core_instance.WebAppSvr01.private_ip}"
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_backend" "lb-be2" {
  load_balancer_id = "${oci_load_balancer.ProdLoadBalancer.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes1.id}"
  ip_address       = "${oci_core_instance.WebAppSvr02.private_ip}"
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}



# ------ Display the public IP of instance

output " Public IP of Load Balancer " {
  value = ["${oci_load_balancer.ProdLoadBalancer.id}"]

}
