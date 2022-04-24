# Amazon MemoryDB for Redis

- 다중 AZ의 내구성을 갖춘 Redis 호환 인메모리 DB 서비스

## ElastiCache for Redis 가 있는데 왜?

- MSA로 오면서, Hot Data를 지원하기 위한 데이터베이스가 필요했다
  - Fast
  - Flexible
  - Friendly
- DB를 관리하기 어려워질 수 있다 (항상 가동)
- Robust 하게 만들기가 어렵다. (내구성 및 데이터 손실 zero)
- Scaling 어려울 수도
- 비싸거나

- ElastiCache는 **기본 DB및 다른 저장소의 Data를 캐싱** or 내구성이 필요하지 않은 일시적 데이터를 위함
- MemoryDB는 멀티 AZ 내구성 / 애플리케이션의 기본 DB(Primary DB)로 지정 가능 (캐싱과는 별개) / 그러면서 Redis API와 호환

## 기능

- microsecond read / 한자리 ms write
- cluster scale out 시 초당 수백만 건의 트랜잭션까지 가능
  - 처리량이 높고 대기 시간이 짧은 까다로운 애플리케이션 지원 가능
- 관리작업 (스냅샷 등) 자동화
- Redis API 100% 호환하는 Primary DB
- multi-AZ 기본 지원 (cluster mode를 통함)
- DB의 key set 별로 샤드당 최대 5개의 복제본 생성하여
  - 해당 key space에 대한 고가용성 및 읽기 성능 확장
- 최대 500개의 노드를 가질 수 있음
  - 250개의 Primary + 250개의 Replica (multi-AZ에 따라)
  - 클러스터 당 128TB의 저장소까지 지원

## 사용 사례

- 리테일 : 고객 프로파일, 계정 정보 저장 / 재고 트래킹 및 이행 (추적 및 제공)
- 게임 : 리더보드, 플레이어 데이터 스토어, 세션 히스토리
- 은행 및 금융 : 유저 트랜잭션, 사기 탐지(실시간 - 빠르게 레코드를 수집하고 Redis를 활용하여 실시간 분석)
- 미디어 : 유저 데이터 및 실시간 스트리밍
- IoT : 들어오는 데이터에 대한 실시간 분석 / redis의 기능인 공간 조회(spatial lookup --> 공간 반경 등)

## 벤치마크

- R6g.16xlarge 에서
- 초당 390,000개의 reads / 1.3GB/s read
- 초당 100,000개의 write / 100MB/s write

## 스케일링 매우 쉽다

- aws memorydb `update-cluster` --cluster-name `my-cluster` --shard-configuration `ShardCount=5`

## 오픈소스 Redis 라면..

- 데이터 전송 시 기본 시스템이 다운되면, 해당 Replica와 해당 데이터는 사라질 것 (Primary가 act, but not deliver)
- MemoryDB는 이를 내부적으로 multi-AZ transaction log에 저장하여 모든 노드에 저장되고 원하는 곳으로 전달될 것.
- 모든 것은 Primary DB로 Redis를 제공하기 위한 설계

## AWS 서비스간 비교 (내구성 측면 )

### ElastiCache for Memcached

- 내구성 측면 지속성 없다.

### ElastiCache for Redis

- 내구성 없으며, 실제로 다른 데이터 베이스를 캐싱하거나
- 임시 데이터의 Primary DB 역할을 할뿐임
- 스냅샷을 사용하거나(연속 스냅샷은 불가)
- 다른 노드에 대한 비동기식 복제 --> 문제는 비동기이므로 데이터 손실 생길 수 있음

### MemoryDB for Redis

- Multi AZ transaction log -> 모든 쓰기 작업은 내구성을 가짐

## Reference

- https://youtu.be/RvBbaKl9k6w?t=1795
