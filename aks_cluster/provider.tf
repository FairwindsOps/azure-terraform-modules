terraform {
  required_version = ">= 0.12"
  required_providers {
    azurerm = ">=2.0.0"
    azuread = ">= 0.3"
  }
}

provider "azurerm" {
  features {}
}
