# VPC

사용자 지정된 가상의 네트워크 환경이다. 논리적으로 격리되어 있는 공간이다.
리전을 선택하고, 원하는 IP range를 가장 먼저 설정한다.
가용영역 단위로 서브넷을 생성하고, 서브넷의 목적에 따라 라우팅 테이블과 연결한다.

## 서브넷

서브넷의 종류에는 크게 Public Subnet과 Private Subnet이 있다.

- Public Subnet : Internet Gateway와 연결된 서브넷
- Private Subdnet : Internet Gateway와 연결되지 않은 서브넷. 펌웨어 패치 등을 위해 NAT Gateway와 연결되어 있다.

## CIDR

서브넷 마스크의크기는 /16 ~ /28 사이이다.

- /16 : 16bit의 CIDR을 사용하면 B클래스와 동일하게 네트워크 할당 (16 비트 네트워크 아이디 + 16비트 호스트 아이디 => 2^16 == 65536개 IP range 사용 가능)
- /24 : 16bit 네트워크 아이디 + 8비트 서브넷 아이디 + 8비트 호스트 아이디 => 2^8 == 251개 (나머지 5개는 예약 IP)의 IP range 사용 가능

## NACL & Security Group

NACL 및 보안그룹은 규칙에 URL을 포함할 수 없으며, 경로도 포함하지 않음.

- NACL (Network aces control list)
  - 서브넷 단위 인바운드(수신), 아웃바운드(송신) 허용/거부 규칙
  - 서브넷으로 들어오려는 모든 인터넷 패킷은 NACL을 거치고, 패킷의 permission을 판단
  - Stateless (인바운드, 아웃바운드 주소/포트를 모두 선언해야 힘)
  - 기본 NACL은 모든 인바운드 및 아웃바운드 트래픽 허용. 명시적으로 연결하지 않았다면 기본 NACL과 암시적 연결
  - 서브넷당 1개의 NACL만 할당 가능
- Security Group
  - 인스턴스 단위 인바운드(수신), 아웃바운드(송신) 허용 규칙
  - 같은 서브넷 내에서, 허용되는 IP를 제외하고 block
  - Stateful (인바인드가 허용이면, 아웃바운드는 자동으로 허용)
  - 인스턴스에 5개의 보안 그룹 할당 가능, 각 보안 그룹은 60개의 규칙 할당 가능
  - 기본적으로 모든 송신(아웃바운드) 허용, 모든 수신(인비운드)

## 고가용성

- 두 번째 서브넷을 만들고, Auto Scaling을 사용해 새 리소스가 두 번째 서브넷으로 자동 시작되게 할 수 있음
- ALB는 서브넷의 엔드 포인트 간 로드를 분산할 수 있음 (A/B 테스트 및 블루/그린 배포 가능)
- 별도의 가용 영역(AZ)에 두 번째 서브넷을 유지함으로써, 한 AZ의 리소스를 사용할 수 없더라도 다른 AZ에서 사용 가능 (다중 AZ)
- 새 서브넷에서 라우팅 테이블을 따로 생성하지 않고, 이전에 생성한 라우팅 테이블과 연결
- ELB는 연결된 리소스에 상태 체크를 하여 장애 조치를 처리함

## VPC 흐름 로그

- VPC 네트워크 인터페이스에서 송수신되는 IP 트래픽 정보를 캡처하는 기능
- VPC, Subnet, ENI 단위로 흐름 로그 설정 가능
- VPC 흐름 로그 설정 이후에 Cloudwatch 및 S3에서 확인할 수 있음
- 지나치게 제한적인 보안그룹 규칙 개선에 사용
- 인스턴스에 도달하는 트래픽 모니터링
- 네트워크 인터페이스에서 들어오고 나가는 트래픽 방향 결정에 도움
- 실시간이 아니며(1분 or 10분), 정렬되어 있지 않음

## Egress Only Internet Gateway(송신 전용 IGW)

- VPC의 인스턴스에서 인터넷으로 IPv6를 통한 아웃 바운드 통신을 허용
- IPv4를 통한 아웃 바운드 전용 인터넷 통신은 = NAT Gateway
- VPC에 Egress Only IGW를 생성한 다음, 라우팅 테이블에 `::/0` 경로 추가

## Carrier Gateway

- SKT 등 통신사업자 네트워크로의 인/아웃바운드 허용 제어
- wavelength Zone에 서브넷을 포함하는 VPC에만 사용
- 5G 구축에 사용되며 초저지연 애플리케이션 구축 가능

## VPC Endpoint & PrivateLink

- VPC Endpoint를 통해 IGW, NAT, VPN, DX 연결 없이도 PrivateLink를 지원하는 서비스와 VPC Endpoint에 비공개로 연결 가능

### Gateway VPC Endpoint

- S3 및 DynamoDB에 대한 연결 액세스 포인트
- Routing Table에서 대상으로 경로 지정 (s3 경우	pl-78a54011과 같이 예약된 접두사명이 존재)

![S3 Endpoint](https://docs.aws.amazon.com/ko_kr/vpc/latest/privatelink/images/vpc-endpoint-s3-diagram.png)

### Interface VPC Endpoint (AWS PrivateLink)

- AWS 서비스 및 엔드포인트 서비스(VPC에서 호스팅되고 있는 서비스) & AWS Marktetplace 서비스에 대해 PrivateLink로 연결 지원
- DX를 타고 S3로 다이렉트로 연결하기 위한 목적으로도 사용됨
- ENI를 기반으로 Private IP를 생성하여 연결
<p><img src="https://docs.aws.amazon.com/ko_kr/vpc/latest/privatelink/images/vpc-endpoint-kinesis-diagram.png" width=300><img src="https://docs.aws.amazon.com/ko_kr/vpc/latest/privatelink/images/vpc-endpoint-kinesis-private-dns-diagram.png" width=300>

### Gateway Load Balancer EndPoint (AWS PrivateLink)

- VPC 경계 간 트래픽 안전하게 교환
- 트래픽을 가로채고 보안 검사 등을 위해 [Gateway Load Balancer](https://docs.aws.amazon.com/ko_kr/elasticloadbalancing/latest/gateway/introduction.html)로 라우팅할 수 있음

## 3-Tier VPC

Single Tier VPC는 모든 것을 하나의 서브넷에 넣기 떄문에 보안에 취약 (개인 블로그나 웹 사이트 등의 애플리케이션의 경우에는 비용 효율적일 수 있다.)

- NAT, ELB (Public Subnet) : 들어오는 트래픽 (ALB), 나가는 트래픽(NAT)
  - 가장 적게 IP가 필요 (ex> /22)
- App (Private Subnet)
  - 가장 많은 IP가 필요 (ex> /20)
- Data (Private Subnet)

  - 퍼블릭보다는 많이 필요하지만, App에 비해서는 적게 (ex> /21)

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

## Reference

- [VPC Peering과 Transit Gateway 어떻게 다를까](https://dev.classmethod.jp/articles/different-from-vpc-peering-and-transit-gateway/)
