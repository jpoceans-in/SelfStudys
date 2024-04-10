### Step - 1 Build a 2-Tier VPC network configuration, with both public and private resources distributed across Availability Zones for redundancy and reliability.

**VPCT2Network**

- Create VPC
- Create InternetGateway
- Attach InternetGateway to VPC
- Establish Public Tier Resources in Availability Zone 1 and Availability Zone 2
	- In Availability Zone 1
		- Create PublicRouteTable1
		- Route-out PublicRouteTable1 to InternetGateway (Internet connection)
		- Create PublicSubnet1
		- Associate PublicRouteTable1 with PublicSubnet1
		- Create ElasticIP1
		- Create NatGateway1 in PublicSubnet1
		- Create PublicNetworkAcl1
		- Associate PublicNetworkAcl1 with PublicSubnet1
	- In Availability Zone 2
		- Create PublicSubnet2
		- Associate PublicRouteTable1 with PublicSubnet2
		- Associate PublicNetworkAcl1 with PublicSubnet2
- Establish Private Tier Resources in Availability Zone 1 and Availability Zone 2
	- In Availability Zone 1
		- Create PrivateRouteTable1
		- Route-out PrivateRouteTable1 to NatGateway1 (Private Internet connection)
        - Create PrivateSubnet1
		- Associate PrivateRouteTable1 with PrivateSubnet1
		- Create PrivateNetworkAcl1
		- Associate PrivateNetworkAcl1 with PrivateSubnet1
	- In Availability Zone 2
		- Create PrivateSubnet2
		- Associate PrivateRouteTable1 with PrivateSubnet2
		- Associate PrivateNetworkAcl2 with PrivateSubnet2

### Step - 2 Associate NACL (Network Access Control List) entries for public and private subnets, allowing inbound/outbound ICMP, HTTP, HTTPS, SSH, MySQL, MongoDB, and Ephemeral traffic.

**PublicNaclEntry**

**PrivateNaclEntry**

- To associate a Network Access Control List (NACL) entry with a public subnet (PublicSubnet1,PublicSubnet2) 
	- INBOUND/OUTBOUND 
		- Allow ALL Network ACL RULES

- To associate a Network Access Control List (NACL) entry with a private subnet (PrivateSubnet1,PrivateSubnet2) 
	- INBOUND,OUTBOUND  
		-   HTTP 80 Network ACL RULES (TCP-6)
		-   HTTPS 443  Network ACL RULES (TCP-6)
		-   SSH 22 Network ACL RULES (TCP-6)
		-   MONGO 2717 Network ACL RULES (TCP-6)
		-   MySQL 3306 Network ACL RULES (TCP-6)
		-   ICMP Network ACL RULES (ICMP-1)
		-   Ephemeral 1024-65535  Ports Network ACL RULES (TCP-6)
		-   Ephemeral 1024-65535 Ports Network ACL RULES (UDP-17)

### Step - 3 Configured Security Groups for LB, EC2, RDS, and Endpoints, ensuring secure communication between Public/Private Load Balancers and EC2 Instances, facilitating dedicated RDS access, S3 access via an Endpoint, and restricting remote connections to Boston EC2.

**SecurityGroups**


 - **Boston EC2 Instances SecurityGroup (BostonSG)**
  - Allow incoming traffic on port 80 (HTTP) and 443 (HTTPS) from 0.0.0.0/0 (or specific IP ranges if applicable) to ensure that the Boston EC2 Instances can receive SSH requests.
    - Allow outgoing traffic on all ports to 0.0.0.0/0 

    - Allow outgoing traffic on all ports to 0.0.0.0/0 
	- SecurityGroupIngress
		- Allow ICMP (Ping) traffic for 0.0.0.0/0
		- Allow SSH traffic for 0.0.0.0/0
	- SecurityGroupEgress
		- Allow all outbound traffic (0.0.0.0/0)

- **Public Localbalance SecurityGroup (LBPublicSG)**
    - Allow incoming traffic on port 80 (HTTP) and 443 (HTTPS) from 0.0.0.0/0 (or specific IP ranges if applicable) to ensure that the LB can receive HTTP/HTTPS requests.
    - Allow outgoing traffic on all ports to 0.0.0.0/0 

    **Use case**
    - Allow outgoing traffic on all ports to 0.0.0.0/0 
	- SecurityGroupIngress
		- Allow ICMP (Ping) traffic for 0.0.0.0/0
		- Allow HTTPS traffic for 0.0.0.0/0
		- Allow HTTP traffic for 0.0.0.0/0
	- SecurityGroupEgress
		- Allow all outbound traffic (0.0.0.0/0)

- **Presentation Tier EC2 Instances SecurityGroup (WebServerSG)**
    - Allow incoming traffic on port 80 (HTTP) and 443 (HTTPS) from the security group of the Application Load Balancer. This allows the EC2 instances to accept traffic only from the Public Localbalance. (LBPublicSG)
    - Allow outgoing traffic on all ports to 0.0.0.0/0 
    **Use case**
	- SecurityGroupIngress
		- Allow ICMP (Ping) traffic for 0.0.0.0/0
		- Allow SSH traffic for the Source Security Group 'BostonSG'
		- Allow HTTP traffic for the Source Security Group 'LBPublicSG'
		- Allow HTTPS traffic for the Source Security Group 'LBPublicSG'
	- SecurityGroupEgress
		- Allow all outbound traffic (0.0.0.0/0)

- **Private Localbalance SecurityGroup for Acess Business Logic Tier EC2 Instances (LBPrivateSG)**
    - Allow incoming traffic on port 80 (HTTP) and 443 (HTTPS) from the security group of the EC2 Instances. This allows the EC2 instances to accept traffic only from the Presentation Tier EC2 Instances. (WebServerSG)
    - Allow outgoing traffic on all ports to 0.0.0.0/0 
    **Use case**
	- SecurityGroupIngress
		- Allow ICMP (Ping) traffic for 0.0.0.0/0
		- Allow SSH traffic for the Source Security Group 'BostonSG'
		- Allow 80 traffic for the Source Security Group 'WebServerSG'
		- Allow 443 traffic for the Source Security Group 'WebServerSG'
	- SecurityGroupEgress
		- Allow all outbound traffic (0.0.0.0/0)

- **Business Logic Tier EC2 Instances SecurityGroup (AppServer1SG)**
    - Allow incoming traffic on port 80 (HTTP) and 443 (HTTPS) from the security group of the Application Load Balancer. This allows the EC2 instances to accept traffic only from the Private Localbalance. (LBPrivateSG)
    - Allow outgoing traffic on all ports to 0.0.0.0/0 
    **Use case**
	- SecurityGroupIngress
		- Allow SSH traffic for the Source Security Group 'BostonSG'
		- Allow HTTP traffic for the Source Security Group 'LBPrivateSG'
		- Allow HTTPS traffic for the Source Security Group 'LBPrivateSG'
	- SecurityGroupEgress
		- Allow all outbound traffic (0.0.0.0/0)


- **RDS Database SecurityGroup (RDatabaseSG)**
    - Allow incoming traffic on the database port (e.g., 3306 for MySQL) from the security group associated with the Presentation Tier,Business Logic Tier ,EC2 instances. This ensures that the database can only be accessed by the trusted EC2 instances.
    - Allow outgoing traffic on all ports to 0.0.0.0/0 

    **Use case**
	- SecurityGroupIngress
		- Allow ICMP (Ping) traffic for 0.0.0.0/0
		- Allow 3306 traffic for the Source Security Group 'WebServerSG'
		- Allow 3306 traffic for the Source Security Group 'AppServer1SG'
	- SecurityGroupEgress
		- Allow all outbound traffic (0.0.0.0/0)

### Step - 4 Establish a Comprehensive Permissions Boundary for AWS IAM Roles

**PermissionsBoundary**

- AllowLogsPolicy
- AllowS3Policy
- AllowEC2Policy

### Step - 5 Establish IAM Roles for AWS Services and Resources

**IAMRoles**

- Establish a Common Role to Perform Related Tasks
	- VPCFlowLogRole
	- SSMIAMRole
- Establish a Dedicated Instance (WebServer,ApiServer,AppServer1,AppServer2) Role to Authorize Essential Permissions for Various Tasks and Services.
	- WebServerRole
	- ApiServerRole
	- AppServer1Role
	- AppServer2Role

### Step - 6 Create PrivateHostedZone

**PrivateHostedZone**

### Step - 7 VPC FLowLog

**VPCFlowLog**

### Step - 8 Establish VPC Endpoints for Aceess Various  and Services

**VPCEndpoints**

VPC Gateway Endpoints for Amazon S3
VPC Interface Endpoints for Amazon Services
VPC PrivateLink Endpoints for VPC to VPC

### Step - 9 Instance
### Step - 10 EKS
### Step - 11 ALB
### Step - 11 ASG
### Step - 11 S3
### Step - 12 RDS
### Step - 13 CloudWatch

