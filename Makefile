infra:
	git pull
	terraform init
	terraform apply -auto-approve

ansible:
	git pull
	ansible-playbook -i $(tool_name)-internal.saitejasroboshop.store, setup-tool.yml -e ansible_user=ec2-user 


secrets:
	git pull
	cd misc/vault-secrets ; make vault_token=$(vault_token)
