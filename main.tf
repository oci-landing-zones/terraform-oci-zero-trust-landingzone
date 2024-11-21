# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# -------------------------------------------------------------------------------------
# -- This configuration deploys the most basic CIS compliant landing zone.
# -- No VCN is deployed.
# -- See other templates for other CIS compliant landing zones with custom settings.
# -- 1. Rename this file to main.tf.
# -- 2. Provide/review the variable assignments below.
# -- 3. In this folder, execute the typical Terraform workflow:
# ----- $ terraform init
# ----- $ terraform plan
# ----- $ terraform apply
# Please read the DEPLOYMENT-GUIDE.md for more variable configuration info.
# -------------------------------------------------------------------------------------

module "zero_trust_landing_zone" {
  source = "github.com/oci-landing-zones/terraform-oci-core-landingzone?ref=v1.1.0"
  # ------------------------------------------------------
  # ----- Environment
  # ------------------------------------------------------
  tenancy_ocid         = "" # Replace with your tenancy OCID.
  user_ocid            = "" # Replace with your user OCID.
  fingerprint          = "" # Replace with user fingerprint.
  private_key_path     = "" # Replace with user private key local path.
  private_key_password = "" # Replace with private key password, if any.
  region               = "" # Replace with region name.
  service_label        = "" # Prefix prepended to deployed resource names.

  # ------------------------------------------------------
  # ----- General
  # ------------------------------------------------------
  cis_level = 2 # Options: 1, 2

  # ------------------------------------------------------
  # ----- Hub Deployment Option
  # ------------------------------------------------------
  # hub_deployment
  #  - 3: "VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)"
  #  - 4: "VCN or on-premises connectivity routed through DMZ VCN with Network Virtual Appliance existing DRG (DMZ VCN will be created and DRG ID required)"
  hub_deployment = 3
  # existing_drg_ocid = "" # please enter the drg ocid if the hub_deployment = 4

  # ------------------------------------------------------
  # ----- Network Appliance Option
  # ------------------------------------------------------
  hub_vcn_deploy_net_appliance_option = "Fortinet FortiGate Firewall" # Option: "Don't deploy any network appliance at this time", "Palo Alto Networks VM-Series Firewall", "Fortinet FortiGate Firewall"
  net_fortigate_version               = "7.2.9_(_X64_)"               # Option: "7.4.4_(_X64_)", "7.2.9_(_X64_)"
  # net_palo_alto_version               = "" # Option: "11.1.3", "11.1.2-h3"
  net_appliance_flex_shape_memory = 56
  net_appliance_flex_shape_cpu    = 4
  net_appliance_boot_volume_size  = 60
  net_appliance_public_rsa_key    = "" #Enter the Public RSA Key
  net_appliance_shape             = "VM.Standard.E4.Flex"

  # ------------------------------------------------------
  # ----- Networking
  # ------------------------------------------------------
  define_net            = true # enables network resources provisioning
  enable_zpr            = true # enables Zero Trust Packet Routing at the tenancy level
  add_tt_vcn1           = true # This deploys one three-tier VCN with default settings, like default name, CIDR, DNS name, subnet names, subnet CIDRs, subnet DNS names.
  tt_vcn1_attach_to_drg = true # attach three-tier VCN to the DRG

  # ------------------------------------------------------
  # ----- Notifications
  # ------------------------------------------------------
  network_admin_email_endpoints  = ["email.address@example.com"] # for network-related events. Replace with a real email address.
  security_admin_email_endpoints = ["email.address@example.com"] # for security-related events. Replace with a real email address.

  # ------------------------------------------------------
  # ----- Logging
  # ------------------------------------------------------
  enable_service_connector      = true        # Enables service connector for logging consolidation.
  activate_service_connector    = true        # Activates service connector.
  service_connector_target_kind = "streaming" # Options: 'streaming', 'objectstorage', 'functions' or 'logginganalytics'.


  # ------------------------------------------------------
  # ----- Security
  # ------------------------------------------------------
  enable_cloud_guard    = true # Set to false if Cloud Guard has already been enabled.
  enable_security_zones = true # Deploys a security zone for this deployment in the enclosing compartment.
  vss_create            = true # Enables Vulnerability Scanning Service for Compute instances.

  # ------------------------------------------------------
  # ----- Governance
  # ------------------------------------------------------
  create_budget = true # Deploys a default budget.
}