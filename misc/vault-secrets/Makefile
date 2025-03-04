default:
	git pull
	terraform init -upgrade
	terraform apply -auto-approve -var vault_token=$(vault_token)