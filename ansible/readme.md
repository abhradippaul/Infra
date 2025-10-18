### Adhoc Command

ansible web -m ping
ansible web -m shell -a uptime/date/uname

### Ansible Playbook

ansible-playbook first-playbook.yml
ansible-playbook first-playbook.yml --syntax-check
ansible-playbook file-creation.yml --list-hosts
