# Ansible AWX Installation

An Ansible AWX operator for Kubernetes built with Operator SDK and Ansible. 

## Resources

- [k3s docs](https://docs.k3s.io/quick-start)
- [Ansible AWX-Operator Github](https://github.com/ansible/awx-operator)

- [Ansible AWX Operator readthedocs.io](https://ansible.readthedocs.io/projects/awx-operator/en/latest/installation/basic-install.html)
  
- [Kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/)

## Install K3s

- Update the system

```bash
sudo apt update -y && sudo apt upgrade -y
```

- Install Script

```bash
curl -sfL https://get.k3s.io | sh -
```

- Check installed k3s version

```bash
kubectl version
```

- Verify kube config file permission:
  
```bash
ls -la /etc/rancher/k3s/k3s.yaml
```

Here is the output:
`-rw------- 1 root root 2969 Nov 23 22:04 /etc/rancher/k3s/k3s.yaml
`

- Modify kube config file owner:
  
```bash
sudo chown mo:mo /etc/rancher/k3s/k3s.yaml
```

- Check environment status

```bash
kubectl get nodes
```

- Check workload

```bash
kubectl get pods
```

## Install Kustomize

- Install Kustomize by downloading precompiled binaries
  
```bash
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
```

- Move `Kustomize` to binary path
  
```bash
sudo mv kustomize /usr/local/bin
```

- Verify `kustomize` command:

```bash
which kustomize
```

- Make new dir
  
```bash
mkdir awx && cd awx
```

- Create `kustomize` config file:

```bash
touch kustomization.yaml
```

- Add `kustomize` config:

Find the latest tag [here](https://github.com/ansible/awx-operator/releases)

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - github.com/ansible/awx-operator/config/default?ref=2.8.0
  - awx.yaml

# Set the image tags to match the git version from the above
images:
  - name: quay.io/ansible/awx-operator
    newTag: 2.8.0

# Specify a custom namespace in which to install AWX
namespace: awx
```

- Install AWX

```bash
kustomize build . | kubectl apply -f -
```

- Check pods in `awx` namespace
  
```bash
kubectl get pods -n awx

# NAME                                               READY   STATUS    # RESTARTS   AGE
# awx-operator-controller-manager-6678865c69-5lpqd   2/2     Running   0          112s
```

- Set current namespace to awx:

```bash
sudo kubectl config set-context --current --namespace=awx
```

- Create `awx.yaml` to pass commands to `kustomize`:

```yaml
---
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx
spec:
  service_type: nodeport
  nodeport_port: 30080
```

- Rerun the build command:

```bash
kustomize build . | kubectl apply -f -
```

- Check deployment logs:

```bash
kubectl logs -f deployments/awx-operator-controller-manager -c awx-manager
```

- Wait for the deploy to complete without errors, then retrieve the admin user, `admin` and password `<resourcename>-admin-password`:

```bash
kubectl get secret awx-admin-password -o jsonpath="{.data.password}" | base64 --decode ; echo
```

- Navigate to the AWX UI

`http://<ip address>:30080/`

- Check the port AWX is running on:

```bash
kubectl get svc
```
