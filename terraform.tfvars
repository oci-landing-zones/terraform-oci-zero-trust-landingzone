customize_net = true

# Security VCN Parameters
add_tt_vcn1               = true
tt_vcn1_name              = "sec-vcn"
tt_vcn1_dns               = "security"
tt_vcn1_attach_to_drg     = true
tt_vcn1_routable_vcns     = []
customize_tt_vcn1_subnets = false

# Shared Service VCN Parameters
add_tt_vcn2               = true
tt_vcn2_name              = "shared-services-vcn"
tt_vcn2_dns               = "shared"
tt_vcn2_attach_to_drg     = true
tt_vcn2_routable_vcns     = ["TT-VCN-1", "TT-VCN-3", "OKE-VCN-1"]
customize_tt_vcn2_subnets = false

# App VCN Parameters
add_tt_vcn3               = true
tt_vcn3_name              = "app1-vcn"
tt_vcn3_dns               = "app1"
tt_vcn3_attach_to_drg     = true
tt_vcn3_routable_vcns     = ["TT-VCN2", "TT-VCN1"]
customize_tt_vcn3_subnets = false

# Hub & Spoke Parameters

hub_deployment_option     = "Yes, new VCN as hub with new DRG"
hub_vcn_name              = "zt-hub-vcn"
hub_vcn_dns               = ""
customize_hub_vcn_subnets = false


#OKE VCN Parameters
oke_vcn1_cni_type      = "Native"
oke_vcn1_name          = "app2-vcn"
oke_vcn1_cidrs         = ["10.3.0.0/16"]
oke_vcn1_dns           = "app2"
oke_vcn1_attach_to_drg = true
oke_vcn1_routable_vcns = ["TT-VCN-2", "TT-VCN-1"]

# Cloud Guard Parameters
enable_service_connector      = true
activate_service_connector    = false
service_connector_target_kind = "streaming"

#VSS
vss_create                                  = true
vss_scan_schedule                           = "WEEKLY"
vss_scan_day                                = "SUNDAY"
vss_port_scan_level                         = "STANDARD"
vss_agent_scan_level                        = "STANDARD"
vss_agent_cis_benchmark_settings_scan_level = "MEDIUM"
vss_enable_file_scan                        = false
