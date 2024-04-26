

# VPC inkl. Zugriff via Internet

resource "google_compute_network" "webshop" {
  name = "webshop-network"
}

resource "google_compute_subnetwork" "webshop_intern" {
  name          = "webshop-intern-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.webshop.self_link
}

# Ausgehender Verkehr zulassen auch ohne Public IP

resource "google_compute_router" "webshop_router" {
  name    = "webshop-router"
  network = google_compute_network.webshop.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "webshop_nat" {
  name                               = "webshop-router-nat"
  router                             = google_compute_router.webshop_router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Firewall-Regeln für den internen Zugriff

resource "google_compute_firewall" "webshop_intern" {
  name    = "webshop-intern-fw"
  network = google_compute_network.webshop.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["10.0.1.0/24"]
}

# Firewall-Regeln für externen Zugriff

resource "google_compute_firewall" "webshop" {
  name    = "webshop-fw"
  network = google_compute_network.webshop.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# VMs

resource "google_compute_instance" "order" {
  name         = "order"
  machine_type = "f1-micro"
  zone         = "us-east1-b" // Die gewünschte Zone in der GCP

  boot_disk {
    initialize_params {
      image = var.image
      size  = 10
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.webshop_intern.self_link
  }

  metadata = {
    user-data = data.template_file.order.rendered
  }
}

resource "google_compute_instance" "customer" {
  name         = "customer"
  machine_type = "f1-micro"
  zone         = "us-east1-b" // Die gewünschte Zone in der GCP
  boot_disk {
    initialize_params {
      image = var.image
      size  = 10
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.webshop_intern.self_link
  }
  metadata = {
    user-data = data.template_file.customer.rendered
  }
}

resource "google_compute_instance" "catalog" {
  name         = "catalog"
  machine_type = "f1-micro"
  zone         = "us-east1-b" // Die gewünschte Zone in der GCP
  boot_disk {
    initialize_params {
      image = var.image
      size  = 10
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.webshop_intern.self_link
  }
  metadata = {
    user-data = data.template_file.catalog.rendered
  }
}

resource "google_compute_instance" "webshop" {
  name         = "webshop"
  machine_type = "f1-micro"
  zone         = "us-east1-b" // Die gewünschte Zone in der GCP
  boot_disk {
    initialize_params {
      image = var.image
      size  = 10
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.webshop_intern.self_link
    access_config {
      // Ermöglicht das Zuweisen einer externen IP-Adresse
    }
  }

  metadata = {
    user-data = data.template_file.webshop.rendered
  }
}
