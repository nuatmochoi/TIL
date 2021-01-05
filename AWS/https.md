# AWS서비스 활용하여 HTTPS 배포하기

1. 프로젝트 구현
2. S3 버킷 올린 이후 정적 웹 사이트 호스팅 활성화
3. Freenom에서 도메인 구입
4. ACM에서 SSL 인증서 발급

   - 인증서 프로비저닝 - 공인 인증서 요청
   - 도메인 이름 추가 (ex> www.example.com, \*.example.com)
   - DNS 검증 클릭
   - 인증서를 클릭하여 [Route 53에서 레코드 생성] 클릭

5. CloudFront를 통해 SSL 인증서 연결
6. Route53을 통해 도메인과 연결
