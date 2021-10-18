resource "random_id" "random_bucket_name" {
  byte_length = 4
}

resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = "10.10.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc.name

  private_ip_google_access = true

  # log_config {
  #   aggregation_interval = "INTERVAL_10_MIN"
  #   flow_sampling        = 0.5
  #   metadata             = "INCLUDE_ALL_METADATA"
  # }
}

resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_instance" "gce" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      # image = "rhel-cloud/rhel-7"
      image = "debian-cloud/debian-10"
    }
  }
  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {
      // Ephemeral public IP
    }
  }
  tags = ["ssh"]
}

resource "google_compute_instance" "gce_large" {
  name         = var.instance_name
  machine_type = "n2-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "rhel-cloud/rhel-7"
    }
  }
  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {
      // Ephemeral public IP
    }
  }
  tags = ["ssh"]
}


resource "google_storage_bucket" "gcs" {
  name     = "gcs-tf-lab-${random_id.random_bucket_name.hex}"
  location = "ASIA"
  # location = "US"
  force_destroy = false

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 3
    }

    action {
      type = "Delete"
    }
  }

}
