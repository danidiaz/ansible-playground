FROM centos:7

MAINTAINER "dddd@ddd.com"

WORKDIR /root

RUN sed -i '/tsflags=nodocs/d' /etc/yum.conf && \
    yum install -y man which openssh openssh-clients openssh-server tar unzip bzip2 git wget vim vim-enhanced tmux iproute nc socat nmap lsof lynx && \
    yum install -y epel-release && \
    yum install -y ansible 
    
COPY ansible.hosts /etc/ansible/hosts
COPY ansible.cfg ansible.cfg 
COPY authorized_keys /root/.ssh/authorized_keys

RUN chmod 600 /root/.ssh/authorized_keys && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N "" && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N "" && \
    echo "LS_COLORS=$LS_COLORS:'di=0;35:' ; export LS_COLORS" >> .bashrc && \
    curl -L -O https://raw.githubusercontent.com/danidiaz/miscellany/master/linux/.tmux.conf && \
    curl -L -O https://raw.githubusercontent.com/danidiaz/miscellany/master/linux/.vimrc && \
    echo "colorscheme evening" >> .vimrc && \
    mkdir -p .vim/autoload .vim/bundle && \
    curl -LSso .vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && \
    git clone https://github.com/tpope/vim-repeat .vim/bundle/vim-repeat && \
    git clone https://github.com/tpope/vim-surround.git .vim/bundle/vim-surround && \
    git clone https://github.com/bootleq/vim-cycle.git .vim/bundle/vim-cycle && \
    git clone https://github.com/wellle/targets.vim .vim/bundle/targets.vim && \
    git clone https://github.com/michaeljsmith/vim-indent-object .vim/bundle/vim-indent-object

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# ssh -A -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -v root@$(docker-machine ip machine) -p 2222
