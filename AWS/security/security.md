# AWS 보안

## AWS Shield

- AWS Shield Standard : L3, L4 디도스 공격을 완화하지만, SYN같은 알림은 표시하지 않는다.
- SYN Flood, UDP Reflection 공격을 완화하기 위해서는 AWS Shield Advanced가 필요하며, 계약을 한 이후에 DDos 공격이 일어나면 수동 완화를 적용해주는 AWS DRT 팀 지원도 받을 수 있다.

## AWS WAF

- L7 디도스 공격(XXS, Cross-Site Scripting을 통한 DDOS 공격)을 막는다. 원리는 정규표현식 기반으로 방어

## Amazon Inspector

- 취약점(CVE) 평가 서비스
- OS, Middleware, Network 관련 취약점 점검
- Agent 기반

### Amazon Inspector assessment report

assessment run에서 테스트한 항목과 평가 결과를 보여주는 문서 - [참고](https://docs.aws.amazon.com/ko_kr/inspector/latest/userguide/inspector_reports.html)

- 평가에 대한 요약
- 평가된 EC2 인스턴스
- 평가에 포함된 규칙 패키지

## Amazon Macie

- 기계 학습 및 패턴 일치를 사용하여 AWS에서 민감한 데이터를 검색하고 보호하도록 설계
- 주로 데이터 보안 및 데이터 프라이버시를 위해 Amazon S3 버킷을 스캔한다.
