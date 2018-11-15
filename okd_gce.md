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
```


$ oc adm policy add-cluster-role-to-user cluster-admin guo --rolebinding-name=cluster-admin
