# JIRA

 1. Installation de la VM jiraserver
 - Lancement du script de création de la VM  
 `~/deeploy/core-dev-services/jira/create-jiraserver.sh`
 - Connexion au noeud core-dev-services en bureau à distance
 - Installation Centos :
   - choix du clavier : French + Supprimer English
   - Réseau : cocher la case activation, noter l'IP
   - Users : créer un compte root et un compte administrateur

 2. Configuration réseau de la VM  :
 - Figer l'IP sur le routeur + DHCP
 - Connexion au noeud core-dev-services en bureau à distance  
   `sudo up link set enp0s3 down`  
   `sudo up link set enp0s3 up`  
 - Coupure du lien bureau à distance  
   `VBoxManage modifyvm jiraserver --vrde off`  
 
 3. Installations 
 - Installations préalables :  
 `sudo yum install git`  
 `sudo yum install wget`  
 - Récupération des scripts de déploiement  
 `git clone https://github.com/peploleum/deeploy.git`  
 - Installation de docker  
 `~/deeploy/docker/docker-centos-7.6.sh`  
 - Démarrage de PostGres  
 `docker-compose -f ~/deeploy/core-dev-services/jira/postgres.yml up -d`  
 - Configuration de la base pour JIRA  
 `docker exec -u postgres -it jira_insight-postgresql_1 sh`  
 `psql -U jira -W`  
 `CREATE DATABASE jiradb WITH ENCODING 'UNICODE' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;`  
 `GRANT ALL PRIVILEGES ON DATABASE jiradb TO jira;`  
 
 4. Configuration de JIRA
 - un compte de service jira
 - un compte administrateur
 - Configuration LDAP :
<table>
<tr><th>Server Settings</th></tr>
<tr><td>Name</td><td>FreeIPA</td></tr>
<tr><td>Directory Type</td><td>Any OpenLDAP type</td></tr>
<tr><td>Hostname</td><td>hostname du serveur IPA</td></tr>
<tr><td>Port</td><td>389</td></tr>
<tr><td>Use SSL</td><td>no</td></tr>
<tr><td>Username</td><td>uid=jira,cn=users,cn=accounts,...</td></tr>
<tr><td>Password:</td><td>jira user LDAP password (can be left blank)</td></tr>
<tr><th>LDAP Schema</th></tr>
<tr><td>Base DN</td><td>dc=...</td></tr>
<tr><td>Additional User DN</td><td>cn=accounts</td></tr>
<tr><td>Additional Group DN</td><td>cn=accounts</td></tr>
<tr><td>LDAP Permissions</td></tr>
<tr><td>Read Only </td><td>Quoted</td></tr>
<tr><td>Read Only, with Local Groups</td><td>Unquoted</td><td>
<tr><td>Read/Write</td><td>Unquoted</td></tr>
<tr><th>Advanced Settings</th></tr>
<tr><td>Secure SSL</td><td>no</td></tr>
<tr><td>Enable Nested Groups</td><td>void</td></tr>
<tr><td>Use Paged Results 1000 results per page</td><td>Unchanged</td></tr>
<tr><td>Follow Referrals</td><td>Unchanged</td></tr>
<tr><td>Naive DN Matching</td><td>Unchanged</td></tr>
<tr><td>Update group memberships when logging in </td><td>For newly added users only</td></tr>
<tr><td>Synchronisation Interval (minutes)</td><td>60</td></tr>
<tr><td>Read Timeout (seconds)</td><td>120</td></tr>
<tr><td>Search Timeout (seconds)</td><td>60</td></tr>
<tr><td>Connection Timeout (seconds)</td><td>10</td></tr>
<tr><th>User Schema Settings</th></tr>
<tr><td>User Object Class</td><td>posixaccount</td></tr>
<tr><td>User Object Filter</td><td>(objectclass=posixaccount)</td></tr>
<tr><td>User Name Attribute</td><td>uid</td></tr>
<tr><td>User Name RDN Attribute</td><td>cn</td></tr>
<tr><td>User First Name Attribute</td><td>givenName</td></tr>
<tr><td>User Last Name Attribute</td><td>sn</td></tr>
<tr><td>User Display Name Attribute</td><td>displayName</td></tr>
<tr><td>User Email Attribute</td><td>mail</td></tr>
<tr><td>User Password Attribute</td><td>userPassword</td></tr>
<tr><td>User Password Encryption</td><td>SHA</td></tr>
<tr><td>User Unique ID Attribute</td><td>uid</td></tr>
<tr><th>Group Schema Settings</th></tr>
<tr><td>Group Object Class</td><td>posixGroup</td></tr>
<tr><td>Group Object Filter</td><td>(&(objectClass=posixGroup)(|(cn=jira-administrators)(cn=jira-software-users)))</td></tr>
<tr><td>Group Name Attribute</td><td>cn</td></tr>
<tr><td>Group Description Attribute</td><td>description</td></tr>
<tr><th>Membership Schema Settings</th></tr>
<tr><td>Group Members Attribute</td><td>memberUid</td></tr>
<tr><td>User Membership Attribute</td><td>memberOf</td></tr>
<tr><td>Use the User Membership Attribute</td><td>When finding the user's group membership : NO </tr>
</table>
 
 

 
