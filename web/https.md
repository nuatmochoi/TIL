## HTTPS

- HTTP의 보안버전이다. 웹사이트 사용자가 인터넷을 통해 신용카드 번호, 은행 정보 및 로그인 자격 증명과 같은 중요한
  데이터를 안전하게 전송할 수 있다.
- 암호화, 인증, 무결성을 보장한다.

## TLS

- SSL은 TLS의 이전 버전 암호화 프로토콜
- 인터넷을 통한 통신에서 보안을 확보하기 위해 송수신자가 서로 신뢰할 수 있는 자임을 확인함과 동시에, 통신 내용이 제3자에 의해 도청되는 것 방지

### TLS Handshake

- 기본적으로 TLS 프로토콜은 클라이언트에 대해 서버가 자신을 인증하면 되는 방식

![TLS Handshake](https://images.ctfassets.net/slt3lc6tev37/3wZIhjRIjfVSmCbVqkBKzb/4a7aa34324108c725dc25fc9e7c4ea4a/tls-ssl-handshake.png)

1. 클라이언트가 서버에 연결
2. 서버가 TLS 인증서를 제공
3. 클라이언트가 서버 인증서를 확인
4. 클라이언트와 서버가 TLS 연결을 통해 정보 교환

### Mutual TLS

- TLS 프로토콜은 추가적으로 서버인증 뿐만 아니라 클라이언트가 자신을 인증하도록 서버에서 요청하는 기능을 제공함
- 보안이 좀 더 까다로운 B2B에서 더 많이 사용되며, Iot 기기와 같이 로그인 프로세스를 따르지 않는 경우에도 사용됨

1. 클라이언트가 서버에 연결
2. 서버가 TLS 인증서를 제공
3. 클라이언트가 서버 인증서를 확인
4. <span style="color:yellow">클라이언트가 TLS 인증서를 제시</span>
5. <span style="color:yellow">서버가 클라이언트 인증서를 확인</span>
6. <span style="color:yellow">서버가 액세스 권한 부여</span>
7. 클라이언트와 서버가 TLS 연결을 통해 정보 교환
