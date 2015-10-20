set -e

#TIP: Create IAM Group (and Users) with appropriate permissions prior to running this script
#User permissions needed are as follows: AWS S3, AWS Redshift, AWS EC2, AWS Marketplace

#Create a VPC
vpcId=`aws ec2 create-vpc --cidr-block 10.0.0.0/16 | jq .Vpc.VpcId -r`
echo vpc $vpcId created

#Create a subnet
subnetid=`aws ec2 create-subnet --vpc-id $vpcId --cidr-block 10.0.0.0/16| jq .Subnet.SubnetId -r`
echo subnet $subnetid created

#Create an Internet gateway
gatewayid=`aws ec2 create-internet-gateway| jq .InternetGateway.InternetGatewayId -r`
echo gateway $gatewayid created

#Attach internet gateway
aws ec2 attach-internet-gateway --internet-gateway-id  $gatewayid --vpc-id  $vpcId

#Add default route to route table.
routetableId=`aws ec2 describe-route-tables | jq .RouteTables[0].RouteTableId -r`
echo route table $routetableId found
aws ec2 create-route --route-table-id $routetableId --destination-cidr-block 0.0.0.0/0 --gateway-id $gatewayid

#Add redshift rule into the security group
securityGroupId=`aws ec2 describe-security-groups --filters Name=vpc-id,Values=$vpcId | jq .SecurityGroups[0].GroupId -r`
aws ec2 authorize-security-group-ingress --group-id $securityGroupId  --protocol tcp --port 5439 --cidr 10.0.0.0/16

#REDSHIFT

#Create a Redshift cluster subnet grp
echo create the cluster subnet group
aws redshift create-cluster-subnet-group --cluster-subnet-group-name mysubnetgroup  --description "My subnet group" --subnet-ids $subnetid

#Create the Redshift cluster
echo redshiftid =`aws redshift create-cluster --node-type dc1.large  --master-username admin --master-user-password Password1 --cluster-type single-node --cluster-identifier My-Redshift-Cluster --db-name redshift --cluster-subnet-group-name mysubnetgroup | jq .Cluster.ClusterIdentifier -r`
echo created $redshiftid


#Create/alter a security group
# TODO

#MATILLION ETL

#Launch Matillion EC2 Instance from the AWS Marketplace
# TOVERIFY - must use the AMI from your region for Matillion from the marketplace
echo instance-id=`aws ec2 run-instances --image-id ami-fd85fa98 --count 1 --instance-type m3.large --key-name MyKeyPair --security-group-ids $securityGroupId --subnet-id $subnetid`
echo $instance-id

#Add an Elastic IP
echo ipAddress=`aws ec2 allocate-address --domain vpc | jq -r .PublicIp`
echo $ipAddress
echo $allocation-id

#Attach the Elastic IP to the Matillion Instance
# TOVERIFY
aws ec2 associate-address --instance-id $instance-id --allocation-id $allocation-id


