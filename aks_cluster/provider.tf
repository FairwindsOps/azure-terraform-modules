terraform {
  required_version = ">= 0.12"
}

provider "azurerm" {
  version = "~> 2.0.0"
  features {}
}

provider "azuread" {
  version = "~> 0.4"
}
