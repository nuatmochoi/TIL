# Database, BigData
- [textbook](db-book.com/db7/index.html)
## SQL
- DBA : DB 설계(스키마), 모니터링(백업), 튜닝
- Oracle (lock, MVCC?)
- 클라우드 : 튜닝도 튜너가 필요 X
    - 엔진이 튜닝
    - RDS : 백업, 용량 확장

- ER Data model (Peter Chen)
    - entity sets
    - relation sets
    - attributes

- 스키마 : DB구조와 제약 조건에 대한 메타데이터의 집합 (물리적인 것이 아닌, 논리적인 도식)
    - ER Diagram 

- null : 알 수 없는 값

- 빅데이터에서 null을 어떻게 처리할 것인가? (ETL) 

## Storage
- Magnetic Disk : seek time의 기술적 한계
- IOPS : 초당 IO가 몇번 가능하냐
    - 4KB read : 10,000 IOPS
- SSD 
    - shell
    - SATA
    - NVMe

## File
- Slotted Page Structure
    - block header -> 각 칸마다 데이터 유형, 데이터 값 등 들어가도록
- Buffer = Memory
    - LRU (가장 참조 안되는 것을 free)

## Indexing
- Balance Tree (B+-tree) : 부모에 자식의 숫자 제한이 없지만, depth가 똑같다 (한 쪽으로 자식이 많지 않음)
    - 인덱싱에서 사용되는 자료구조
    - leaf node를 따라가면 원하는 레코드를 찾을 수 있게끔
    - leaf node만 봐도 모른다면 point가 연결되어 있기 때문에 값을 가져올 수 있음
    - 속도가 안 나온다? -> 인덱스를 만들 때, 포인트를 쫓아가는 작업이 없기 때문에 더 빨라지는 효과

## Transaction
- DB = locking mechanism (ex> 돈 입금, 출금)
- 데이터에 접근하는 프로그램 실행의 최소 단위
- ACID (약속)
    - 원자성(all or nothing) - (DB의 커밋 단위 -> commit;) 
    - 고립성(트랜잭션의 각 단계 사이에 다른 작업이 들어올 수 없다. 트랜잭션은 각각 독립되어야 한다.)
    - 일관성(상태가 바뀌었지만 총합은 보장)
    - 영속성(실행되었을 때 결과 보장)

## Recovery
- DML 조작 레벨에서의 recovery (<-> 테이블 삭제 등 DDL 단계와는 다름)
- 기기 다운 등 장애에서 복구
- redo log

## BigData
- [BigData란](https://www.youtube.com/watch?v=kxLFYfns3t8)
- 개인화, 추천, 공공데이터 -> 목표 설정 -> 데이터 수집, 가공
    - s3 넣기 전에 가공해서 넣어라! / ETL (빅데이터 80~90%) 