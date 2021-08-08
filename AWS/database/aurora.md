## Amazon Aurora

![Amazon Aurora](https://docs.aws.amazon.com/ko_kr/AmazonRDS/latest/AuroraUserGuide/images/AuroraArch001.png)

- MySQL PostgreSQL 오픈소스와 호환
  - MySQL의 5배, PostgreSQL의 3배 쓰루풋
  - 고가용성 보장 (단일 데이터 베이스가 여러 리전에 걸쳐있음)
    - RDS MySQL은 Multi-AZ 활성화 시 Active-Standby 모델
    - RDS Aurora는 Active-Active 모델로 단일 장애점(SPOF) 제거
  - 지역 전체 중단에도 RPO 1초, RTO 1분 미만
- 1/10 비용으로 상용 데이터베이스 수준의 성능 & 가용성 제공
  - 하지만 RDS MySQL에 비해서는 20%~30% 정도 비쌈
- Aurora Serverless
  ![Aurora Serverless](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2018/08/08/vpc-883x1024.png)
  - 데이터베이스를 shutdown 시켜놓았을 때 EC2에 대한 과금 X
  - 자동으로 용량 조절
  - 초당 지불 (최소 1분)
  - 자주 사용하지 않거나, 주기적인 워크로드에 적합
  - HTTP 기반 API 제공

### Aurora 장애조치

자동으로 장애조치를 하며, 관리자의 개입없이도 장애조치가 작용된다.

- Aurora는 DB 인스턴스의 CNAME이 정상적인 복제본을 가리키도록 변경하며, 해당 복제본은 승격되어 새로운 기본 복제본으로 지정된다. 이는 30초 이내에 수행됨.
- 현재 AZ를 사용할 수 없는 경우, Aurora는 다른 AZ에서 DB 인스턴스를 자동으로 다시 생성함.
- 복제본이 없는 경우, 원래 인스턴스와 동일한 AZ에 새 DB 인스턴스를 생성 시도함.
- 여러 리전에 걸친 장애 복구는 수동 프로세스이며, 보조 리전을 승격시키는 조치가 필요함

### Aurora Multi-Masters

![Aurora Multi-masters](https://d2908q01vomqb2.cloudfront.net/887309d048beef83ad3eabf2a79a64a389ab1c9f/2019/06/11/A.jpg)

기존 aurora는 클러스터 내 읽기/쓰기가 가능한 마스터 노드는 1개만 구성하였고, 최대 15개의 읽기 복제본만 구성(읽기 성능만 확장)할 수 있었다.

Multi-Masters의 출시로 이제는 읽기/쓰기가 모두 가능한 마스터 노드를 2개 이상 구성할 수 있게 되어, 읽기/쓰기 성능 모두 확장 가능하게 되었다. (2019년에 정식버전으로 병합)

- 마스터 노드 1개가 장애가 발생하더라도 다른 마스터노드가 쓰기 작업을 할 수 있게 되었다.
- 샤딩 없이 쓰기 성능을 확장 가능
  - 샤딩 : 최대 성능의 데이터베이스 타입을 사용 중인데 성능이 부족하게 된다면, 같은 스키마를 가진 데이터를 다수의 db에 분산하여 저장하는 방법

따라서 고가용성과 성능을 보장할 수 있게됨
