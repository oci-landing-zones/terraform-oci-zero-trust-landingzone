# Zero Trust Landing Zone

This template shows how to deploy a CIS compliant landing zone with Zero Trust Packet Routing enabled using [OCI Core Landing Zone](../../) configuration.

In this template, a single default three-tier VCN is deployed. Additionally, the following services are enabled:
- [Zero Trust Packet Routing](https://docs.oracle.com/en-us/iaas/Content/zero-trust-packet-routing/overview.htm) is enabled with the creation of a ZPR namespace with security attributes and the associated policies.
- [Connector Hub](https://docs.oracle.com/en-us/iaas/Content/connector-hub/overview.htm), for logging consolidation. Collected logs are sent to an OCI stream.
- A [Security Zone](https://docs.oracle.com/en-us/iaas/security-zone/using/security-zones.htm) is created for the deployment. The Security Zone target is the landing zone top (enclosing) compartment.
- [Vulnerability Scanning Service](https://docs.oracle.com/en-us/iaas/scanning/using/overview.htm#scanning_overview) is configured to scan Compute instances that are eventually deployed in the landing zone.
- A basic [Budget](https://docs.oracle.com/en-us/iaas/Content/Billing/Concepts/budgetsoverview.htm#Budgets_Overview) is created.
- A Hub/Spoke networking topology including either Fortinet's Fortigate Firewall or Palo Alto Networks Firewall. Both configurations are mostly the same, except for the network appliance option (_hub\_vcn\_deploy\_net\_appliance\_option_) and their respective settings (_net\_appliance\_variables_).


Please see other [templates](../../templates/) available for CIS compliant landing zones with custom configurations.

## Default Values

This template has the following parameters set:

| Variable Name                       | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | Value                                                                                                                              |
|-------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|
| service_label                       | A unique identifier to prefix the resources                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |                                                                                                                                    |
| define_net                          | Check to define networking resources. By default, the Landing Zone does NOT deploy any networks.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | true                                                                                                                               |
| hub_deployment_option               | The hub deployment option. In this case, a DRG is deployed to act as the hub in the Hub/Spoke topology.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | "VCN or on-premises connectivity routing through DMZ VCN with Network Virtual Appliance (DRG and DMZ VCN will be created)"         |
| hub_vcn_deploy_net_appliance_option | Choose one of the available network appliance options for deploying in the Hub VCN.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | Options: "Don't deploy any network appliance at this time", "Palo Alto Networks VM-Series Firewall", "Fortinet FortiGate Firewall" |
| net_fortigate_version               | Fortinet Fortigate Firewall Version.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | 7.2.9_(\_X_64) or 7.4.4_(\_X_64)                                                                                                   |
| net_appliance_flex_shape_memory     | Network Appliance Amount of Memory for the Selected Flex Shape                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | 56                                                                                                                                 |
| net_appliance_flex_shape_cpu        | Network Appliance Number of OCPUs for the Selected Flex Shape                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | 4                                                                                                                                  |
| net_appliance_boot_volume_size      | Network Appliance Boot Volume Size                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | 60                                                                                                                                 |
| net_appliance_public_rsa_key        | Network Appliance Instance public SSH Key                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | Enter Public SSH Key                                                                                                               |
| net_appliance_shape                 | Network Appliance Instance Shape                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | VM.Standard.E4.Flex                                                                                                                |
| enable_zpr                          | Whether ZPR is enabled as part of this Landing Zone deployment. Besides enabling the service, Core Landing Zone creates a ZPR namespace with security attributes and associated policies for deployed VCNs.                                                                                                                                                                                                                                                                                                                                                                                                                    | true                                                                                                                               |
| add_tt_vcn1                         | Click to add a three-tier VCN, with three subnets: web (public by default), application (private) and database (private). An optional subnet (private by default) for bastion deployment is also available.                                                                                                                                                                                                                                                                                                                                                                                                                    | true                                                                                                                               |
| tt_vcn1_attach_to_drg               | When true, attaches three-tier VCN 1 to the DRG                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | true                                                                                                                               |
| network_admin_email_endpoints       | List of email addresses that receive notifications for networking related events.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | ["email.address@example.com"]                                                                                                      |
| security_admin_email_endpoints      | List of email addresses that receive notifications for security related events.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | ["email.address@example.com"]                                                                                                      |
| enable_cloud_guard                  | When true, OCI Cloud Guard Service is enabled. Set to false if it's been already enabled through other means.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | true                                                                                                                               |
| enable_service_connector            | Whether Service Connector should be enabled. If true, a single Service Connector is managed for all services log sources and the designated target specified in 'Service Connector Target Kind'. The Service Connector resource is created in INACTIVE state. To activate, check 'Activate Service Connector?' (costs may incur).                                                                                                                                                                                                                                                                                              | true                                                                                                                               |
| activate_service_connector          | Whether Service Connector should be activated. If true, costs my incur due to usage of Object Storage bucket, Streaming or Function.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | true                                                                                                                               |
| service_connector_target_kind       | Service Connector Hub target resource. Valid values are 'objectstorage', 'streaming', 'functions' or 'logginganalytics'. In case of 'objectstorage', a new bucket is created. In case of 'streaming', you can provide an existing stream ocid in 'existing_service_connector_target_stream_id' and that stream is used. If no ocid is provided, a new stream is created. In case of 'functions', you must provide the existing function ocid in 'existing_service_connector_target_function_id'. If case of 'logginganalytics', a log group for Logging Analytics service is created and the service is enabled if not already | streaming                                                                                                                          |
| enable_security_zones               | Determines if Security Zones are enabled in Landing Zone compartments. When set to true, the Security Zone is enabled for the enclosing compartment. If no enclosing compartment is used, then the Security Zone is not enabled.                                                                                                                                                                                                                                                                                                                                                                                               | true                                                                                                                               |
| vss_create                          | Whether Vulnerability Scanning should be enabled. If checked, a scanning recipe is enabled and scanning targets are enabled for each Landing Zone compartment.                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | true                                                                                                                               |
| create_budget                       | If checked, a budget will be created at the root or enclosing compartment and based on forecast spend.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | true                                                                                                                               |

For a detailed description of all variables that can be used, see the [Variables](../../VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment.

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/main.zip&zipUrlVariables={"cis_level":"2","hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20through%20DMZ%20VCN%20with%20Network%20Virtual%20Appliance%20(DRG%20and%20DMZ%20VCN%20will%20be%20created)","define_net":true,"enable_zpr":true,"add_tt_vcn1":true,"tt_vcn1_attach_to_drg":true,"enable_service_connector":true,"activate_service_connector":true,"service_connector_target_kind":"streaming","enable_security_zones":true,"vss_create":true,"create_budget":true,"enable_cloud_guard":true})

You are required to review/adjust the following variable settings:
- Make sure to pick an OCI region for deployment.
- Provide real email addresses for *Network Admin Email Endpoints* and *Security Admin Email Endpoints* fields.
- Uncheck *Enable Cloud Guard Service* option in case it is already enabled in your tenancy.

With the stack created, perform a Plan, followed by an Apply using RMS UI.

## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*.
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:
    - $ terraform init
    - $ terraform plan
    - $ terraform apply