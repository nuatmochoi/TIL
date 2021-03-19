# 방화벽 / IDS / IPS

## 방화벽

- Authentication : 사용자 인증
- Authorization (access control) : 패킷 검사 및 IP 검증
- Encryption : 암호화

## IDS/ IPS

- 방화벽은 IP/Port 기반 차단 솔루션(L3~L4)이기 때문에, 외부에서 내부로 무조건 들어와야 하는 서비스의 경우는 관련 서비스 포트를 모두 허용으로 둠
- 해당 경우에 악의적인 접근을 차단하기 어렵기 때문에, 이를 보안(L4~L7)하기 위해서 나온 것이 IDS(탐지) / IPS (예방)
- 오탐률을 낮추기 위해 IDS와 IPS를 같이 사용하는 경우가 많음

### IDS (침입 탐지 시스템, Intrusion Detection System)

- 비인가된 사용자가 시스템을 조작하는 것을 탐지
- NIDS(NetworkBased IDS)와 HIDS(HostBased IDS)가 존재
- 악의적 네트워크 트래픽을 탐지하고 로깅. 관리자는 해당 로그를 보고 보안정책을 재검토
- 각종 해킹 수법 패턴이 자체 내장. 실시간으로 침입을 감지 및 추적 가능.

### IPS (침입 예방 시스템, Intrusion Prevention System)

- IDS가 탐지하는 역할까지라면, IPS는 여기에 더해서 차단 기능까지 수행
- 네트워크 트래픽을 검사하여 주어진 정책에 따라 차단

## WAF (Web Application Firwall)

- L7 계층에서 HTTP(80) 프로토콜을 베이스로 하는 취약점 공격 탐지 및 차단
