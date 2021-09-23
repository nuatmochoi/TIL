# 쿠버네티스

- 2014년 구글에서 처음 개발
- 컨테이너 여러 개를 한 번에 관리하는 기술은 Container Orchestration이라고 명명됨
- CNCF (CLoud Native Computing Foundation, 클라우드 기술 표준형을 개발하는 재단)에서 쿠버네티스를 중심 프로젝트로 편성
- 그 결과, 쿠버네티스는 Container Orchestration의 표준이 됨.

## 분산 시스템

- 보안이 어려움
- loosely coupled(구조적으로 개선이 어려운 문제)
- 즉시성을 요하는 분야에서 어려울 수 있다.
- 위 단점을 극복하기 위해 edge computing이 많이 이용된다. edge computing은 cloud computing과 상호 보완적.

## 쿠버네티스

- k8s 최소 관리 단위 : pod (pod에는 여러 개의 컨테이너가 들어있다)
- kubelet을 통해 kubernetes master가 각 서비스를 관리한다.
- service는 동일한 pod를 여러 개 실행시킨 것
- k8s는 서비스에 대해 대표 접속 ip를 부여한다. 대표로 받은 요청을 각 pod의 고유 ip로 분산함
- pod가 비정상이 되면 k8s에 삭제되고 새로 생성 / 요청 수가 늘어나면 pod 추가 생성 (auto scaling)
- etcd : 각 서비스와 pod의 구성 정보, 상태 데이터를 저장하는 곳

## 과정

1. devops가 container / pod / service의 구성 정보를 전달
2. k8s manager가 각 노드의 용량에 맞게 pod를 분산 배포 (resource scaling)
3. 컨테이너 pod service 구성 정보 & 접속 정보 저장
4. 요청이 들어오면 proxy를 통해 대표 주소로 받은 요청을 서비스에 속한 pod로 포워딩함

## Ingress Controller

- [Ingress](https://kubernetes.io/ko/docs/concepts/services-networking/ingress/)
- 인그레스는 클러스터 내 서비스에 대한 외부 접근(HTTP, HTTPS request)을 관리하는 규칙의 모음
- 인그레스는 로드 밸런싱, SSL 인증서 처리 및 도메인 기반의 가상 호스팅을 제공할 수 있음
- 인그레스는 인그레스 컨트롤러를 조건으로 필요로 하며, 인그레스 리소스만 생성한다면 효과가 없음
  - 쿠버네티스는 AWS, GCE, Nginx ingress controller를 지원하고 있음
