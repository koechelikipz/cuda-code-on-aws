# Deploying MATLAB generated CUDA code on AWS

## Requirements
- MATLAB® 
- MATLAB Coder™
- GPU Coder™
- Parallel Computing Toolbox™ 
- Deep Learning Toolbox™ 
- Image Processing Toolbox™ 
- An Amazon Web Services™ (AWS) account
- An SSH Key Pair for your AWS account in the US East (N. Virginia) region. For more information, see [Amazon EC2 Key Pairs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html).

## Costs

You are responsible for the cost of the AWS services used when implementing this demo.  Resource settings, such as instance type, will affect the cost of deployment. The AMI used for this guide, with the recommended instance type costs $1/hour. For cost estimates, see the pricing pages for each AWS service you will be using. Prices are subject to change.

## Introduction

The following guide demonstrates how to generate CUDA code using GPU Coder, build and run an executable on an EC2 instance.

## Prepare your AWS Account

1. If you don't have an AWS account, create one at https://aws.amazon.com by following the on-screen instructions.
2. Use the regions selector in the navigation bar to choose the **US-EAST (N. Virginia)** region where you want to deploy MATLAB.
3. Create a [key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) in that region.  The key pair is necessary as it is the only way to connect to the instance as an administrator.
4. If necessary, [request a service limit increase](https://console.aws.amazon.com/support/home#/case/create?issueType=service-limit-increase&limitType=service-code-) for the Amazon EC2 instance type or VPCs.  You might need to do this if you already have existing deployments that use that instance type or you think you might exceed the [default limit](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-resource-limits.html) with this deployment.

## Architecture overview

![alt text](/Architecture.PNG?raw=true)
      
## Steps

1. Writing an entry point function in MATLAB
2. Generate a static library using GPU Coder
3. Deploy generated code to an S3 bucket
4. Deploy code in S3 bucket to an EC2 instance(s) or AutoScaling Group 
5. Build executable on EC2 instance
6. Create a simple web app to interact with the executable

















