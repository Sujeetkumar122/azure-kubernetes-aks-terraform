# Production Hardened Azure Kubernetes Service (AKS)
# Author: Sujeet Kumar - Senior DevSecOps Engineer & Cloud Architect

resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.cluster_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = var.cluster_name
  kubernetes_version      = "1.28.5"
  private_cluster_enabled = true
  sku_tier                = "Standard"

  default_node_pool {
    name                = "systempool"
    node_count          = 3
    vm_size             = "Standard_D4s_v5"
    vnet_subnet_id      = var.vnet_subnet_id
    enable_auto_scaling = true
    min_count           = 3
    max_count           = 6
    os_disk_size_gb     = 128
    os_disk_type        = "Managed"
    type                = "VirtualMachineScaleSets"
    only_critical_addons_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"
    outbound_type     = "userDefinedRouting"
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  tags = var.tags
}

variable "cluster_name" {
  type    = string
  default = "aks-prod-eastus-01"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "resource_group_name" {
  type    = string
  default = "rg-aks-prod-eastus"
}

variable "vnet_subnet_id" {
  type    = string
  default = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-hub-connectivity-prod/providers/Microsoft.Network/virtualNetworks/vnet-spoke-app-eastus/subnets/snet-aks-nodes"
}

variable "log_analytics_workspace_id" {
  type    = string
  default = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-hub-connectivity-prod/providers/Microsoft.OperationalInsights/workspaces/log-analytics-prod"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Compliance  = "CIS-v2.0"
  }
}
