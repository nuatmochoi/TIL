## 온프레미스와 VPC 연결

### Direct Connect

- VPN처럼 AWS와 직접 연결하지 않고, 중간에 AWS와 연결된 DX Location이 있어, 해당 DX Location 까지만 전용회선을 구축하면 되는 형태
  - 이후 DX Location 내 고객/파트너의 상면에 고객의 라우터를 설치, AWS Cage에 있는 AWS의 라우터와 연결한다. 이 작업을 Cross Connect라고 부름
- DX Location은 국내에서 가산의 KNIX, 평촌의 LG U+가 있다.
- 전용선을 사용하기 때문에 Bandwidth와 Latency가 일관적
- 이중화 방법 (반기에 한번 씩 Direct Connect의 정기 점검이 있어 고가용성 보장을 위해 이중화가 필요)
  1. Direct Connect + VPN 백업
     - 라우팅의 우선 순위는 무조건 VPN < DX
     - DX에 문제가 발생할 때 VPN으로 Failover가 되는 구성
     - 이중화 방법 중 가장 비용이 싼 방법
     - 즉, Direct Connect는 active 상태, VPN은 failover를 위해 standby 상태로 존재한다.
  2. DX Location 내에 inter-connection을 2개 설정하는 방법
  3. LAG (Link Aggregation Group) : 전용선의 최대 Bandwidth가 10Gbps까지이기 때문에, 이것을 4개 묶어 40Gbps까지 높인 방법
  4. DX Location과 전용선을 모두 2개씩 구축하는 방법 (가장 비용이 비쌈, 주로 금융권에서 사용)

#### 2개의 Direct Connect로 이중화

- 액티브/액티브 (BGP 다중 경로) : 네트워크 트래픽이 양쪽 direct connect로 로드밸런싱된다. 한쪽이 사용할 수 없게 될 때 다른 쪽 direct connect로 라우팅된다. 기본 구성.
- 액티브/패시브 (Failover) : 한쪽이 트래픽을 처리하는 동안 다른 쪽은 대기 상태. 액티브가 사용 불가일 때 패시브로 트래픽이 연결.

#### Direct Connect의 active/standby 우선순위

대부분의 고객들은 일관적인 트래픽의 flow를 위해 active/standby 방식을 선호하며, BGP parameter를 통해 이것을 조절할 수 있다.

1. global적으로 longest prefix(CIDR가 더 긺)가 우선순위를 가진다.
2. AWS to On-Premise 트래픽 : AS prepending 파라미터를 통해 보다 적은 AS-PATH를 가지는 회선이 우선순위 (61000 > 61000, 61000)
3. On-Premise to AWS 트래픽 : BGP의 Local Preference 파라미터를 통해 우선순위가 높은 회선을 사용 (7300 > 7100)

따라서 동일한 회선이 항상 사용되도록 BGP parameter를 조정하는 것이 필요

## Direct Connect Gateway

![DX GW](https://docs.aws.amazon.com/ko_kr/directconnect/latest/UserGuide/images/dx-gateway.png)

`[온프레미스 IDC App <-> A리전 VPC App]`, `[온프렘 IDC App <-> B리전 VPC App]`

두 연결 모두 일정한 성능(속도)의 연결이 이루어지기를 원하며, A리전에만 DX가 연결되어 있을 때 최소 비용 구현하기 위해서 DX GW가 사용됨 (VPC 간에 연결하는 것이 아님)

1. Direct Connect Gateway를 프로비저닝하고, DX GW와 각 리전의 VPC용 VGW를 연결
2. 마지막으로 Direct Connect 연결에서 Private Virtual Interface(VIF)를 생성하고 DX GW와 연결
3. 복수 리전에 각각 퍼져있는 VPC와 DX를 연결할 수 있다.

## Reference

- [AWS Summit Seoul 2016 - AWS Direct Connect 및 VPN을 이용한 클라우드 아키텍쳐 설계 (Steve Seymour, AWS)](https://www.youtube.com/watch?v=kXLpCCbmIWQ&ab_channel=AmazonWebServicesKorea)
- [KINX와 함께 하는 AWS Direct Connect 도입 - 남시우 매니저(KINX)](https://www.youtube.com/watch?v=8X1g2w-0fvM&ab_channel=AmazonWebServicesKorea)
- [실전! AWS 하이브리드 네트워킹 (AWS Direct Connect 및 VPN 데모 세션) - 강동환, AWS SA:: AWS Summit Online Korea 2020](https://www.youtube.com/watch?v=yMgwrkqfcbg&ab_channel=AmazonWebServicesKorea)
