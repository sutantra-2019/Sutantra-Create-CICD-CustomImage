Purpose:


  To deploy / maintain Kubernetes service into AWS EKS, Need pre-requisite software in place to deploy the services as POD and other K8s Configurations.
  Since we need to have separate code pipeline for each K8s service, we can't install the pre-requisites for each service repeatedly. So to avoid this problem,
  We can build a custom docker image with all the pre-requisite software's and use the Docker image as a runtime environment for all the K8s services.

 
Softwares's In Custom Image:

  AWS CLI, 
  AWS IAM Authenticator, 
  Git, 
  Python3, 
  Kubectl, 
  Helm, 
  cURL, 
  Docker
