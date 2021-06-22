# Cloudwatch

## 구독 필터

- Kinesis, Lambda에서 CloudWatch Logs에 대한 구독 필터를 사용 가능 (람다에서 트리거로 사용 가능)
- 구독 필터를 통해 서비스로 전송되는 로그는 Gzip 형식으로 Base64 인코딩 & 압축됨

```js
var zlib = require('zlib');
exports.handler = function (input, context) {
	var payload = Buffer.from(input.awslogs.data, 'base64');
	zlib.gunzip(payload, function (e, result) {
		if (e) {
			context.fail(e);
		} else {
			result = JSON.parse(result.toString('ascii'));
			console.log('Event Data:', JSON.stringify(result, null, 2));
			context.succeed();
		}
	});
};
```

함수 실행 결과로 cloudwatch logs가 json으로 변경된 값이 반환된다.

## 지표 수식

- CloudWatch 지표를 쿼리하고, 수식을 사용하여 지표에 기반한 새로운 시계열을 만들고 metric 일치를 비교하여 CloudWatch Alert을 생성할 수 있음
- ex> HTTP 403 Forbedded 응답 수가 전체 api 호출의 2% 초과 : `(Custom403Error/Count)*100 >= 2`

## Reference

- [SubscriptionFilters](https://docs.aws.amazon.com/ko_kr/AmazonCloudWatch/latest/logs/SubscriptionFilters.html)
