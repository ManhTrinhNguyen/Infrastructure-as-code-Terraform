# Infrastructure-as-code-Terraform

## Overview 

- I have created my Infrastructure manually .

  - Manually Create EC2 Instance
 
  - Manually Create EKS Cluster with all the Role and Networking Configuration
 
- Also I need to manage and keep configuring and adjusting that Infrastructure all the time after created

- The concept of Iac is automate those process just like I automated the build pipeline and to manage, creating and configuring Infrastructure also using Code . So I can work on that as a Team, have a history and make adjustment as a code

## Introduction to Terraform 

- Terraform allow me to automate and mange my Infrastructure, and my Platform and Services that run on that Infrastructure

- It is Open Source and use Declarative Language

  - Declarative Language : I don't have to define every step how is this automation and managment is done . I just Declare what I want the final result then Terraform will figure out how to execute it
 
### What does it mean that Terraform is a tools for infrastructure provisioning ?

- Let say I want to start Application and I want to set up a Infrastructure from scratch so my App can run

- There is 2 Different task for setting the Whole Setup : Prepare Infrastructure (Provisioning Infrastructure) (For Devops) and Deploy Applications (For Developers)

-Prepare Infrastructure (Provisioning Infrastructure) :

  - My Infrastructure will be like : Spin up several Server, where I will deploy 5 Microservice Apps that make up my Apps as Dockcer container and also Database Container . I decide AWS Platform to build my Infrastucture on
  
  - First I will go to AWS to prepare a setup so Application can deploy there . Prepare Infrastructure
  
    - Create Private Network Space (VPC)
      
    - Create EC2 Server (Spin up Server)
      
    - Install Docker in each one of those and other tools I might need
      
    - Security : Firewall rules etc...
      
    - !!! NOTE : All of these need to be done in the Correct Order bcs 1 task maybe depend on another

- Once my Infrastructure prepared I can now Deploy Applications on that .

- So Terraform come into the Provision Infrastructure part .

### What is different between Ansible and Terraform ?

<img width="600" alt="Screenshot 2025-03-30 at 09 56 18" src="https://github.com/user-attachments/assets/2f3697af-887a-4cd6-8b9e-13fc7c6a6206" />

- Terraform and Ansible are both Infrastructure as a Code . Meaning they are both use to automate, provisioning, configuring and managing the Infrastructure

- However Terraform is mainly infrastructure provision tools . Also can Deploy Application

- And Ansible is mainly a configuration tools . Once Infrastructure provision and it is there, Ansible can be use to Configure it and Deploy Application, Install and Update software on that Infrastructure

- Other different is Ansible is more Mature . Terraform is relatively new also changing dynamically . Terraform is more advance orchestration .

### Managing existing Infrastructure 

- Let's say I have created a Infrastructure and later I decide to add 5 more Server to deploy more Services, also my team also want to add some security configuration or maybe remove some stuff . Using Terraform I can make such Adjustment pretty easy .

- This task of managing the Infrastructure is just as Important bcs Once I have created initial Infrastructure, I will continually adjusting and changing it, and bcs of that I also need some automation tool, that will do most of the heavy lifting for me .

- Another common use case is replicating that Infrastructure .

    - Let's say I have tested this set up and everyting work fine I decide now I want to release my Application into Production Environment . So I want to create the same Infrastructure for Production and keep the first as a Development Environment where I can test new feature new microservices and update before I launch into Production . I can use Terraform to automate that Proccess . I can do the same for Staging Environment as well


### Terraform Architecture 

**How do Terraform work? How do Terraform connect to Provider Platform?**

- In order to do the Jobs, Terraform have 2 main component that make up its architecture : Terraform Core and Terrform Provider (Provider for specific technologies) .


**Terraform CORE**

- The Core uses 2 input sources in order to do its job .

  - Terraform Configuration (TF-config) : Me as a User write and where I define what need to be created or provisioned
 
  - Terraform State : Where Terraform keep the up to date how the current set up of the Infrastructure looks like
 
- So what Core then does is it take those input and it figures out the plan of what needs to be done . It compares the State, What is current State, What is the Configuration that I desire (The end result) and compare that and when it see there is difference or I want something else than what the current State is , It will figure out what need to be done to get to desire state of the configuration file (So what needs to be created, what needs to be updates, deleted in which order of Infrastructure set up) 

**Terraform Provider**

<img width="600" alt="Screenshot 2025-03-30 at 10 34 38" src="https://github.com/user-attachments/assets/0e2aa63a-6bb8-41ea-be80-69ced40d812f" />

- Provider for specific technology . Could be Cloud Provider like AWS, Azure or other ...

- Terrform has also provider for more higher level component like Kubernetes or other platform as a service tools . Even some software as a Service tools . So it give me possibility to create stuff on different level, like create an AWS Infrastructure then deploy Kubernetes on top of it, and then create Services or Components inside that Kubernetes Cluster . It does that through Providers

- Terraform has over 100 Providers for different technologies. And each provider then give Terraform user access to its resources .

    - With AWS provider, I have access to 100 of AWS resources, like EC2, AWS IAM etc...  
    - With Kubernetes provider I get access to Kubernetes resources like Services, Deployment and Namespace
 
- This way Terraform try to help provision and cover the complete application set up . From Infrastructure all the way to Application

- Once the CORE create an execution plan base on the input from config file and state . It then uses providers for specific technologies to execute the plan, to connect to those platforms and to acutally carry out those execution steps .

#### Example Configuration File 

- AWS :

<img width="500" alt="Screenshot 2025-03-30 at 10 39 27" src="https://github.com/user-attachments/assets/55e9529f-0620-4b1e-a121-0a111c84e2ee" />

- Kubernetes :

<img width="500" alt="Screenshot 2025-03-30 at 10 39 38" src="https://github.com/user-attachments/assets/49b2290f-04a1-41bc-8e48-56a0a40e5c73" />

#### Declarative and Imperative 

- When I create Terraform file instead of defining what steps to be executed to create VPC or to spin up 5 EC2 Instances, or create the network configuration I define the end State I desire

    - So I say 5 Servers with network configuration like this and I want one AWS user that has these permission to access those Server, Terraform will do that for me . Instead of defining exectly what to do which is (Imperative approach) I define what the end result should be (Declarative Approach)
 
- For the initial set up this may not make much difference . But consider When I am updating my Infrastructure like removing a server or adding another server or making other adjustment

    - With Imperative config file : Remove 2 Servers, add firewall config, add some permissions to the AWS user etc ... I give instruction of what to do .
 
    - With Imperative approach I have to somehow add up too much Instructions and figure out the dekta between all the changes applied by multiple instructions 
 
    - With Declarative config file : I would say, My new desired state is now seven Servers, this firewall config and user with this set of permissions . Do whatever needs to be done to get from the Current State to the new desired state . So now I don't have to acutally calculate and decide how many service need to be add .
 
    - With the Declarative approach I just adjust the old configuration file and re-execute it instead of adding the new set of instruction . This is very comfortable bcs my configuration files stays clean and small . Also Always know what the Current Setup is just looking at the configuratio file bcs it is alway the end result
 
  <img width="558" alt="Screenshot 2025-03-30 at 10 54 41" src="https://github.com/user-attachments/assets/b410e6bc-dcea-42e7-9d83-66750a0e85b1" />

### Terraform commands for different Stages 

**How do I make Terraform take action?**

- Terraform have commands I can execute to go through different stages

- `refesh`: Terrform will query the Infrastructure Provider (like AWS) to get up to date State . So Terraform will now know what is the current State of the Infrastructure .

- `plan`: taking current state and my configuration file as input and decide base on the difference what need to be done .

    - So What Terrform needs to do in order to achieve that desired state that I defined in a Terraform configuration file. If it is an initial setup it figures out all the steps to create the desired setup . If it is an update, it compare the existing setup with a new desired state and figures out what changes and adjustments need to be made in which order to create the new desired state like add new Servers, add new Permission etc...
 
    - This is where the CORE kind of constructs the plan logically or what need to be done
 
- `apply` : Execute the plan (Where the actual execution happen) .

    - So `plan` command like a reivew what will happen . If I execute `apply`, Terraform in the background will do the `refresh` get the up to date State then create the plan and then apply it
 
- `destroy` : Destroy the whole set up removing element one by one in the right order and cleaning up all the Resources that were created . Basically reverting everyting have been created

    - Destroy like `apply` it also check, will also check what is currently running and then create a plan of what needs to be removed, in which order .  

    - And it could be used let's say I create an environment for an important demo day and I didn't want to interfere with the existing environments . Once the demo is over I can destroy the whole setup

#### Key take away 

<img width="600" alt="Screenshot 2025-03-30 at 11 30 59" src="https://github.com/user-attachments/assets/72cf7a72-4e21-4e30-a01a-889ed90f4051" />

- Terrform is a tool for creating and configuring infrastructure like virtual servers and so on . And the managing the Infrastructure and not for installing application on these provisioned servers .

- Terraform is a universal Infrastructure as code tool . I can use 1 tool for all of those environment

- Bcs it intergrate with many diffent platform , I have 1 tools to intergrate all those different technologies and their API . So I don't need to learn a API of each tool to talk to them 

## Install Terraform (https://developer.hashicorp.com/terraform/downloads)

- Install via package manager

    - For Mac OS :
 
    ```
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
    ```

**Local setup**

- Write a Terraform file that connect to AWS account and I will create VPC and subnet in my AWS Account

- Step 1 : Create Project Folder

- Step 2 : Create file for terrform `main.tf`

- Step 3 : Create Terraform plugin for VS Code

## Providers in Terraform 

### Introduction 

- In Terraform whenever I want to connect to a technologies and start using its API to create resoruces inside, to configure it (Interact with AWS, Jenkins ...) . I need a Provider

- Provider is a program know how to talk to specific technology . This Provider translate my Terraform configuration to something that AWS API understand so it can talk to AWS for me .

#### Partner Provider 

- These are thrid party technology partners that have created these providers and also actively maintain them .

#### Community Provider 

- Bassically created by community members . This could ne team of developers and individual developers that publish their providers to terraform registry for others to use them as well

!!! NOTE : Terrform is really well documented . Whenever I looking for an example to create, to orchestrate or automate some technology with Terraform . I can look up in the Documentation 

### Install and Connect to Provider 

- Step 1 : I will configure Proivder In /Terraform/main.tf

-  Terrform being an infrastructure as code tool, basically will be used and its files will be checked in into a code repository

-  Never hard code credentiasl directly in the configuration file 

- Step 2 :

  ```
  provider "aws" {
  region = "us-west-1"
  access_key = ""
  secret_key = ""
  }
  ```

  - This is telling Terraform in order to be able to connect to my AWS account it will need those Credentials, and this is a Region that I am working in .
 
  - Those value I can find in Terrform AWS Docs
 
   -  So Provider is basically a program that know how to talk to AWS, and when we install Terraform it doesn't come with this code automatically (Provider are not included in Terrform download) . Bcs Terraform come with a lot of Providers, it will waste of Resoruces .

   -  Instead it is actuall modular. As a Terraform user decide what provider I want to work on and only install those . That mean whenever I define a Provider I need to install it

  - **Good Practice** : is to provide globally which Provider Terraform project use, as well as define the version number for each used provider in the Configuration file . This is not required but good practice to define it 
    
    ```
    terraform {
      required_providers {
        aws = {
          source = "hashicorp/aws"
          version = "5.93.0"
        }
      }
    }
    ```

  - In Documation If I click the Use Provider button I will give me a actual code with a specific version of that Provider (Alway latest version)
  
  - If I have multiple Provider I can list it in required_providers block with their specific version

- Step 3 : Create a Separate File called `providers.tf` and have this configuration define in Provider file

  ```
  providers.tf
  
  provider "aws" {
    region = "us-west-1"
    access_key = ""
    secret_key = ""
  }
  ```

- Step 4 : I have defined  the AWS Provider, Now I can install it locally using `terraform init` command  .

    - In /Terrform folder where main.tf located. I will execute `terraform init` .
 
    - In the background `terraform init` Terrform will look inside that folder where I am executing the Command and see that I have defined a provider, so it needs to install it
 
    - It is important to execute `terraform int` command in the folder where `main.tf` located
 
    - After it install I have 2 more file have been generated by Terrform `.terraform` and `.terraform.lock.hcl`
 
    - `.terrform`: I have Terrform provider AWS with a Version this is actually the code that has been downloaded that will then be talking to AWS for me
 
    - `.terrform.lock.hcl` : This is a file that keep track of which Providers are installed locally, which version I have and so on . If I add another Provider then I will appear in here
 
- NOTE : If I use multiple Providers, all of them will list in `providers.tf` . I can extract the whole configuration in separate file to keep my code clean.

- NOTE : Regarding to Provider definition this can work without the `providers.tf` code . and I can use AWS Provider without explicictly defining it in `providers.tf`. However it only work for Providers which are part of the Terraform Registry .

    - For Provider which are not part of the Terraform Registry I need to explicicitly defineing it in `providers.tf` bcs this configuration actually define the source or the location where terraform should look for the Provider code to download 

### Provider exposing resources 

- Once I have Provider installed locally . How Do I interact with Provider ? (AWS)

- Provider gives me access to the entire whole API of AWS . Basically whatever it possible to do with an API of a technology, provider is giving me that possibility.

- So if AWS expose different services and resources in those services . I can interact with them through Provider

- Now Through AWS Provider I can now have access to every single service in AWS and the Resources of those Services 

## Resources and Data Source

- `resource` and `data` is 2 type of Component that Provider give us 

#### Resources 

- The way to create new Resource in AWS is using `resource` . Every resource that I have access to through this Provider has specific name

  - Syntax for create resource : `resource "<provider>_<resource type>" "<variable_name>" {}`
    
  - For example I want to create VPC in AWS I can use : `resource "aws_vpc"`
 
  - variable name is I can call whatever I want
 
  - Inside the block in can pass parameter . Each resource block describes one or more infrastructure object
 
    - For example in VPC there is a parameter I need to pass in is `cidr_block = "10.0.0.0/16"` basically I define an IP address range that will be assign to VPC, all the component EC2 Instances or whatever that get created inside that VPC will get an IP address from this IP address range (This is a Private IP Address)
   
    - I want to create a Subnet in VPC so I create another resource . Whenever create Subnet I need to tell Terraform in which VPC the Subnet should be created .

      - !!! NOTE : Whenever I create a resource for another resource that doesn't exist yet . In Terraform I can reference the Resources that I have define in the same Context .
     
      - For example to get vpc_id in VPC resources I can get a VPC resources Object `vpc_id = aws_vpc.development-vpc` and then get the id from that object `vpc_id = aws_vpc.development-vpc.id` . That is how I can reference an vpc_id of VPC that I have not create yet .
   
      ```
      resource "aws_subnet" "dev-subnet-1" {
        vpc_id = aws_vpc.development-vpc.id
      }
      ```
    - Define cidr block . VPC has Range of Cidr block and Subnet will get a Sub Range of this whole VPC IP address .
   
    - I can define which AZ Subnet will be created in . If I leave it as a default it will take a Random one
   
    - Those attribute name I can look up in the Docs (https://registry.terraform.io/providers/hashicorp/aws/latest/docs) .
   
  - My entire code in this section :
 
  ```
  provider "aws" {
  region = "us-west-1"
  access_key = ""
  secret_key = ""
  }

  resource "aws_vpc" "development-vpc" {
    cidr_block = "10.0.0.0/16"
  }
  
  resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = "10.0.10.0/24"
    availability_zone = "us-west-1"
  }
  ```

#### Terraform Apply 

- `terraform apply` that will take whatever I defined in the Terrform file I create above and then it will apply that configuration  

- After `terraform apply` executed . It will wating for my Input , I need to confirm the action that Terraform is going to take

- In the Terminal Terraform will show me what Terraform plan to do in order to give me a Desire State

#### Data Sources

- What if I want to create a Subnet within an existing VPC ? So I would need an ID of a existing VPC 1 way to do that is going to my AWS UI and grab my VPC ID but it is not efficent

- So for that I can query that Infomation from AWS using Provider . And for that another the Component that Provider give us in addition to `resource` is `data`

- `data` let me query a existing resources and component in AWS while `resource` let me create new resources .

- The result of query is exported under my given name 

- `data "aws_vpc" "existing_vpc" {}` As a Parameter, we are passing in a search criteria or filter cirteria. I basically want to tell AWS, give me a VPC that matches this following criteria so I will pass the Parameters that will tell Terraform which VPC I want to get here as a Result

- I have a bunch of Parameter in the Docs .

  - I can tell Terraform give me an AWS VPC that has this specific `cidr_block`,
  
  - or `default` VPC

  - or give me VPC with specific id `id`

  - or VPC that has specific key-value pair define `tag`

  - or I have filter attribute here that let me define some more custom criteria to fetch the VPC
 
  - And this apply to all resources whenever I am defining data of provider I can fetch some information, some resources using `data`
 
- So let's say I want to get default VPC and then create a Subnet in that existing VPC . The I reference `data` (The result of this query) is . `data.<provier>.<name-of-the-data>` and it will give me a Object and I just want the ID `data.<provier>.<name-of-the-data>.id`

  - The different is if I want `data` result I need to put data at first . Terraform will know this is from `data` not from `resource` .
 
  - I am creating the subnet in a default VPC so I need to provide a subset of IP address from the default VPC cidr block . If have some subnet that already exist in default VPC the new Subnet have to have a different set of IP address . Bcs Each Subnet inside a VPC has to have different set of IP Address

```
data "aws_vpc" "existing_vpc" {
  default = true
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id = data.aws_vpc.existing_vpc
  cidr_block = "172.31.0.0/24"
  availability_zone = "us-west-1"
}
```

- Now I have dev-subnet-2 ready . I can `terraform apply` . Now Terrform will calculate (I can see in the Terminal) the difference and the actions they need to take in order to fulfill our desired State

#### Recap 

- One way to describe Provider and Resource and Data that similar to Programing Language

  - Provider defination is like Importing the Library that has set of code and function
 
  - Defining `resource` and `data` is like calling a function from that library I just imported by passing various parameter
 
  - `resource` is function that create something
 
  - `data` is function that return something that already exist
 
- And the user credentials that I define at the beginning Access key , Access Secret key . That user has to has certain permission in order to create things (Resources) in AWS or to Query (data) in AWS

- What happen if I execute `terraform apply` again (Nothing change in the Config file) . Terrform will checked all the resources and Terraform decide no changes that need to be made . And the reason is Terraform language is declarative

  -  Basically I need to declacre what the end result I want to be . I am not telling Terraform what to do . When I use `terraform apply` Terraform need to figure out the current State in the AWS account and Desired state .
 
    - current State : Do I have already have one subnet with this name and this configuration another subner with this name this configuration . If yes Terraform know there is nothing to do . If Terrform can not find the subnet in AWS account or this VPC then Terraform knows it has to create one
 
  - Terraform have a lot of advangtage :
 
    - Idem potency : mean whenever I execute or apply the same exact configuration 100 times I alway get the same result
   
    - And as a user I don't have to remember and know what the current State is and define what changes need to be made to that State . I only have to define what my end desired state should be . How many Subnet I want . Which Subnet I want .... and Terrform make a nessesary changed to get me to Desired Outcome 

## Change/Destroy a resource 

#### Changing Resources 

- I will add a Name to my `resource` .

- To give Name to the Resource . I can do that by using `tags` parameter. Tags are key-value pair in AWS and I can edit any resource in AWS and I can have arbitrary key-value pair

```
resource "aws_vpc" "development-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name: "development"
    vpc_env = "dev" # I can give any name I want
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-west-1"
  tags = {
    Name: subnet-1-dev
  }
}

data "aws_vpc" "existing_vpc" {
  default = true
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id = data.aws_vpc.existing_vpc
  cidr_block = "172.31.48.0/20"
  availability_zone = "us-west-1"
  tags = {
    Name: subnet-2-default 
  }
}
```
- Then I will apply it : `terraform apply`

  - In terminal I can see `~` and `+` and `-` icons
 
    - `~` : For a change
   
    - `+` : For created
   
    - `-` : For removing
   
  - In terminal I can see the change and also see that I have a number hidden attributes that will stay unchanged .
 
  - If I want to remove something I just need to take it out from `resource`
 
####  Removing/Destroying Resources 

- Let's say I don't want the dev-subnet-2 anymore . There is 2 way that removing the `resource` that I don't need it anymore

  - Option 1 : Remove the `resource` from Terraform file . Again Terraform will compare a current State which is I have a Subnet in default VPC and the Desired State which is no Subnet Resources specified for default VPC . 
 
  - Option 2: Using Terraform command `terraform destroy -target <resource-type>.<resource-name>` . 

  - Alway use Options 1 bcs if I use Options 2 I end up with configuration file that doesn't acutally correspond to current state
  - 












 
