# VPC
사용자 지정된 가상의 네트워크 환경이다. 논리적으로 격리되어 있는 공간이다.
리전을 선택하고, 원하는 IP range를 가장 먼저 설정한다.
가용영역 단위로 서브넷을 생성하고, 서브넷의 목적에 따라 라우팅 테이블과 연결한다.

## 서브넷
서브넷의 종류에는 크게 Public Subnet과 Private Subnet이 있다.
- Public Subnet : Internet Gateway와 연결된 서브넷
- Priavate Subdnet : Internet Gateway와 연결되지 않은 서브넷. 펌웨어 패치 등을 위해 NAT Gateway와 연결되어 있다.

## CIDR
서브넷 마스크의크기는 /16 ~ /28 사이이다.
- /16 : 16bit의 CIDR을 사용하면 B클래스와 동일하게 네트워크 할당 (16 비트 네트워크 아이디 + 16비트 호스트 아이디 => 2^16 == 65536개 IP range 사용 가능)
- /24 : 16bit 네트워크 아이디 + 8비트 서브넷 아이디 + 8비트 호스트 아이디 => 2^8 == 251개 (나머지 5개는 예약 IP)의 IP range 사용 가능

## NACL & Security Group
- NACL (Network aces control list)
    - 서브넷으로 들어오려는 모든 인터넷 패킷은 NACL을 거치고, 패킷의 permission을 판단
    - Stateless (인바운드, 아웃바운드 주소/포트를 모두 선언해야 힘)
- Security Group
    - 같은 서브넷 내에서, 허용되는 IP를 제외하고 block
    - Stateful (인바인드가 허용이면, 아웃바운드는 자동으로 허용)

## 고가용성
- 두 번째 서브넷을 만들고, Auto Scaling을 사용해 새 리소스가 두 번째 서브넷으로 자동 시작되게 할 수 있음
- ALB는 서브넷의 엔드 포인트 간 로드를 분산할 수 있음 (A/B 테스트 및 블루/그린 배포 가능)
- 별도의 가용 영역(AZ)에 두 번째 서브넷을 유지함으로써, 한 AZ의 리소스를 사용할 수 없더라도 다른 AZ에서 사용 가능 (다중 AZ)
- 새 서브넷에서 라우팅 테이블을 따로 생성하지 않고, 이전에 생성한 라우팅 테이블과 연결
- ELB는 연결된 리소스에 상태 체크를 하여 장애 조치를 처리함

## 3-Tier VPC
Single Tier VPC는 모든 것을 하나의 서브넷에 넣기 떄문에 보안에 취약 (개인 블로그나 웹 사이트 등의 애플리케이션의 경우에는 비용 효율적일 수 있다.)

- NAT, ELB (Public Subnet) : 들어오는 트래픽 (ALB), 나가는 트래픽(NAT)
    - 가장 적게 IP가 필요 (ex> /22)
- App (Private Subnet)
    - 가장 많은 IP가 필요 (ex> /20)
- Data (Private Subnet) 
    - 퍼블릭보다는 많이 필요하지만, App에 비해서는 적게 (ex> /21)
- 3티어 설계에 적합한 트래픽 패턴 - IGW -> ALB -> App -> Data -> App -> NAT -> IGW

- `enableDnsHostnames` 
    - PC에서 시작된 인스턴스가 퍼블릭 DNS 호스트 이름을 가져오는지 여부
    - `true`인 경우 VPC의 인스턴스는 퍼블릭 DNS 호스트 이름을 갖지만, `enableDnsSupport`가 `true`인 경우에만 가능
- `enableDnsSupport`
    - VPC에 대해 DNS 확인이 지원되는지 여부
    - `false`이면 퍼블릭 DNS 호스트 이름을 IP주소로 확인하는 DNS 서버가 활성화되지 않음
    - `true`이면 Amazon 제공 DNS 서버에 대한 쿼리와 예약된 IP주소에 대한 쿼리가 성공

## VPC Peering 
![VPC Peering](https://cdn-ssl-devio-img.classmethod.jp/wp-content/uploads/2020/05/VPC-Peering-On-Premise-1.png)
- 프라이빗 IPv4 또는 IPv6 주소를 사용하여 두 VPC 간 트래픽을 라우팅하기 위한 VPC 간의 네트워킹 연결
- 온프레임과 연결시 모든 VPC에 VPN Connection을 해주어야 하는 번거로움
- VPC 당 최대 VPC Peering 가능 개수 : 125개
- 대역폭 제한 없음
    - 대역폭 제한이 문제가 된다면 VPC Peering 사용

## Transit Gateway
![Transit Gateway](https://cdn-ssl-devio-img.classmethod.jp/wp-content/uploads/2020/05/TGW-On-Premise-1.png)
- VPC와 온프레미스 네트워크를 단일 게이트웨이에 연결할 수 있도록 해주는 서비스
- 여러 VPC를 한번에 연결할 수 있게 함 + VPN Connection의 개수도 줄어듦
- 대역폭 제한 : 50 Gbps
- Transit Gateway당 VPC 최대 연결 개수 : 5000개
    - VPC 1개당 125개가 넘는 VPC Peering이 필요하다면, Transit Gateway 사용  
    - 단순한 구조이지만, VPC Peering 보다 많은 비용 청구

## 온프레미스와 VPC 연결

### VPN
- IPSec 네트워크 프로토콜 기반 VPN 연결
- VPN Tunnels은 기본적으로 이중화(되어 있고, TLS 통신이기 때문에 안전하게 통신 가능
- 인터넷 기반이기 때문에 성능, 품질이 전용선보다는 떨어지고, 지연이 생길 수 있다. (Bandwidth와 Latency가 가변적)
- AWS 상에 VPN을 연결하기 위한 Virtual Private Gateway(VGW)가 만들어지고, 해당 VGW와 온프레미스의 CGW(Customer Gateway)가 통신

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

#### Direct Connect의 active/standby 우선순위

대부분의 고객들은 일관적인 트래픽의 flow를 위해 active/standby 방식을 선호하며, BGP parameter를 통해 이것을 조절할 수 있다.

1. global적으로 longest prefix(CIDR가 더 긺)가 우선순위를 가진다.
2. AWS to On-Premise 트래픽 : AS prepending 파라미터를 통해 보다 적은 AS-PATH를 가지는 회선이 우선순위 (61000 > 61000, 61000)
3. On-Premise to AWS 트래픽 : BGP의 Local Preference 파라미터를 통해 우선순위가 높은 회선을 사용 (7300 > 7100)

따라서 동일한 회선이 항상 사용되도록 BGP parameter를 조정하는 것이 필요

## Reference
- [VPC Peering과 Transit Gateway 어떻게 다를까](https://dev.classmethod.jp/articles/different-from-vpc-peering-and-transit-gateway/)
- [AWS Summit Seoul 2016 - AWS Direct Connect 및 VPN을 이용한 클라우드 아키텍쳐 설계 (Steve Seymour, AWS)](https://www.youtube.com/watch?v=kXLpCCbmIWQ&ab_channel=AmazonWebServicesKorea)
- [KINX와 함께 하는 AWS Direct Connect 도입 - 남시우 매니저(KINX)](https://www.youtube.com/watch?v=8X1g2w-0fvM&ab_channel=AmazonWebServicesKorea)
- [실전! AWS 하이브리드 네트워킹 (AWS Direct Connect 및 VPN 데모 세션) - 강동환, AWS SA:: AWS Summit Online Korea 2020](https://www.youtube.com/watch?v=yMgwrkqfcbg&ab_channel=AmazonWebServicesKorea)