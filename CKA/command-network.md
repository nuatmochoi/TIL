# Command network

- Network interface : `ip a`, `ip link`

  - state 확인 가능

- MAC address of ControlPlane : `ip link show etho0`

- `arp -a`

- 외부 통신 : `ip route show default`

- 모든 열린 TCP 소켓 리스트 : `netstat -nplt`
- 포트의 상태 확인 : `netstat -anp`

## CNI

1. /opt/cni/bin : 설치된 CNI의 배포 패키지 확인
   - 네트워크 인터페이스 : 인터페이스를 컨테이너의 Network Namespace에 추가하고, 호스트와 연결 (veth pair)
     - BRIDGE, VLAN, IPVLAN, MACVLAN, WINDOWS 등
   - IPAM 플러그인 : 인터페이스에 IP를 할당하고, Routing Table 갱신
     - host-local, dhcp, static 등
2. /etc/cni/net.d : 설치된 CNI의 설정 파일
   - 예를 들어 Calico 설치시, 설정 파일을 /etc/cin/net.d/10-calico.conflist에 저장하는 식
3. `kubectl get daemonset -n kube-system` : CNI에 해당하는 daemonset 확인

- weave-net deploy : `kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"`
- flannel install : `kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml`

- cluster ip range : `cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep cluster-ip-range`

- `kube exec -it pod -- sh`로 쉘 실행 이후, `curl http://web-service.default.svc` 등 FQDN을 통해 액세스 여부 판단 가능

  - ex> `bacekend-database.default.svc.cluster.local`
    - `backend-database` : 서비스 이름
    - `default`: 서비스가 정의된 namespace
    - `svc.cluster.local` : 클러스터의 도메인 접두사

- `k exec -it hr -- nslookup mysql.payroll > /root/CKA/nslookup.out`

## Ingress

- ingress 생성하기 전에 `k get svc --all-namespaces`로 서비스 및 포트 확인
