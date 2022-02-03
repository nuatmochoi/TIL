# Cluster Networking
1. Pod 내 Container간 통신

![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=http%3A%2F%2Fcfile21.uf.tistory.com%2Fimage%2F99649A475CC41D1C2EE057)
- veth0(VNI)는 하나의 IP를 사용하며, 각 컨테이너끼리는 port 번호로 서로를 구분

2. Pod-to-Pod 통신
- Pod 하나는 고유한 IP 주소를 가지며, IP 주소로 서로 통신
3. Pod-to-Serivce 통신
- Pod는 죽었다가 살아날 수 있고, IP 주소가 동일할 것이라는 보장이 없기 때문에, Service 앞단에 reverse-proxy나 Load Balancer를 둠으로써 통신이 가능
- service 정의 시 selector를 통해 트래픽을 전달할 Pod를 결정
4. External-to-Service 통신

## Service
- Pod는 클러스터 내에서 노드를 옮기며 IP가 변경됨
- 동적으로 변하는 Pod의 IP를 특정하기 위한 방법이 Service
- label과 label selector를 활용하여, 어떤 Pod를 Service로 묶을지 정의

### Service Type (서비스를 외부 IP 주소에 노출하기 위함)
![ClusterIP](https://so-so.dev/static/36a1b1ee1f762b8e55892e3bf9fb855e/302a4/image_0.png)
1. ClusterIP : 클러스터 내부에서만 접근. 실서비스에서 사용 X
    - 기본적으로 외부와 통신 불가
    - 외부와 통신을 위해서는
        - netfilter chain rule을 통해 IP로 들어온 패킷을 각 Pod에 포워딩하는 설정을 하거나
        - worker node 내 reverse proxy를 생성하여 ClusterIP로 패킷 포워딩
        - 위 세팅을 EKS에서 진행하기 위해서는 EKS cluster 생성 시에 ssh 접근을 위한 값들을 입력해주어야 함
2. NodePort : 모든 Node에서 특정 포트를 열고, 이 포트로 보내지는 모든 트래픽을 서비스로 forwarding 
    - 포트당 한 서비스만 할당
    - 30000~32767 사이 포트만 사용 가능
    - Node의 IP주소가 바뀌면 이를 반영해야 함
3. LoadBalancer : 모든 트래픽이 로드밸런스를 거쳐 서비스로 포워딩
    - AWS EKS에서 LoadBalancer 타입은 NLB를 프로비저닝 (L7을 사용하려면 Ingress 타입으로 배포)
4. Ingress : 도메인 및 경로를 기반으로 들어오는 패킷을 특정 서비스로 포워딩
    - AWS EKS에서 Ingress 타입은 ALB를 프로비저닝함
    - ingress 사용 이전에 clusterIP나 NodePort 타입의 서비스가 생성되어 있어야 함
    - worker node 내부에 ingress를 감지하여 로드밸런서를 프로비저닝하는 ingress controller가 있어야 함



## Serive proxy 
![proxy and service](https://blog.leocat.kr/assets/img/2019-08-22-translation-kubernetes-nodeport-vs-loadbalancer-vs-ingress1.png)
(이미지는 ClusterIP 기준)
- kube-proxy는 고전적 의미의 proxy가 아니라 서비스에 대한 가상 IP를 구현하기 위함
- proxy를 사용하는 이유는 인바운드 트래픽을 백엔드에 전달하기 위함.

### Proxy mode

1. Userspace
    - Service가 생성되면 Node에 Proxy port 생성
    - 클라이언트 요청 인입 시, iptables는 요청한 ClusterIP와 Port를 확인하고, Proxy Port로 트래픽 라우팅
    - kube-proxy는 기본적으로 Round Robin 방식으로 백엔드 Pod 선택 + Session Affinity(AWS ELB의 Stick Session과 동일)에 따라 Pod 중 하나를 선택하여 트래픽 전달 
        - Pod로의 요청 실패 시 자동으로 다른 Pod로 연결 재시도
    
    ![Userspace](https://d33wubrfki0l68.cloudfront.net/e351b830334b8622a700a8da6568cb081c464a9b/13020/images/docs/services-userspace-overview.svg)

2. iptables : default proxy mode. userspace와 달리 kube-proxy는 iptables만 관리하며, 직접 트래픽을 받지 않음. iptables을 거쳐 요청이 직접 포드로 전달되어 userspace보다 빠르다.
    - Service 생성되면 Node에 kube-proxy에 의해 iptables 갱신
    - 클라이언트 요청 인입 시, 패킷의 Target이 Service의 IP와 Port로 설정
    - iptables의 rule 중 맞는 Backend가 있다면 Random하게 선택
        - pod로의 요청 실패 시 재시도 없이 그냥 실패. 방지를 위해 Readiness Probe(컨테이너의 요청 준비 여부 확인) 설정 필요 
    - 지정된 Pod으로 패킷 전달 전, 패킷의 Target의 IP와 Port를 해당 Pod으로 수정
    - 패킷 전달

    ![iptables](https://d33wubrfki0l68.cloudfront.net/27b2978647a8d7bdc2a96b213f0c0d3242ef9ce0/e8c9b/images/docs/services-iptables-overview.svg)


3. IPVS : Linux 커널 제공 L4 LB인 IPVS가 Proxy 역할을 수행. iptables보다 높은 성능(low latency & high throughput)
    ![IPVS](https://d33wubrfki0l68.cloudfront.net/2d3d2b521cf7f9ff83238218dac1c019c270b1ed/9ac5c/images/docs/services-ipvs-overview.svg)

## ETCD
- 2379 포트에서 클라이언트 통신을 받고, 2380포트에서 서버간 통신


## Reference
- https://medium.com/google-cloud/understanding-kubernetes-networking-pods-7117dd28727
- https://medium.com/finda-tech/aws-eks%EC%97%90%EC%84%9C-service-%ED%83%80%EC%9E%85-%EB%B3%84-ingress-%ED%85%8C%EC%8A%A4%ED%8A%B8-b911f129c8d5
- https://medium.com/swlh/kubernetes-services-simply-visually-explained-2d84e58d70e5
