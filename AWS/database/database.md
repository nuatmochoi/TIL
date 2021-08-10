## 완전 관리형 데이터베이스

- 고객은 스키마 설계, 쿼리 작성, 쿼리 최적화에만 신경
- AWS에서 백업, 복구, 보안, 스케일링, 모니터링 등 모두 지원
- MySQL, PostgreSQL, MariaDB 등 오픈소스DB 지원

  - 상용 DB보다 성능, 가용성 안 좋다

- 이를 해결하기 위해 **Amazon Aurora** 출시

## AWS DB 종류

- 관계형 : RDS, Aurora (ACID)
- Key-value : DynamoDB (높은 처리량, 낮은 지연)
  - Aurora와는 달리 서버리스
  - 아이템(항목) (== RDB의 row)
  - Attributes (속성) (== RDB의 column)
    - 모든 아이템들이 동일한 속성을 가지지 않아도 된다
    - 테이블이 생성된 이후에도 원하는 아이템에 대해서 속성을 추가할 수 있다.
  - 파티션키 지정 (데이터 분산이 잘 되도록)
  - 조회를 빠르게하기 위해 소트키를 옵션으로 지정
- Document : DocumentDB
- In-memory : ElastiCache (마이크로 초단위 레이턴시, 애플리케이션에서 바로 접근 가능한 캐시 구조)
- GraphQL : Neptune
- Time-series : Timestream (시계열 데이터)
- Ledger : QLDB (블록체인)
- Wide column : Keyspaces (아파치 카산드라 호환)

## OLAP vs OLTP

- OLAP (OnLine Analytical Processing) : 온라인 분석 처리
  - 데이터 웨어하우스의 데이터를 전략적인 정보로 변환시키는 역할. 기본 접근, 조회, 계산, 시계열, 복잡한 모델링
- OLTP (OnLine Transaction Processing) : 온라인 트랜잭션 처리
  - 여러 이용자가 실시간으로 데이터 베이스의 데이터 갱신, 조회하는 작업을 처리하는 방식. 주로 금융 전산 관련

## DR 구성

- mirroring 상태로 active/active로 두면 동기화 문제는 없지만 비용 높음
- Hot / Cold로 나눠서 생각할 수 있음
  - Hot : 데이터만 이중화, 네트워크는 이중화 X
  - Cold : 수동 작업
