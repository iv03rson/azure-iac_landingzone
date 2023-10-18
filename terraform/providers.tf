provider "azuread" {
  tenant_id =  ""
}

provider "azurerm" {
  features {}
  alias           = "hub"
  subscription_id = ""
}

provider "azurerm" {
  features {}
  alias           = ""
  subscription_id = ""
}