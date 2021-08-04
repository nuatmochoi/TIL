# VPN

- IPSec 네트워크 프로토콜 기반 VPN 연결
- VPN Tunnels은 기본적으로 이중화(되어 있고, TLS 통신이기 때문에 안전하게 통신 가능
- 인터넷 기반이기 때문에 성능, 품질이 전용선보다는 떨어지고, 지연이 생길 수 있다. (Bandwidth와 Latency가 가변적)
- AWS 상에 VPN을 연결하기 위한 Virtual Private Gateway(VGW)가 만들어지고, 해당 VGW와 온프레미스의 CGW(Customer Gateway)가 통신

## AWS Site-to-Site VPN

- AWS 서비스와 IDC를 잇는 VPN
- Site-to-Site VPN은 IPsec VPN 연결을 지원
- 다음 네 가지 요소가 포함됨

  1. 가상 프라이빗 게이트웨이

     ![Virtual Private GW](https://docs.aws.amazon.com/ko_kr/vpn/latest/s2svpn/images/vpn-how-it-works-vgw.png)

  2. 전송 게이트웨이(Transit Gateway)

     ![Transit Gateway](https://docs.aws.amazon.com/ko_kr/vpn/latest/s2svpn/images/vpn-how-it-works-tgw.png)

  3. 고객 게이트웨이 디바이스

     ![CGW device](https://docs.aws.amazon.com/vpn/latest/s2svpn/images/cgw-high-level.png)

     - 고객 게이트웨이를 구성할 때 터널 두 개를 모두 구성하는 것이 중요. 디바이스 장애 시 VPN 두번째 터널로 자동 failover하도록 설정
     - 구성 요소
       - IKE (인터넷 키 교환) : 필수
       - IPsec (IPsec 보안 연결) : 터널의 암호화 처리
       - Tunnel (터널 인터페이스) : 왕복하는 트래픽 수신
       - BGP (Border Gateway Protocol 피어링) : 선택 사항

  4. 고객 게이트웨이

- AWS VPN CloudHub : 다수의 Site-to-Site VPN 연결을 사용할 경우, VPC 뿐만 아니라 사이트 간 서로 통신할 수 있게 함
  - Hub and Spoke 모델 구현에 적합 : 여러 지사가 있고, 원격 지사 간에 기본 연결 또는 백업 연결을 위한 구조
    ![VPN CloudHub](https://docs.aws.amazon.com/ko_kr/vpn/latest/s2svpn/images/AWS_VPN_CloudHub-diagram.png)

## AWS Client VPN

- AWS와 사용자(클라이언트)를 연결하는 VPN
- 로컬 및 모바일 디바이스에서 OpenVPN기반 VPN Client 애플리케이션을 사용하여 VPN 세션을 설정함. VPN 세션 설정 이후 VPC 내 리소스에 접근 가능

  ![Client VPN](https://docs.aws.amazon.com/ko_kr/vpn/latest/clientvpn-admin/images/architecture.png)
