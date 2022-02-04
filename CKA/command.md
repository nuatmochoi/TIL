### image list

- https://kubernetes.io/ko/docs/tasks/access-application-cluster/list-all-running-container-images/

```sh
kubectl get pods --all-namespaces -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' |\
sort
```

- `k get nodes`

- `k get pods --all-namespaces`
- pod이 어느 노드인지 : `kubectl get pods -o wide`

- replicaset : `k get rs`

### 컨테이너 이미지 변경

```
kubectl patch rs new-replica-set --type='json' -p='[{"op": "replace", "path": "/spec/containers/0/image", "value":"busybox"}]'
```

- rs yaml 추출 : `k get rs new-replica-set -o yaml`

- 리소스 강제 교체 : `k replace --force -f sample.yaml`

- rs replicas 수 변경 : `k scale --replicas=2 rs/new-replica-set`

- namespace list : `kubectl get ns`

- `k apply -f sample.yaml --namespace=finance`

- 도메인 명명 : `서비스. namespace. svc.cluster.local`

- imperative pod deploy : `k run nginx-pod --image=nginx:alpine`

- 리소스 수정 : `kubectl edit deployment frontend`

### --label 옵션 지원 종료

```
k run redis --image=redis:alpine
k label pod redis tier=db
```

### 서비스 명령형 생성

`k expose pod redis --port=6379 --name=redis-service --type="ClusterIP"`

- 모든 라벨 : `k get pod --show-labels`
- 특정 라벨 모든 리소스 : `k get all -l env=prod`

- taint 걸기 : `k taint node node01 spray=mortein:NoSchedule`
  - 순서 : `key=value:효과`

### yaml 파일 생성 (기본 토대)

- `k run nginx --image=nginx --dry-run=client -o yaml > nginx.yaml`
- dry-run 옵션을 통해 실제 리소스를 생성하지 않고 yaml만 생성

### Node Affinity

#### required

- `kubectl apply -f https://k8s.io/examples/pods/pod-nginx-required-affinity.yaml --dry-run=client -o yaml > require.yaml`

#### prefered

- `kubectl apply -f https://k8s.io/examples/pods/pod-nginx-preferred-affinity.yaml --dry-run=client -o yaml > prefer.yaml`

- daemonset describe : `k describe daemonset kube-flannel-ds -n kube-system`

- static pod path 등 config 확인
  1. `ps -aux | grep kubelet`
  2. 결과 중 `--config=/var/lib/kubelet/config.yaml` 확인
  3. `vi /var/lib/kubelet/config.yaml` 중 static pod path 확인

#### multiple scheduler

- leader-elect

- 여러 개 secret 생성 : `k create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123`

#### 유지보수 (drain)

- `k drain node01 --ignore-daemonsets`
- cordon과 차이는 SchedulingDisable된 노드의 Pod를 삭제하고 재생성
  - 이러한 특징으로 사용 가능한 node가 없을 때 drain 대신 cordon을 써야함
- 오류 뜨면 --force 옵션 추가
- 다시 스케줄링 추가 : `k uncordon node01`

#### node 초기화

- `kubeadm init --apiserver-cert-extra-sans=controlplane --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address 10.8.203.12`
- 초기화 후 다시 시작하려면 `kubeadm reset cleanup-node`

#### Control Plane node 업그레이드

##### Kubeadm 업그레이드

- `k drain controlplane --ignore-daemonsets`으로 master node SchedulingDisable 한 이후
- `apt-get update && apt-get install -y --allow-change-held-packages kubeadm=1.20.0-00`
- `kubeadm upgrade plan`
- `kubeadm upgrade apply v1.20.0`

##### kubelet 업그레이드

- `apt install kubelet=1.20.0-00`
- kubelet 재시작
  - `sudo systemctl daemon-reload`
  - `sudo systemctl restart kubelet`

#### worker node 업그레이드

- `ssh node01`
- `apt-get update && apt-get install -y --allow-change-held-packages kubeadm=1.20.0-00`
- `kubeadm upgrade node`
- `apt install kubelet=1.20.0-00`
- `sudo systemctl restart kubelet`
- `exit`

#### Etcd snapshot

- `export ETCDCTL_API=3`
- `ps -aux | grep -i etcd`

```sh
etcdctl --cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /opt/snapshot-pre-boot.db
```

#### Etcd backup restore

1.  etcdctl --cacert=/etc/kubernetes/pki/etcd/ca.crt \
    --cert=/etc/kubernetes/pki/etcd/server.crt
    --key=/etc/kubernetes/pki/etcd/server.key
    --data-dir=/var/lib/etcd_backup --initial-advertise-peer-urls=https://10.5.159.9:2380 --initial-cluster=controlplane=https://10.5.159.9:2380 --name=controlplane snapshot restore /opt/snapshot-pre-boot.db

2.  /etc/kubernetes/manifests의 hostPath 수정

#### name of CA

- `openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text`

#### cluster 변경

- `k config use-context research --kubeconfig=/root/my-kube-config`

#### Assign 된 Role

- `k describe rolebinding kube-proxy -n kube-system`

#### Role yaml

- `k create role developer --verb="*" --dry-run=client --resource=pod -o yaml > drole.yaml`

#### RoleBinding yaml

- `k create rolebinding dev-user-binding --role=developer --user=dev-user --dry-run=client -o yaml > rb2.yaml`

#### PV yaml

- `kubectl create -f https://k8s.io/examples/pods/storage/pv-volume.yaml --dry-run=client -o yaml > pv.yaml`

#### Node Join Token (워커노드를 마스터 클러스터에 결합)

- `kubeadm token list`
- `kubeadm token create --print-join-command`
