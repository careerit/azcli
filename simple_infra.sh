#!/bin/bash

source ./variables.txt


# Create Resource Group
az group create --name $RG --location $LOCATION 

# Create Virtual Network
az network vnet create --resource-group $RG --name $VNET_NAME --address-prefix 10.0.0.0/16 --location $LOCATION


#Create Network Security Group

az network nsg create --resource-group $RG --name $NSG_NAME 


# Create NSG rules


az network nsg rule create -g $RG --nsg-name $NSG_NAME --name ssh-web-port \
	            --priority 500 --source-address-prefixes Internet --destination-port-ranges 22 80 \
		     --access Allow --protocol Tcp --description "Allow Internet on ports 22,8080."


# Create subnet

az network vnet subnet create -g $RG --vnet-name $VNET_NAME -n $SUBNET1 \
            --address-prefixes 10.0.0.0/20 --network-security-group $NSG_NAME


# Create Virtual Machine

az vm create --name $VM_NAME --resource-group $RG  --image $IMAGE --size $VM_SIZE --vnet-name $VNET_NAME \
             --subnet $SUBNET1 --admin-username $USER \
             --ssh-key-values /home/baddi/.ssh/id_rsa.pub
