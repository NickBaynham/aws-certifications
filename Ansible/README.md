# Install Ansible on a Mac

Set a DEV_HOME environment variable on your profile to the directory where your repositories usually download to.

```
brew install ansible
sudo mkdir /etc/ansible
```

## /etc/ansible/ansible.cfg

```
[defaults]
private_key_file=~/.ssh/ec2.pem
remote_user = ec2-user
```

## /etc/ansible/hosts

```
[aws]
54.209.20.33
```

## ping all

```
ansible all -m ping
```

## Response

```
[WARNING]: Platform linux on host 54.209.20.33 is using the discovered Python interpreter at /usr/bin/python3.7, but future installation of another Python interpreter could change the meaning of that path.
See https://docs.ansible.com/ansible-core/2.13/reference_appendices/interpreter_discovery.html for more information.
54.209.20.33 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.7"
    },
    "changed": false,
    "ping": "pong"
}
```

## /etc/ansible/nginx.yaml

```yaml
---
- hosts: webservers
  become: yes
  tasks:
    - name: Installs Nginx web server
      yum: pkg=nginx state=installed update_cache=true
      notify:
        - start nginx

    - name: Upload default index.html for host
      copy: src=$DEV_HOME/aws-certifications/www/html/index.html dest=/usr/share/nginx/html/ mode=0644

    - name: Upload first CSS file
      copy: src=$DEV_HOME/aws-certifications/www/css/style.css dest=/usr/share/nginx/html/ mode=0644

    - name: Add a line in /etc/nginx/sites-available/default
      lineinfile: dest=/etc/nginx/sites-available/default
                  regexp='# Only for nginx-naxsi'
                  line='location /images {}'       
    
    - name: Create a directory called images
      file: path=/usr/share/nginx/html/images state=directory mode=0755

    - name: Upload first image
      copy: src=$DEV_HOME/aws-certifications/www/images/pic.png dest=/usr/share/nginx/html/images/ mode=0644


  handlers:
    - name: start Nginx
      service: name=nginx state=started
```
## Running the Playbook

```
ansible-playbook $DEV_HOME/aws-certifications/Ansible/nginx.yaml
```

