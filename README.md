# deeploy

## GitLab

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


### CI / CD sample
(TODO)


## FreeIPA

Make sure git is set up to checkout out linux style end of lines

* build a free ipa server image

        git clone https://github.com/freeipa/freeipa-container
        cd freeipa-container
        docker build -f Dockerfile.centos-7 -t freeipa-server .
        
* run the installer (docker has to have ipv6 enabled)
        
        docker run --rm --name freeipa-server-container \
        -e IPA_SERVER_IP=10.65.34.239 -p 153:53/udp -p 153:53 \
            -p 180:80 -p 443:443 -p 389:389 -p 636:636 -p 88:88 -p 464:464 \
        -p 88:88/udp -p 464:464/udp -p 123:123/udp -p 7389:7389 \
        -p 19443:9443 -p 19444:9444 -p 19445:9445 \
        -ti -h ipa.peploleum.com \
        -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        --tmpfs /run --tmpfs /tmp \
        -v $PWD/srv/data:/data peploleum/freeipa-server \
         -U