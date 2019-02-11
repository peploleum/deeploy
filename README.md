# deeploy

## GitLab

### Prerequisites :
* Install a docker engine  
* Prepare your system to resolve the namespace gitlab.peploleum.com (127.0.0.1)

### Run GitLab :

        cd gitlab
        docker-compose -f gitlab.yml up -d

### Configure GitLab
Use a web browser and connect to http://gitlab.peploleum.com:9080
* Create a password
* Create a login
* Import your projects : New Project / Import project -> Github
* If needed go on github and generate a "Personal access tokens"

Your projects are in GitLab.

### Register GitLab Runner
You need to register a runner for each project.  
For a project :  
* Get the registration token in Settings > CI/CD > Runners  
* Run the registration script

        ./register-runner.sh %containerID %projectName %gitLabIP %RegistrationToken

### Mirror project Github to GitLab
For each project :

* Create a bare mirrored clone of the repository

        git clone --mirror https://github.com/peploleum/repository-to-mirror.git
* Set the push location to your mirror 

        cd repository-to-mirror.git
        git remote set-url --push origin http://gitlab.peploleum.com:9080/capgemini/mirrored
* Update the mirror

        git fetch -p origin
        git push --mirror
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