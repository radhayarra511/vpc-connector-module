locals {
vpc_connectors = {
              for x in var.vpc_connectors :
              "${x.connector_name}" => x
}            
}
resource "google_vpc_access_connector" "connector_beta" {
  for_each      = local.vpc_connectors
  provider      = google-beta
  name          = each.value.connector_name
  project       = var.project_id
  region        = each.value.region
  ip_cidr_range = lookup(each.value, "ip_cidr_range", null)
  network       = lookup(each.value, "host_network", null)
  dynamic "subnet" {
    for_each = each.value.subnet_name == null ? [] : [each.value]
    content {
      name       = each.value.subnet_name
      project_id = lookup(each.value, "host_project_id", null)
    }
  }
  machine_type   = lookup(each.value, "machine_type", null)
  min_instances  = lookup(each.value, "min_instances", null)
  max_instances  = lookup(each.value, "max_instances", null)
  max_throughput = lookup(each.value, "max_throughput", null)
}

