#!/bin/bash

## Check if lines exist and remove them
checkLinesRemove () {
    checkLineRemove=$(grep -oh $1 ~/noc_assignment/variables.tf)
if [[ $checkLineRemove == "$1" ]]
    then
        sed -i.bak "/$1/d" ~/noc_assignment/variables.tf
        echo "old $1 var was removed, configuring a new $1 var..."
else
        echo "$1 var is not configured, configuring a new $1 var..."
fi
}

## Check if Quotes are existed, If not add Quotes
checkQuotes () {
if [[ $2 == *'"'* ]]
    then
        echo -e "variable "$1" {default = $2}" >> ~/noc_assignment/variables.tf
else
        withQuotes=\"${2}\"
        echo -e "variable "$1" {default = $withQuotes}" >> ~/noc_assignment/variables.tf
fi
}

## Check config status
checkConfigured () {
checkIfCongigured=$(grep -oh $1 ~/noc_assignment/variables.tf)
if [[ $checkIfCongigured == "$1" ]]
    then
        echo "$1 is configured"
else
        echo "$1 is not configured"
fi
}

read -p "destroy or apply? " choice
choiceVar=$choice

if [[ $choiceVar == 'destroy' ]]
    then
        ## Execute functions in order
        
        checkLinesRemove accessKey
        checkLinesRemove secretKey
        checkLinesRemove sessionToken
        checkQuotes accessKey "$AWS_ACCESS_KEY_ID"
        checkQuotes secretKey "$AWS_SECRET_ACCESS_KEY"
        checkQuotes sessionToken "$AWS_SESSION_TOKEN"

        ## Destroy tf config

        cd ~/noc_assignment
        terraform destroy -input=true -auto-approve

elif [[ $choiceVar == 'apply' ]]
    then
        
        
        ## Execute functions in order
        checkLinesRemove accessKey
        checkLinesRemove secretKey
        checkLinesRemove sessionToken
        checkQuotes accessKey "$AWS_ACCESS_KEY_ID"
        checkQuotes secretKey "$AWS_SECRET_ACCESS_KEY"
        checkQuotes sessionToken "$AWS_SESSION_TOKEN"
        checkConfigured accessKey
        checkConfigured secretKey
        checkConfigured sessionToken

        ## Apply tf config

        cd ~/noc_assignment
        terraform init
        terraform apply -input=true -auto-approve
else
    echo " Please enter a valid option (apply/destroy)"
fi
