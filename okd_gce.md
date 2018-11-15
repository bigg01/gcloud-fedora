```
sudo yum install -y ansible pyOpenSSL python-cryptography python-lxml
git clone https://github.com/openshift/openshift-ansible
sudo -s
vi /etc/yum.repos.d/origin.repo
[origin-repo]
name=Origin RPMs
baseurl=https://storage.googleapis.com/origin-ci-test/logs/test_branch_origin_extended_conformance_gce/3628/artifacts/rpms
enabled=1
gpgcheck=0

exit 
sudo ansible-playbook -i inventory/hosts.localhost playbooks/prerequisites.yml
sudo ansible-playbook -i inventory/hosts.localhost playbooks/deploy_cluster.yml
#
sudo ansible-playbook -i inventory/hosts.localhost playbooks/redeploy-certificates.yml
sudo ansible-playbook -i inventory/hosts.localhost playbooks/adhoc/uninstall.yml


sudo htpasswd -c /etc/origin/master/htpasswd guo

oc create -f https://raw.githubusercontent.com/bigg01/gcloud-fedora/master/is-java.yaml -n openshift

sudo ansible-playbook -i inventory/hosts.localhost playbooks/redeploy-certificates.yml -e openshift_certificate_expiry_warning_days=30

```

```
cat inventory/hosts.localhost
#bare minimum hostfile

[OSEv3:children]
masters
nodes
etcd

[OSEv3:vars]
# if your target hosts are Fedora uncomment this
#ansible_python_interpreter=/usr/bin/python3
openshift_deployment_type=origin
openshift_portal_net=172.30.0.0/16
# localhost likely doesn't meet the minimum requirements
openshift_disable_check=disk_availability,memory_availability
openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider',}]
#openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/htpasswd'}]
#guo:$apr1$1/rt.MSZ$QRv5FD03MTUj/EOOo68D50
openshift_master_htpasswd_users={'guo': '$apr1$1/rt.MSZ$QRv5FD03MTUj/EOOo68D5'}
#
openshift_master_default_subdomain=app.oliverg.ch
openshift_console_hostname=console.oliverg.ch
openshift_master_cluster_hostname=oliverg.ch
openshift_master_cluster_public_hostname=console.oliverg.ch
openshift_node_groups=[{'name': 'node-config-all-in-one', 'labels': ['node-role.kubernetes.io/master=true', 'node-role.kubernetes.io/infra=true', 'node-role.kubernetes.io/compute=true']}]


[masters]
localhost ansible_connection=local openshift_public_hostname=oliverg.ch

[etcd]
localhost ansible_connection=local

[nodes]
# openshift_node_group_name should refer to a dictionary with matching key of name in list openshift_node_groups.
localhost ansible_connection=local openshift_node_group_name="node-config-all-in-one"
```


$ oc adm policy add-cluster-role-to-user cluster-admin guo --rolebinding-name=cluster-admin


https://blog.openshift.com/lets-encrypt-acme-v2-api/


./acme.sh --issue --dns dns_gcloud -d console.oliverg.ch -d oliverg.ch -d '*.app.oliverg.ch'
https://github.com/Neilpang/acme.sh/tree/master/dnsapi
