# k8s install commands

## Control Plane node 업그레이드

### Kubeadm 업그레이드

- `k drain controlplane --ignore-daemonsets`으로 master node SchedulingDisable 한 이후
- `apt-get update && apt-get install -y --allow-change-held-packages kubeadm=1.20.0-00`
- `kubeadm upgrade plan`
- `kubeadm upgrade apply v1.20.0`

### kubelet 업그레이드

- `apt install kubelet=1.20.0-00`
- kubelet 재시작
  - `sudo systemctl daemon-reload`
  - `sudo systemctl restart kubelet`

## worker node 업그레이드

- `ssh node01`
- `apt-get update && apt-get install -y --allow-change-held-packages kubeadm=1.20.0-00`
- `kubeadm upgrade node`
- `apt install kubelet=1.20.0-00`
- `sudo systemctl restart kubelet`
- `exit`

## Node init & join
- init 및 join 이후 `/var/lib/kubelet/config.yaml`이 생성

### node 초기화 (kubeadm init)

- `kubeadm init --apiserver-cert-extra-sans=controlplane --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address 10.8.203.12`
- 초기화 후 다시 시작하려면 `kubeadm reset cleanup-node`
- controlplane 이후, 환경 변수 설정 필요 : `export KUBECONFIG=/etc/kubernetes/admin.conf` 혹은 루트유저가 아니라면 아래 shell script 실행
```sh
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### Node Join Token (워커노드를 마스터 클러스터에 결합)

- `kubeadm token list`
- `kubeadm token create --print-join-command`

- 워커 노드에서 `kubeadm join 10.1.45.6:6443 --token wnurzd.y81snxw584u8bo95 \
        --discovery-token-ca-cert-hash sha256:5e22ae00d77e04f38f82d16807f004f4cdc2928ce71779d573b777632464fbe2`
- 이후 마스터 클러스터에서 `k get nodes`로 join되었는지 확인
