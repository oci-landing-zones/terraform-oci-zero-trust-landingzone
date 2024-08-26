# OCI Zero Trust Landing Zone

This repository contains the Zero Trust Landing Zone to deploy to the Oracle Cloud Infrastructure platform that supports our customers’ zero trust journey. This Zero Trust Landing Zone is assembled from the OCI core modules that users can leverage as their default configuration or fork this repo and customize it for their own use cases.

## Oracle Cloud Infrastructure Zero Trust Landing Zone

The Oracle Zero Trust Landing Zone deploys a secure architecture that supports requirements described by NIST, CISA, and NCSC. In addition to the Center for Internet Security (CIS) Benchmarks, this Zero Trust Landing Zone will implement several additional services including Zero Trust Packet Routing (ZPR), Access Governance, and the ability to plug in your preferred 3rd party Zero Trust Network Access (ZTNA) solution (e.g., Fortinet, Palo Alto, Cisco, etc.). Please review the guides below to get started with the OCI Zero Trust Landing Zone. This Zero Trust Landing Zone solution has options to deploy services that are available in the Commercial Realm (OC1). The button below will take you directly to the OCI Resource Manager console where you can start the deployment. Please note that some services are not available in all realms, so you will need to review the Implementation Guide and Configuration Guide before deploying.

*If you are logged into your OCI tenancy in the Commercial Realm (OC1), the button will take you directly to OCI Resource Manager where you can proceed to deploy. If you are not logged in, the button takes you to the Oracle Cloud initial page where you must enter your tenancy name and login to OCI.*

## Table of Contents

1. [OCI Zero Trust Landing Zone](#oci-zero-trust-landing-zone)
2. [Oracle Cloud Infrastructure Zero Trust Landing Zone](#oracle-cloud-infrastructure-zero-trust-landing-zone)
3. [Overview](#overview)
4. [Deliverables](#deliverables)
5. [Architecture](#architecture)
    - [IAM](#iam)
    - [Compartments](#compartments)
    - [Groups](#groups)
    - [Dynamic Groups](#dynamic-groups)
    - [Policies](#policies)
6. [Networking](#networking)
7. [Governance](#governance)
8. [Monitoring](#monitoring)
9. [Cost Tracking](#cost-tracking)
10. [Resource Tagging](#resource-tagging)
11. [Executing Instructions](#executing-instructions)
12. [Documentation](#documentation)
13. [Help](#help)
14. [Contributing](#contributing)
15. [Security](#security)
16. [License](#license)
17. [Known Issues](#known-issues)
    - [Terraform Apply Failure 404-NotAuthorizedorNotFound](#terraform-apply-failure-404-notauthorizedornotfound)
    - [OCI Tags](#oci-tags)
    - [OCI Compartment Deletion](#oci-compartment-deletion)
    - [OCI Vault Deletion](#oci-vault-deletion)
    - [Enabling no internet access on an existing deployment](#enabling-no-internet-access-on-an-existing-deployment)
    - [Resource Manager does not allow elements with same value in array type](#resource-manager-does-not-allow-elements-with-same-value-in-array-type)
    - [Support for free tier tenancies](#support-for-free-tier-tenancies)

## Overview

The Zero Trust Landing Zone deploys a standardized environment in an Oracle Cloud Infrastructure (OCI) tenancy that’s based on the OCI Core Zero Trust Landing Zone, which helps organizations comply with the [CIS OCI Foundations Benchmark v2.0](https://www.cisecurity.org/benchmark/oracle_cloud/).

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

## Deliverables

This repository encloses two deliverables:

- A reference implementation written in Terraform HCL (Hashicorp Language) that provisions fully functional resources in an OCI tenancy.
- Something Zero Trust Related

## Architecture

### IAM

The Zero Trust Landing Zones IAM model seeks to enforce segregation of duties and the least privilege principle by defining compartments, policies, groups, and dynamic groups.

### Compartments

At least four compartments are provisioned:

- **Security**: Holds security resources that are primarily managed by security administrators. Services and resources include Cloud Guard, Vaults, Keys, Vulnerability Scanning, Bastion, and Service Connector Hub.
- **Network**: Holds network resources that are primarily managed by network administrators. Services include VCN (Virtual Cloud Network) and DRG (Dynamic Routing Gateway).
- **AppDev**: Designed to hold services oriented for the application portion of workloads that are primarily managed by application administrators. Services include Compute instances, Storage, Functions, and Kubernetes clusters.
- **Database**: Designed to hold database services that are primarily managed by database administrators.
- **Enclosing compartment**: Designed to enclose the aforementioned compartments in a single top compartment. When deploying as a non-administrator, an enclosing compartment is mandatory.

### Groups

By default, the Zero Trust Landing Zone defines the following personas that account for most organizational needs:

- **IAM Administrators**: Manage IAM services and resources including compartments, groups, dynamic groups, policies, identity providers, authentication policies, network sources, and tag defaults. However, this group is not allowed to manage the out-of-box *Administrators* and *Credential Administrators* groups. It's also not allowed to touch the out-of-box *Tenancy Admin Policy* policy.
- **Credential Administrators**: Manage users' capabilities and credentials in general, including API keys, authentication tokens, and secret keys.
- **Cost Administrator**: Manage budgets and usage reports.
- **Auditor**: Entitled with read-only access across the tenancy and the ability to use cloud-shell to run the *cis_reports.py* script. Confirm if this is part of this repo also.
- **Announcement Readers**: For reading announcements displayed in OCI Console.
- **Security Administrators**: Manage security services and resources including Vaults, Keys, Logging, Vulnerability Scanning, Web Application Firewall, Bastion, and Service Connector Hub.
- **Network Administrators**: Manage OCI network family including VCNs, Load Balancers, DRGs, VNICs, and IP addresses.
- **Application Administrators**: Manage application-related resources including Compute images, OCI Functions, Kubernetes clusters, Streams, Object Storage, Block Storage, and File Storage.
- **Database Administrators**: Manage database services including Oracle VMDB (Virtual Machine), BMDB (Bare Metal), ADB (Autonomous databases), Exadata databases, MySQL, NoSQL, etc.
- **Storage Administrators**: The only group allowed to delete storage resources including buckets, volumes, and files. Used as a protection measure against inadvertent deletion of storage resources.

**NOTE**: Following the least privilege principle, groups are only entitled to manage, use, read, or inspect the necessary resources to fulfill their duties.

### Dynamic Groups

The Zero Trust Landing Zone defines four dynamic groups to satisfy common needs of workloads that are eventually deployed:

- **Security Functions**: To be used by functions defined in the Security compartment. The matching rule includes all functions in the Security compartment. An example is a function for rotating secrets kept in a Vault.
- **AppDev Functions**: To be used by functions defined in the AppDev compartment. The matching rule includes all functions in the AppDev compartment. An example is a function for processing application data and writing it to an Object Storage bucket.
- **Compute Agent**: To be used by Compute's management agent in the AppDev compartment.
- **Database KMS**: To be used by databases in the Database compartment to access keys in the Vault service.

### Policies

The Zero Trust Landing Zone policies implement segregation of duties and follow least privilege across the different personas (groups). In OCI, services also need to be explicitly granted. The Zero Trust Landing Zone provisions policies authorizing Cloud Guard, Vulnerability Scanning Service, and OS Management Service with the necessary actions for their functioning. We recommend reviewing *config/iam_service_policies.tf* for additional details.

The Zero Trust Landing Zone template creates a few compartments in the tenancy root compartment or under an enclosing compartment:

- **Network compartment**: For all networking resources.
- **Security compartment**: For all logging, key management, scanning, and notifications resources.
- **Application Development compartment**: For application development related services including Compute, Storage, Functions, Streams, Kubernetes, API Gateway, etc.
- **Database compartment**: For all database resources.
- **Enclosing compartment**: A compartment at any level in the compartment hierarchy to hold the above compartments.

The compartment design reflects a basic functional structure observed across different organizations where IT responsibilities are typically split among networking, security, application development, and database admin teams. Each compartment is assigned an admin group with enough permissions to perform its duties. The provided permissions lists are not exhaustive and are expected to be appended with new statements as new resources are brought into the Terraform template.

## Networking

The Zero Trust Landing Zone will deploy the following network topology:

- **Three-tier VCN**: Three subnets are provisioned, one to host the security-related resources, one to host the shared services, and one for application purposes. Route rules and network security rules are configured based on provided connectivity settings.
- **VCNs** will also be connected to an OCI DRG V2 service in a Hub & Spoke topology. The DRG will be used as the central Hub. The DMZ VCN will be configured for firewall deployments.

[Zero Trust Landing Zone ready Terraform configurations](https://blogs.oracle.com/cloud-infrastructure/post/adding-our-security-partners-to-a-cis-oci-landing-zone).

## Governance

The strong governance framework established by Zero Trust Landing Zone IAM foundation is complemented by monitoring, cost tracking, and resources tagging capabilities.

## Monitoring

CIS OCI Foundations Benchmark strongly focuses on monitoring. It's very important to start with a strong monitoring foundation and make appropriate personnel aware of changes in the infrastructure. The Zero Landing Zone implements the Benchmark recommendations through a notifications framework that sends notifications to email endpoints upon infrastructure changes. This framework is 100% enabled by OCI Events and Notifications services. When an event happens (like an update to a policy) a message is sent to a topic and topic subscribers receive a notification. In the Zero Trust Landing Zone, subscribers are email endpoints that must be provided for IAM and network events as mandated by CIS Benchmark. IAM events are always monitored in the home region and at the Root compartment level. Network events are regional and monitored at the Root compartment level.

Zero Trust Landing Zone extends events monitoring with operational metrics and alarms provided by OCI Monitoring service. The Zero Trust Landing Zone queries specific metrics and sends alarms to a topic if the query condition is satisfied and topic subscribers receive a notification. This model allows for capturing resource-level occurrences like excessive CPU/memory/storage consumption, FastConnect channel down/up events, Exadata infrastructure events, and others.

As mandated by CIS Benchmark, Zero Trust Landing Zone also enables VCN flow logs to all provisioned subnets and Object Storage logging for write operations.

Last but not least, Zero Trust Landing Zone uses OCI Service Connector Hub to consolidate logs from different sources including VCN flow logs and Audit logs. This is extremely helpful when making OCI logs available to 3rd-party SIEM (Security Information and Event Management) or SOAR (Security Orchestration and Response) solutions. OCI Service Connector Hub can aggregate OCI logs in Object Storage, send them to an OCI Stream, or to an OCI Function. By default, the Zero Trust Landing Zone uses Object Storage as the destination.

## Cost Tracking

The resources created by the Zero Trust Landing Zone are free of charge and cost nothing to our customers. If there's a possibility of cost, Zero Trust Landing Zone does not enable the resource by default leaving it as an option. This is the case of Service Connector Hub for instance as customers may incur costs if large amounts of logs are sent to an Object Storage bucket. For this reason, Service Connector Hub has to be explicitly enabled by Zero Trust Landing Zone users.

After setting the basic foundation with Zero Trust Landing Zone, customers deploy their workloads by creating cost-consuming resources like Compute instances, databases, and storage. To avoid surprises with costs, Zero Trust Landing Zone allows for the creation of a basic budget that notifies a provided email address if a forecasted spending reaches a specific threshold. If an enclosing compartment is deployed, the budget is created at that level, otherwise it is created at the Root compartment.

## Resource Tagging

Resource tagging is an important component of a governance framework as it allows for the establishment of a fine-grained resource identification mechanism regardless of the resource compartment. In OCI, this enables two critical aspects: cost tracking and tag-based policies.

For further detail on the topics covered above, please review the deployment guide located here.

## Executing Instructions

- [Terraform Configuration](terraform.md)
- [Compliance Checking](compliance-script.md)

## Documentation

- [Deploy a Secure Zero Trust Landing Zone that Meets the CIS Foundations Benchmark for Oracle Cloud](https://docs.oracle.com/en/solutions/cis-oci-benchmark/index.html#GUID-4572A461-E54D-41E8-89E8-9576B8EBA7D8)
- [CIS OCI Zero Trust Landing Zone Quick Start Template Version 2](https://www.ateam-oracle.com/cis-oci-landing-zone-quick-start-template-version-2)
- [Deployment Modes for Zero Trust Landing Zone](https://www.ateam-oracle.com/deployment-modes-for-cis-oci-landing-zone)
- [Tenancy Pre Configuration For Deploying Zero Trust Landing Zone as a non-Administrator](https://www.ateam-oracle.com/tenancy-pre-configuration-for-deploying-cis-oci-landing-zone-as-a-non-administrator)
- [Strong Security Posture Monitoring with Cloud Guard](https://www.ateam-oracle.com/cloud-guard-support-in-cis-oci-landing-zone)
- [Logging Consolidation with Service Connector Hub](https://www.ateam-oracle.com/security-log-consolidation-in-cis-oci-landing-zone)
- [Vulnerability Scanning in CIS OCI Zero Trust Landing Zone](https://www.ateam-oracle.com/vulnerability-scanning-in-cis-oci-landing-zone)
- [How to Deploy OCI Secure Zero Trust Landing Zone for Exadata Cloud Service](https://www.ateam-oracle.com/how-to-deploy-oci-secure-landing-zone-for-exadata-cloud-service)
- [Operational Monitoring and Alerting in the Zero Trust Landing Zone](https://www.ateam-oracle.com/operational-monitoring-and-alerting-in-the-cis-landing-zone)
- [How to Deploy Zero Trust Landing Zone for a Security Partner Network Appliance](https://www.ateam-oracle.com/post/how-to-deploy-landing-zone-for-a-security-partner-network-appliance)
- [Adding Our Security Partners to a Zero Trust Landing Zone](https://blogs.oracle.com/cloud-infrastructure/post/adding-our-security-partners-to-a-cis-oci-landing-zone)
- [Advanced Configuration using Terraform Overrides](https://www.ateam-oracle.com/post/oci-cis-landing-zone-advanced-configuration-using-terraform-overrides)
- [Creating a Secure Multi-Region Zero Trust Landing Zone](https://www.ateam-oracle.com/post/creating-a-secure-multi-region-landing-zone)
- [The Center for Internet Security Oracle Cloud Infrastructure Foundations Benchmark 1.2 Release update](https://www.ateam-oracle.com/post/the-center-for-internet-security-oracle-cloud-infrastructure-foundations-benchmark-12-release-update)

## Help

Open an issue in this repository.

## Contributing

This project welcomes contributions from the community. Before submitting a pull request, please [review our contribution guide](./CONTRIBUTING.md).

## Security

Please consult the [security guide](./SECURITY.md) for our responsible security vulnerability disclosure process.

## License

Copyright (c) 2020-2024 Oracle and/or its affiliates.

Released under the Universal Permissive License v1.0 as shown at <https://oss.oracle.com/licenses/upl/>.

## Known Issues

### Terraform Apply Failure 404-NotAuthorizedorNotFound

Terraform CLI or Resource Manager fails to apply with a message similar to this:

