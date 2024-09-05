## <a name="config_input_variables"></a>Input Variables
Input variables used in the configuration of the Zero Trust Landing Zone in the **vars.tfvars** file. 

### <a name="tf_variables"></a>Terraform Provider Variables
Variable Name | Description | Required | Default Value
--------------|-------------|----------|--------------
**tenancy_ocid** | The OCI tenancy id where this configuration will be executed. This information can be obtained in OCI Console. | Yes | None
**user_ocid** | The OCI user id that will execute this configuration. This information can be obtained in OCI Console. The user must have the necessary privileges to provision the resources. | Yes | ""
**fingerprint** | The user's public key fingerprint. This information can be obtained in OCI Console. | Yes | ""
**private_key_path** | The local path to the user private key. | Yes | ""
**private_key_password** | The private key password, if any. | No | ""

### <a name="env_variables"></a>General Variables
Variable Name | Description | Required | Default Value
--------------|-------------|----------|--------------
**region** \* | The tenancy region identifier where the Terraform should provision the resources. | Yes | None
**service_label** | A label used as a prefix for naming resources. | Yes | "ztlz"
**cis_level** | Determines CIS OCI Benchmark Level to apply on Landing Zone managed resources. Level 1 is be practical and prudent. Level 2 is intended for environments where security is more critical than manageability and usability. Level 2 drives the creation of an OCI Vault, buckets encryption with a customer managed key, write logs for buckets and the usage of specific policies in Security Zones. For more information please review the CIS OCI Benchmark available [here](https://www.cisecurity.org/benchmark/oracle_cloud). Acceptable inputs are "1" or "2". | Yes | "2"


\* For a list of available regions, please see https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm

### <a name="networking_variables"></a>Networking - Security VCN
Variable Name | Description | Required | Default Value
--------------|-------------|----------|--------------
**add_tt_vcn1** | Adds the Security VCN | Yes | True
**tt_vcn1_name** | Name for the the Security VCN | Yes | "sec-vcn"
**tt_vcn1_cidrs** | Security VCN CIDR ranges | Yes | ["10.0.0.0/20"]
**tt_vcn1_dns** | DNS Name for the security VCN | No | "security"
**tt_vcn1_attach_to_drg** | Attach the VCN to a DRG | Yes | True
**tt_vcn1_routable_vcns** | Routable VCNs to this VCN | No | []
**customize_tt_vcn1_subnets** | Customize the subnet for the security VCN | No | False

### <a name="networking_variables"></a>Networking - Shared Service VCN
Variable Name | Description | Required | Default Value
--------------|-------------|----------|--------------
**add_tt_vcn2** | Adds the Shared Service VCN | Yes | True
**tt_vcn2_name** | Name for the the Shared Service VCN | Yes | "shared-services-vcn"
**tt_vcn2_cidrs** | Security VCN CIDR ranges | Yes | ["10.1.0.0/20"]
**tt_vcn2_dns** | DNS Name for the security VCN | No | "shared"
**tt_vcn2_attach_to_drg** | Attach the VCN to a DRG | Yes | True
**tt_vcn2_routable_vcns** | Routable VCNs to this VCN | No | ["TT-VCN-1","TT-VCN-3","OKE-VCN-1"]
**customize_tt_vcn2_subnets** | Customize the subnet for the security VCN | No | False

### <a name="networking_variables"></a>Networking - Application VCN
Variable Name | Description | Required | Default Value
--------------|-------------|----------|--------------
**add_tt_vcn3** | Adds the Application VCN | Yes | True
**tt_vcn3_name** | Name for the the Application VCN | Yes | "app1-vcn"
**tt_vcn3_cidrs** | Security VCN CIDR ranges | Yes | ["10.2.0.0/20"]
**tt_vcn3_dns** | DNS Name for the security VCN | No | "app1"
**tt_vcn3_attach_to_drg** | Attach the VCN to a DRG | Yes | True
**tt_vcn3_routable_vcns** | Routable VCNs to this VCN | No | ["TT-VCN2", "TT-VCN1"]
**customize_tt_vcn3_subnets** | Customize the subnet for the Application VCN | No | False

### <a name="networking_variables"></a>Networking - Hub & Spoke
Variable Name | Description                                                                                                                                         | Required | Default Value
--------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|----------|--------------
**hub_deployment_option** | Type of Hub & Spoke deployment                                                                                                                      | Yes | "Yes, new VCN as hub with new DRG"
**hub_vcn_name** | Name for the the Hub & Spoke VCN                                                                                                                    | Yes | "zt-hub-vcn"
**hub_vcn_dns** | DNS name for the hub & spoke VCN                                                                                                                    | No | ""
**hub_vcn_cidrs** | CIDR range for the Hub & Spoke VCN                                                                                                                  | Yes | ["192.168.0.0/26"]
**customize_hub_vcn_subnets** | Customize the Hub & Spoke subnets                                                                                                                   | No | False
**hub_vcn_deploy_firewall_option** | Firewall option for the Hub & Spoke                                                                                                                 | "Fortinet FortiGate Firewall"
**fw_instance_shape** | Compute shape to be used for the firewall deployment. For Palo Alto, we recommend VM.Standard3.Flex. For Fortinet, we recommend VM.Standard.E4.Flex | Yes | VM.Standard.E4.Flex
**fw_instance_flex_shape_memory** | Memory allocation for the compute instance for the firewall                                                                                         | Yes | 16
**fw_instance_flex_shape_cpu** | CPU count for the compute instance for the firewall                                                                                                 | Yes | 4
**fw_instance_boot_volume_size** | Boot volume size for the firewall                                                                                                                   | Yes | 20
**fw_instance_public_rsa_key** | Firewall Instance public RSA Key                                                                                                                    | False | ""

### <a name="networking_variables"></a>Networking - OKE VCN
Variable Name | Description | Required | Default Value
--------------|-------------|----------|--------------
**add_oke_vcn1** | Adds the OKE VCN | Yes | True
**oke_vcn1_cni_type** | OKE Network type | False | "Native"
**oke_vcn1_name** | Name for the the OKE VCN | Yes | "app2-vcn"
**oke_vcn1_cidrs** | OKE VCN CIDR ranges | Yes | ["10.3.0.0/20"]
**oke_vcn1_dns** | DNS Name for the OKE VCN | No | "app1"
**oke_vcn1_attach_to_drg** | Attach the VCN to a DRG | Yes | True
**oke_vcn1_routable_vcns** | Routable VCNs to this VCN | No | ["TT-VCN2", "TT-VCN1"]

### <a name="networking_variables"></a>Security - Cloud Guard and Service Connector
Variable Name | Description | Required | Default Value
--------------|-------------|----------|--------------
**enable_cloud_guard** | Enables cloud Guard in the root compartment | Yes | False
**enable_service_connector** | Enables the service connector, but doesn't activate it yet | False | True
**activate_service_connector** | Activates the service connector. This might results in a cost | False | False
**service_connector_target_kind** | Target kind for the service connector | No | "Streaming"

### <a name="networking_variables"></a>Security - Security Zones
Variable Name | Description | Required | Default Value
--------------|-------------|----------|--------------
**enable_security_zones** | Enable Security Zones | True | True
**security_zones_reporting_region** | The reporting region of security zones. It defaults to tenancy home region if undefined. | False | ""

### <a name="networking_variables"></a>Security - Vulnerability Scanning
Variable Name | Description | Required | Default Value
--------------|-------------|----------|--------------
**vss_create** | Creates Vulnerability Scanning | Yes | True
**vss_scan_schedule** | Scheduling interval for the VSS | False | WEEKLY
**vss_scan_day** | What day of the week should the schedule run | False | SUNDAY
**vss_port_scan_level** | Port Scan Level | No | STANDARD
**vss_agent_scan_level** | Agent Scan Level | No | STANDARD
**vss_agent_cis_benchmark_settings_scan_level** | Benchmark Scan Level | No | MEDIUM
**vss_enable_file_scan** | Enable File Scan | No | False

### <a name="networking_variables"></a>Alerts
Variable Name | Description | Required | Default Value
--------------|-------------|----------|--------------
**network_admin_email_endpoints** | Network admin email addresses to receive alerts | Yes | []
**security_admin_email_endpoints** | Security admin email addresses to receive alerts | True | []

### <a name="networking_variables"></a>Budgets
Variable Name | Description | Required | Default Value
--------------|-------------|----------|--------------
**create_budget** | Create Budgets for the Landing Zone | No | False
