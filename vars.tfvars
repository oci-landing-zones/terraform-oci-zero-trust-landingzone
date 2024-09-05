# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

#If cloud guard is enabled, deploy security zones 
# Expose SSH public key in firewall instance


# Provider Identity parameters 

tenancy_ocid         = "ocid1.tenancy.oc1.."
user_ocid            = "ocid1.user.oc1.."
fingerprint          = ""
private_key_path     = "path_to_key"
private_key_password = ""


# General Parameters
region        = "us-phoenix-1"
service_label = "ztlz"
cis_level     = 1

# Security VCN Parameters
add_tt_vcn1               = true
tt_vcn1_name              = "sec-vcn"
tt_vcn1_cidrs             = ["10.0.0.0/20"]
tt_vcn1_dns               = "security"
tt_vcn1_attach_to_drg     = true
tt_vcn1_routable_vcns     = []
customize_tt_vcn1_subnets = false

# Shared Service VCN Parameters
add_tt_vcn2               = true
tt_vcn2_name              = "shared-services-vcn"
tt_vcn2_cidrs             = ["10.1.0.0/20"]
tt_vcn2_dns               = "shared"
tt_vcn2_attach_to_drg     = true
tt_vcn2_routable_vcns     = ["TT-VCN-1", "TT-VCN-3", "OKE-VCN-1"]
customize_tt_vcn2_subnets = false

# App VCN Parameters
add_tt_vcn3               = true
tt_vcn3_name              = "app1-vcn"
tt_vcn3_cidrs             = ["10.2.0.0/20"]
tt_vcn3_dns               = "app1"
tt_vcn3_attach_to_drg     = true
tt_vcn3_routable_vcns     = ["TT-VCN2", "TT-VCN1"]
customize_tt_vcn3_subnets = false

# Hub & Spoke Parameters

hub_deployment_option     = "Yes, new VCN as hub with new DRG"
hub_vcn_name              = "zt-hub-vcn"
hub_vcn_dns               = ""
hub_vcn_cidrs             = ["192.168.0.0/26"]
customize_hub_vcn_subnets = false
#hub_vcn_deploy_firewall_option = "Fortinet FortiGate Firewall"
hub_vcn_deploy_firewall_option = "No"
fw_instance_shape              = "VM.Standard.E4.Flex"
fw_instance_flex_shape_memory  = 16
fw_instance_flex_shape_cpu     = 4
fw_instance_boot_volume_size   = 20
fw_instance_public_rsa_key     = "key"

#OKE VCN Parameters

add_oke_vcn1           = false
oke_vcn1_cni_type      = "Native"
oke_vcn1_name          = "app2-vcn"
oke_vcn1_cidrs         = ["10.3.0.0/16"]
oke_vcn1_dns           = "app2"
oke_vcn1_attach_to_drg = true
oke_vcn1_routable_vcns = ["TT-VCN-2", "TT-VCN-1"]

# Cloud Guard Parameters
enable_cloud_guard            = false
enable_service_connector      = true
activate_service_connector    = false
service_connector_target_kind = "streaming"

# Security Zone

enable_security_zones           = true
security_zones_reporting_region = ""


#VSS

vss_create                                  = true
vss_scan_schedule                           = "WEEKLY"
vss_scan_day                                = "SUNDAY"
vss_port_scan_level                         = "STANDARD"
vss_agent_scan_level                        = "STANDARD"
vss_agent_cis_benchmark_settings_scan_level = "MEDIUM"
vss_enable_file_scan                        = false
create_budget                               = false

network_admin_email_endpoints  = ["example@email.com"]
security_admin_email_endpoints = ["example@email.com"]
