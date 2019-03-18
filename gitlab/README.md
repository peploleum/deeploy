# GitLab

### Prerequisites :
* Install OS Ubuntu 16.04 
* Install git and xclip

        sudo apt-get install git xclip
* Install Docker : https://docs.docker.com/install/linux/docker-ce/ubuntu/ 
* Install Docker Compose : https://docs.docker.com/compose/install/
* Prepare your system to resolve the namespace gitlab.peploleum.com (127.0.0.1)

### Run GitLab :

        cd gitlab
        docker-compose -f gitlab.yml up -d

### Configure GitLab
Use a web browser and connect to http://gitlab.peploleum.com:9080
* Create a password
* Create a login
* Generate ssh key

        mkdir ~/.ssh
        chmod 700 ~/.ssh
        ssh-keygen -t rsa (follow the prompt)
* Copy the key in your clipboard

        xclip -sel clip < ~/.ssh/id_rsa.pub
* Paste the key in your GitLab profile (Settings > SSH Keys) and save
* Validate the SSH configuration

        ssh -T git@gitlab.peploleum.com -p 9022
                > The authenticity of host '[gitlab.peploleum.com]:9022 ([x.x.x.x]:9022)' can't be established.
                > ECDSA key fingerprint is SHA256:xxxxxxxxxxxxxxxxxxx.
                > Are you sure you want to continue connecting (yes/no)? yes
                > Warning: Permanently added '[gitlab.peploleum.com]:9022,[x.x.x.x]:9022' (ECDSA) to the list of known hosts.
                > Welcome to GitLab, @username!

### Configure GitHub project in GitLab

#### Import GitHub projects
* Login on http://gitlab.peploleum.com:9080
* New Project / Import project -> Github

If needed go on GitHub and generate a "Personal access tokens"

#### Register GitLab Runner
You need to register a runner for each project.  
For a project :  
* Get the registration token in Settings > CI/CD > Runners  
* Run the registration script

        ./register-runner.sh %containerID %projectName %gitLabIP %RegistrationToken

#### Mirror project Github to GitLab
For each project :

* Run the mirror script

        ./mirror-github.sh %GitHubUserLink %GitHubProjectName %GitLabProject

Sample : ./mirror-github.sh https://github.com/peploleum/ graphy magnarox/graphy

### LDAP configuration

follow this [recipe](https://computingforgeeks.com/how-to-configure-gitlab-freeipa-authentication/)

> convenience scripts are [here](gitlab/config):

        cd gitlab/config
        
> edit scripts and config files to match freeipa settings (IP, server hostname).
    
> execute prepare script (gitlab-ce container id required)  
        
        ./prepare-ldap.sh $gitlab-ce_docker_container_id
        
> execute a bash in the gitlab container

        docker exec -it $gitlab_container_id /bin/bash
        
> in the container: check config files in the container (/configure-ldap.sh and /etc/gitlab/freeipa_setting.yml)
  
> in the container: execute config script  

        ./configure-ldap.sh

        
### CI / CD sample
(TODO)