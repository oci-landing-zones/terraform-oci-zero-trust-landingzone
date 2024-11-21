# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# -------------------------------------------------------------------------------------
# -- This configuration deploys the Zero Trust Landing Zone.
# -- A hub and a three tier VCN are deployed.
# -- See other templates for other CIS compliant landing zones with custom settings.
# -- 1. Provide/review the variable assignments below.
#       * Environment variables
#       * Notification variables
#       * Uncomment the section of Network Appliance Option: Fortinet FortiGate Firewall (line 47-53) if deploying Fortinet Firewall,
#       * Uncomment the section of Network Appliance Option: Palo Alto Networks VM-Series Firewall (line 59-65) if deploying Palo Alto Firewall
# -- 2. In this folder, execute the typical Terraform workflow:
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
  tenancy_ocid         = "ocid1.tenancy.oc1..aaaaaaaahbsqqoq6hngruus5z4e3zclij32obawvlsxsrz4culbvq5k5p2ia" # Replace with your tenancy OCID.
  user_ocid            = "ocid1.user.oc1..aaaaaaaacm7yvg4f5tvm4jdf4qsnuo47fsywie7ldniit4nkfnt64hbrdg6q" # Replace with your user OCID.
  fingerprint          = "d4:ce:c1:ad:79:c3:6a:fd:f5:57:46:0b:e5:b4:c3:26" # Replace with user fingerprint.
  private_key_path     = "/Users/yupeyang/.oci/oci_api_key.pem" # Replace with user private key local path.
  private_key_password = "" # Replace with private key password, if any.
  region               = "us-phoenix-1" # Replace with region name.
  service_label        = "ztcli" # Prefix prepended to deployed resource names.

  # ------------------------------------------------------
  # ----- General
  # ------------------------------------------------------
  cis_level = 1 # Options: 1, 2

  # ------------------------------------------------------
  # ----- Hub Deployment Option
  # ------------------------------------------------------
  # hub_deployment
  #  - 3: "VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)"
  #  - 4: "VCN or on-premises connectivity routed through DMZ VCN with Network Virtual Appliance existing DRG (DMZ VCN will be created and DRG ID required)"
  hub_deployment = 3
  # existing_drg_ocid = "" # please enter the drg ocid if the hub_deployment = 4

  # -----------------------------------------------------------
  # ----- Network Appliance Option: Fortinet FortiGate Firewall
  # -----------------------------------------------------------
  hub_vcn_deploy_net_appliance_option = "Fortinet FortiGate Firewall"
  net_fortigate_version               = "7.2.9_(_X64_)" # Option: "7.4.4_(_X64_)", "7.2.9_(_X64_)"
  net_appliance_flex_shape_memory     = 56
  net_appliance_flex_shape_cpu        = 4
  net_appliance_boot_volume_size      = 60
  net_appliance_public_rsa_key        = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMffzPTbnVZdf8HWXnCzdWYrCUdYRNPEaqhEOIF3CS7t <yupei.yang@oracle.com>" #Enter the Public RSA Key
  net_appliance_shape                 = "VM.Standard.E4.Flex"

  # ---------------------------------------------------------------------
  # ----- Network Appliance Option: Palo Alto Networks VM-Series Firewall
  # ---------------------------------------------------------------------
  # hub_vcn_deploy_net_appliance_option = "Palo Alto Networks VM-Series Firewall"
  # net_palo_alto_version               = "11.1.3"  # Option: "11.1.2-h3", "11.1.3"
  # net_appliance_flex_shape_memory     = 56
  # net_appliance_flex_shape_cpu        = 4
  # net_appliance_boot_volume_size      = 60
  # net_appliance_public_rsa_key        = "" #Enter the Public RSA Key
  # net_appliance_shape                 = "VM.Standard2.4"

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
  enable_cloud_guard    = false # Set to false if Cloud Guard has already been enabled.
  enable_security_zones = true # Deploys a security zone for this deployment in the enclosing compartment.
  vss_create            = true # Enables Vulnerability Scanning Service for Compute instances.

  # ------------------------------------------------------
  # ----- Governance
  # ------------------------------------------------------
  create_budget = true # Deploys a default budget.
}