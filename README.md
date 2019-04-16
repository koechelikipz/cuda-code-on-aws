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

![alt text](/Overview.PNG?raw=true)
      
# Steps

1. Write an entry point function in MATLAB
2. Generate a static library using GPU Coder
3. Setup AWS environment
4. Deploy generated code to an S3 bucket
5. Deploy code in S3 bucket to an EC2 instance(s) or AutoScaling Group 
6. Build executable on EC2 instance
7. Create a simple web app to interact with the executable

## Step 1. Write an entry point function

Please see the MATLAB script `alexnet_predict.m` for more information

## Step 2. Generate a static library using GPU Coder

Please see the MATLAB script `test_codegen.m` for more information

## Step 3. Setup AWS environment

| AWS component  | steps |
| ------------- | ------------- |
| **IAM Roles**  | <ul><li>We need 2 IAM roles:<ul><li>One that allows EC2 instances to access services like S3 and CodeDeploy</li><li>One that allows CodeDeploy to access services like S3 and EC2</li></ul></li><li>Search and open IAM from Services</li><li>Click on Roles --> Create role --> Name your role</li><li>Click on permissions tab -> Attach policies</li><li>For the EC2 role, add ‘AmazonEC2RoleforAWSCodeDeploy’ and ‘AmazonS3FullAccess’ from the list of policies</li><li>For the CodeDeploy role, add ‘AWSCodeDeployRole’ and ‘AmazonS3FullAccess’ from the list of policies</li></ul>|
| **EC2 Instance(s)**  | <ul><li>Configure your EC2 instance for CodeDeploy to work using steps described [here](https://docs.aws.amazon.com/codedeploy/latest/userguide/instances-ec2-create.html)</li><li>Create an EC2 instance using the recommended [AMI](https://aws.amazon.com/marketplace/pp/B077GCZ4GR?qid=1554245914494&sr=0-1&ref_=srh_res_product_title) and p2.xlarge instance type</li><li>Verify if the CodeDeploy agent is running on the instance. The steps are described [here](https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-verify.html)</li></ul>  |
| **S3 Bucket**  | <ul><li>Create an S3 bucket, so that the code generated files can be deployed from here</li><li>A S3 bucket was created in the same region as the EC2 instance and CodeDeploy deployment group for this demo.However, it is also possible to have a cross region AWS architecture</li><li>Go to the S3 Properties tab and enable Versioning</li><li>Go to the Permissions tab -> Bucket Policy</li><li>Please see the sample bucket policy in the repository</li><li>Replace the arn names with yours</li><li>You can find the AWS account number for your arn under the Support tab in the AWS console</li><li>Please see this [AWS documentation page](https://docs.aws.amazon.com/AmazonS3/latest/user-guide/create-configure-bucket.html) for more information</li></ul>  |
| **CodeDeploy**  | <p>You can also use [scp](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html#AccessingInstancesLinuxSCP) to upload the code generated files. However, AWS CodeDeploy is a free service that allows you to deploy applications from your development machine to one or more EC2 instances at once.</p><ul><li>Go to the AWS CodeDeploy console</li><li>Click on ‘Create application’</li><li>Name your application and select EC2 from the compute platform options</li><li>Click on ‘Create deployment group’ and name it</li><li>Select the service/IAM role created previously from the service role drop down</li><li>Choose deployment type based on your requirement</li><li>Select EC2 or AutoScaling groups in environment configuration based on your requirement. In this case I used an EC2 instance</li><li>If you are using just 1 EC2 instance uncheck load balancing and click Create deployment group</li></ul>  |

## Step 4. Deploy generated code to an S3 bucket

- You need to do this from the command line using the AWS CLI
- Please follow steps here to set up the AWS CLI on your development machine
- Place your codegen directory and the appspec.yml file in one directory and navigate to the parent directory from the command line
- The directory structure would look like:
  - temp
    - codegen
    - appspec.yml
- Execute the following command in the command line:
`aws deploy push --application-name <name of your CodeDeploy App> --s3-location s3://codegens3/codegen.zip --ignore-hidden-files`

## Step 5. Deploy code in S3 bucket to an EC2 instance(s) or AutoScaling Group

- Create a YAML file named ‘appspec.yml’ in the same directory that contains the codegen directory
- This file tells AWS CodeDeploy the source and destination of your files
- An example appspec.yml file is shown [here](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-example.html#appspec-file-example-server)
- The deployment will fail if:
  - YAML file has incorrect syntax
  - You don’t have path permissions at the destination
- Click on ‘Create deployment’
- Select S3 under Revision type
- The revision location would be:  `s3://your-bucket-name/codegen.zip`
- Complete by clicking on ‘Create deployment’

## Step 6. Build executable on EC2 instance

- SSH into the EC2 instance using the instructions [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)
- Navigate to the directory containing all the code generated files
- Find and edit the make file(.mk extension) to update the paths to the source files
- Execute the following commands to create the static library using the updated paths:<br/>
`make -f <path to make file> clean` followed by `make -f <path to make file>`
- Execute the following command from the command line:
`nvcc -arch sm_35 -o classifier relative path/to/main.cu relative path/to/inputFile.a -I<relative path to codegen directory><br/> -L"./<relative path to codegen directory>" -lmwjpegreader  -lcudart -lcudnn -lcudart -lcublas`
- `lmwjpegreader` is needed if you are using the `imread` MATLAB function in your MATLAB source code. 
Please see this [documentation page](https://www.mathworks.com/help/images/code-generation-for-image-processing.html) for more information on how to use image processing functions in code generation.
- Please see this [documentation page](https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#introduction) for more information on `nvcc`.

## Step 7. Create a simple web app to interact with the executable

- Install Apache web server on EC2 instance: `sudo apt-get install apache2`
- We are using PHP, to install PHP: `sudo apt-get install php libapache2-mod-php`
- Change server root to `/var/www/` by editing file `/etc/apache2/sites-enabled/ 000-default.conf`
- Add server root folder permissions for the user: `sudo chmod -R g+rw /var/www`
- Restart server:  `sudo service apache2 restart`
- Create a dummy php file in the server folder and check if the server is running by going to `<EC2 public DNS>/filename.php`
- Place the files in `var/www` from the repository in your server root
- The single page PHP webapp will let the user upload a JPEG file
- Clicking on the predict button will call the CUDA executable
- The webapp will parse and display the classification result









