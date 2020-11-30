# 쿠버네티스

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
