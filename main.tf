# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "zero-trust-landing-zone" {
  source = "github.com/oci-landing-zones/terraform-oci-core-landingzone"

  # ZT Identification
  lz_provenant_prefix  = "ZTLZ"
  lz_provenant_version = "1.0"

  # GENERAL #
  tenancy_ocid                      = var.tenancy_ocid
  user_ocid                         = var.user_ocid
  fingerprint                       = var.fingerprint
  private_key_path                  = var.private_key_path
  private_key_password              = var.private_key_password
  region                            = var.region
  service_label                     = var.service_label
  cis_level                         = var.cis_level
  extend_landing_zone_to_new_region = var.extend_landing_zone_to_new_region
  customize_iam                     = var.customize_iam
  define_net                        = var.define_net
  display_output                    = var.display_output



  # IAM #
  enclosing_compartment_options                        = var.enclosing_compartment_options
  enclosing_compartment_parent_ocid                    = var.enclosing_compartment_parent_ocid
  existing_enclosing_compartment_ocid                  = var.existing_enclosing_compartment_ocid
  deploy_exainfra_cmp                                  = var.deploy_exainfra_cmp
  use_custom_id_domain                                 = var.use_custom_id_domain
  custom_id_domain_ocid                                = var.custom_id_domain_ocid
  rm_existing_id_domain_iam_admin_group_name           = var.rm_existing_id_domain_iam_admin_group_name
  rm_existing_id_domain_cred_admin_group_name          = var.rm_existing_id_domain_cred_admin_group_name
  rm_existing_id_domain_security_admin_group_name      = var.rm_existing_id_domain_security_admin_group_name
  rm_existing_id_domain_network_admin_group_name       = var.rm_existing_id_domain_network_admin_group_name
  rm_existing_id_domain_appdev_admin_group_name        = var.rm_existing_id_domain_appdev_admin_group_name
  rm_existing_id_domain_database_admin_group_name      = var.rm_existing_id_domain_database_admin_group_name
  rm_existing_id_domain_auditor_group_name             = var.rm_existing_id_domain_auditor_group_name
  rm_existing_id_domain_announcement_reader_group_name = var.rm_existing_id_domain_announcement_reader_group_name
  rm_existing_id_domain_exainfra_admin_group_name      = var.rm_existing_id_domain_exainfra_admin_group_name
  rm_existing_id_domain_cost_admin_group_name          = var.rm_existing_id_domain_cost_admin_group_name
  rm_existing_id_domain_storage_admin_group_name       = var.rm_existing_id_domain_storage_admin_group_name
  existing_id_domain_security_fun_dyn_group_name       = var.existing_id_domain_security_fun_dyn_group_name
  existing_id_domain_appdev_fun_dyn_group_name         = var.existing_id_domain_appdev_fun_dyn_group_name
  existing_id_domain_compute_agent_dyn_group_name      = var.existing_id_domain_compute_agent_dyn_group_name
  existing_id_domain_database_kms_dyn_group_name       = var.existing_id_domain_database_kms_dyn_group_name
  rm_existing_id_domain_ag_admin_group_name            = var.rm_existing_id_domain_ag_admin_group_name
  existing_id_domain_net_fw_app_dyn_group_name         = var.existing_id_domain_net_fw_app_dyn_group_name
  rm_existing_ag_admin_group_name                      = var.rm_existing_ag_admin_group_name
  existing_ag_admin_group_name                         = var.existing_ag_admin_group_name
  existing_net_fw_app_dyn_group_name                   = var.existing_net_fw_app_dyn_group_name
  groups_options                                       = var.groups_options
  rm_existing_iam_admin_group_name                     = var.rm_existing_iam_admin_group_name
  existing_iam_admin_group_name                        = var.existing_iam_admin_group_name
  rm_existing_cred_admin_group_name                    = var.rm_existing_cred_admin_group_name
  existing_cred_admin_group_name                       = var.existing_cred_admin_group_name
  rm_existing_security_admin_group_name                = var.rm_existing_security_admin_group_name
  existing_security_admin_group_name                   = var.existing_security_admin_group_name
  rm_existing_network_admin_group_name                 = var.rm_existing_network_admin_group_name
  existing_network_admin_group_name                    = var.existing_network_admin_group_name
  rm_existing_appdev_admin_group_name                  = var.rm_existing_appdev_admin_group_name
  existing_appdev_admin_group_name                     = var.existing_appdev_admin_group_name
  rm_existing_database_admin_group_name                = var.rm_existing_database_admin_group_name
  existing_database_admin_group_name                   = var.existing_database_admin_group_name
  rm_existing_auditor_group_name                       = var.rm_existing_auditor_group_name
  existing_auditor_group_name                          = var.existing_auditor_group_name
  rm_existing_cost_admin_group_name                    = var.rm_existing_cost_admin_group_name
  rm_existing_storage_admin_group_name                 = var.rm_existing_storage_admin_group_name
  existing_security_fun_dyn_group_name                 = var.existing_security_fun_dyn_group_name
  existing_appdev_fun_dyn_group_name                   = var.existing_appdev_fun_dyn_group_name
  existing_compute_agent_dyn_group_name                = var.existing_compute_agent_dyn_group_name
  existing_database_kms_dyn_group_name                 = var.existing_database_kms_dyn_group_name

  # POLICIES #
  policies_in_root_compartment = var.policies_in_root_compartment

  # NET_THREE_TIER_VCNS #
  add_tt_vcn1                                   = var.add_tt_vcn1
  tt_vcn1_name                                  = var.tt_vcn1_name
  tt_vcn1_cidrs                                 = var.tt_vcn1_cidrs
  tt_vcn1_attach_to_drg                         = var.tt_vcn1_attach_to_drg
  tt_vcn1_routable_vcns                         = var.tt_vcn1_routable_vcns
  customize_tt_vcn1_subnets                     = var.customize_tt_vcn1_subnets
  tt_vcn1_web_subnet_name                       = var.tt_vcn1_web_subnet_name
  tt_vcn1_web_subnet_cidr                       = var.tt_vcn1_web_subnet_cidr
  tt_vcn1_web_subnet_is_private                 = var.tt_vcn1_web_subnet_is_private
  tt_vcn1_app_subnet_name                       = var.tt_vcn1_app_subnet_name
  tt_vcn1_app_subnet_cidr                       = var.tt_vcn1_app_subnet_cidr
  tt_vcn1_db_subnet_name                        = var.tt_vcn1_db_subnet_name
  tt_vcn1_db_subnet_cidr                        = var.tt_vcn1_db_subnet_cidr
  deploy_tt_vcn1_bastion_subnet                 = var.deploy_tt_vcn1_bastion_subnet
  tt_vcn1_bastion_subnet_name                   = var.tt_vcn1_bastion_subnet_name
  tt_vcn1_bastion_subnet_cidr                   = var.tt_vcn1_bastion_subnet_cidr
  tt_vcn1_bastion_subnet_allowed_cidrs          = var.tt_vcn1_bastion_subnet_allowed_cidrs
  tt_vcn1_bastion_is_access_via_public_endpoint = var.tt_vcn1_bastion_is_access_via_public_endpoint

  add_tt_vcn2                                   = var.add_tt_vcn2
  tt_vcn2_name                                  = var.tt_vcn2_name
  tt_vcn2_cidrs                                 = var.tt_vcn2_cidrs
  tt_vcn2_attach_to_drg                         = var.tt_vcn2_attach_to_drg
  tt_vcn2_routable_vcns                         = var.tt_vcn2_routable_vcns
  customize_tt_vcn2_subnets                     = var.customize_tt_vcn2_subnets
  tt_vcn2_web_subnet_name                       = var.tt_vcn2_web_subnet_name
  tt_vcn2_web_subnet_cidr                       = var.tt_vcn2_web_subnet_cidr
  tt_vcn2_web_subnet_is_private                 = var.tt_vcn2_web_subnet_is_private
  tt_vcn2_app_subnet_name                       = var.tt_vcn2_app_subnet_name
  tt_vcn2_app_subnet_cidr                       = var.tt_vcn2_app_subnet_cidr
  tt_vcn2_db_subnet_name                        = var.tt_vcn2_db_subnet_name
  tt_vcn2_db_subnet_cidr                        = var.tt_vcn2_db_subnet_cidr
  deploy_tt_vcn2_bastion_subnet                 = var.deploy_tt_vcn2_bastion_subnet
  tt_vcn2_bastion_subnet_name                   = var.tt_vcn2_bastion_subnet_name
  tt_vcn2_bastion_subnet_cidr                   = var.tt_vcn2_bastion_subnet_cidr
  tt_vcn2_bastion_subnet_allowed_cidrs          = var.tt_vcn2_bastion_subnet_allowed_cidrs
  tt_vcn2_bastion_is_access_via_public_endpoint = var.tt_vcn2_bastion_is_access_via_public_endpoint

  add_tt_vcn3                                   = var.add_tt_vcn3
  tt_vcn3_name                                  = var.tt_vcn3_name
  tt_vcn3_cidrs                                 = var.tt_vcn3_cidrs
  tt_vcn3_attach_to_drg                         = var.tt_vcn3_attach_to_drg
  tt_vcn3_routable_vcns                         = var.tt_vcn3_routable_vcns
  customize_tt_vcn3_subnets                     = var.customize_tt_vcn3_subnets
  tt_vcn3_web_subnet_name                       = var.tt_vcn3_web_subnet_name
  tt_vcn3_web_subnet_cidr                       = var.tt_vcn3_web_subnet_cidr
  tt_vcn3_web_subnet_is_private                 = var.tt_vcn3_web_subnet_is_private
  tt_vcn3_app_subnet_name                       = var.tt_vcn3_app_subnet_name
  tt_vcn3_app_subnet_cidr                       = var.tt_vcn3_app_subnet_cidr
  tt_vcn3_db_subnet_name                        = var.tt_vcn3_db_subnet_name
  tt_vcn3_db_subnet_cidr                        = var.tt_vcn3_db_subnet_cidr
  deploy_tt_vcn3_bastion_subnet                 = var.deploy_tt_vcn3_bastion_subnet
  tt_vcn3_bastion_subnet_name                   = var.tt_vcn3_bastion_subnet_name
  tt_vcn3_bastion_subnet_cidr                   = var.tt_vcn3_bastion_subnet_cidr
  tt_vcn3_bastion_subnet_allowed_cidrs          = var.tt_vcn3_bastion_subnet_allowed_cidrs
  tt_vcn3_bastion_is_access_via_public_endpoint = var.tt_vcn3_bastion_is_access_via_public_endpoint
  net_appliance_public_rsa_key                  = var.net_appliance_public_rsa_key
  net_appliance_name_prefix                     = var.net_appliance_name_prefix
  net_appliance_shape                           = var.net_appliance_shape
  net_appliance_flex_shape_memory               = var.net_appliance_flex_shape_memory
  net_appliance_flex_shape_cpu                  = var.net_appliance_flex_shape_cpu
  net_appliance_boot_volume_size                = var.net_appliance_boot_volume_size

  # SECURITY #
  enable_security_zones             = var.enable_security_zones
  sz_security_policies              = var.sz_security_policies
  security_zones_reporting_region   = var.security_zones_reporting_region
  enable_cloud_guard                = var.enable_cloud_guard
  enable_cloud_guard_cloned_recipes = var.enable_cloud_guard_cloned_recipes
  cloud_guard_reporting_region      = var.cloud_guard_reporting_region
  cloud_guard_risk_level_threshold  = var.cloud_guard_risk_level_threshold
  cloud_guard_admin_email_endpoints = var.cloud_guard_admin_email_endpoints

  # VSS #
  vss_create                                  = var.vss_create
  vss_scan_schedule                           = var.vss_scan_schedule
  vss_scan_day                                = var.vss_scan_day
  vss_port_scan_level                         = var.vss_port_scan_level
  vss_agent_scan_level                        = var.vss_agent_scan_level
  vss_agent_cis_benchmark_settings_scan_level = var.vss_agent_cis_benchmark_settings_scan_level
  vss_enable_file_scan                        = var.vss_enable_file_scan
  vss_folders_to_scan                         = var.vss_folders_to_scan

  # Alerts #
  network_admin_email_endpoints  = var.network_admin_email_endpoints
  security_admin_email_endpoints = var.security_admin_email_endpoints
  storage_admin_email_endpoints  = var.storage_admin_email_endpoints
  compute_admin_email_endpoints  = var.compute_admin_email_endpoints
  budget_admin_email_endpoints   = var.budget_admin_email_endpoints
  database_admin_email_endpoints = var.database_admin_email_endpoints
  exainfra_admin_email_endpoints = var.exainfra_admin_email_endpoints
  create_alarms_as_enabled       = var.create_alarms_as_enabled
  create_events_as_enabled       = var.create_events_as_enabled
  alarm_message_format           = var.alarm_message_format
  notifications_advanced_options = var.notifications_advanced_options
  budget_alert_threshold         = var.budget_alert_threshold


  # HUB VCN #
  hub_deployment_option                              = var.hub_deployment_option
  hub_vcn_name                                       = var.hub_vcn_name
  hub_vcn_cidrs                                      = var.hub_vcn_cidrs
  customize_hub_vcn_subnets                          = var.customize_hub_vcn_subnets
  hub_vcn_web_subnet_name                            = var.hub_vcn_web_subnet_name
  hub_vcn_web_subnet_cidr                            = var.hub_vcn_web_subnet_cidr
  hub_vcn_web_subnet_is_private                      = var.hub_vcn_web_subnet_is_private
  hub_vcn_web_subnet_jump_host_allowed_cidrs         = var.hub_vcn_web_subnet_jump_host_allowed_cidrs
  hub_vcn_mgmt_subnet_name                           = var.hub_vcn_mgmt_subnet_name
  hub_vcn_mgmt_subnet_cidr                           = var.hub_vcn_mgmt_subnet_cidr
  hub_vcn_mgmt_subnet_external_allowed_cidrs_for_ssh = var.hub_vcn_mgmt_subnet_external_allowed_cidrs_for_ssh
  hub_vcn_outdoor_subnet_name                        = var.hub_vcn_outdoor_subnet_name
  hub_vcn_outdoor_subnet_cidr                        = var.hub_vcn_outdoor_subnet_cidr
  hub_vcn_indoor_subnet_name                         = var.hub_vcn_indoor_subnet_name
  hub_vcn_indoor_subnet_cidr                         = var.hub_vcn_indoor_subnet_cidr
  hub_vcn_deploy_net_appliance_option                = var.hub_vcn_deploy_net_appliance_option
  hub_vcn_north_south_entry_point_ocid               = var.hub_vcn_north_south_entry_point_ocid
  hub_vcn_east_west_entry_point_ocid                 = var.hub_vcn_east_west_entry_point_ocid


  add_oke_vcn1           = var.add_oke_vcn1
  oke_vcn1_cni_type      = var.oke_vcn1_cni_type
  oke_vcn1_name          = var.oke_vcn1_name
  oke_vcn1_cidrs         = var.oke_vcn1_cidrs
  oke_vcn1_attach_to_drg = var.oke_vcn1_attach_to_drg
  oke_vcn1_routable_vcns = var.oke_vcn1_routable_vcns


  # SERVICE CONNECTOR HUB #
  enable_service_connector                               = var.enable_service_connector
  activate_service_connector                             = var.activate_service_connector
  service_connector_target_kind                          = var.service_connector_target_kind
  onboard_logging_analytics                              = var.onboard_logging_analytics
  existing_service_connector_bucket_vault_compartment_id = var.existing_service_connector_bucket_vault_compartment_id
  existing_service_connector_bucket_vault_id             = var.existing_service_connector_bucket_vault_id
  existing_service_connector_bucket_key_id               = var.existing_service_connector_bucket_key_id
  existing_service_connector_target_stream_id            = var.existing_service_connector_target_stream_id
  existing_service_connector_target_function_id          = var.existing_service_connector_target_function_id

  # Budget #
  budget_alert_email_endpoints = var.budget_alert_email_endpoints
  budget_amount                = var.budget_amount
  create_budget                = var.create_budget

}