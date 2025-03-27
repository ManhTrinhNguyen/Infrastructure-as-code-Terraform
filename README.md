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
 
**What does it mean that Terraform is a tools for infrastructure provisioning ?**

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













 
