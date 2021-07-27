# AWS 컨테이너 서비스

- 빠른 배포로 개발 효율 향상
- 작은 단위 이미지 관리 및 비용 절감 -> 운영 효율 향상
- 다양한 컨테이너 서비스로 빠르고 쉽게 클러스터 운영
- IaC는 필수

- 컨테이너 스케일링+스케줄링+배포전략 하려면 오케스트레이션 툴이 필요 -> ECS, EKS가 해당 역할
- 컨테이너 호스팅 : EC2, Fargate
- 이미지 저장 : ECR

## ECS

- 상태 체크로 자동으로 복구
- 클러스터(컨테이너 인스턴스 그룹)을 API로 관리

## EKS

- 관리형 k8s 서비스
- 최신 버전의 k8s 지원

## Fargate

- EC2에 컨테이너 배포하려면 서버&클러스터를 관리해야함
- Fargate는 서버&클러스터 관리가 필요 없음
- [AWS Fargate for Amazon EKS에서 Amazon EFS를 지원하기 시작](https://aws.amazon.com/ko/blogs/korea/new-aws-fargate-for-amazon-eks-now-supports-amazon-efs/)하면서, 상태 저장 워크로드를 운영할 수 있게 되었음
  - EKS Pod 들은 일시적임(죽었다가 살아나는 것 반복) - 다른 가용 영역에서 pod이 생성될 수도 있으며 EBS는 동일 AZ 단위이기 때문에 데이터 유실
  - 특히 Prometheus 등 로그는 유실되면 안되는 워크로드
  - [과정](https://kscory.com/dev/aws/eks-efs)
    ![EKS with EFS](https://kscory.com/assets/aws/eks-efs/01-eks-efs-intro_02.png)
    1. EFS 생성
    2. EFS Provisioner 생성 :EFS와 EKS 간 커뮤니케이션을 위함
    3. StorageClass 생성 : k8s 관리자가 특정 스토리지 유형(EFS or EBS)와 구성을 등록하기 위한 수단
    4. Storage 내 PVC 바인딩 (PVC 객체 및 관련 API를 통해 k8s 사용자가 권한 요청)

## AWS PROTON

- 완전 관리형 컨테이너 및 서버리스 애플리케이션 배포 서비스
- 템플릿 코드로 인프라 관리 (컨테이너 배포에 패턴이 존재하고 해당 패턴을 템플릿으로 제공 in github)

## ROSA (Red Hat Openshift On AWS)

- 관리형 Openshift 서비스

## AMP

- 프로메테우스의 완전 관리형 서비스
- 서버에 프로메테우스에 설치하지 않고, 컨테이너 관리가 필요없어짐(컨테이너 관리에 필요한 모니터링 서버가 원래는 필요함)

## AMG

- 그라파나를 완전 관리형 서비스로 제공

## ECS Anywhere

- ECS를 온프레미스에서 사용하도록 해줌

## EKS Anywhere

- 온프레미스 인프라에서 쿠버네티스 클러스터를 일관되고 쉽게 운영 가능

## 자동화

- Terraform : 프로비저닝
- Helm : k8s object 패키징
- Argo : 컨테이너 배포, gitops 구현

## 카오스엔지니어링 (실패 주입 -> self-healing)

1. 리소스에 부하 주입
2. Pod을 랜덤 강제 삭제
3. 워커노드 랜덤 강제 삭제
4. 네트워크 트래픽 차단
