# Server

## Snowflake Servers
- 재현이 어려움, 변경시 연쇄적 장애 유발
- ski resort에는 좋으나 data center에는 좋지 않음
## Pheonix Servers
- Configuration drift 방지. 서버를 완전히 태우고 주기적으로 잿더미에서 부활

### Shift Left (원점 회귀)
- base image 기반 피닉스 서버가 자주 사용됨
    - Base AMI : Golden AMI와 비슷. 반대되는 단어로는 Application AMI

### Catter -> Rancher
소처럼 (번호표) 서버를 다뤄라

# Mutable & Immutable Infrastructure
1. Mutable : 버전 up 때 reboot
    - Configuration drift를 방지하지 못함
2. Immutable : Destroy하고 새로 Provision (Bule/Green)

- Chef, puppet : lift&shift 방식으로 옮길 때 (mutable)
- ANSIBLE : Mutable
- Terraform : Immutable 

## Imperative vs declarative
1. Imperative : 2개 서버 추가, 룰 추가, 권한 추가 (Ansible)
    - 3에서 5로 바꾸면 8대
2. Declarative : 3개 서버 셋업, 룰 셋업, 권한 셋업 (Terraform)
    - 3에서 5로 바꾸면 5대

## Mutable Terraform
- 권장되지 않음. provisioner 기능은 최후의 방법으로 사용해라
- 왜냐, 멱등성이 깨지며, terraform은 어느 부분이 바뀌었는지 알 수 없음
- 테라폼을 ansible과 통합해서 쓰면 Mutable하게 사용 가능

- app management만 ansible 에게 맡기고, 이전은 terraform이 처리하도록

- Immutable 하게 사용하기 위해서는 승인된 템플릿을 사용하는 것이 중요!!!

