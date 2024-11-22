# Zero Trust Landing Zone

This template shows how to deploy a Zero Trust Landing Zone with Zero Trust Packet Routing (ZPR) enabled using an OCI Core Landing Zone configuration.

In this template, a single default three-tier VCN is deployed. Additionally, the following services are enabled:

- [Zero Trust Packet Routing](https://docs.oracle.com/en-us/iaas/Content/zero-trust-packet-routing/overview.htm) is enabled with the creation of a ZPR namespace with security attributes and the associated policies.
- [Connector Hub](https://docs.oracle.com/en-us/iaas/Content/connector-hub/overview.htm), for logging consolidation. Collected logs are sent to an OCI stream.
- A [Security Zone](https://docs.oracle.com/en-us/iaas/security-zone/using/security-zones.htm) is created for the deployment. The Security Zone target is the landing zone top (enclosing) compartment.
- [Vulnerability Scanning Service](https://docs.oracle.com/en-us/iaas/scanning/using/overview.htm#scanning_overview) is configured to scan Compute instances that are eventually deployed in the landing zone.
- A basic [Budget](https://docs.oracle.com/en-us/iaas/Content/Billing/Concepts/budgetsoverview.htm#Budgets_Overview) is created.
- A Hub & Spoke networking topology, including either Fortinet Fortigate Firewall or Palo Alto Networks VM-Series Firewall. Both configurations are mostly the same, except for the network appliance option (_hub\_vcn\_deploy\_net\_appliance\_option_) and their respective settings (_net\_appliance\_variables_).

## Default Values

This template has the following parameters set:

| Variable Name | Description | Value | Options |
|---|---|---|---|
| service\_label | A unique identifier to prefix the resources | | |
| cis\_level | Determines CIS OCI Benchmark Level of services deployed by the landing zone: Level 1 is practical and prudent. Level 2 is intended for environments where security is more critical than manageability and usability. Level 2 drives the creation of an OCI Vault, buckets encryption with a customer managed key, write logs for buckets and the usage of specific policies in Security Zones | 1 | Acceptable inputs are "1" or "2" |
| define\_net | Define networking resources - by default, the Zero Trust Landing Zone deploys a three-tier VCN with subnets. See *add\_tt\_vcn1* below. | true | "true" or "false" |
| hub\_deployment | The hub deployment option. In this case (3), a *new* DRG is deployed to act as the hub in a Hub & Spoke topology. With the other option (4), an existing DRG is used in a Hub & Spoke topology. | 3 | "3" or "4" |
| hub\_vcn\_deploy\_net\_appliance\_option | Choose one of the available network appliance options for deploying in the Hub VCN. | | "Don't deploy any network appliance at this time", "Palo Alto Networks VM-Series Firewall", "Fortinet FortiGate Firewall" |
| net\_fortigate\_version | Fortinet Fortigate Firewall Version. | | "7.4.4\_(\_X64\_)" or "7.2.9\_(\_X64\_)" |
| net\_palo\_alto\_version | Palo Alto Networks VM-Series Firewall Version. | |  "11.1.3" or "11.1.2-h3" |
| net\_appliance\_flex\_shape\_memory | Network Appliance Amount of Memory for the Selected Flex Shape | 56 | Any integer greater than or equal to 56; costs will incur. |
| net\_appliance\_flex\_shape\_cpu | Network Appliance Number of OCPUs for the Selected Flex Shape | 4 | Any integer greater than or equal to 4; costs will incur. |
| net\_appliance\_boot\_volume\_size | Network Appliance Boot Volume Size | 60 | Any integer greater than or equal to 60; costs will incur. |
| net\_appliance\_public\_rsa\_key | Network Appliance Instance public SSH Key | Enter Public SSH Key | Valid public SSH key |
| net\_appliance\_shape | Network Appliance Instance Shape. This depends of your choice of Fortinet or Palo Alto Networks appliances.  For Fortinet, use VM.Standard.E4.Flex; for Palo Alto Networks use VM.Standard2.4. | VM.Standard.E4.Flex | "VM.Standard.E4.Flex" or "VM.Standard2.4" |
| enable\_zpr | Whether ZPR is enabled as part of this landing zone deployment. Besides enabling the service, Core Landing Zone creates a ZPR namespace with security attributes and associated policies for deployed VCNs. <br><br>**By definition, a Zero Trust Landing Zone should deploy ZPR.** | true | "true" or "false" |
| add\_tt\_vcn1 | Add a three-tier VCN, with three subnets: web (public), application (private) and database (private). An optional subnet (private) for bastion deployment is also available. | true | "true" or "false" |
| tt\_vcn1\_attach\_to\_drg | When true, attaches three-tier VCN to the Dynamic Routing Gateway | true | "true" or "false" |
| network\_admin\_email\_endpoints | List of email addresses that receive notifications for networking related events. | ["email.address@example.com"] | Valid email addresses |
| security\_admin\_email\_endpoints | List of email addresses that receive notifications for security related events. | ["email.address@example.com"] | Valid email addresses |
| enable\_cloud\_guard | When true, OCI Cloud Guard Service is enabled. Set to false if it's been already enabled through other means. | true | "true" or "false" |
| enable\_service\_connector | Whether Service Connector should be enabled. If true, a single Service Connector is managed for all services log sources and the designated target specified in *service\_connector\_target\_kind*. The Service Connector resource is created in an INACTIVE state. To activate, check 'Activate Service Connector?' (costs may incur). | true | "true" or "false" |
| activate\_service\_connector | Whether Service Connector should be activated. If true, costs my incur due to usage of Object Storage, Streaming or Function services. | true | "true" or "false" |
| service\_connector\_target\_kind | Service Connector Hub target resource: in case of 'objectstorage', a new bucket is created. In case of 'streaming', you can provide an existing stream OCID in *existing\_service\_connector\_target\_stream\_id* and that stream is used. If no OCID is provided, a new stream is created. In case of 'functions', you must provide the existing function OCID in *existing\_service\_connector\_target\_function\_id*. If case of 'logginganalytics', a log group for Logging Analytics service is created and the service is enabled, if not already. | streaming | "objectstorage", "streaming", "functions" or "logginganalytics" |
| enable\_security\_zones | Determines if Security Zones are enabled in landing zone compartments. When set to true, the Security Zone is enabled for the enclosing compartment. If no enclosing compartment is used, then the Security Zone is not enabled. | true | "true" or "false" |
| vss\_create | Whether Vulnerability Scanning should be enabled. If checked, a scanning recipe is enabled and scanning targets are enabled for each landing zone compartment. | true | "true" or "false" |
| create\_budget | If checked, a budget will be created at the root or enclosing compartment and based on forecast spend. | true | "true" or "false" |

For a detailed description of all variables that can be used, see the [Variables](https://github.com/oci-landing-zones/terraform-oci-core-landingzone/blob/main/VARIABLES.md) documentation.

This template can be deployed using OCI Resource Manager Service (RMS) or Terraform CLI:

## OCI RMS Deployment

By clicking the button below, you are redirected to an OCI RMS Stack with variables pre-assigned for deployment.

[![Deploy_To_OCI](../../images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/main.zip&zipUrlVariables={"cis_level":"1","hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20through%20DMZ%20VCN%20with%20Network%20Virtual%20Appliance%20(DRG%20and%20DMZ%20VCN%20will%20be%20created)","define_net":true,"enable_zpr":true,"add_tt_vcn1":true,"tt_vcn1_attach_to_drg":true,"enable_service_connector":true,"activate_service_connector":true,"service_connector_target_kind":"streaming","enable_security_zones":true,"vss_create":true,"create_budget":true,"enable_cloud_guard":true})

You are required to review/adjust the following variable settings:

- Make sure to pick an OCI region for deployment.
- Provide real email addresses for *network\_admin\_email\_endpoints* and *security\_admin\_email\_endpoints* fields.
- Uncheck *Enable Cloud Guard Service* option in case it is already enabled in your tenancy.
- Make sure to enter the *net\_appliance\_public\_rsa\_key* variable with the public SSH key for the network appliance instance.

With the stack created, perform a Plan, followed by an Apply using RMS UI.

## Terraform CLI Deployment

1. Rename file *main.tf.template* to *main.tf*.
2. Provide/review the variable assignments in *main.tf*.
3. In this folder, execute the typical Terraform workflow:

	``
	terraform init
	``
	
	``
	terraform plan
	``
	
	``
	terraform apply
	``
