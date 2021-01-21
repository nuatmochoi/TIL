# AWS Cloudfront

- CloudFront는 전 세계적으로 정적, 동적인 웹 컨텐츠, 비디오 스트리밍 및 API를 안전하고 규모에 맞게 제공하는 CDN (Content Dilivery Network) 서비스이다.
- 에지 로케이션이라고 하는 전세계 데이터 센터 네트워크를 통해 콘텐츠 제공
- 에지 서버로 콘텐츠를 캐시하고 제공하면 시청자와 가장 가까운 위치에서 콘텐츠 제공

  - 에지 로케이션에서 컨텐츠를 캐싱함으로써 s3 버킷의 부하를 줄이고, 컨테츠 전달 시 사용자에게 빠른 응답

- CloudFront 기능 : Origin Access Identity (OAI)

  - 해당 컨텐츠에 대한 액세스를 CloudFront 및 해당 작업으로 제한함.

- 악의적 공격 보호 및 안정장치
  - AWS WAF / AWS Shield 통합

## 동영상 스트리밍

MediaConvert를 통해 S3 버킷 내에 hls 포맷으로 전환했다면 다음은
CloudFront를 통해 영상을 배포해야 한다.

1. CloudFront 서비스 접속
2. [Create Distribution] 클릭
3. Web 형식과 RTMP 형식 중에서 고르라고 선택지를 주는데, RTMP 형식 사용하는 것이 아니면 Web 선택. (AWS CloudFront는 2021년부터 RTMP를 지원하지 않는다)
4. 세부 세팅

   - `Origin Domain Name` : 원하는 S3 버킷 선택 -> Origin ID는 자동으로 입력된다.
   - `Viewer Protocol Policy` : HTTP and HTTPS
   - `Allowed HTTP Method` : GET, HEAD
   - `Smooth Streaming` : MS smooth streaming 사용한다면 Yes
   - `Restrict Viewer Access` : 접근 제한을 걸 때 사용하므로 No
   - `Price Class` : 전 세계의 edge를 사용할 지, 특정 리전의 edge를 사용할지.

5. `http://d3kq9c1qyaz6nw.cloudfront.net/test.m3u8` 혹은 내부에 폴더가 존재한다면
   `http://d3kq9c1qyaz6nw.cloudfront.net/Test/Default/HLS/test.m3u8` 과 같은 형식으로 CDN에 접근할 수 있다.

6. video.js를 이용하여 hls에 접근할 수 있다.

```html
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>Document</title>
		<link
			href="https://unpkg.com/video.js/dist/video-js.css"
			rel="stylesheet"
		/>
	</head>
	<body>
		<video
			id="my_video_2"
			class="video-js vjs-default-skin"
			controls
			preload="auto"
			width="640"
			height="360"
			data-setup="{}"
		>
			<source
				src="http://d2d8kokzpr29em.cloudfront.net/test/Default/HLS/test.m3u8"
				type="application/x-mpegURL"
			/>
		</video>

		<script src="https://vjs.zencdn.net/7.2.3/video.js"></script>
		<script
			src="https://cdnjs.cloudflare.com/ajax/libs/videojs-contrib-media-sources/4.7.2/videojs-contrib-media-sources.min.js"
			integrity="sha512-utkFvaMvnpseOQ/4m1+/2zKYNh5r/FHUs5XZAds52wXbfMgeHvHg/3PFnou6DME2U7F2OkcPSM0AWQdYdPKAKg=="
			crossorigin="anonymous"
		></script>
	</body>
	-->
</html>
```
