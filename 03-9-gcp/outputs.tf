output "url_webshop" {
  value = google_compute_instance.webshop.network_interface.0.access_config.0.nat_ip
}
