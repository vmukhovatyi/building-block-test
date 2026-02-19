variable "project_id" {
  description = <<-EOD
    Google Cloud project ID where to create the technical DNS zone.
  EOD
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,30}[a-z0-9]", var.project_id))
    error_message = <<-EOM
      It must be 6 to 30 lowercase letters, digits, or hyphens. It must start with a letter.
      Trailing hyphens are prohibited.
    EOM
  }
}

variable "root_zone_project" {
  description = <<-EOD
    Google Cloud project ID that holds the root zone.
  EOD
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,30}[a-z0-9]", var.root_zone_project))
    error_message = <<-EOM
      It must be 6 to 30 lowercase letters, digits, or hyphens. It must start with a letter.
      Trailing hyphens are prohibited.
    EOM
  }
}