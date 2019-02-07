# deeploy

## GITLAB

Run gitlab :

        cd gitlab
        docker-compose -f gitlab.yml up -d

Use a web browser : http://ip:9080
* Create a password
* Create a login
* Import your projects : New Project / Import project -> Github
* If needed go on github and generate a "Personal access tokens"

Your projects are in Gitlab.

Deployment scripts
(To complete)


## FreeIPA

Make sure git is set up to checkout out linux style end of lines

        git clone https://github.com/freeipa/freeipa-container
        cd freeipa-container
        docker build -f Dockerfile.centos-7 -t freeipa-server .
        
        mkdir 
        docker run --rm --name freeipa-server-container \
        -ti -h server.peploleum.com \
        -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        --tmpfs /run --tmpfs /tmp \
        -v $PWD/srv/data:/data peploleum/freeipa-server \
         -U -r peploleum.com