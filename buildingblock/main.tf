terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

resource "google_project_service" "dns" {
  service            = "dns.googleapis.com"
  project            = var.project_id
  disable_on_destroy = false
}

data "google_dns_managed_zone" "root_zone" {
  name    = "cf-technical-dns"
  project = var.root_zone_project
}

resource "google_dns_managed_zone" "technical_dns_zone" {
  dns_name   = format("%s.%s", var.project_id, data.google_dns_managed_zone.root_zone.dns_name)
  name       = "cf-technical-dns"
  description = "Technical DNS zone provided by Cloud Services and Support team via building block"
  project    = var.project_id
  depends_on = [google_project_service.dns]
}

data "google_dns_record_set" "technical_dns_zone_nameservers" {
  managed_zone = google_dns_managed_zone.technical_dns_zone.name
  project      = var.project_id
  name         = google_dns_managed_zone.technical_dns_zone.dns_name
  type         = "NS"
}

resource "google_dns_record_set" "zone_delegation" {
  managed_zone = data.google_dns_managed_zone.root_zone.name
  name         = google_dns_managed_zone.technical_dns_zone.dns_name
  type         = "NS"
  rrdatas      = data.google_dns_record_set.technical_dns_zone_nameservers.rrdatas
  project      = var.root_zone_project
}
