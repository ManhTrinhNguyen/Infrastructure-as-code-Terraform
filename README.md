- [Provisioner](#Provisioners)

- [Modules Part 1](#Modules-1)

- [Modules Part 2](#Modules-2)

- [Modules Part 3](#Modules-3)

- [Automate Provisoning EKS-Cluster Part 1](#Provision-EKS-1)

- [Automate Provisoning EKS-Cluster Part 2](#Provision-EKS-2)
 
- [Automate Provisoning EKS-Cluster Part 3](#Provision-EKS-3)

- [How do Control Plane and Worker Node Communicate ?](#Control-Plane-Worker-Node-Communication)

- [Complete CI/CD with Terraform](#CI/CD-Terraform)

- [Remote State in Terraform](#Remote-State)

- [Best Practice in Terraform](#Best-Practice)

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

## Terraform commands 

- Let's say I have a configuration file and I want to check difference between current and desired state, and I don't know what current state is bcs there is multiple people working on the project and I just to see the different and also I don't want to do `terrform apply` . For that I can use `terrform plan`

- `terraform plan` is like a preview same as what Terraform apply command give me but without acutal apply it

- If I am executing `terraform apply` command and I don't want always confirm , I can pass in `terraform apply -auto-approve`

- What if i want to completely destroy my Infrastructure . I want to clean up everything I create in the configuration file : `terraform destroy`  . This command will destroy all the resource in the correct order one by one

## Terraform State 

- Terrform keep track of a Current State and read the Desire State from the configuration file .

- When I execute `terraform apply` or `terraform destroy` I will have refresing state messages . For the `resources` that are available in the configuration file or I have defined here, Terraform refreshes the state and then it calculates in the background wheather anything needs to be done in order to get from the current state to the desired state

- How does Terrform knows what the Current State of the resources defined in the Configuration file ?

  - In Terraform folder that have `main.tf` file 2 additional files have been generated by Terraform and these are called `terrform.tfstate` and `terraform.tfstate.backup`
 
    -  `terrform.tfstate` : This is a JSON file that give me a list of resources and their current State . And terrform generate these file on the first apply .
   
    -  First time apply, Terraform will go to AWS and connect to AWS account, It execute whatever we defined in a configuration state . and then store Terraform State in the `terraform.tfstate` file
   
    -  Whenever I make changes this `terraform.tfstate` get updated . And this refreshing output that I see in the Terminal . What `refresh` actually does is Refresing `terraform.tfstate` file and setting new information   

    - `terraform.tfstate.backup` : is the Previous State for the resources . Before I deleted all my resources this was a State, the previous state with all the information here and it is save as a backup to have a previous state as well
   
- Terraform uses `terraform.tfstate` and `terraform.tfstate.backup` to manage the State and update the Current State in order to know what changes need to be done to take me from the current State to a Desired State

- Especially If I have 100 of `resource` in my account it will be so difficult to see in `terrform.tfstate` . If I want to see some of the attr in there I can use command : `terrform state` . This command help me access inside the State

  -  When I execute `terraform state` I can see a list of subcommand
  
   ```
      Subcommands:
      list                List resources in the state
      mv                  Move an item in the state
      pull                Pull current state and output to stdout
      push                Update remote state from a local state file
      replace-provider    Replace provider in the state
      rm                  Remove instances from the state
      show                Show a resource in the state
   ```

   - Most of the time shouldn't update the State directly . Should be done by Terraform itself 
 
## Output Values

- Allow me to output a set of Attribute and their values of the resources I just created

- As I can see those generated values by `resources` once I create `resource`, either in the Terraform State file `terraform.tfstate` or using `terraform state` show subcommand for specific resources

- Another way to get those genrated values is using ouput values .

- Output values are like function return values

- Inside the configuration I can define what value Terraform want to output at the end of applying my Configuration from 1 of `resource`

-  For example I want to output the ids of every `resource` that I am creating (VPC and Subnet) .

  - First I will `terraform destroy` both of them . Then I will recreate them an output id of each resources

  - I will use `output "variable_name" {}` . And In the block I want to tell Terraform which Atrributes value I want it to output . `output "variable_name" {value = aws_vpc.development-vpc.id}`. If I want to check which attribute are available for each `resource` I can use `terraform plan` which will show me the preview plan action including the attributes either I set or AWS will set for that `resource`

- Each attribute I have to define its own output
  
```
output "dev-vpc-id" {
  value = aws_vpc.development-vpc.id
} 

output "dev-subnet-id" {
  value = aws_subnet.dev-subnet-1.id
}
```

- This is handy if I am creating bunch of `resource` and I want to have ids of all of them Or If I create Server Instances and I want their public IP Address I can output them so I don't have to do `terraform state show`


## Variables 

- I can use `variable` in the configuration file

- For example I want value of CIDR Block not to be hardcode but I want to pass it as a parameter, in this case I can define a `variable` for CIDR block and then reference that variable and its values

- It could be very handy if I have value that used multiple times for different `resource` . Or If I want to reuse the configuration files of Terraform for multiple different environments and I want to passin diffrent
parameter for different use case

- Input valirables are like function arguments .

- I will use variable for CIDR block subnet by using `variable "subnet-cidr-block" {}` I can name variable whatever I want .

  - Inside the block I can define several attributes

  ```
  variable "subnet-cidr-block" {
    description = "subnet cidr block"
  }
  ```

  - And now I can use a Variable as a value `vpc_id = aws_vpc.development-vpc.id`
 
  ```
  resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.subnet-cidr-block
  availability_zone = "us-west-1"
  }
  ```

#### 3 way to pass value to the input variable 

- First way : When I do `terraform apply` I get a prompt for entering for entering the CIDR Block

- Second way: Using command line Argument `terraform apply -var "subnet-cidr-block=10.0.30.0/24"`

- Third way : Defining variable file and assigning all the variable to my terraform configuration inside that file . And that file in Terraform acutally has its own naming convention and file ending `terraform.tfvars`

  - Inside this file : I can define key-value pairs for my Variables . `subnet_cidr-block = "10.0.40.0/24"` and save it . and then I apply it `terraform apply` Terraform will find that Variable file and read the variable value and set it
 
  - This is a best pratice . Should use most of the time .
 
  - For example

  ```
  main.tf

  variable "vpc_cidr_block" {
    description = "vpc cidr block"
  }
  variable "subnet_cidr_block" {
    description = "subnet cidr block"
  }
  resource "aws_vpc" "development-vpc" {
    cidr_block = var.vpc_cidr_block
  }
  
  resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = "us-west-1"
  }
  ```

  ```
  terraform.tfvars

  subnet_cidr_block = "10.0.40.0/24"
  vpc_cidr_block = "10.0.0.0/16"
  ```

#### Use case for Input Variables 

- If I have configuration file or multiple configuration files that create a whole infrastructure and If I want to replicate the same exact infrastructure as development environment, a staging environment and production environment I can have the configuration files for all three environment and then change the parameters base on the Environment I am in.

- For example :

```
main.tf

variable "environment" {
  description = "deployment environment"
}

resource "aws_vpc" "development-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: var.environment
  }
}
```

```
terraform.tfvars

environment = "deployment" ## Base on which environment I am applying to, I would basically subtitue the value for that envinronment  
```

- In this case I would have a variables file for Dev, Production and Staging

  - `terraform-dev.tfvars`: All the dev environment would set here 
 
  - `terraform-pro.tfvars` : All the production environment would set here
 
  - `terraform-staging.tfvars` : All the staging environment sould set here
 
- If I change the name of these variables file from `terraform.tfvars` to `terraform-dev.tfvars` or else I have to pass the file name as a parameter when I apply . `terrafrom apply -var-file terraform-dev.tfvars`

#### Default Value 

- I can assign variables default values . In is `variable "" {}` block I can set default

  -  Default variable will kick in if Terraform can not find a value defined for that Variable . Either in the Variable file or as a command line parameter
 
  ```
  variable "vpc_cidr_block" {
    description = "vpc cidr block"
    default = "10.0.10.0/24"
  }
  ```

  -  This is handy , if I have the configuration that should work as a default setup and then I allow different users for different use cases to pass in parameters to override the default . Example development configuration could be the default and then I would have variable files for other environments . Or could be Production and then I have development and staging variable file
 
#### Type Constraints 

- I can set the Variable Type. Could be string, number, bool, 

  ```
  variable "vpc_cidr_block" {
    description = "vpc cidr block"
    default = "10.0.10.0/24"
    type = string
  }
  ```

- I use it in the case If I have some value that has to be of a certain type. And I want the users of my configuration files that basically pass in value through the Variable file .

- Another example I want variable to be a list that contain multiple cidr blocks

  ```
  main.tf
  
  variable "cidr_block" {
    description = "vpc cidr block for vpc and subnet"
    default = "10.0.10.0/24"
    type = list(string)
  }
  ```

  ```
  terraform-dev.tf

  cidr_block = ["10.0.0.0/16", "10.0.10.0/24"]
  ```

  - Now I have the variable that hold a List so I have to change how I reference that variable
 
  ```
  main.tf

  variable "cidr_block" {
    description = "vpc cidr block for vpc and subnet"
    default = "10.0.10.0/24"
    type = list(string)
  }

  resource "aws_vpc" "development-vpc" {
    cidr_block = var.cidr_block[0]
  }

  resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.cidr_block[1]
    availability_zone = "us-west-1"
  }
  ```

- Another example that I can also have Object as variable

  ```
  cidr_blocks = [
    {cidr_block = "10.0.0.0/16", name = "dev-vpc"},
    {cidr_block = "10.0.10.0/24", name = "dev-subnet"}
  ]
  ```

  - I can validate a list of object using a list of object type
 
  ```
  main.tf

  variable "cidr_block" {
    description = "vpc cidr block for vpc and subnet"
    default = "10.0.10.0/24"
    type = list(object{
      cidr_block = string
      name = string
    })
  }

  resource "aws_vpc" "development-vpc" {
    cidr_block = var.cidr_block[0].cidr_block
    tags = {
      Name: var.cidr.blocks[0].name
    }
  }

  resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.cidr_block[1]..cidr_block
    availability_zone = "us-west-1"
    tags = {
      Name: var.cidr.blocks[1].name
    }
  }
  ```

  - Use case for this is if I create configuration files and the I let other team members maybe use those configuration files by passing in different parameters as variables . I may want to restrict or give them guidelines to what values they can pass in as parameters 


## Environment Variables in Terraform 

- Never Hardcode credentials . There is 2 ways to set Credentiasl so Terraform can pick it up

#### Setting as ENV

- In terminal . `export AWS_SECRET_ACCESS_KEY=""`  . This is the same exect ENV that I need to set for using AWS command line interface . This is the same for AWS itself . Then I do `terraform apply` Terraform will able to connect to AWS eventhough I don't have credentials in the Configuration ile for provider block

- However If I switch to another terminal those ENV will not set bcs they only accessible in certain context that set them up

- If I want to have globally configured AWS credentials then I need to configure them in the `~/.aws/credentials`, this is a default location for storing AWS credentials on any Operating System, then Terraform can also pick it up .
  
    - As long as I have AWS CLI on my machine I can set the credentiasl using AWS configure command `aws configure`. 

    - When I do `aws configure` and enter all these values . The `~/.aws/credentials` will automatically get generated with credentials and config files inside . And that will be bacsically my global AWS user credential configuration
 
    - Now if I use `terraform apply -var-file terraform-dev.tfvars` Terraform should be able to authenticate with AWS account
 
    - I can also config Region using ENV . In my local machine I have the default Region set already . So in my I can leave `provider "aws" {}` empty
 
#### Set Variable using TF environment variable . 

- What if I want to define my own custome ENV .

- Terraform let me set global ENV using `TF_VAR_<Any-Name>` . Example : `export TF_VAR_avil_zone`="us-west-1".

  - After that
    
  ```
  main.tf

  variable avil_zone{}
  
  resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.cidr_block[1]..cidr_block
    availability_zone = var.avil_zone
    tags = {
      Name: var.cidr.blocks[1].name
    }
  }
   ```

## Create Git Repository for local Terraform Project 

<img width="600" alt="Screenshot 2025-04-03 at 14 06 23" src="https://github.com/user-attachments/assets/11688431-809a-4264-a07a-0dc19b90af96" />

- In Github Repo I create `terraform-learn` Repository . This should be Private but for learning purpose I will keep it Public .

#### Connect local project with Git Repo 

-  Initialize empty repo : `git init`

-  Connect to remote folder : `git remote add origin <git-repo-url>` . This is will point to the remote project I have create in Github

-  `git status` (check current status of git) : It tell me I have to check in all the code

-  `.gitignore`:

    - Ignore `.terraform/*` folder . Doesn't have to part of the code bcs when I do `terraform init` it will be downloaded on my computer locally
 
    - Ignore `*.tfstate`, `*.tfstate.*` bcs Terraform is a generated file that gets update everytime I do `terraform apply`.
 
    - Ignore `*.tfvars` the reason is Terraform variables are a way to give users of  terraform a way to set Parameter for the configurations file this parameters will be different base on the Environment . Also Terraform file may acutally contain some sensitive data
 
- Basiccally I have `main.tf`, `providers.tf`, `.terraform.lock.hcl`

    - `terraform.lock.hcl` file should be check in bcs this is a list of Proivders that I have installed locally with specific version 

## Automate AWS Infrastructure 

#### Demo Overview 

- I will deploy EC2 Instances on AWS and I will run a simple Docker Container on it .

- However before I create that Instance I will Provision AWS Infrastructure for it

- To Provision AWS Infrastructure

  1. I need create custom VPC
   
  2. Inside VPC I will create Subnet in one of the Availability Zone . I can create multiple Subnet in each AZ 
 
  3. Connect this VPC to Internet using Internet Gateway on AWS . Allow traffic to and from VPC with Internet
 
  4. And then in this Configure VPC I will deploy an EC2 Instance
 
  5. Deploy Nginx Docker Container
 
  6. Create Securtiy Group (Firewall) in order to access the nginx server running on the EC2
 
  7. Also I want to SSH to my Server . Open ports for that SSH as well
 
- When I have multi server deployment, basically I just have multi server deployment basically I just have to create the whole network and infrastructure configuration once

- **Best Practice with Terraform** : That I want to create the whole Infrastructure from sratch I want to deploy everything that I need, All the Infrastructure, All the Server inside and it I don't need it anymore later I can just remove it without touching the defaults created by AWS . That mean I want to create my own VPC and I want to work with my own VPC and leave the default one basically as is

#### VPC and Subnet 

- Create `variable` and put it into a vpc `resource` and subnet `resource`

- Also Change the name tag . For every component that I am creating I will give it a prefix of the environment that it is going to be deployed in . So on the development server all components will have dev prefix . On production will have prod prefix and so on . So I will create env `variable env_prefix {}`

    - To use `variable` inside the String . `Name: "${var.env_prefix}-vpc"` 

```
main.tf

provider "aws" {
  region = "us-west-1"
}

variable vpc_cidr_block{}
variable subnet_cidr_block {}
variable availability_zone {}
variable env_prefix {} 

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name: "${var.env_prefix}-subnet"
  }
}
```

- Now I will set Variable in `terraform.tfvars`

```
vpc_cidr_block = "10.0.0.0/16"
subnet_cidr_block = "10.0.10.0/24"
availability_zone = "us-west-1b"
env_prefix = 'dev'
```

- Everything is ready to create VPC and Subset

    - I will use `terrform plan` : To show me what Terraform will be execute
 
    - Then I can apply it `terraform apply --auto-approve`

#### Route Table And Internet Gateway 

- In VPC details view I can see some default components Terraform generated for me :

  - Route Table : was generated by AWS for my newly created VPC . Route Table is a Virtual Router in VPC . A Route Table is just a set of rules that tells your network where to send traffic.
    
      - Route table decide where the traffic will be forwarded to within the VPC
   
      - AWS give me a Route table by default whenever I create a VPC
   
      - When I click in my Route table I see 1 route configured . Bcs Route Table basically routes the traffic within a VPC . Example if I have multiple EC2 Instances inside the VPC or some other resources Route Table will be handling and managing the traffic between them .
   
      - Destination `10.0.0.0/16` is a IP Address's range that I defined in `vpc_cidr_block`
   
     - I have the IP Address Range inside that network
 
     - I also have Network ACL . Firewall configureation for Subnet in that VPC .
     
          - Network ACL open by default . Security Group closed by default
   
      - In our VPC I have a route table handles all the traffic inside VPC and I know it is a traffic inside VPC bcs IP address range matches my VPC's IP Address range
   
      - Local Target mean this is handled within the VPC . Doesn't go outside in the internet and that mean my VPC isn't connect to internet
   
      - Important: The route table doesn’t care about specific IP addresses like `10.0.1.5`. It works with CIDR blocks, and based on where the destination IP falls, it decides which target (gateway, NAT, endpoint, etc.) to use.
   
- **Internet Gateway Target** : This mean this Route Table acutally handles or will handle all the traffic coming from the Internet and leaving the Internet 

    - Basically I need the Internet Gateway Target in my Custom VPC so I can connect my VPC to the Internet

#### Create new Route Table 

- I will create new Route table and create those 2 Rules .

    - Local Target : Connect within VPC
 
    - Internet Gateway : Connect to the Internet
 
- By default the entry for the VPC internal routing is configured automatically . So I just need to create the Internet Gateway route

- I am creating the internet gateway in the VPC and then I am using that Internet gateway inside my Route Table to tell Route Table handle the request of the VPC to go to and come in from the Internet

- Terraform knows in which order or in which sequence the components must be created . That mean even if I define in the wrong order, Terraform will figure out which resource need to create frist 
  
```
main.tf

## I have VPC and subnet VPC configure above

resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id ## Define VPC that I want to create from

  route {
    cidr_block = "0.0.0.0/0" ## Any IP address can access to VPC
    gateway_id = aws_internet_gateway.myapp-igw ## This is a Internet Gateway for my Route Table 
  }

  tags = {
    Name: "${var.env_prefix}-rtb"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
    Name: "${var.env_prefix}-rtb"
  }
}
```

- **Recap** : I have configured VPC and Subnet inside VPC . I am connecting VPC to Internet Gateway and then I am configureing a new Route Table that I am creating in the VPC to route all the Traffic to and from using the Internet Gateway

- Think about the Route table as virtual router inside VPC and Internet Gateway as a virtual modem that connect me to the Internet

!!! Best Practice : Create new components, instead of using default ones

#### Subnet Association with Route Table 

- If I click in Route Table Section . I have a tap called Subner Assoociations . This mean I have created a route table inside my VPC . However I need to associate subnets with the route table so that traffic within the subnet can also be handled by the route table.

- By default when I do not associate subnets to a route table they are automatically assigned or associated to the main route table in that VPC where the Subnet is running 

- The main Route Table is the one said Yes in the Main column 

- Right now subnet is associated with the main route table that doesn't have the internet gateway . I will change that in Terraform

```
## Continue in the main configuration above

main.tf

resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id = aws_subnet.mapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}
```

- To execute Terraform file `terraform apply`

- So my Subnet or all the reousrces including EC2 that I will deploy into my subnet, all these request will be handle by the Route Table I just created

#### Use Main Route Table 

- What if I used the default route table instead of the new one

- To use the default route table

- The way I can configure the default Route Table is using Resource called AWS default routes table .

- To get the `default_route_table_id` from the VPC Object I will use : `terraform state show aws_vpc.myapp-vpc` . I can see all the attributes this `resource` have (However I need to have that resource exsiting in my AWS account, otherwise I won't be able to get any list) . So now I can see the `default_route_table_id` . 
  
```
## Remove aws_route_table_association resource
## Remove aws_route_table resource
## I still keep the Internet Gateway

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
    Name: "${var.env_prefix}-rtb"
  }
}

resource "aws_default_route_table" "main-rtb" {
  ## I don't need a vpc_id bcs I am referencing the existing Route Table .

  ## Instead I need default_route_table_id .
  default_route_table_id = aws_vpc.myapp.vpc.default_route_table_id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name = "${var.env_prefix}-main-rtb"
  }
}
```

- After execute `terraform apply` . The previous route table got removed and the new one got created and the new one got created in its place, which is also a main one .

- In that route section I see the defailt local routing and gateway configuration .

- And In the Subnet Association I have not defined any explicit subnet association for this route table . However subnets in that VPC all the subnets that are not explicitly associated are automatically assigned to main route table . So I don't have to do 
 explicitly associated agian bcs It happen by default  

#### Security Group 

- When I deploy my virtual machine in the subnet, I want to be able to SSH into it at port 22 . As well as I want to accessing nginx web server that I deploy as a container, through the web browser so I want to open port 8080 so that I can access from the web browser

- First I need `vpc_id` . So I have to associate the security Group with the VPC so that server inside that VPC can be associated with the security group and VPC ID 

- Generally I have 2 type of rules :

    - I have traffic come in inside the VPC (Incoming Traffic) . For example When I SSH into EC2 or Access from the browser. The Incomeing Traffic rule are configured by attribute call `ingress` . inside the Ingress block I have configuration for one firewall role and I have couple attribute inside Ingress block
 
      - The resone we have 2 Ports `from_port` and `to_port` It is bcs I can acutally configure a Range . For example If I want to open Port from 0 to 1000 I can do `from_port = 0 && and to_port = 1000`
      - `cidr_blocks` : Sources who is allowed or which IP addresses are allowed to access to the VPC
     
      - For SSH accessing the server on SSH should be secure and not everyone allow to do it

      - If my IP address is dynamic (change alot) . I can configure it as a variable and access it or reference it from the variable value instead of hard coding . So I don't have to check the `terraform.tfvars` into the repository bcs this is the local variables file that I ignored . Bcs everyone can have their own copy of variable file and set their own IP address
     
  - Traffic outgoing call `egress` . The arrtribute for these are the same
 
      - Example of Traffic leaving the VPC is .
   
          - Installation : When I install Docker or some other tools on my Server these binaries need to be fetched from the Internet
          - Fetch Image From Docker Hub or somewhere else 
        
```
## Continue from above section

variable var.my-ip {}

resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["${var.my-ip}"] ## This is not a single IP address . This is a range of IP addresses  
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"] ## This is not a single IP address . This is a range of IP addresses  
  }

  egress {
    from_port = 0 # Not restric from and to any PORT 
    to_port = 0
    protocol = "-1" ## Any Protocol 
    cidr_blocks = ["0.0.0.0/0"] ## This is not a single IP address . This is a range of IP addresses
    prefix_list_id = [] # It for allowing access to VPC endpoints 
  }

  tags = {
    Name : "${var.env_prefix}-sg"
  }
}
```

- After execute `terraform apply --auto-approval` . I can check in the Security Group

  - I have the default security group of the VPC that I created . Bcs AWS create some default component for VPC and security group is one of them . By default Security Group is blocked all the port are closed no traffic is allowed in
 
  - And I also have the Security Group I just created
 
  - !!! Note : I can resue the default SG and I don't have to create a new one

#### Use Default Security Group 

```
variable var.my-ip {}

resource "aws_default_security_group" "myapp-sg" {
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["${var.my-ip}"] ## This is not a single IP address . This is a range of IP addresses  
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"] ## This is not a single IP address . This is a range of IP addresses  
  }

  egress {
    from_port = 0 # Not restric from and to any PORT 
    to_port = 0
    protocol = "-1" ## Any Protocol 
    cidr_blocks = ["0.0.0.0/0"] ## This is not a single IP address . This is a range of IP addresses
    prefix_list_id = [] # It for allowing access to VPC endpoints 
  }

  tags = {
    Name : "${var.env_prefix}-default-sg"
  }
}
```

#### Amazon Machine Image for EC2 

- Review : I have a VPC that has a Subnet inside . Connect VPC to Internet using Internet Gate Way and configure it in the Route Table . I also have create Security Group that open Port 22, 8080

- Create EC2 Instances :
  
```
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owner = ["amazon"]
  filter = {
    name = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
  filter = {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
 
resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
}
```

  - `ami` : Is a Operating System Image . Values of this is a ID of the image `ami-065ab11fb3d0323d`

    - This `ami id` might be different base on Region. Also it can be change when the new image gets released . Should never hardcode it
   
    - So Instead hard code `ami id` I will use `data` to fetch the Image ID

    - To get `Owners` got to EC2 -> Image AMIs -> paste the `ami id` image that I want to get owner from. I will see the owner on the tap
   
    - I can also have my own Image . In the Launch instances -> Amazon Machine Image -> I can see My AMIs section . For example If I create a EC2 Instance the Amazon Linux Image then I make changes on top of that like install some tools etc and just prepare it for my own needs, I can create my own Image and reuse for other deployments

    - Then I have a `filter` . filter in data let me define the criteria for this query  . Give me the most recent Image that are owned by Amazon that have the name that start with `amzn2-ami-kernel` (Or can be anything, any OS I like to filter) . In `filter {}` I have `name` attr that referencing which key I wants to filter on, and `values` that is a list
   
    - I can define as many filter as I want
   
    - Output the `aws_ami` value to test my value is correct `output "aws_ami_id" { value = data.aws_ami.latest-amazon-linux-image }` . Then I will see `terraform plan` to see the output object . However with output is how I can actually validate what results I can getting with this data execution . After this 
I can get the AMI-ID and put it in `ami`
  
#### Create EC2 Instances 

```
tf.main

variable instance_type {}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owner = ["amazon"]
  filter = {
    name = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
  filter = {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
 
resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_default_security_group.default_sg.id]
  availability_zone = var.avil_zone

  associate_public_ip_address = true

  key-name = "server-key-pair"

  tags = {
    Name: "${var.env_prefix}-server"
  }
}
```

```
terrform.tfvars

instance_type = "t2.micro"
```

- Second Required Attr is `instance_type` . I can choose `instance_type` base on how much `resource` I want .

- Maybe I want to deploy different type in different Environment so I can make it configurable and reference it as a `Variable`

- Other Attribute is Optional like subnet id and security group id etc ... If I do not specify them explicitly, then the EC2 instance that we define here will acutally launched in a default VPC in one of the AZ in that Region in one of the Subnet . However I have create my own VPC and this EC2 end up in my VPC and be assign the Security Group that I created in my VPC .

- To define specific subnet : `subnet_id = aws_subnet.myapp-subnet-1.id`

- To define Security Group : `vpc_security_group_ids = [aws_default_security_group.default_sg.id]`

- `associate_public_ip_address = true`. I want to be able access this from the Browser and as well as SSH into it .

- I need the keys-pair (.pem file) to SSH to a server . Key pair allow me to SSH into the server by creating public private key pair or ssh key pair . AWS create Private Public Key Pair and I have the private part in this file .

  - To secure this file I will move it into my user `.ssh`  folder : `mv ~/Downloads/server-key-pair-pem` ~/.ssh/ ` and then restrict permission : `chmod 400 ~/.ssh/server-key-pair.pem` . This step is required bcs whenever I use a `.pem` doesn't a strict access aws will reject the SSH request to the server
 
  - To use the key : `key-name = "server-key-pair"`
 
- Now I can use `terraform apply --auto-approve` to create EC2 Instance

- After created I can ssh into it `ssh -i ~/.ssh/server-key-pair.pem ec2-user@<public-ip>`

#### Automate create SSH key Pair

```
main.tf

variable public_key_location {}

resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_default_security_group.default_sg.id]
  availability_zone = var.avil_zone

  associate_public_ip_address = true

  key_name = aws_pair.ssh-key.key_name

  tags = {
    Name: "${var.env_prefix}-server"
  }
}
```

```
terraform.tfvars

public_key_location = "/Users/nana/.ssh/id_rsa.pub"
```

- `public_key` : I need a Public Key so AWS can create the Private key pair out of that Public key value that I provide

    - Where Do I get the Public key ? Locally I can create my own Private and Public key pair it by using `ssh-keygen` then I have files like this `.ssh/id_rsa.pub` and `.ssh/id_rsa` I can reuse it for other Provider
    
    - To use that public_key in Terraform I can extract that key into a `Variable` or I can use `File` location
    
      - `puclic_key = file("~/.ssh/irs.pub")` or I can set location as `variable` `public_key = file(var.my_public_key)` and then in `terraform.tfvars` I set the public_key_location variable `public_key_location = "~/.ssh/id_rsa.pub"` 

  - Now I can reference this key pair in the AWS EC2 instances .

  - Then Now I can apply it : `terraform apply --auto-approve`
 
  - Then I can add another Output that print the Public IP of the Instance :
 
  ```
  output "ec2_public_ip" {
    value = aws_instance.myapp-server.public_ip
  }
  ```

  - Now Bcs I use the Public key from my local and I don't have the `.pem` file . I can take the `~/.ssh.id_rsa` private key to ssh to a Server `ssh -i ~/.ssh/id_rsa ec2-user@52.58.95.171` . Short cut `ssh ec2-user@52.58.95.171` I don't have to specify .
 
#### Advandtage of Terraform 

- When I am creating a lot of resources and you end up creating some of it and configuring some of that stuff there is high chance that I forget about these things when this time to clean up the resources . So when I delete everything using `terraform destroy` . I may actually forget to delete this stuff that I created manually or configured manually

- Another case is If I want to replicate the environment  I want to create development environment and I want to use the same for Staging environment .

- Repication is difficult with maunual configuration . I have to document the manual steps

- Collaboration is more difficult

- **Best Practice** : So there is a clear advantage of automating and basically writing all the code that possible inside the Terraform configuration file and not doing and configuring stuff manually 

#### Run entrypoint script to start Docker container 

-  Now I have EC2 server is running and I have Networking configured . However there is nothing running on that Server yet . No Docker install, No container Deployed

-  I want to ssh to server, install docker, deploy container automatically . So i will create configuration for it too

-  With Terraform there is a way to execute commands on a server on EC2 server at the time of creation . As soon as Intances ready. I can define a set of commands that Terraform will execute on the Server . And the way to do that is using Attr `user_data`

-  `user_data` is like an Entry point script that get executeed on EC2 instance whenever the server is instantiated . I can provide the script using multiline string and I can define it using this syntax

    ```
    main.tf

    variable public_key_location {}
    
    resource "aws_key_pair" "ssh-key" {
      key_name = "server-key"
      public_key = file(var.public_key_location)
    }
    
    resource "aws_instance" "myapp-server" {
      ami = data.aws_ami.latest-amazon-linux-image.id
      instance_type = var.instance_type
    
      subnet_id = aws_subnet.myapp-subnet-1.id
      vpc_security_group_ids = [aws_default_security_group.default_sg.id]
      availability_zone = var.avil_zone
    
      associate_public_ip_address = true
    
      key_name = aws_pair.ssh-key.key_name

      user_data = <<EOF
      
      ### Inside this block I can define the whole shell script . Just like I would write it in a normal script file, in a bash file
  
                    #!/bin/bash
                    sudo yum update -y && sudo yum install -y docker
                    sudo systemctl start docker
                    sudo usermod -aG docker ec2_user
                    docker run -p 8080:80 nginx
                  EOF

      user_data_replace_on_change = true
    
      tags = {
        Name: "${var.env_prefix}-server"
      }
    }
    ```  

    - `-y`: Stand for automatic confirmation
 
    - `sudo systemctl start docker` : Start docker
 
    - `sudo usermod -aG docker ec2_user` : Make user can execute docker command without using sudo
 
    - So above is a `user_data` command that will run everytime the instance gets launched . I just need to configure the Terraform file, so that each time I change this user data file, The Instance actually get destroyed and re-created.
 
    - If I check AWS_Provider docs and check for `aws_intance` I can see the `user_data` input filed has an optional flag `user_data_replace_on_change` . I want enable this flag, I want to ensure that my Instance is destroyed and recreated when I modify this `user_data` field . This way I know that my user data script is going to run each time on the clean, brand-new instance, which will ge me a consistent State
 

- Once I have `user_data` configured I can use `terraform apply`.

- !!! NOTE : `user_data` will only executed once . However bcs I add `user_data_replace_on_change = true` now if the `user_data` script itself changes  this will force the recreation of the of the instance and re-execution of the user data script . But again this is only if something in the `user_data` script itself changes. If changes everything else like tags , key_name .... In this case it not going to force the recreation of the instance

- In my example bcs I made a change related to the user data specificly by adding this attribute. When I ran `terraform apply` The instance will be re-created and `user_data` was executed again

- And this time I added another output to show me the Public_ip so save me time to go to get public ip

#### Extract to shell script 

- Of course if I have longer and configuring a lot of different stuff I can also rerference it from a file .

- I will use file location `user_data = file("entry-script.sh")`

- In the same location I will create a `entry-script.sh` file

```
 #!/bin/bash
sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker
sudo usermod -aG docker ec2_user
docker run -p 8080:80 nginx
```

#### Commit to own feature branch 

- I can check all this code into separate feature branch and push it to remote repository .

  - `git checkout -b feature/deploy-to-ec2-default-components`
  - `git add .`
  - `git commit -m "create new branch"`
  - `git push`

#### Configuring Infrastructures, not Servers 

- I just created infrastructure . All using Terraform . 

  - Configure networking

  - Provision a server EC2

- Then Once the Infrastructure are actually ready and it is time to deploy applications and install stuff on it. I acutally switch back to shell script

- The point here is that Once server created . Once Infrastructure is there Terraform doesn't help further with installing Docker and configuring out server any further . It give a possibility to execute script by giving the attribute but I can't debug . If something go wrong I won't have a feedback or a message . I will have to SSH into it and I will have to see what happened why doesn't work ....

- Where Terrafrom should be use and where Terraform will stop . So Terraform is a tool for creating, configuring and managin infrastructure . Once Server are Provisioned the Firewall rule are set etc . Deploy Application or configuring Server itself install packages or updating their version and so on should be done with another tool like Ansible, Chef, Puppet

- Tool like Ansible coming to automate deploying the application 
configureing server, installing/updating packages version and so on

<img width="600" alt="Screenshot 2025-04-08 at 14 10 53" src="https://github.com/user-attachments/assets/9f7593e1-e9df-4cab-a799-4081d0aee673" />

## Provisioners

- There is many case where I need to execute some soft of Command or Shell Script on the Virtual Server that I have provisioned with Terraform by passing in the `user_data`

- Many of the cloud providers like aws, etc ... They support this attribute to hand over some initial execution connamnd or a file . However there is important to diffentciate here that all this data or these commands or script to be executed will basically be handed over from Terraform to the cloud Provider

- Once the EC2 created by Terraform and Terraform get a status of EC2 created . However Terraform doesn't wait for the virtual machine to be initialized . Once the Cloud Provider initialized will then execute these commands on that initialized server . So Terraform doesn't have any control over what's will happen next or how these command will be executed . If one of the command fail Terraform will not know about the Error

- There are still way to execute command execute script from Terraform . Terraform has its own concept of Provisioner for executing commands and scripts on Virtual Machines . And it is good to know what these concepts are how they are used and what it is about .

- I will create a new branch `git checkout -b feature/provisioner`

- Alternative to executing the commands or script on the remote server using a provisioner called `remote-exec`

- `remote-exec` is a Provisioner that allow us to connect to the remote server and execute command on that server .

- `remote-exec` have to be execute inside the `resource "aws_instance" "" {}` . 

- To define commands here is using `inline = []` let me define a list of commands to be executed on a remote server . For example

```
provisioner "remote-exec" {
  inline = [
    "export ENV=dev"
    "mkdir newDir"
  ]
}
```

- Whenever I define a remote `remote-exec` provisoner I have to tell Terraform how to connect to that remote server . Eventhough I am in the `resource "aws_instance" "" {}` it doesn't actually by default connect to that Server . So I need to define the connection explicicly to connect to this remote server .

  - I can do that by using `connection {}` provisioner .
 
  - Inside `connection {}` I have 2 `types` of connection . `type = "ssh"` and `type = "winrm"` . The default is `SSH`
 
  - and then I have the `host =` I have to tell Terraform the remote server address . Since I am inside the `resources "aws_instance"` and this is a Server I am connecting to I can use `host = self.public_ip` . In Programming Language I have `this` to refer to the current context
 
  - And I have user name `user = "ec2-user"`
 
  - And I have the `private_key = file(var.private_key_location)`
 
  - I can also have `password` if I use Username and Password

  ```
  variable private_key_location {}

  resource "aws_instance" "myapp-instance" {
    connection {
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      private_key = file(var.private_key_location)
    }
  
    provisioner "remote-exec" {
      inline = [
        "export ENV=dev"
        "mkdir newDir"
      ]
    }
  } 
  ```

- Different bettween `user_data` and `remote-exec` is that `user_data` just passing the data to AWS . and `remote-exce` is execute from Terraform . In this case I am ssh to EC2 and create new directory from Terraform .

- `remote-exec` is actually execute on the Remote Server not on Local Machine . That mean If I want to execute a Script file I have to copy that file to a remote server first . To do that I use `provisioner "file" {}`

- `provisioner "file" {}` specificly made for copying file from our local machine to the remote machine . To copy a file I have `source = <name-of the-file>` and `destination = "/home/ec2-user/<name-of-the-file>"` . And the `remote-exec` provisioner needs to be updated so we have the absolute path of the script on our EC2 Instance . So the destination we are using in the file provisioner needs to be used here as well, so the script can run . And then I would be able to execute that file that gets copied and created on the remote machine remotely by ssh into it and then execute the file .

```
variable private_key_location {}

resource "aws_instance" "myapp-instance" {
  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file(var.private_key_location)
  }

  provisioner "file" {
    source = "entry-srcipt.sh"
    destination = "/home/ec2-user/entry-script-on-ec2.sh"
  }

  provisioner "remote-exec" {
    inline = ["/home/ec2-user/entry-script-on-ec2.sh"]
  }
} 
```

- If I want to copy file to multiple different servers I can have own `connection {}` blocks inside the `provisioner "file" {}`

```
provisioner "file" {
  source = "entry-srcipt.sh"
  destination = "/home/ec2-user/entry-script-on-ec2.sh"

  connection {
    type = "ssh"
    host = someotherserver.public_ip
    user = "ec2-user"
    private_key = file (var.private_key_location)
  }
}
```

- There is a cleaner way to use `remote-exec` and run this script from our local machine as a alternative . And this is will use the local path of the script and copy the file to the remote server in one single command using `script` instead of `inline`

  - `script = "entry-script.sh"` this I just need to provide the script file from my local machine on my Terraform project . Agian I am taking a local script copying it to the remote server and then executing it but this time it is all done in 1 command which is a cleaner and better way of doing it
 
- There is 1 more provisioner `provisioner "local-exec" {}` . The command that will be executed locally . For example if I want to execute some commamd locally on my laptop then I can execute them using `local-exec` .

```
provisoner "local-exec" {
  command = "echo ${self.public_ip} > output.txt"
}
```

- When I am working with Terraform there is actually alot of use case and scenarios where I would want to execute some stuff remotely on my servers . There is things to configure, there are applications and software to be installed and so on.

#### Provisoner are not recommended by Terraform 

- Why I should not be using them ? There might be some unexpected behavior or some parts of the script or command may not actually execute and I may have some problems

- Provisoner concept actually breaks the concept of idempotency in Terraform  . In Idempotency it is a word that alway give me the same output no matter how many time I am execute command . So when I do `terraform apply` with the same exact configuration it always give me the same output . So the problem with provisioner is  that bcs I am using scripts, they are basic shell script that are not actually part of terraform itself . Terraform have no way of knowing what I am executing in that Script . Terraform has no way of knowing wheather these commands actually executed successfully . Or if we change something in here Terraform can not tell wheather this change acutally deviates from the current state . So what needs to be actually done in order to apply the changes that I made in my commands or in my shell script

- Also Terraform can not control the way I write those script

- There is the alternative also the best practice :

  - If I want to execute command remotely or configure a remote server I actually should use some configuration management tool (Chef, Ansible, Puppet) .
 
  - Once the Server is provisioned with terraform I can hand over the process to one of those configuration management tools. So using terraform I can pass the init data or initial data to this config manager tool . And then config manager takes over and configure the server and does all the stuff that it can do .
 
  - Bcs the config manager tools have more visibility inside the VM and they can actually compare the state and they can manage and control how the things get executed there, while Terraform can not do this
 
  - As for the `local-exec` If I want to locally create files, there is a provider called local that maintained by Hashicorp and this is a recommended way of handling local files in Terraform . The advantage of using local provider instead of local exec will be that the provider actually has a way of comparing if something changed and what the current and desired states are so I can detect the changes
 
- And as for any type of other script execution generally . Wheather it copying files to the remote or executing some scripts, instead of using the configuration manager, especially that I am building this whole thing up using CI/CD pipeline where I intergrate terraform, I can acutally execute this script as a separate part from from Jenkins or my CI/CD tool 

#### Provisioner failure 

- If the provison fail for example If I use the wrong source location of the script so the file can be copied and if it is not found on the remote machine so the file can not be executed, then Terraform will actually taint or mark the resources where the provision is getting executed as failed . So I have to recreated, eventhough the EC2 instance may get created and initialized I will get an error status from Terraform and the EC2 instance will be marked for deletion

## Modules-1

#### Introduction 

- Now we have written a configuration for a pretty basic use case of just creating an EC2 instance and deploying it into a subnet . However still with this basic configuration we have over 100 lines of code already all in 1 file . And More resources we add and the more complex our inrastructure gets . We will end up with huge file where we just have an endless scroll . Very difficult if I want to change something or find something

- In Terraform we have concept of modules to make configuration not monolithic . So I am basically break up part of my configuration into logical groups and package them together in folders . and this folders then represent modules

- Modules = container for multiple resources used together

- For example : Every `resources` that we need in order to create EC2 instances . Will be package in 1 module . The Instances itself, the AWS instance, the key pair creation bcs I need the key pair for that instance to get the most recent image . And also security Group bcs we are asigning security group to EC2 instance . So this could be 1 logical grouping of the resources and we can all that a web server instance . So if we are deploying an infrastructure with multiple instances, in different regions, in differnet AZ, We can reuse that same web server module in multiple different places .

- The good thing is whenever I define a module . I can pass in whatever parameter I want I can parameterize any values that I want to pass from outside dynamically . Also I can access the output of the module . So whenever the resources get created that are part of a module we can acutally access the objects and its attributes afterwards .

- Just like in Programming I define function once and can reuse it in multiple different places in the configuration, and we can pass in parameters to that function and we can decide what these parameters are going to be and we can return some values from the function .

- And modules make the configuration much cleaner . Make it easier to find the parts of configuration and resoruces that I have defined

- Note : Whenever we are creating a module, it should be a proper abstraction of our resources . Meaning it doesn't make sense to just have a module for creating an AWS instance just one resource . Bcs then we have an overhead of creating this whole new folder and a configuration file just for one resource . It only make sense to create a module when I want to group a couple of `resoruces` together into a logical group . Like Creating a web server with all the configuration around it, like firewall with security group and the key pair belonging to it . Maybe a volumes that will be attached to it and so on ... Same thing with Networking . For example when I create a VPC its need subnets inside, it needs internet gateway, route table so all of it should be in 1 module called VPC

- We can create our own module . However for common use cases there are already modules created by Terraform or other companies that we can reuse

- If I go to `registry Terraform` . In the Modules section I can see a bunch of Module available

  - `Resources tap` : Basically it will create everything for me I just have to provide the parameters for all those resources
 
  - `Inputs  tap` : And the parameter that I can provide are defined in inputs tap
 
  - `Outputs` : The resulting Object or resources that are creating using this module return . So I can use all these values as an output . For example when I create the VPC with subnets, I need the VPC id and subnet id maybe to create other `resources` like EC2 isntances and so on and they will be in another module. And I have to use the output of one module in another by referencing those ids . And I can do that bcs those value will be exposed
 
  - `dependency` : describe wheather this module contains or references other modules . In this case it doesn't so it creating everything from sratch with resources . However it depends on a provider of AWS which is logical bcs it create a bunch of  AWS resources so it need to have AWS provider
 
  - Whenever I am using that module when I use `terraform init` it actutally also intall the module 


## Modules-2

#### Modularize our project 

- I will create a branch for module `git checkout -b feature/modules`

- Best practice: Separate Project structure . Extract everything from main to those file

  - main.tf
  - variable.tf
  - outputs.tf
  - providers.tf

- Create `output.tf` file : `touch output.tf`

- Create `variable.tf` file : `touch variable.tf`

- Create `main.tf` file : `touch main.tf`

- Create `providers.tf` file : `touch providers.tf`

- I don't have to link that file I don't have to reference the `variable.tf` and `output.tf` bcs Terraform knows that these files belong together and it kind of grabs everyting and link them together

- And I also have the `providers.tf` files that will hold all of the providers which I have configured already . Eventhough I have only 1 here which is our AWS provider it is **Best Pratice** to use providers file in the same way .

#### Create Module

Create folder call modules : `mkdir modules`.

Inside `modules` :

  - Create folders for the acutal modules : `mkdir webserver` - `mkdir subnet`

  - Each module will have its own `main.tf`, `output.tf`, `providers.tf`, `variables.tf`.

So now when we create module and configuration of these module we can just reference them from the `main.tf` . So we have an entry point configuration file which is our `root` module and then we have the children modules inside that we can reference from `root` .  

There is 1 one about modules and when I am creating them . When I am creating a module it actually should group a couple of resources together . So creating a module for one or 2 `resources` deosn't really make much sense . When I create a `modules` it should group at least 3 or 4 `resources`  

So I will extract the whole Configuration of the networking . Grap those 3 `resources` (Subnet, Internet Gateway, Route table and its association with gateway). In this case I will extract those `resources` into `/subnet/main.tf`

The way to use the module from another config file. In our case I am going to be actually referencing and using that module in the `main.tf` of the `root` module , is make it completely configrurable bcs we have to pass in all the variables . All the values that are set in the `resources` should be pass in by the configuration that is referencing it . So all of these values are going to be replaced with `variables` . 

  - Example in `/subnet/main.tf`

  ```
  resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = var.vpc_id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone

    tags = {
      Name : "${var.env_prefix}-subnet-1"
    }
  }

  resource "aws_default_route_table" "myapp-default-rtb" {
    default_route_table_id = var.default_route_table_id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myapp-igt.id
    }
  
    tags = {
        Name: "${var.env-prefix}-rtb"
      }
  }

  resource "aws_internet_gateway" "myapp-igt" {
    vpc_id = var.vpc_id
  
    tags = {
      Name: "${var.env-prefix}-igw"
    }
  }
  ```

  - `aws_internet_gateway` reference of a `resource` that exist in the same module . So we don't have to replace that through a variable bcs we have that `resource` available in the same context

  - If anything don't have `reference` inside the same context I have to replace with `variable`

Now I have to define all those `variables` inside that module `/subnet` in the `/subnet/variables.tf` . So all the variable definitions must actually be in that file. 

  - in `/subnet/variables.tf`

  ```
  variable subnet_cidr_block {}
  variable avail_zone {}
  variable env_prefix {}
  variable vpc_id {}
  variable default_route_table_id {}
  ```

  - I will remove the `variable subnet_cidr_block {}` from `root/variable.tf` bcs we only need it in the subnet module

#### Use The module 

Now I have configuration and `variable` defined . How do I use the `module` ?

The way to use that is, in `root/main.tf` I use `module "myapp-subnet" {}` . Then I need a couple of Attribute 

  - `source = "modules/subnet"` : Where this module actually living .

  - Once `source` is defined now We have to pass in all those `variables` that I defined in `/subnet/variable.tf`, the value to those `variables` need to be provided when we are refering to module

  -  Think of it like defind a function with a bunch of parameters and then calling that function in here by passing parameters one be one as a values .

  -  Previously we had all these `variables` already set in `root/terraform.tfvars` . Now since we use `module` we have to define them in the `module "myapp-subnet" {}` section .

  - We can set `subnet_cidr_block = "0.0.0.0/32"` by hard coding like this OR We can also set them as a `variables` `subnet_cidr_block = var.subnet_cidr_block` . If I want to reference it from `root/main.tf` in the root module we need that `variable` defininition also in the `variables.tf`

  - We are referencing a `variable` called `sunbet_cidr_block` that has to be define in the same `module` where `root/main.tf` is . And those `/root/variable.tf` then are set through the `terraform.tfvars` (Where I define value for all those variable)

  - So this is how it work . Actual Values defined in `terraform.tfvars` -> that are set as values in `root/variables.tf` -> and then passing on those values like `var.subnet_cidr_block` to the `module "myapp-subnet"` which is also grabbing those values through `variable` references which also have to be find in the `subnet/variables.tf`
  - 
<img width="600" alt="Screenshot 2025-04-12 at 11 33 28" src="https://github.com/user-attachments/assets/a4b0670e-6ff9-4e80-8e2b-c9c1e30a9029" />

```
module "myapp-subnet" {
  source = "./modules/subnet" ## ./ is for current directory
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.myapp-vpc.id
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}
```

**Module Comparison to function**

Input variables = like function arguments

Output values = like function return values

#### Module Output 

How do we access the resources that will be created by a `module` in another module

  - The first thing we need to do is output the subnet object . Kinda like exporting the subnet object so that it can be used by other modules the way we do that by using output component `/subnet/output.tf`

  ```
  output "sunbet" {
    value = aws_subnet.myapp-subnet-1 
  }
  ```

  - Now we have defined output here . We can actually access the subnet object by referencing the output

  - Now I will reference the ouput from `/subnet/output.tf` in the `root/main.tf` . So we referencing one of the resources of a module and then we need a name of the `module` and we need to reference the name of the `ouput` . `module.<name-of-module>.<name-of-output-for-that-module>.id`

  ```
  resource "aws_instance" "myapp-server" {

  ami = data.aws_ami.latest-amazon-image.id
  instance_type = var.instance_type
  
  subnet_id = module.myapp-subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone = var.availability_zone

  associate_public_ip_address = true

  key_name = aws_key_pair.ssh-key.key_name

  user_data = file("entry_script.sh")

  user_data_replace_on_change = true
  tags = {
    Name = "${var.env-prefix}-server"
    }
  }
  ```

#### Apply Configuration Changes 

`terraform init` to initialize modules

  - We don't see webserver `module` output in the terminal bcs we are not reference that in the root .

  - Basically Terraform detects that we are referring to a `module` called `module "my-subnet" {}` it only tries to find and initialzi that module

`terraform plan` : To preview what Terraform would do 

`terraform apply` : Acutally apply the configuration 

## Modules-3

#### Create webserver Module

We have the instance itself, key-pair that created for the Instance, we have the AMI query from the AWS which is also relevant for the Instance, and we have the Security Group, which also configures the Firewalls for the Instance

- In `webserver/main.tf` . We need to fix the reference to all the value like `vpc_id` . We can leave all these fixed coded values if they don't change Or we can also parameterized them if  we want to pass in different values .

- For example: If we want to be able to decide which operating system image should be use for the Instances : `values = [var.image_name]`

- `subnet_id = aws_subnet.myapp-subnet-1.id` We don't have access to a module anymore bcs this module actually define outside . So we will parameterize that as well . `subnet_id = var.subnet_id` .

- Then I will move the `entry-script.sh` to webserver module

```
resource "aws_security_group" "myapp-sg" {
  vpc_id = var.vpc.id
  description = "Allow inbound traffic and outbout traffic"
  tags = {
    Name: "${var.env-prefix}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "myapp-ingress-8080" {
  security_group_id = aws_security_group.myapp-sg.id
  from_port = 8080
  to_port = 8080
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "TCP"
}

resource "aws_vpc_security_group_ingress_rule" "myapp-ingress-22" {
  security_group_id = aws_security_group.myapp-sg.id
  from_port = 22
  to_port = 22
  cidr_ipv4 = var.my_ip
  ip_protocol = "TCP"
}

resource "aws_vpc_security_group_egress_rule" "myapp-egress" {
  security_group_id = aws_security_group.myapp-sg.id 
  ip_protocol = "-1" 
  cidr_ipv4 = "0.0.0.0/0"
}

data "aws_ami" "latest-amazon-image" {
  owners = [ "amazon" ]
  most_recent = true

  filter {
    name = "name"
    values = [var.image_name]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-image.id
  instance_type = var.instance_type
  
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone = var.availability_zone

  associate_public_ip_address = true

  key_name = aws_key_pair.ssh-key.key_name

  user_data = file("entry_script.sh")

  user_data_replace_on_change = true
  tags = {
    Name = "${var.env-prefix}-server"
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
}
output "dev-vpc-id" {
  value = aws_vpc.myapp-vpc.id
} 
output "dev-subnet-id" {
  value = aws_subnet.myapp-subnet-1.id
}

output "public_IP" {
  value = aws_instance.myapp-server.public_ip
}
```

  - Declare all those `variables` in the `/webserver/variables.tf` .

```
variable vpc_id {}
variable my_ip {}
variable env_prefix {}
variable image_name {}
variable public_key_location {}
variable instance_type {}
variable subnet_id {}
variable sg_id {}
variable avail_zone {} 
```

- In `/root/main.tf` . We are referencing every value either using VAR or `module` or `resource name` which is good pratice bcs we are not hardcoding any value  . 

```
module "myapp-server" {
  source = "./modules/webserver"
  vpc_id = aws_vpc.myapp-vpc.id
  my_ip = var.my_ip
  env_prefix = var.env-prefix
  image_name = var.image_name
  public_key_location = var.public_key_location
  instance_type = var.instance_type
  subnet_id = module.myapp-subnet.subnet.id ## module.<module-name>.<name-of-ouput-of-that-module>.id
  avail_zone = var.avail_zone
}
```

- And now We have to make sure that all those values are actually defined in our `terrform.tfvars`

```
vpc_cidr_block = "10.0.0.0/16"
subnet_cidr_block = "10.0.10.0/24"
avail_zone = "us-west-1a"
env_prefix = "dev"
my_ip = "85.246.32.98/32"
instance_type = "t2.micro"
public_key_location = "/Users/trinh/.ssh/id_rsa.pub"
image_name = "Deep Learning Proprietary Nvidia Driver AMI GPU TensorFlow 2.16 (Amazon Linux 2) 20240729"
```

- in `root/output.tf` . I can refernce those values through `module` component . We need the name of the module which called `myapp-server` . and inside of the `module` we need to access the EC2 instance . And in order to access the `resources` and its atrribute from a module . We have to `output` that object first

```
output "ec2_public_ip" {
  value = module.myapp-server.instance.public_id ## module.<module-name>.<output-name-of-that-module>.attribute
}
```

- in `/webserver/output.tf`

```
output "instance" {
  value = aws_instance.myapp-server
}
```

So now we have updated all of our files, so that the references to all the different modules, resources and outputs should not have any issues when we try to run Terraform commands. 

- run `terraform plan` to preview

- `terraform apply`

Terraform refresh the State it compared the current state with the desired state and this is the output in the terminal . 

  - First VPC and subner already created so they will not created again . However we have Security Group an existing one that will be destroyed and new `resources` will be create in their place

#### Wrap up 

We already created a sturcture in Terraform which is the structure standard way of structring my Terraform project .

We created `modules` . We are logically grouped similar `resources` that belong together into own `module` while still creating one of the `resources` outside . We also learn how to use those modules how to reference them and pass on different values that we configured inside the modules themselves . As well as we will learn how to reference the `resource` object inside the `modules` itself using this module reference and then basically just access any attribute of that object

We have all all the `resources` parameterzied which is the **best practice** . So all the values are set in one place in the tf vats file . If something changes we just adjust it in one place 

## Provision-EKS-1

In this part I will create EKS Cluster by using Terraform

In previous I created EKS manually and it cost me a lot of time, If I want to change something on the exsting Infrastructure it will so not efficent . No history about changes . If I now needed to create the same environment somewhere else, maybe on another AWS account, maybe have an EKS Cluster for production environment, for dev environment etc .. basically just replicate the same exact cluster with the same configuration will be very difficult to remember and know exectly what we did and replicate that exactly on another environment . Finally what if I want to delete everything ? Take too much time

 
#### Step to Create EKS 

First we have Control Plane that managed by AWS itself that I need to create (EKS)

Once I have Control Plane Nodes I need to connect those Worker Nodes to the Control Planes Nodes in order to have a complete cluster so that I can start deploying my application 

For that I need a VPC where Worker Nodes will run and the create the Worker Node acutally . 

<img width="600" alt="Screenshot 2025-04-15 at 10 11 39" src="https://github.com/user-attachments/assets/5a804669-9e93-480a-8728-ecba516b225d" />

And I create cluster always in a specific region my region has multiple availability zones (2 or 3) . I end up with a highly available Control Plane which is managed by AWS which is running somewhere else, And I have the Worker Nodes that we create ourselves and connect to the Control Plane that we also want to be highly available so we want to deploy them into all the available AZs of our region  

#### VPC

I will remove the `main.tf` . I will create multiple Terraform configuration files and I will name them differently 

I will first create VPC with all the Subnets and all the components needed inside VPC 

When I create VPC I used Cloud Formation . Bcs Cloud Formantion has a template that configures a VPC in a way that EKS cluster will need it . 

VPC for EKS cluster actually needs a very specific configuration of a VPC and the subnet inside as well as route tables and so on

In this case I don't have a Cloud Formation template that I am gonna use, Cloud formation is actually an alternative to Terraform, as it's also an infrastructure provisioning tool however specificly for AWS . 

What I gonna use instead is an existing ready module for creating a VPC for the EKS cluster . In the Terraform registry I have list of `modules` and one of them is AWS VPC . I can configure this VPC with all the inputs that I want by just passing in parameters and in the background it will actually create all the nescessary `resources` for VPC and Subnets and Route Tables and so on 

In my project I will create `touch vpc.tf`

```
vpc.tf

variable vpc_cidr_block {}
private_subnet_cidr_block {}
public_subnet_cidr_block {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  ## Pass in the VPC attribute that we need to create VPC for EKS Cluster

  name = "myapp-vpc"
  cidr = var.vpc_cidr_block

  private_subnet = var.private_subnet_cidr_block ## This will be an array of cidr block
  public_subnet = var.public_subnet_cidr_block ## This will be an array of cidr block
  
}
```

Just like `providers` are baciscally packages of code that will be installed and downloaded whenever we need them . `Module` are also a code get downloaded on `terraform init`

**Best practice** Always use `variable` instead of hardcoding

Specify the Cidr block of subnets . Basically inside the `module "vpc"` the subnet `resources` are already define . So subnet  will be created . We can decide how many subnet and which subnets and with which cidr blocks they will be created . And for EKS specifically there is actually kind of the **best practice** for how to configure VPC and its Subnets 

<img width="600" alt="Screenshot 2025-04-15 at 10 47 23" src="https://github.com/user-attachments/assets/80387a5f-ab19-4a5d-a1af-4cef23ca1317" />

**Best Practice** : create one Private and one Public Subnet in each of the Availability Zones in the Region where I am creating my EKS . In my region there are 3 AZs so I need to create 1 Private and 1 Public key in each of those AZs so 6 in total

Values of those Variable: 

  - Subet private and public cidr block have to be a subnet or part of the vpc block

```
vpc_cidr_block = "10.0.0.0/16"

private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

public_subnet_cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
```

I need to define that I want those subnets to be deployed in all the availability zones . So I want them to be distributed to these 3 AZs that I have in the Region and for that I have an attribute here called `azs` and I need to define a name of those AZs `azs = ["us-west-1a", "us-west-1b", "us-west-1c"]` . 

  - But I want to dynamically set the Regions . By using `data` to query AWS to give me all the AZ for the region

  - I have to specify which Region I am querying the AZs from . Then it will give me AZs from the Region that is defined inside the AWS providers

  - How do I know the this Object acutally has `names` attribute ? Go to Docs of `resources` or `data`, I have the section Attribute Reference data source exprorts

  - also I can look up `azs` what this value expected 
    
  ```
  provider "aws" {
    region = "us-west-1"
  }
  
  data "aws_availability_zones" "azs" {} # data belong to a provider so I have to specify the Provider .

  module "myapp-vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  azs = data.aws_availability_zones.azs.names
  }
  ```

Then I will enable the `enable_nat_gateway` . By default the net gateway is enabled for the the subnets . However we are going to set it to true for transparency and Also I am going to enable single nat gateway which basically creates a shared common net gateway for all the private Subnet so they can route their internet traffic through this shared net Gateway

```
provider "aws" {
  region = "us-west-1"
}

data "aws_availability_zones" "azs" {} # data belong to a provider so I have to specify the Provider .

module "myapp-vpc" {

source  = "terraform-aws-modules/vpc/aws"
version = "5.19.0"

enable_nat_gateway = true
single_nat_gateway = true
enable_dns_hostnames = true 
}
```

Finally I want to `enable_dns_hostnames` inside our VPC . For example when EC2 instances gets created it will get assigned the Public IP address, and private IP address but it will also get assigned the public and private DNS names that resolve to this IP address 

I want add tags : 

```
tags = {
  "kubernetes.io/cluster/myapp-eks-cluster" = "shared" # This will be a cluster name
}

public_subnet_tags = {
  "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  "kubernetes.io/role/elb" = 1
}

private_subnet_tags = {
  "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  "kubernetes.io/role/internal-elb" = 1
}
```

  - Why do I have this tags ? `"kubernetes.io/cluster/myapp-eks-cluster" = "shared"` . Basically I have used tag to lables our resources so that I know for example which environment they are belong to so we have a tag with environment prefix

  - One use case is tags are for human consumption so that we can detect using the label that it's dev `resource` for example .

<img width="635" alt="Screenshot 2025-04-15 at 11 38 03" src="https://github.com/user-attachments/assets/a09f00bc-7293-4d9b-80cb-1792ca9d6b87" />

  - However tags are also for referencing components from other components programmatically . So basically in EKS Cluster when we create the Control Plane, one of the processes in the Control Plane is Kubernetes Cloud Controller Manager, and this Cloud Controller Manager actually that com from AWS is the one that Orchestrates connecting to the VPC, connecting to the Subnets, connecting with the Worker Nodes and all these configurations . So basically talking to the `resources` in our AWS Account and Creating some stuff . So Kubernetes Cloud Manager needs to know which resources in our account it should talk to, It needs to knwo which VPC should be used in a Cluster, Which Subnet should be use in the Cluster . Bcs We may have multiple VPC and multiple Subnets and we need to tell control Plane or AWS, use these VPCs and these subnet for this specific cluster . We may also have multiple VPCs for multiple EKS Clusters so it has to be specific `label` that Kubernetes Cloud Controller Manager can acutally detect and identify

  - The same way I tag a VPC I need to tag Subnet as well that the Subnet can be found and identify

  -  These tag are basically there to help the Cloud Control Manager identify which VPC and subnet it should connect to , and that is why I have the Cluster Name here bcs obviously if I have multiple Cluster I can differentiate the VPCs and subnets or the lables using the cluster name

  -  For Public and Private Subnets I need one more tags respectively.
    
   - In public subnets all three of them, I will add another the tag called `kubernetes.io/role/elb`
   
   - And for Private Subnet I have `kubernetes.io/role/internalelb`
   
   - So public has `elb` which is elastic load balancer and private has internal `elb` . So basically when I create load balancer service in Kubernetes, Kubernetes will provision a cloud native load balancer for that service . However it will provision that cloud load balancer in the Public Subnet bcs the Load Balancer is actually an entry point to a Cluster and Load Balancer gets an external IP Address so that we can communicate to it from outside, like from browser request or from other clients . And since we have Public Subnet and Private Subnet in VPC the Public one is actually a subnet that allows communication with Internet . Private subnet closed to Internet . So If I deploy Load Balancer in Private one I can't access it bcs it blocked . So kubernetes need to know basically which one is a public subnet so that it can create and provision that load balancer in the public subnet So that the load balancer can be accessed from the Internet . And there are also internal Load Balancers in AWS which will be created for services and components inside the Private Subnets 
   
   - Basically Private Subnet is the one that not for the Internet and I can't access it from the Browser or external Resources . Public subnet is open for external request . All the resources that AWS provision that has an external IP Address must be deploy in Public Subnet
   
   - So these tag are acutally for consumption by the Kubernetes Cloud Controller Manager and AWS load balancer controller that is responsible for creating load balancer for Load Balancer Service Type for example . Those 2 master Processes are the ones that need those tags to indentify the right components and to differentiate between public and private subnet
   
   - !!! NOTE : Those tags are required

 Whenever I create new `module` I have to do `terraform init` first . The `provider` plugin and `modules` get installed bcs they are a dependencies that need to be downloaded first before It can be use . And they get download from `.terraform` folder 

Execute `terraform plan` I will see the output of all the different `resources` that will be created when I execute my configuration 


## Provision-EKS-2

#### EKS Cluster and Worker Nodes 

So now I have VPC already configured . I will create EKS Cluster

I will create new file `touch eks-cluster.tf`

I will use the EKS `module` . This will basically create all the `resources` needed in order to create cluster as well as any Worker Nodes that I configure for it and provision some of the part provision some of the part of Kubernetes 

And in the dependencies section the `module` is also using Kubernetes Provider in order to connect to Kubernetes Cluster and execute some provisioning tasks there .

It is a good idea to version all our Components generally bcs it make look more visible of which versions are used in case some problem happens, So I can debug it easily and know exactly which version are my `modules`

First I add `cluster_name` and `cluster_version`

Then I need to set `subnet_ids` . This is a list of Subnet that I want the Worker Nodes to be started in . So I have created a VPC with 6 Subnets (3 Private and 3 Public) . 

  - Private : Where I want my Workload to be scheduled . 

  - Public : are for external resources like Load Balancer of AWS for external connectivity

  - So I will reference private subnet for `subnets_id = module.myapp-vpc.private_subnets` . For Security reason bcs It is not exposed to Internet .  I am referencing the `private_sunets` by `modules` bcs I have the `private_subnet` exposed from this module . If I want to reference any attributes of objects created by a module, then inside a module in our case it is the VPC module, I have the `output`. In `output` list I can see all the attributes that are exposed .

Then I can set `tags` for EKS Cluster itself . I don't have to set some required text like I did in the `vpc module` 

  - If I am running my Microservice Application in this Cluster then I can just pass in the name of my Microservice Application, just to know which Cluster is running in which Application

 In addition to Subnet or the Private Subnets where workloads will run we also need to provide a VPC id  . I can also reference it through module . `module.myapp-vpc.vpc_id`

 Then I need to configure how I want my Worker Nodes to run or what kind of Worker Nodes I want to connect to this Cluster .

   - In this case I will use Nodegroup semi-managed by AWS . `eks_managed_node_groups` . The Value of this Attribute is a map of EKS managed NodeGroup definitions .
 
<img width="435" alt="Screenshot 2025-04-15 at 13 22 08" src="https://github.com/user-attachments/assets/77221d9c-6973-4d88-9618-b0a4d4db6690" />

    - How do I know how to configure this object ? or what Attributes and values I can use inside ? Bcs the default values is just an empty brackets so I need to knwo obviously what goes inside . I can see in the README of the `module` . Base on this I can configure my own configurtion . I can define multuple Nodegroup inside `eks_managed_node_groups` attribute . I can have Blue Green deployment or I can have development, Staging etc.... Where each group will have it's own name . And inside the group I can have 1 or more Instances and I can define Configuration for those instances 

 So I will have 3 Instances inside of type t3.medium

<img width="400" alt="Screenshot 2025-04-15 at 13 34 43" src="https://github.com/user-attachments/assets/69b0f1a9-50b1-4508-9d0f-1475b3769910" />

So now I have minimum required to create Cluster . I can `terraform apply` it 

NOTE : Also Now I have to create the Role for the Cluster and for the Node Group as well . This `eks module` acutally define those roles and how they should be created . So we don't have to configure them 

```
module "eks" {
 source  = "terraform-aws-modules/eks/aws"
 version = "20.35.0"

 cluster_name = "myapp-eks-cluster"
 cluster_version = "1.32"

 enable_cluster_creator_admin_permissions = true

 subnet_ids = module.myapp-vpc.private_subnets
 vpc_id = module.myapp-vpc.vpc_id

 eks_managed_node_groups = {
     dev = {
       instance_types = ["t3.medium"]
 
       min_size     = 1
       max_size     = 3
       desired_size = 3
     }
   }

 tags = {
  evironment = "dev"
  application = "myapp"
 }
} 
```

## Provision-EKS-3

#### Cluster Overview 

Checkout Resources which is basically things that are already running one those Worker Nodes . And I have Kubernetes Work Loads like Pods, Daemon Set, Deployment, etc ... And I also have kube-proxy . And I have 2 coreDNS running in my Cluster . And I can see Configmap and Secret .  This is all the default that EKS and Kubernetes give me inside my cluster when I install it . This is basically all Kubernetes Processes in order to run the Cluster 

I can also some configuraton data for the EKS Cluster itself like server endpoint, the certificate authority data, which subnets are part of that Cluster . 

Also with Subnet are part of that cluster. Node Group name or Fargate profile whichever I have available . 

So the Configuration part is more the configuration data on the AWS Infrastructure part, And the resources are more the Kubernetes level resources and configuration 

  - kube-proxy is running on each of the Servers

In IAM Service . I can see the `myapp-eks-cluster-...` role is created by Terraform 

In EC2 I can see 3 Nodes running in my AWS account. And each one is in a differen AZs which is great thing bcs I have high Availability by distributing my Servers accross AZs 

In VPC I have cidr block all default componet get created 

  - Also Route Table and I have 3 Route Table actually got created for my VPC . 1 is Default, and 2 for public and private

  - with Public Route table that was created with an Internet Gateway Route . IGW allow VPC to talk to the Internet

  - with Private Route Table that was created with NAT routing so this is baciscally a route that allow worker Nodes to connect to the Control Plan Node . And the reason I need that is bcs our Worker Nodes are actually in one VPC and the Control Plane Node in another VPC which is managed by AWS . So these resources in two different VPC or two different Private Network and they ahve to talk to each other . And AWS make that communication possible without an Internet Gateway but using NAT gateway instead . So resources can still privately talk to each other from diferent VPCs . And that is basically the configuration for routing traffic back and forth from control plane nodes to Worker Nodes

  - And I also have Subnet Association with those Route Table

  - Also In the Subnet I have 3 Private Subnet and 3 Public Subnet on each AZs. All the Private Subnet they associate with the NAT Gateway and all the Public Subnet they associate with Internet Gateway

In the Security Group . There is 3 different SG created in the back ground using VPC `module` 

  - One is `eks-cluster-sg` . Inbound rule is allow all type of traffic on any ports within the cluster . Bcs the Pods and Services and nodes they have to communicate with each other from the different Worket Nodes, as well as commnicate with pods, containers and services On Control Plane Nodes

  - Another one is `eks-cluster-node` and `eks-cluster-cluster` these 2 are for NodeGroup and cluster. So baciscally I have 2 Separate VPCs, 1 for Worker Nodes and 1 for Control Planes Nodes and all the Components all the Services running on Worker Nodes and Control Plane Nodes have to also talk to each other across these two different VPCs . and the Services actually run and listen on various Ports so with these SG I am opening the Ports so that these Services can talk to each other between those two VPCs . So I am opening the Correct Ports on both Worker nodes and Control Plane Nodes and as a source o who can access those ports are the security group themselves. Which again complies to the least privilege requirement of security bcs I am say only those resources that need to talk to each other will have permissions to talk to each other . So I have minimum require Permission on different Ports from different resources . And instead of having IP address ranges as the source of the communication so who can actually talk to the Services on these Ports . We have Security group as Sources where those different services are running

#### Deploy nginx-App into Cluster 

How to connect to Cluster using kubectl 

<img width="409" alt="Screenshot 2025-04-15 at 14 41 45" src="https://github.com/user-attachments/assets/9602b86d-7d9d-49c5-851b-9f04eedebaef" />

  - First I need to configure my environment so that kubectl can connect with my cluster . `aws eks update-kubeconfig --name myapp-eks-cluster --region us-west-1`
 
  - Now the context was configured in my user home directory in the `/.kube/config` . This file contain all the information that kubectl and AWS IAM authenticator need to authenticate with to authenticate with AWS also authenticate with EKS Cluster

  - If I try `kubectl get node` I will get error time out Which mean more thing need to configure
 
  - I need to explicitly enable public access to my Cluster . `cluster_enpoint_public_access = true` . Which make my Kubernetes Cluster or the API server process on the Kubernetes Cluster publicly accessible from external clients like kubectl

Now I can connect to my Cluster . `kubectl apply -f <nginx-config>`

Now I can go EC2 - and Load Balancer . And 1 Load Balancer acutally get created bcs I create a Service of type Load Balancer . And Load Balancer available in all three AZs in the Region that I specified . It also have a DNS name I that I can access it from . The Port 80 automatically open so I don't have to adjust the security Group and open the Port it all happen automatically when load balancer get provisioned . 

This is a best part of Terraform . Even though it took sometime to put together all this configuration and go through all the attribute I only have that time investment once, I only need to configure all these understand all these attributes once so once I have the configuration set up here, I just do apply and can spin up the whole Cluster again without doing any manual work and when i done I just destroy it 
  
## Control-Plane-Worker-Node-Communication

#### EKS Cluster Architecture 

An EKS consist of 2 VPCs, 1 VPC managed by AWS that run a Control Plane, 1 VPC of the User (my account) that run a Worker Nodes (EC2 Isntances) where containers run as well as other AWS infrastructure (like load balancer) used by Cluster . 

All the Worker Nodes need a ability to connect to managed API server endpoint. This Connection allow Worker Nodes to register itself with the Kubernetes Control Plane and recieved request to run application pod 

The Worker Nodes connec either to the public endpoint, or through EKS-managed Elastic Network Interface (ENI) that are place in my AWS Account Subnet that I provide when create Cluster . The Route that Worker Node take to connect determine by whether I have enable or disable the Private Endpoint for my Cluster . Even when private endpoint is disabled, EKS still provision ENIs to allow for actions that originate from the Kubernetes API server to Worker Nodes, such as `kubectl exec` `kubectl logs`

#### The order of Operation for Worker Node to come online and start receiving commands from Control Plane is  

EC2 Instance Start . Kubelet and Kubernetes Agents are started as a part of boot process on each Instance . 

Kubelet reach out to Kubernetes Cluster Endpoint to register the Node . It connect to Public Endpoint outside of the VPC or to Private Endpoint within the VPC 

Kubelet receives API commands and send regular status and heartbeat to the endpoint . When I query API-Server (kubectl get nodes), I see the latest status that each Node's Kubelet has report back to API server 

If Node unable to reach cluster endpoint, it is unable to register with the Control Plane thus unable to receives command to start and stop the Pod . If new nodes are unable to connect, this prevents you from being able to use these nodes as part of the cluster.

#### Networking Mode 

EKS has two ways of controlling access to the cluster endpoint. Endpoint access control lets you configure whether the endpoint is reachable from the public internet or through your VPC. You can enable the public endpoint (default), private endpoint, or both endpoints at the same time. When the public endpoint is enabled, you can also add CIDR restrictions, which allow you to limit the client IP addresses that can connect to the public endpoint.

**Communication from Worker Nodes to the Control Plane**

When a worker node joins an EKS cluster, it needs to connect to the Kubernetes API server to register itself and receive instructions. This communication path depends on the cluster's endpoint access configuration:​

Public Endpoint Only: Worker nodes communicate with the API server over the internet via the public endpoint. This requires the nodes to have a route to the internet, typically through a NAT gateway or an internet gateway. ​

Private Endpoint Enabled: EKS provisions Elastic Network Interfaces (ENIs) in your VPC subnets, allowing worker nodes to communicate with the API server over the AWS private network. This setup doesn't require internet access for the nodes. ​

The API server listens on port 443 (HTTPS), and worker nodes initiate outbound connections to this port to interact with the control plane.

**Communication from the Control Plane to Worker Nodes**

The control plane communicates with worker nodes primarily for tasks like executing commands (kubectl exec), fetching logs, and health checks. This communication is facilitated through the ENIs that EKS places in your VPC subnets. The control plane connects to the kubelet on each worker node over port 10250 (HTTPS). ​

It's important to ensure that the security groups associated with your worker nodes allow inbound traffic on port 10250 from the control plane's ENIs. EKS manages these ENIs and their associated security groups to maintain secure communication. 

#### VPC Configuration 

In general, your nodes are going to run in either a public or a private subnet. Whether a subnet is public or private refers to whether traffic within the subnet is routed through an internet gateway. If a subnet is associated with a route table that has a route to an internet gateway, it’s known as a public subnet. If a subnet is associated with a route table that does not have a route to an internet gateway, it’s known as a private subnet.

The ability for traffic that originates somewhere else to reach your nodes is called ingress. Traffic that originates from the nodes and leaves the network is called egress. Nodes with public or elastic IP addresses within a subnet configured with an internet gateway allow ingress from outside of the VPC. Private subnets usually include a NAT gateway, which allows traffic from the nodes to leave the VPC (egress).

There are three typical ways to configure the VPC for your Amazon EKS cluster:

1. Using only public subnets. Nodes and ingress resources (like load balancers) all are instantiated in the same public subnets.

2. Using public and private subnets. Nodes are instantiated in the private subnets and ingress resources (like load balancers) are instantiated in the public subnets.

3. Using only private subnets. Nodes are instantiated in private subnets. There are no public ingress resources as this configuration is only used for workloads that do not need to receive any communications from the public internet.

#### NAT gateway 

NAT Gateway Always Sits in a Public Subnet

Because a NAT Gateway needs internet access, it must be in a public subnet that has:

 - A route to the Internet Gateway (IGW)
 
 - A public IP address assigned

**What does it do?**

A NAT Gateway allows:

 - Instances in private subnets to initiate outbound connections to the internet
 
 - But it blocks inbound connections from the internet

For example:

EC2s or EKS worker nodes in private subnets can pull images from DockerHub or ECR. But no one from the internet can directly reach those EC2s

**How traffic flows:**

Let’s say a node in the private subnet wants to pull an image:

Node (in private subnet) sends request (e.g., to DockerHub)

Route table sends traffic to NAT Gateway (in public subnet)

NAT Gateway sends traffic out to the Internet Gateway

The response comes back and is routed properly to the originating node

## CI/CD-Terraform

#### Overview 

In previous use case which built a docker Image in a pipeline and then deployed that Image on a remote Server, I will take that use case and integrate Terraform in order to provision that remote server as part of CI/CD process 

With Terraform I will start with a clean State so I don't have any running instances provisioned here . So I will provision a server using Terraform before we deploy it 

I will create a new `stage("provision server")` in Jenkinsfile . And this will be a part where Terraform will provison create the new Server for me so that I can deploy my application on it, which lets me automate that part of creating a remote server also using CI/CD pipeline . In order to do that I have to do a couple of thing . 

  - First I need to create a Key-pair an SSH key pair for the server . Whenever I create an Instance I need to assign an SSH key pair so that I can SSH into that Server .

  - Second : Install Terraform inside Jenkins Container . Bcs I want to execute Terraform Command in Jenkins

  - After that I will create Terraform file inside my Project so I can execute `terraform apply` inside the folder where I have defined Terraform config files

  - **Best Practice** To include everything that my application needs, including the Infrastructure automation, application configuration automation, all of this code inside the application itself

#### Create SSH Key Pair 

I could either go inside Jenkins container and create this public private key using `ssh keygen`, or as a alternative I can create one key pair inside AWS manually and then give Jenkins basically or create a credential in Jenkins from that key pair 

I will create a key pair inside AWS and then give it to Jenkins instead of creating from Terraform 

Go to AWS - EC2 -> Create key pair `.pem`

After that I need to give that PEM file to Jenkins . Inside Multi Branch Pipeline credentials I will create a new Credential and this is going to be SSH credential .

  - ID : `server-ssh-key`

  - Username: is the username that will be logging into the Server with SSH . On EC2 Instance the user I get out of the box is `ec2-user`

  - Private key : paste the content from `.pem` file

#### Install Terraform inside Jenkins Container 

SSH into my Droplet and then go inside Jenkins container and we are going to install Terraform inside the Container 

SSH to Droplet Server : `ssh root@<Ip-address>`

Go inside the container : `dockcer exec -it -u 0 <container-id> bash`

On Hashicorp Download I can see installation for different OS (https://developer.hashicorp.com/terraform/downloads) . 

Check what OS that I have `cat /etc/os-release` . 

This time I will choose Ubuntu/Debian . I will Copy and paste this to my Jenkin container . Bcs I am loggin in as Root User so I don't need `sudo`

```
wget -O - https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

apt update && apt install terraform
```

#### Terraform Configuration File 

In the App I will add folder `mkdir terraform` 

Inside `terraform` folder add: `touch main.tf` 

I have already create a Terraform for deploy EC2 instances on AWS with SG and everything so I will just go over to Terraform project where I did it in module 11 to 13 . I will copy the whole thing in `main.tf` but make some adjustment 

Remove Key-Pair 

In `resources "aws_instance"` set `key_name="myapp-key-pair"` this is the key name I have create it inside AWS 

Copy the `entry-script.sh` . 

In this case I want to deploy and execute `docker-compose` bcs I am copying the Docker Compose file to EC2 Instance and executing Docker Compsose command 

To install docker compse inside Jenkins : (https://docs.docker.com/compose/install/standalone/)

In `entry-script.sh`

```
sudo yum update -y && sudo yum install -y docker
sudo systemctl start docker
sudo usermode -aG docker ec2-user

# Dowload docker compose
curl -SL "https://github.com/docker/compose/releases/download/v2.35.0/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
```

How do I set a `.tfvars` values when we are executing the Terraform configuration files from CI/CD pipeline 

In `main.tf` I can provide Default Values for `vpc_cidr_block` and `subnet_cidr_block` so I don't have to provide Value all the time and just use default values, however I still have the option to override it 

```
main.tf

provider "aws" {
 region = var.region
}

variable vpc_cidr_block {
 defafult = "10.0.0/16"
}

variable subnet_cidr_block {
 default = "10.0.10.0/24"
}

variable avail_zone {
 default = "us-west-1a"
}

variable env_prefix {
 default = "dev"
}

variable my_ip {
 default = "my ip address"
}

variable instance_type {
 default = "t3.medium"
}

variable region {
 default = "us-west-1"
}
```

After the I will create `variable.tf` file then copy all the variable code above to it 

Remove `output aim`

#### Provision Stage In Jenkinsfile

Inside `stage("provision server"){ steps { script {}}}` I will execute Terraform command 

However Terraform configuration files are inside Terraform directory so I need execute `terraform init` and `terraform apply` from that directory  . To do that I use `dir('terraform') {}` provide the folder name or relative path . Then I can execute Terraform command in that block 

For `terraform apply` to work , Terraform and Jenkins Server basically needs to authenticate with AWS bcs I am creating `resources` inside AWS account, and obviously, AWS will need some kine of authentication to allow Terraform and Jenkins server to create those `resources` inside the AWS account in that Region 

In the `provider "aws" {}` I can give `access_key` and `access_secret_key` . I can hardode it in the Provider but the Best Pratice is to set them as an ENV . So basically I need to set ENV in the `stage` for Terraform so that AWS provider can grab those ENV and connect to the AWS . Above `steps {}` I will provide `environment {}`

Let's say I want to set the environment to test. By default I have defined it to be `dev` . However from CI/CD pipeline I want to define which environment I am deploying to . Let's say this CI/CD Pipeline is for test environment . To override or set a value of a variable inside Terraform Configuration from Jenkinfile is using `TF_VAR_name`  . Using `TF_VAR_name` I can override and set all the rest of `variables as well`

```
stage("provision server"){
 environment {
  AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
  AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
  TF_VAR_env_prefix = "test"
 }
 steps {
  script {
   dir('terraform') {
    sh "terraform init"
    sh "terraform apply --auto-approve"
   }
  }
 }
}
```

#### Deploy Stage in Jenkinsfile

Bcs I create provisoning Server from Terraform I don't know what IP Address is going to be here, I need the right Public IP once Terraform create the Instance . 

To reference the Attribute of Terraform `resource` from Jenkinsfile . And to get access to AWS instance Public IP . I can use `output {}` command in order to get a value . Right in the `stage ("provision server")` I will use `terraform output <name-of-output>` . However I need to save the result of the `output` command so I can use it in the next `stage` . I can do that by assigning the result of `sh` command to an ENV in Jenkins `EC2_PUBLIC_IP = sh "terraform output ec2_public_ip"` . However for that to work I need to add a parameter here inside the shell script execution and set `returnStdout: true` . What this does is basically it prints out the value to the standard `output`, so I can save it into a `variable` . I can also `trim()` that value if there are any spaces before or after

If I need othet Attribute as well I can easily define them in `output` section I can give it any value that I want and I can access them 

Now In `deploy stage` I can reference IP address : `def ec2Instance = "ec2-user@${EC2_PUBLIC_IP}"`

Another thing I need to consider when working with Terraform . When `stage("provision server")` execute, Terraform will create an Instance so Terraform will wait until the Instance is created until AWS basically tells Terraform the Instance is already running and Terraform Return and after the next `Stage` will be execute . However after EC2 Instance is created, it needs sometime to initialize . So the issue here with Terraform when `terraform apply` executed and the server gets created, this instance gets created and the server gets created, this instance gets created and after that in the initialization process, the `entry_script.sh` will be executed so all of these command sof installing docker and starting Docker Service as well as installing docker-compose will be executed in the initialization process, So it could be that when we are in the `deploy` stage those commands haven't completed yet andthat mean we can't execute any remote command on that server bcs it's still installing all these technologies and it is still initializing some of the stuff and this could be timing issue and my build will fail if my server isn't ready yet. It will happen the first time when my server created 

An easy solution to that problem is to basically just wait in the deploy Stage for a couple seconds to give a server time to initialize which will be the easiest solution . I can do `sleep(time: 90s, unit: "SECONDS")`

This will make the build pipeline a little bit slower, especially if  the server is already created and this is the second or thrid run of the pipeline, The server, the instance is already there The Terraform doesn't have to create a new Server, everytime the build runs then waiting for for one and a half minutes could be a waste of time so I may do some extra optimization where I bascically if else statement wheather the server already initialize then only wait or only execute the sleep if it's still in initialziation process

Another thing is to add  `-o StrictHostKeyChecking=no` to the `scp ...` command as well

```
stage("provision server"){
 environment {
  AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
  AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
  TF_VAR_env_prefix = "test"
 }
 steps {
  script {
   dir('terraform') {
    sh "terraform init"
    sh "terraform apply --auto-approve"
    env.EC2_PUBLIC_IP = sh (
     script: "terraform output ec2_public_ip",
     returnStdout: true 
    ).trim() 
   }
  }
 }
}

stage("deploy") {
 steps {
   script {
     sleep(time: 90, unit: "SECONDS")
     echo "Deploying the application to EC2..."

     def shellCMD = "bash ./server-cmds.sh ${IMAGE_NAME}"
     def ec2Instance = 'ec2-user@${EC2_PUBLIC_IP}'

      sshagent(['ec2-server-key']) {
           sh "scp docker-compose.yaml -o StrictHostKeyChecking=no ${ec2Instance}:/home/ec2-user"
           sh "scp server-cmds.sh -o StrictHostKeyChecking=no ${ec2Instance}:/home/ec2-user"
           sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCMD}"
       }
   }
 }
}
```

#### Final Modification and Execute Pipeline 

Set IP address of Jenkins to allow Jenkin to ssh to AWS . `variable jenkins_ip { default = ""}` and I will add that to a security group `resource` . If the Jenkin IP is dynamic then I can have a default here and override it from Jenkinfile using `TF_VAR_name`

```
ingress {
 from_port = 22
 to_port = 22
 protocol = "TCP"
 cidr_blocks = [var.my_ip, var.jenkins_ip]
}
```

#### Docker Login to pull Docker Image 

The problem here is when I pull Image from Private repository I first have to do docker Login so that the Server we are trying to pull that image to authenticate with the Private Repository bcs it is secured 

Docker login take username and password . Now the difference here is that docker login in `build image stage` get execute on Jenkin Server so Jenkin itself can authenticate with Docker private Repository to push an image bcs image is on the Jenkins server itself . But in `deploy stage` I want to do docker login from EC2 Server 

So in `server-cmd.sh`

```
export IMAGE=$1
export DOCKER_USER=$2
export DOCKER_PASSWORD=$3

echo $DOCKER_PASSWORD | docker login -u $DOCKER_USER --password-stdin

docker-compose -f docker-compose.yaml up --detach

echo "success"
```

`$DOCKER_PASSWORD`, `$DOCKER_USER` have to be define and pass on as Parameters . In shell command I can pass the script itself multiple parameters and for each parameter I have a number 

To get `$DOCKER_PASSWORD`, `$DOCKER_USER` in Jenkinsfile , I get it from `Credentials` and read that value in ENV block  . `DOCKER_CRED = credentials('docker-hub-repo)` . 
But it give me whole object, to get Username and passowrd from it : `${DOCKER_CREDS_USR}`, `${DOCKER_CRED_PSW}` those 2 value automatically created in Jenkin ENV when I am extracting credentials with username password type I get additional environment varialbe set 

```
environment {
DOCKER_CRED = credentials('docker-hub-repo) 
}
```

<img width="635" alt="Screenshot 2025-04-17 at 15 07 38" src="https://github.com/user-attachments/assets/55d4b08d-ad92-4169-9235-23acc452ab14" />

## Remote-State

When I am working with Terraform in a team where different team members maybe execute Terraform commands locally or I am intergrating Terraform in a CI/CD pipeline I have multiple places where State can be created . 

Problem : Each user /CI server must make sure they always have the latest state data before running Terraform 

In my case I ran CI/CD pipeline and create a Terraform State inside Jenkins . So that Terraform State file is only available inside that Jenkins Server, so we don't have access to it locally . So If I wanted to do `terraform plane or apply` some change on top of that, I would not be able to do it bcs I don't have that State . 

To share the Terraform State between different environments maybe different team members and there is actually a very simple way to do that, and it is also a **Best Practice** is to configure a remote Terraform State . So basically a remote storage where this Terraform State file will be stored . 

It is also good for data backup in case something happens to the Server and the State file basically gets removed so to store it in a remote place securely is actually a good way to do that 

It's also can be shared and Keep Sensitive data off disk

#### Configure Remote Storage 

To configure a Remote Storage for Terraform State file I use `terraform {}` block 

`terraform {}` block is for configuring metadata and information about Terraform itself 

`backend` is a remote backend for Terraform and one of the Remote storages for Terraform State file is `S3 bucket ` . `S3 bucket` is a storage in AWS that is mostly used for storing files 

`bucket` is to configure name of bucket . It needs to be globally unique

`key` is a path inside my bucket that I will create and it can have a folder structure like a folder hierarchy structure 

`region` doesn't have to be the same region as the one that I am creating my `resources` in bcs it is just for storing the data

```
terraform {
 required_version = ">= 0.12"
 backend "s3" {
  bucket = "myapp-tf-s3-bucket-tim"
  key = "myapp/state.tfstate"
  region = "us-west-1"
 }
}
```

With those Configuration above Terraform will create the State file inside the bucket and then it will keep updating that Terraform state file inside the bucket everytime something changes 

Before execute these changes make sure to `terraform destroy` current infrastructure first 

#### Create AWS S3 Bucket 

Go to AWS -> S3 

When I switch to S3 service the Region will become global 

Choose Create S3 bucket 

  - `Block all public access` I can't open these files in the browser which makes sense bcs I want to protect my state files and I will able to access them obviously using AWS Credentials

  - `Bucket Versioning` this basically creates a versioning of the files that I am storing in the bucket so everytime a file content changes a new version is created . I basically end up with a bunch of file that, very similar to git repository, I have file that versioned bcs I have history of the changes

  - **Good practice** is to enable bucket versioning for my Terraform state file bcs if something happens and the up to date latest version of my State basically get messed up or somebody accidentally messes something up in the state file, then I still can go back to the previous State

  - `Default encryption` . Server-side encryption is now automatically selected as a default encryption type

  - `Bucket key` can be disable 

If I already have a local State and I want to migrate it to the Remote State then I can do Terraform init and basically just confirm that I want the migration but I have to do it manually by executing `terraform init`

If I want to access my Terraform State that currently exists in my AWS infrastructure I can actually do that locally bcs the State is not stored anymore on Jenkins but rather on a Shared remote backend as long as I have AWS credentials and everything configured to access the bucket 

  - First in my local I will do `terraform init`

  - Second I do `terraform state list` it will connect to the bucket and actually give me the list of the `resoruces` that have been created from the remote storage . So this way everyone can access this shared remote state of Terraform 

## Best-Practice

#### State and State File 

Terraform is a tool creating Infrastructure and then making changes and maintaining that infrastructure and to keep track of the current infrastructure State and what changes I want to make, Terraform use State 

When I change configuration in Terraform script it will compare my desired configuration with current Infrastructure State and figure out a plan to make those desired changes 

State in Terraform is a simple JSON file and has all the infrastructure resources that Terraform manages for me 

#### 1st Best Practice 

Bcs it is a simple JSON file, I could make adjustment to the Statefile directly . However, the first best practice is only change the State file contents through terraform command `terraform apply`

Do Not edit the file directly 

#### 2nd Best Practice 

When I first execute `terraform apply` Terraform will automatically create the state file locally . But what if I am working in a team so other team members also need to execute Terraform commands and they will need the State file for that . Every team member will need a latest State file before making their own update 

Always Set up a shared remote storage for State File 

In practice, remote storage backend for state file can be Amazon's S3 bucket, Terraform Cloud, Azure Storage, Google cloud storage etc .... 

#### 3st Best Practice 

What if 2 team members execute Terraform commands at the same time . Thing happen to the State file when I have concurrent changes is I might get a conflict or mess up my State file 

To avoid changing Terraform State at the same time is Locking the State file until update fully completed then unblock it for the next command 

In Practice, I will have this configured in my Storage Backend . In S3 bucket for example DynamoDB service is automatically used for State file locking

!!! NOTE : Not all Service Backend supported be aware when choosing a remote Storage for State file 

If supported TF will lock my state for all operating that could write state 

#### 4th Best pratice 

What happens if I lose my State file ? Something may happen to my remote storage location or someone may accidentally override the data or it may get corrupted . To avoid this the is to Back up State file 

In practice, I can do this enabling versioning for it and many storage backends will have such a feature 

This also mean that I have a nice history of state changes and I can reverse to any previouse Terraform State if I want to 

#### 5th Best Practice 

Now I have my State file in a Share remote location with locking enable and file versioning for backup so I have one State file for my Infrastructure . But usally I will have multiple environment like development, testing and production so which environment does this state file belong to ?

Use 1 dedicated State file per environment and each State file will have its own storage backend with locking and versioning configured 

#### Next 3 Best practice are about how to manage Terraform code itself and how to apply Infrastructure changes 

These Practices can be grouped into a relatively new trend that emerged in the IaC which is called GitOps

#### 6th Best Practice 

When I am working on Terraform scripts in a Team, it is important to share the code in orther to collaborate effectively 

I should host Terraform code in its own Git repository just like my Application code . This is not only beneficial for effective collaboration in a team but I also get versioning for my infrastructure code changes, So I can have history of changed for my Terraform code 

#### 7th Best Practice 

Who is allow to make changed to Terraform code ? 

Treat Terraform code just like my application code . This mean I should have the same process of reviewing and testing the changes in my Infrastructure code as I have for my application code 

This mean I should have the same process of reviweing and testing the changes in my Infrastructure code as I have for my application code with continuous intergration pipeline using merge requests to integrate code changed, this will allow my team to collaborate and produce quality infrastructure code which is tested and reviewed 

#### 8th Best Pratice 

I have tested and review my Iac code repository . How do I apply them to actual Infrastructure 

Execute Terraform command to apply changes in a continuous deployment pipeline. 

So instead of team members manually updating the infrastructure by executing Terraform commands from their own computers it should happen only from an automated build this way I have a single location from which all the infrastructure changes happen and I have a more streamlined process of updating my Infrastructure 














 
