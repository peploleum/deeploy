# FreeIPA


FreeIPA is the Redhat IDM.

#### Warning

In openstack, add the security group freeipa on each VM you want to enroll in FreeIPA including the freeipa server itself.

If this security group doesn't exist, you can generate it with these commands on the openstack controller :

        cd deeploy/freeipa/srv
        ./create-freeipa-security-group.sh

#### Server

Make sure git is set up to checkout out linux style end of lines

* build a free ipa server image

        git clone https://github.com/freeipa/freeipa-container
        cd freeipa-container
        docker build -f Dockerfile.centos-7 -t freeipa-server .
        
* run the installer (requires ipv6-enabled docker daemon)
        
        cd freeipa/srv
        ./freeipa.sh install 10.10.10.10 PEPLOLEUM.COM server.peploleum.com

#### Client

* ubuntu dockerized client is a fail due to ip-client-install ubuntu package dependency on systemd as an init system. content of freeipa/client runs only on VMs.

