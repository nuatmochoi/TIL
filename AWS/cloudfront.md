# AWS Cloudfront

- CloudWatch는 전 세계적으로 정적, 동적인 웹 컨텐츠, 비디오 스트리밍 및 API를 안전하고 규모에 맞게 제공하는 CDN (Content Dilivery Network) 서비스이다.
- 에지 로케이션이라고 하는 전세계 데이터 센터 네트워크를 통해 콘텐츠 제공
- 에지 서버로 콘텐츠를 캐시하고 제공하면 시청자와 가장 가까운 위치에서 콘텐츠 제공

  - 에지 로케이션에서 컨텐츠를 캐싱함으로써 s3 버킷의 부하를 줄이고, 컨테츠 전달 시 사용자에게 빠른 응답

- CloudFront 기능 : Origin Access Identity (OAI)

  - 해당 컨텐츠에 대한 액세스를 CloudFront 및 해당 작업으로 제한함.

- 악의적 공격 보호 및 안정장치
  - AWS WAF / AWS Shield 통합

## 동영상 스트리밍

- 참조: https://blog.embian.com/123

1. 동영상 시청을 위해 sined cookie 발급하는 API 호출
   (http://docs.aws.amazon.com/ko_kr/AmazonCloudFront/latest/DeveloperGuide/private-content-signed-cookies.html)
2. Signed URL로 비디오 파일 요청
   (http://docs.aws.amazon.com/ko_kr/AmazonCloudFront/latest/DeveloperGuide/private-content-signed-urls.html)

위의 방법을 통해 S3 내의 HLS 파일을 받아와 플레이어에서 재생
(video 태그와 hls.js를 통해 라이브 스트리밍 가능)

## Reference

https://cloud.hosting.kr/techblog_180716_a-match-made-in-the-cloud/
