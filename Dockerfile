########################################################################################################
# Written By: Arun Kumar C
#
# Description: This docker images to use as  runtime environment for the AWS Code Build.
#              Which allows us to use, 
#
#				Kubectl 
#				AWSCLI 
#				Helm 
#				Python3 
#				AWS IAM Authenticator
#				JDK
#				JRE
#				Maven
#				CRMIS Dependencies
########################################################################################################

FROM ubuntu:18.04 AS core

ARG DEBIAN_FRONTEND=noninteractive
ARG AWS_DEFAULT_REGION
ARG AWS_CONTAINER_CREDENTIALS_RELATIVE_URI

ENV TZ=Pacific

RUN echo 'Creating a Custom Image For AWS Code Build - Kubernetes Applications' \
	&& apt-get update -y \
	&& apt-get install -y tzdata \
	&& apt-get install -y awscli \
	&& apt-get install -y git \
	&& apt-get install -y curl \
	&& curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator \
	&& chmod +x ./aws-iam-authenticator \
	&& mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator \
	&& curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
	&& chmod +x kubectl \
	&& mv ./kubectl /usr/local/bin/kubectl \
	&& kubectl version --client\
	&& curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh \
	&& chmod 700 get_helm.sh \
	&& /bin/bash get_helm.sh \
	&& helm version

RUN apt-get install -y openjdk-8-jdk \
	&& apt-get install -y openjdk-8-jre \
	&& mkdir -p /usr/share/maven /usr/share/maven/ref \
	&& aws s3 cp s3://pge-ecm-crmis-dependencies/apache-maven-3.6.3-bin.tar.gz /tmp/apache-maven-3.6.3-bin.tar.gz \
	&& tar -xzf /tmp/apache-maven-3.6.3-bin.tar.gz -C /usr/share/maven --strip-components=1 \
	&& rm -f /tmp/apache-maven-3.6.3-bin.tar.gz \
	&& ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
	&& mkdir ~/.m2 \
	&& mkdir ~/.m2/repository \
	&& aws s3 cp s3://pge-ecm-crmis-dependencies/com.zip ~/.m2/repository/com.zip \
	&& apt-get install -y zip \
	&& cd ~/.m2/repository \
	&& unzip ~/.m2/repository/com.zip \
	&& rm -fR ~/.m2/repository/com.zip

