A playground for working with Ansible. Uses docker-compose.

Copy an `authorized_keys` file into the folder before building the image.

The idea is to connect to the head node using SSH agent forwarding:

```
ssh-agent
ssh-add
ssh -A -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$(docker-machine ip machine) -p 2222

ansible all -a "echo foo"
```
