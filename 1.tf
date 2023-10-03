# Set the GCP project and region
provider "google" {
  credentials = file("path/to/your/credentials.json")
  project     = "your-project-id"
  region      = "us-central1"
}

# Create a small Windows instance
resource "google_compute_instance" "windows_instance" {
  name         = "windows-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2019"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    # Custom startup script for Windows
    echo "Custom startup script executed." > /tmp/startup-script.log
    EOF
}

# Allow RDP traffic 
resource "google_compute_firewall" "allow-rdp" {
  name    = "allow-rdp"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
#whitelist
  source_ranges = ["0.0.0.0/0"]
}

# Provisioning script to install Burp Suite Professional on Windows
resource "google_compute_instance" "windows_instance" {
  connection {
    type        = "winrm"
    user        = ""  # Replace
    password    = ""  # Replace 
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      # Download the Burp Suite Professional installer 
      "wgethttps://portswigger-cdn.net/burp/releases/download?product=pro&version=2023.10.2.1&type=WindowsX64 -O C:\\burp_installer.exe",
      
      # Install Burp Suite silently
      "C:\\burp_installer.exe /S",

      # Remove the installer
      "Remove-Item C:\\burp_installer.exe"
    ]
  }
}


path/to/your/credentials.json: The path to your GCP service account key JSON file.
your-project-id: Your GCP project ID.
username and password: Replace these with the username and password you use for the Windows instance.





