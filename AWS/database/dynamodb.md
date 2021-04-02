# DynamoDB

## 특징
- 자동 이중화 : 서버 장애 또는 가용 영역 중단시 내결함성을 제공하기 위해 AWS 리전의 3개 시설에 자동으로 데이터 복제
- SSD기반 NoSQL 서비스
- 테이블 데이터는 json 형식으로 저장됨
- 완전 관리형 NoSQL 데이터베이스 서비스
    - 클러스터링, 백업정책, 성능 상향, 다중리전 지원
- 트랜잭션, JOIN과 같은 작업이 필요하다면 DBMS 사용이 더 적합 (DDB의 단점)
- 규모가 커지더라도 PUT/GET이 항상 10ms 이내, 무제한으로 Scaling 가능.
- Table + Item + Attribute
    - Table : item들의 집합. 리전당 생성할 수 있는 최대 개수 256개
        - 기본키 지정 필수 
            - 단순 기본키 : Partition Key (Hash Key) (=, != 연산만 가능)
            - 복합 기본키 : Sort Key (Range Key) (범위연산 및 ~ 연산 가능)
- 테이블 내 항목의 데이터 크기는 400KB를 초과할 수 없다.

### 인덱스
- 단순 보조 인덱스 기본키 : Hash Key (기본키 이용하여 자동 생성)
- 복합 보조 인덱스 기본키 : Hash Key + Range Key

- Global 보조 인덱스(GSI) : 파티션키와 정렬키가 모두 다름 (모든 파티션에 접근 가능)
    - 생성, 삭제가 자유롭고 쿼리 용량에 제한 없음
- Local 보조 인덱스 (LSI) : 파티션키는 같지만 정렬키가 다름 (특정 파티션에만 접근 가능)
    - 테이블 생성 시에만 생성 가능. 삭제 불가. 
    - Hot Key 이슈를 막기 위하여 사용됨
    - 10GB 제한

### Scaling 
- 전체 데이터를 골고루 분산시키기 위해 Partition Key 사용 (Scaling의 핵심이 Partition Key)
    - DynamoDB는 DB 트래픽이 늘어나면 자동으로 instance를 늘리는데, 그 기준은 파티션키를 hash 값. 
    - 한 파티션 키에 해당하는 데이터는 10GB가 넘을 수 없다.
- 로드가 적은 DDB의 테이블 사용시 한 서버로 처리
- 로드가 많아지면 파티션 키의 hash 값으로 두 개의 서버로 쪼개지고, 그래도 부하가 크다면, 계속 쪼개지는 과정 반복.

### Partition Key
- Key-Value 저장소 용도일 때는 파티션키를 고려하지 않아도 크게 문제 없음.
- Query 를 사용할 때 Partition Key + Sort Key 조합으로 Key를 설정해야 함
    - DDB의 Query 기능은 Partition Key에 속한 Sort Key에 조건을 걸어 데이터 조회하기 때문
    - Query를 사용하고 싶어도, 특정 Partition Key에만 데이터가 몰려서는 안되기 때문에, 파티션키 정하는 것이 어려운 것임 (Hot Key 이슈)

## 추가 기능
1. DAX (DynamoDB Accelerator)
    - DDB와 동일한 인터페이스의 in-memory cache 서버. 
    - 읽기 볼륨이 많거나 1ms 미만의 읽기 지연시간이 필요할 때 필요
2. Stream + Lambda
    - DDB에 POST/PUT/DELETE 되는 데이터가 생길 때마다 Lambda를 실행할 수 있음
3. Global Table
    - AWS가 지원하는 리전에 자동으로 동기화되는 데이터를 구성할 수 있음
    - 전세게에 DB 분산

## 요금 계산
- 모든 아이템을 KB 단위로 환산한 뒤에 소수점 이하를 올림하고 용량단위의 배수로 맞춰서 다시 올림 (1Byte만 사용해도 용량단위로 올림해서 계산)
- 용량 단위
    - WCUs : 1KB
    - RCUs : 4KB, Strictly Consistent Read (Real Time)
    - RCus : 8KB, Eventually Consistent Read (Near Time)
- 온디맨드 프로비저닝에 비해, 읽기 및 쓰기용량을 미리 예약하면 비용을 절감할 수 있다.

## Reference 
- [DynamoDB 사용하기](https://medium.com/@bbirec/dynamodb-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0-de3fc045c7b8)
