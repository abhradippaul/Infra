### Adhoc Command

ansible web -m ping
ansible web -m shell -a uptime/date/uname

### Ansible Playbook

ansible-playbook first-playbook.yml
ansible-playbook first-playbook.yml --syntax-check
ansible-playbook file-creation.yml --list-hosts
ansible-playbook nginx-install.yml --extra-vars name=nginx
ansible-vault encrypt nginx-install.yml
ansible-vault view nginx-install.yml
ansible-vault decrypt nginx-install.yml
ansible-vault edit nginx-install.yml
ansible-vault edit nginx-install.yml --list-tags
ansible-vault edit nginx-install.yml --tags "restart"
ansible-vault edit nginx-install.yml --skip-tags "restart"
