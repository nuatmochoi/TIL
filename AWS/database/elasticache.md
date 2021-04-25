# ElastiCache

## AOF

- 데이터 내구성이 필요할 경우 Redis AOF(append-only file) 기능 사용
- 모든 실패 시나리오를 보호하는 것은 아니며, 물리적 서버에서 하드웨어 결함이 생겨 노드가 실패하면 ElastiCache가 다른 서버에 새로운 노드를 프로비저닝한다.
  - 이 경우 AOF 파일을 사용하여 데이터를 복구할 수 없으며, Redis는 콜드 캐시로 재시작됨
