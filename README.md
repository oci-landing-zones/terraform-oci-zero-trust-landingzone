[![Deploy_To_OCI](images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-core-landingzone/archive/refs/heads/main.zip&zipUrlVariables={"cis_level":"1","hub_deployment_option":"VCN%20or%20on-premises%20connectivity%20routing%20through%20DMZ%20VCN%20with%20Network%20Virtual%20Appliance%20(DRG%20and%20DMZ%20VCN%20will%20be%20created)","define_net":true,"enable_zpr":true,"add_tt_vcn1":true,"tt_vcn1_attach_to_drg":true,"enable_service_connector":true,"activate_service_connector":true,"service_connector_target_kind":"streaming","enable_security_zones":true,"vss_create":true,"create_budget":true,"enable_cloud_guard":true})
<br>
*If you are logged into your OCI tenancy in the Commercial Realm (OC1), the button will take you directly to OCI Resource Manager where you can proceed to deploy. If you are not logged, the button takes you to Oracle Cloud initial page where you must enter your tenancy name and login to OCI.*

# OCI Zero Trust Landing Zone

The OCI Zero Trust Landing Zone deploys a [Zero Trust](https://www.oracle.com/security/what-is-zero-trust/)
secure architecture that supports requirements described by NIST, CISA, and NCSC. In addition to the Center for Internet Security (CIS) Benchmarks, this Zero Trust Landing Zone will implement several additional services including Zero Trust Packet Routing (ZPR), Access Governance, and the ability to plug in your preferred third-party Zero Trust Network Access (ZTNA) solution (e.g., Fortinet, Palo Alto Networks, Cisco, Check Point, etc.). See the [Oracle Cloud Infrastructure Blog article](https://blogs.oracle.com/cloud-infrastructure/post/accelerating-zero-trust-journey-on-oci-with-landing-zones) for more details.

Please review the guides below to get started with the OCI Zero Trust Landing Zone. This Zero Trust Landing Zone solution has options to deploy services that are available in the OCI Commercial Realm (OC1). The button below will take you directly to the OCI Resource Manager console where you can start the deployment. Please note that some services are not available in all realms, so you will need to review the [Deployment Guide](./DEPLOYMENT-GUIDE.md) before deploying.

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
    - [IAM](#iam)
    - [Networking](#networking)
    - [Monitoring](#monitoring)
    - [Cost Tracking](#cost)
3. [SIEM](#SIEM)
4. [Requirements](#requirements)
5. [Contributing](#contributing)
6. [License](#license)
7. [Known Issues](#known-issues)


## <a name="overview">Overview</a>

The Zero Trust Landing Zone deploys a standardized environment in an Oracle Cloud Infrastructure (OCI) tenancy that’s based on the OCI Core Landing Zone, which helps organizations comply with the [CIS OCI Foundations Benchmark v2.0](https://www.cisecurity.org/benchmark/oracle_cloud/).

The template uses multiple compartments, groups, and IAM policies to segregate access to resources based on job function. The resources within the template are configured to meet the CIS OCI Foundations Benchmark settings related to:

- IAM (Identity & Access Management)
- Networking
- Keys
- Cloud Guard
- Zero Trust Package Routing
- Logging
- Vulnerability Scanning
- Bastion
- Events
- Alarms
- Notifications
- Object Storage
- Budgets
- Security Zone

## <a name="arch">Architecture</a>

### <a name="iam">IAM</a>

The Zero Trust Landing Zones IAM model seeks to enforce segregation of duties and the least privilege principle by defining compartments, policies, groups, and dynamic groups.

The OCI Zero Trust Landing Zone creates specific compartments in the tenancy root compartment:
 - Network compartment: for all networking resources.
 - Security compartment: for all logging, key management, scanning, and notifications resources.
 - Application Development compartment: for application development related services, including Compute, Storage, Functions, Streams, Kubernetes, API Gateway, etc.
 - Database compartment: for all database resources.
 - Enclosing compartment: a compartment at any level in the compartment hierarchy to hold the above compartments.

The compartment design reflects a basic functional structure observed across different organizations, where IT responsibilities are typically split among networking, security, application development and database admin teams. Each compartment is assigned an admin group, with enough permissions to perform its duties. The provided permissions lists are not exhaustive and are expected to be appended with new statements as new resources are brought into the Terraform template.

### <a name="networking">Networking</a>

A single Zero Trust Landing Zone deployment can create up to ten (10) VCNs: three (3) three-tier VCNs, three (3) Exadata Cloud Service VCNs, three (3) OKE VCNs and one (1) Hub VCN. The VCNs can be standalone or peered.
The Zero Trust Landing Zone will by default, create following network:

 Three-tier VCNs with:

 - One public subnet that will be attached to a DRG

 Hub and Spoke topology

 The Zero Trust Landing Zone will also preset the configuration to use a hub and spoke topology through DMZ VCN with Network Virtual Appliance.

The Hub VCN is a choke point for external traffic that ingresses into the VCNs (either from Internet or on-premises) or from internal traffic generated by the spoke VCNs.

The Hub VCN is coupled with a Dynamic Routing Gateway (DRG), managed by the landing zone.

A network appliance should also be selected. It is important to understand that the current deployment of the Zero Trust Landing Zone will not configure the network appliance but only deploy the required resources and images. Depending on the type of firewall, manual configuration is still required.
The Zero Trust Landing zone supports 4 types of network appliance deployments:

- **Don't deploy any network appliance at this time**: this option will not deploy any network appliance in the Landing Zone. We don't recommend this option for production environments!

- **Palo Alto Networks VM-Series Firewall**: deploys the Palo Alto firewall on compute instances so that you can configure it to secure the Zero Trust VCNs

- **Fortinet FortiGate Firewall**: deploys the Fortinet FortiGate firewall on compute instances so that you can configure it to secure the Zero Trust VCNs

- **User-Provided Virtual Network Appliance**: allows you to specify the compute image that stores your custom network appliance.


### <a name="monitoring">Monitoring</a>

CIS OCI Foundations Benchmark strongly focuses on monitoring. It's very important to start with a strong monitoring foundation and make appropriate personnel aware of changes in the infrastructure. The Zero Landing Zone implements the Benchmark recommendations through a notifications framework that sends notifications to email endpoints upon infrastructure changes. This framework is 100% enabled by OCI Events and Notifications services. When an event happens (like an update to a policy) a message is sent to a topic and topic subscribers receive a notification. In the Zero Trust Landing Zone, subscribers are email endpoints that must be provided for IAM and network events as mandated by CIS Benchmark. IAM events are always monitored in the home region and at the Root compartment level. Network events are regional and monitored at the Root compartment level.

Zero Trust Landing Zone extends events monitoring with operational metrics and alarms provided by OCI Monitoring service. The Zero Trust Landing Zone queries specific metrics and sends alarms to a topic if the query condition is satisfied and topic subscribers receive a notification. This model allows for capturing resource-level occurrences like excessive CPU/memory/storage consumption, FastConnect channel down/up events, Exadata infrastructure events, and others.

As mandated by CIS Benchmark, Zero Trust Landing Zone also enables VCN flow logs to all provisioned subnets and Object Storage logging for write operations.

Last but not least, Zero Trust Landing Zone uses OCI Service Connector Hub to consolidate logs from different sources including VCN flow logs and Audit logs. This is extremely helpful when making OCI logs available to third-party SIEM (Security Information and Event Management) or SOAR (Security Orchestration and Response) solutions. OCI Service Connector Hub can aggregate OCI logs in Object Storage, send them to an OCI Stream, or to an OCI Function. By default, the Zero Trust Landing Zone uses Object Storage as the destination.

### <a name="cost">Cost Tracking</a>

Most resources created by the Zero Trust Landing Zone are free of charge. If there's a possibility of cost, Zero Trust Landing Zone does not enable the resource by default leaving it as an option. This is the case of Service Connector Hub and Network Appliance resources as customers may incur costs if those are enabled. For this reason, Service Connector Hub and Network Appliance have to be explicitly enabled by Zero Trust Landing Zone users.

After setting the basic foundation with Zero Trust Landing Zone, customers deploy their workloads by creating cost-consuming resources like Compute instances, databases, and storage. To avoid surprises with costs, Zero Trust Landing Zone allows for the creation of a basic budget that notifies a provided email address if a forecasted spending reaches a specific threshold. If an enclosing compartment is deployed, the budget is created at that level, otherwise it is created at the Root compartment.

## <a name="SIEM">SIEM</a>

A SIEM (Security Information and Event Management) solution is a software tool that provides organizations with centralized security monitoring capabilities. They are used to identify, analyze, and respond to potential security threats in real-time or through historical data analysis.

The Zero Trust Landing Zone does not provide a SIEM solution as part of the deployment, however you can bring your own SIEM solution that integrates with OCI logs and events. The landing zone uses Events, Streams and Service Connectors so that you can readily configure your SIEM solution for integration with OCI.

To determine your type of Service Connector target (*service\_connector\_target\_kind*), please review "SIEM Integration" on this [guide](https://github.com/oracle-quickstart/oci-self-service-security-guide/tree/main/1-Logging-Monitoring-and-Alerting).

## <a name="requirements">Requirements</a>

### Terraform Version >= 1.3.0

This module requires Terraform binary version 1.3.0 or greater, as its underlying modules rely on Optional Object Type Attributes feature. The feature shortens the amount of input values in complex object types, by having Terraform automatically inserting a default value for any missing optional attributes.

## <a name="contributing">Contributing</a>

See [CONTRIBUTING.md](./CONTRIBUTING.md).


## <a name="license">License</a>

Copyright (c) 2024, Oracle and/or its affiliates.

Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

See [LICENSE](./LICENSE.txt) for more details.


## <a name="known-issues">Known Issues</a>

* **CIS Level and Firewall Functionality**
    *  Deploying an optional firewall network appliance in conjunction with the option of CIS Level 2 is not supported at this time.
       This limitation is due to the requirement imposed by Security Zone for an encrypted boot volume with a customer managed key on the network appliance. The suggested workaround is to opt for CIS level 1 if you intend to use a third party firewall. This is going to be addressed in the next release.

* **Terraform Apply Failure 404-NotAuthorizedorNotFound**
    * Terraform CLI or Resource Manager fails to apply with a message similar as this:
    ```
        2021/07/01 23:53:25[TERRAFORM_CONSOLE] [INFO]
        2021/07/01 23:53:25[TERRAFORM_CONSOLE] [INFO] Error: 404-NotAuthorizedOrNotFound
        2021/07/01 23:53:25[TERRAFORM_CONSOLE] [INFO] Provider version: 4.33.0, released on 2021-06-30.
        2021/07/01 23:53:25[TERRAFORM_CONSOLE] [INFO] Service: Identity Policy
        2021/07/01 23:53:25[TERRAFORM_CONSOLE] [INFO] Error Message: Authorization failed or requested resource not found
        2021/07/01 23:53:25[TERRAFORM_CONSOLE] [INFO] OPC request ID: f14a700dc5d00272933a327c8feb2871/5053FB2DA16689F6421821A1B178D450/D3F2FE52F3BF8FB2C769AEFF7754A9B0
        2021/07/01 23:53:25[TERRAFORM_CONSOLE] [INFO] Suggestion: Either the resource has been deleted or service Identity Policy need policy to access this resource. Policy reference: https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm
    ```

    This is due to eventual consistency, where resources need to be propagated to all regions before becoming fully available. We have dealt with these type of issues in code by introducing artificial delays. However, they may still arise as the consistency is eventual. If you face errors like this, simply re-plan and re-apply the Terraform configuration (you do not need to destroy and start all over). The errors should go away in the subsequent run. If they still persist, the problem is of a different nature.

    **If your plan continues to fail, please ensure the OCI service is available in your realm.  All OCI services deployed by OCI Core Landing Zone are available in the commercial (OC1) realm but may not be in others.**

* **OCI Compartment Deletion**
    * By design, OCI compartments are not deleted upon *terraform destroy* by default. Deletion can be enabled in Landing Zone by setting *enable_cmp_delete* variable to true in locals.tf file. However, compartments may take a long time to delete. Not deleting compartments is ok if you plan on reusing them. For more information about deleting compartments in OCI via Terraform, check [OCI Terraform provider documentation](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment).

* **OCI Vault Deletion**
    * By design, OCI vaults and keys are not deleted immediately upon *terraform destroy*, but scheduled for deletion. Both have a default 30 day grace period. For shortening that period, use OCI Console to first cancel the scheduled deletion and then set the earliest possible deletion date (7 days from current date) when deleting.

* **Support for free tier tenancies**
    * Deploying in a free tier tenancy is not supported at this time as there are some services that are not available. If you want to try the Landing Zone please upgrade your account to a pay-go account.
