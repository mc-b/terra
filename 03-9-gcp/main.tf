terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.5"
    }
  }

  required_version = ">= 0.14.9"
}

provider "google" {
  project = "<PROJECT_ID>"
  region  = "us-east1"
}

# VPC inkl. Zugriff via Internet. Braucht alle drei Eintraege damit es funktioniert

resource "google_compute_network" "webshop" {
  name                    = "webshop"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "webshop_intern" {
  name          = "webshop-intern"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.webshop.self_link
}

# Interne Firewall-Regel für SSH und HTTP

resource "google_compute_firewall" "webshop_intern" {
  name    = "webshop-intern"
  network = google_compute_network.webshop.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["10.0.1.0/24"]
}

# Externe Firewall-Regel für SSH und HTTP

resource "google_compute_firewall" "webshop" {
  name    = "webshop"
  network = google_compute_network.webshop.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# VMs

resource "google_compute_instance" "order" {
  name         = "order"
  machine_type = "e2-micro"
  zone         = "us-east1-b"
  tags         = ["order"]

  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20240319"
      size  = 10
    }
  }

  network_interface {
    network = google_compute_network.webshop.self_link
    access_config {
      // Hier kannst du die Einstellungen für die öffentliche IP-Adresse konfigurieren
    }
  }

  metadata = {
    // Hier kannst du die Benutzerdaten konfigurieren
  }
}

resource "google_compute_instance" "customer" {
  name         = "customer"
  machine_type = "e2-micro"
  zone         = "us-east1-b"
  tags         = ["customer"]

  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20240319"
      size  = 10
    }
  }

  network_interface {
    network = google_compute_network.webshop.self_link
    access_config {
      // Hier kannst du die Einstellungen für die öffentliche IP-Adresse konfigurieren
    }
  }

  metadata = {
    // Hier kannst du die Benutzerdaten konfigurieren
  }
}

resource "google_compute_instance" "catalog" {
  name         = "catalog"
  machine_type = "e2-micro"
  zone         = "us-east1-b"
  tags         = ["catalog"]

  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20240319"
      size  = 10
    }
  }

  network_interface {
    network = google_compute_network.webshop.self_link
    access_config {
      // Hier kannst du die Einstellungen für die öffentliche IP-Adresse konfigurieren
    }
  }

  metadata = {
    // Hier kannst du die Benutzerdaten konfigurieren
  }
}

resource "google_compute_instance" "webshop" {
  name         = "webshop"
  machine_type = "e2-micro"
  zone         = "us-east1-b"
  tags         = ["webshop"]

  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20240319"
      size  = 10
    }
  }

  network_interface {
    network = google_compute_network.webshop.self_link
    access_config {
      // Hier kannst du die Einstellungen für die öffentliche IP-Adresse konfigurieren
    }
  }

  metadata = {
    // Hier kannst du die Benutzerdaten konfigurieren
  }
}
