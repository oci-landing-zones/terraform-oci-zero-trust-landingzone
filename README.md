[![Deploy_To_OCI](images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oci-landing-zones/terraform-oci-zero-trust-landingzone/archive/refs/heads/main.zip)<br>
*If you are logged into your OCI tenancy in the Commercial Realm (OC1), the button will take you directly to OCI Resource Manager where you can proceed to deploy. If you are not logged, the button takes you to Oracle Cloud initial page where you must enter your tenancy name and login to OCI.*

# OCI Zero Trust Landing Zone (Initial Release)

The Oracle Zero Trust Landing Zone deploys a secure architecture that supports requirements described by NIST, CISA, and NCSC. In addition to the Center for Internet Security (CIS) Benchmarks, this Zero Trust Landing Zone will implement several additional services including Zero Trust Packet Routing (ZPR), Access Governance, and the ability to plug in your preferred 3rd party Zero Trust Network Access (ZTNA) solution (e.g., Fortinet, Palo Alto, Cisco, etc.). Please review the guides below to get started with the OCI Zero Trust Landing Zone. This Zero Trust Landing Zone solution has options to deploy services that are available in the Commercial Realm (OC1). The button below will take you directly to the OCI Resource Manager console where you can start the deployment. Please note that some services are not available in all realms, so you will need to review the Implementation Guide and Configuration Guide before deploying.

## Table of Contents

1. [Initial Release Disclaimer](#initialreleasedisclaimer)
2. [Overview](#overview)
3. [Architecture](#architecture)
    - [IAM](#iam)
    - [Networking](#networking)
    - [Monitoring](#monitoring)
    - [Cost Tracking](#cost)
4. [Requirements](#requirements)  
5. [Contributing](#contributing)
6. [License](#license)
7. [Known Issues](#known-issues)

## <a name="initialreleasedisclaimer">Initial Release Disclaimer</a>

This is the first release following the early preview version. It is still under development, with on-going testing and validation. As such, it may contain bugs, incomplete features, and unexpected behavior. This is NOT intended for production use.  Please see [Known Issues](#known-issues) for successful deployment.

This initial release is for OCI customers to explore the revamped, standardized Landing Zone framework and new templates, including the Core landing Zone for base tenancy provisioning and Zero Trust landing zone which is built on the Core.

The modules that comprise the new landing zone framework are an evolution of landing zone modules previously published under the oracle-quickstart GitHub organization. We invite you to explore the framework and submit any feature requests, comments or questions via GitHub comments. You can subscribe to be notified once the framework is released in general availability at which point it would be supported by Oracle.

## <a name="overview">Overview</a>

The Zero Trust Landing Zone deploys a standardized environment in an Oracle Cloud Infrastructure (OCI) tenancy that’s based on the OCI Core Landing Zone, which helps organizations comply with the [CIS OCI Foundations Benchmark v2.0](https://www.cisecurity.org/benchmark/oracle_cloud/).

The template uses multiple compartments, groups, and IAM policies to segregate access to resources based on job function. The resources within the template are configured to meet the CIS OCI Foundations Benchmark settings related to:

- IAM (Identity & Access Management)
- Networking
- Keys
- Cloud Guard
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

 The Zero Trust Landing Zone can create up to 5 VCNs: three (3) three-tier VCNs (Security, Shared-Services, App), an optional OKE VCNs and one (1) Hub VCN. These VCNs are configured in a Hub & Spoke model that connect to a DRG. 
 
 The three-tier VCNs are comprised of:
 
 - One public (by default) subnet for load balancers.
 - Two private subnets: one for the application tier and one for the database tier.

The OKE VCN is comprised of:

- One public subnet for load balancers.
- Two private subnets: one for worker nodes, one for API endpoint.

The Hub VCN is a choke point for external traffic that ingresses into the VCNs (either from Internet or on-premises) or from internal traffic generated by the spoke VCNs. It is comprised of:

- One public subnet for load balancers.
- Two private subnets: one for inbound north-south traffic (from Internet or on-premises), one for inbound east-west (cross-spoke) traffic.
- One private subnet for managing the firewall appliance that is  optionally deployed.

The Hub VCN is coupled with a Dynamic Routing Gateway (DRG), managed by the landing zone.


### <a name="monitoring">Monitoring</a>

CIS OCI Foundations Benchmark strongly focuses on monitoring. It's very important to start with a strong monitoring foundation and make appropriate personnel aware of changes in the infrastructure. The Zero Landing Zone implements the Benchmark recommendations through a notifications framework that sends notifications to email endpoints upon infrastructure changes. This framework is 100% enabled by OCI Events and Notifications services. When an event happens (like an update to a policy) a message is sent to a topic and topic subscribers receive a notification. In the Zero Trust Landing Zone, subscribers are email endpoints that must be provided for IAM and network events as mandated by CIS Benchmark. IAM events are always monitored in the home region and at the Root compartment level. Network events are regional and monitored at the Root compartment level.

Zero Trust Landing Zone extends events monitoring with operational metrics and alarms provided by OCI Monitoring service. The Zero Trust Landing Zone queries specific metrics and sends alarms to a topic if the query condition is satisfied and topic subscribers receive a notification. This model allows for capturing resource-level occurrences like excessive CPU/memory/storage consumption, FastConnect channel down/up events, Exadata infrastructure events, and others.

As mandated by CIS Benchmark, Zero Trust Landing Zone also enables VCN flow logs to all provisioned subnets and Object Storage logging for write operations.

Last but not least, Zero Trust Landing Zone uses OCI Service Connector Hub to consolidate logs from different sources including VCN flow logs and Audit logs. This is extremely helpful when making OCI logs available to 3rd-party SIEM (Security Information and Event Management) or SOAR (Security Orchestration and Response) solutions. OCI Service Connector Hub can aggregate OCI logs in Object Storage, send them to an OCI Stream, or to an OCI Function. By default, the Zero Trust Landing Zone uses Object Storage as the destination.

### <a name="cost">Cost Tracking</a>

The resources created by the Zero Trust Landing Zone are free of charge and cost nothing to our customers. If there's a possibility of cost, Zero Trust Landing Zone does not enable the resource by default leaving it as an option. This is the case of Service Connector Hub for instance as customers may incur costs if large amounts of logs are sent to an Object Storage bucket. For this reason, Service Connector Hub has to be explicitly enabled by Zero Trust Landing Zone users.

After setting the basic foundation with Zero Trust Landing Zone, customers deploy their workloads by creating cost-consuming resources like Compute instances, databases, and storage. To avoid surprises with costs, Zero Trust Landing Zone allows for the creation of a basic budget that notifies a provided email address if a forecasted spending reaches a specific threshold. If an enclosing compartment is deployed, the budget is created at that level, otherwise it is created at the Root compartment.


## <a name="requirements">Requirements</a>

### Terraform Version >= 1.3.0

This module requires Terraform binary version 1.3.0 or greater, as its underlying modules rely on Optional Object Type Attributes feature. The feature shortens the amount of input values in complex object types, by having Terraform automatically inserting a default value for any missing optional attributes.

## <a name="contributing">Contributing</a>

See [CONTRIBUTING.md](./CONTRIBUTING.md).


## <a name="license">License</a>

Copyright (c) 2023, Oracle and/or its affiliates.

Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

See [LICENSE](./LICENSE) for more details.


## <a name="known-issues">Known Issues</a>

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
    * By design, OCI compartments are not deleted upon *terraform destroy* by default. Deletion can be enabled in Landing Zone by setting *enable_cmp_delete* variable to true in locals.tf file. However, compartments may take a long time to delete. Not deleting compartments is ok if you plan on reusing them. For more information about deleting compartments in OCI via Terraform, check [OCI Terraform provider documentation](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_compartment).

* **OCI Vault Deletion**
    * By design, OCI vaults and keys are not deleted immediately upon *terraform destroy*, but scheduled for deletion. Both have a default 30 day grace period. For shortening that period, use OCI Console to first cancel the scheduled deletion and then set the earliest possible deletion date (7 days from current date) when deleting.

* **Support for free tier tenancies**
    * Deploying in a free tier tenancy is not supported at this time as there are some services that are not available. If you want to try the Landing Zone please upgrade your account to a pay-go account. 

### Pre-Deployment Considerations

* Cloud Guard is managed from the root compartment; if it is already enabled, disable Cloud Guard activation during Landing Zone deployment.

* For any firewall instances you deploy, memory should be increased from the default value to 64 or greater.

### Post-Deployment Considerations

* The routing VCN (hub) is the nexus for all other Zero Trust Landing Zone VCNs (spokes).  Remove any gateways from all VCNs except the routing hub VCN (zt-hub-vcn).
	* Terminate IGW in app1-vcn
	* Terminate NGW in app1-vcn
	* Terminate SGW in app1-vcn

* Default route tables are not used; all routing is managed by VCN-specific route tables with associated NSGs.  For a proper Hub and Spoke network topology, fix route tables and align NSGs with route tables.

	Security VCN (sec-vcn):
	
		web-subnet-route-table
		- remove all destinations except 0.0.0.0/0
		app-subnet-route-table
		- remove all destinations except 0.0.0.0/0
		db-subnet-route-table
		- remove all destinations except 0.0.0.0/0

		lbr-nsg
		- remove all ingress except 0.0.0.0/0 (TCP/443)
		- remove all egress except
		      hub-vcn-indoor-subnet 192.168.0.32/28 (All/All)
		      app-nsg (TCP/80)
		app-nsg
		- remove all ingress except lbr-nsg (TCP/80)
		- remove all egress except
		      hub-vcn-indoor-subnet 192.168.0.32/28 (All/All)
		      db-nsg (TCP/1521-1522)
		db-nsg
		- remove all ingress except app-nsg (TCP/1521-1522)
		- remove all egress except
		      hub-vcn-indoor-subnet 192.168.0.32/28 (All/All)
	
	
	Shared Services VCN (share-services-vcn):
	
		web-subnet-rtable
		- remove all destinations except 192.168.0.0/26
		app-subnet-rtable
		- remove all destinations except 192.168.0.0/26
		db-subnet-rtable
		- remove all destinations except 192.168.0.0/26
		
		lbr-nsg
		- remove all ingress except 192.168.0.0/26 (TCP/443)
		- remove all egress except
		      hub-vcn-indoor-subnet 192.168.0.32/28 (All/All)
		      app-nsg (TCP/80)
		app-nsg
		- remove all ingress except lbr-nsg (TCP/80)
		- remove all egress except
		      hub-vcn-indoor-subnet 192.168.0.32/28 (All/All)
		      db-nsg (TCP/1521-1522)
		db-nsg
		- remove all ingress except app-nsg (TCP/1521-1522)
		- remove all egress except
		      hub-vcn-indoor-subnet 192.168.0.32/28 (All/All)
	
	
	Application VCN - three tier (app1-vcn):
	
		web-subnet-rtable
		- remove all destinations except 0.0.0.0/0
		app-subnet-rtable
		- remove all destinations except 0.0.0.0/0
		db-subnet-rtable
		- remove all destinations except 0.0.0.0/0
		
		lbr-nsg
		- remove all ingress except 0.0.0.0/0 (TCP/443)
		- remove all egress except
		      hub-vcn-indoor-subnet 192.168.0.32/28 (All/All)
		      app-nsg (TCP/80)
		app-nsg
		- remove all ingress except lbr-nsg (TCP/80)
		- remove all egress except
		      hub-vcn-indoor-subnet 192.168.0.32/28 (All/All)
		      db-nsg (TCP/1521-1522)
		db-nsg
		- remove all ingress except app-nsg (TCP/1521-1522)
		- remove all egress except
		      hub-vcn-indoor-subnet 192.168.0.32/28 (All/All)
	
	
	Application VCN - OKE (app2-vcn):
	
		api-subnet-route-table
		- keep destination 0.0.0.0/0
		pods-subnet-route-table
		- remove all destinations except 0.0.0.0/0
		services-subnet-route-table
		- keep destination 0.0.0.0/0
		workers-subnet-route-table
		- remove all destinations except 0.0.0.0/0
		
		api-nsg
		-  keep ingress
		      api-nsg (TCP/6443)
		      pods-nsg (TCP/6443)
		      pods-nsg (TCP/12250)
		      workers-nsg (TCP/6443)
		      workers-nsg (TCP/10250)
		      workers-nsg (TCP/12250)
		      workers-nsg (ICMP)
		      bastion 10.3.48.0/20 (TCP/6443)
		-  remove egress SGW
		-  keep egress
		      api-nsg (TCP/6443)
		      pods-nsg (All/All)
		      workers-nsg (TCP/10250)
		      workers-nsg (TCP/12250)
		      workers-nsg (ICMP)
		pods-nsg
		-  remove all ingress except
		      api-nsg (All/All)
		      pods-nsg (All/All)
		      workers-nsg (All/All)
		-  remove all egress except
		      api-nsg (TCP/6443)
		      api-nsg (TCP/12250)
		      pods-nsg (All/All)
		      OPTIONAL: 0.0.0.0/0 (TCP/All)
		services-nsg
		-  keep ingress except 0.0.0.0/0 (All/All)
		-  remove all egress except
		      workers-nsg (TCP/10256)
		      workers-nsg (TCP/30000-32767)
		      workers-nsg (ICMP)
		workers-nsg
		-  remove all ingress except
		      api-nsg (All/All)
		      services-nsg (TCP/10256)
		      services-nsg (TCP/30000-32767)
		      workers-nsg (All/All)
		      bastion 10.3.3.0/28 (TCP/22)
		      0.0.0.0/0 (ICMP)
		-  remove all egress except
		      api-nsg (TCP/6443)
		      api-nsg (TCP/10250)
		      api-nsg (TCP/12250)
		      pods-nsg (All/All)
		      workers-nsg (All/All)
		      0.0.0.0/0 (ICMP)
		      OPTIONAL: 0.0.0.0/0 (TCP/All)
	
	
	Hub and Spoke Routing VCN (zt-hub-vcn):
	
		web-subnet-route-table
		- keep IGW
		outdoor-subnet-route-table
		- keep NGW
		- keep SGW
		indoor-subnet-route-table
		- add 10.0.0.0/20, 10.1.0.0/20, 10.2.0.0/20, 10.3.0.0./16
		- keep SGW
		mgmt-subnet-route-table
		- keep NGW
		- keep SGW
	
		outdoor-nlb-nsg
		- keep ingress 0.0.0.0/0 (TCP/443)
		- keep egress outdoor-fw-nsg (TCP/All)
		outdoor-fw-nsg
		- keep ingress outdoor-nlb-nsg (TCP/80)
		- keep egress 0.0.0.0/0 (TCP/All)
		indoor-fw-nsg
		- keep ingress indoor-nlb-nsg (TCP/80)
		- keep egress 0.0.0.0/0 (TCP/All)
		indoor-nlb-nsg
		- keep ingress 0.0.0.0/0 (TCP/80)
		- keep egress indoor-fw-nsg (TCP/All)
		jump-host-nsg
		- no ingress
		- keep egress mgmt-nsg (TCP/22)
		mgmt-nsg
		- keep ingress
		      jump-host-nsg (TCP/22)
		      bastion service 192.168.0.48/28 (TCP/22)
		      bastion service 192.168.0.48/28 (TCP/443)
		- no egress


### On-Premises Connectivity

* Configuration of Fast Connnect, routing, NSGs, etc. for specific customer on-premises facilities is beyond the scpoe of Zero Trust Landing Zone.  Customer connctivity needs to be added manually, as a post-deployment exercize.

### Identity Domain bug

* Details???
