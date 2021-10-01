# EKS

## k8s

### Kubernetes Cluster
![k8s cluster](https://aws-eks-web-application.workshop.aws/images/10-intro/k8s_component.png)
- 쿠버네티스 배포 시 클러스터가 생성됨, 클러스터는 노드의 집합이며, 노드는 크게 control plane과 data plane으로 나뉨
    - Control Plane : worker node와 클러스터 내 pod를 관리하고 제어
    - Data Plnae : worker node로 구성되며, pod를 호스팅함

### Kubernetes Objects
- desired state를 담은 레코드이며, 오브젝트 생성 시 k8s의 컨트롤 플레인에서 오브젝트의 current state와 desired state를 일치시키기 위해 지속적으로 관리함
- k8s의 오브젝트에는 pod, service, deployment 등이 있음
