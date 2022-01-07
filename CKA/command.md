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
