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