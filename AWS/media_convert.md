# How to use MediaConvert & Lambda & S3

1.  인풋 s3 버킷 생성
2.  아웃풋 파일을 담을 s3 버킷 생성
3.  s3의 [속성] 탭에 들어가서 **정적 웹 사이트 호스팅** 활성화 (박스에 index.html 추가)
4.  [권한] 탭에서 **모든 퍼블릭 액세스 차단** 해제
5.  CORS 구성에 들어가서 다음 내용 추가

    ```json
    [
    	{
    		"AllowedHeaders": ["*"],
    		"AllowedMethods": ["PUT", "POST", "DELETE"],
    		"AllowedOrigins": ["http://www.example1.com"],
    		"ExposeHeaders": []
    	},
    	{
    		"AllowedHeaders": ["*"],
    		"AllowedMethods": ["PUT", "POST", "DELETE"],
    		"AllowedOrigins": ["http://www.example2.com"],
    		"ExposeHeaders": []
    	},
    	{
    		"AllowedHeaders": [],
    		"AllowedMethods": ["GET"],
    		"AllowedOrigins": ["*"],
    		"ExposeHeaders": []
    	}
    ]
    ```

6.  MediaConvert를 경유하기 위한 IAM Role 설정

    - IAM 서비스 접속
    - [역할 생성] 클릭
    - MediaConvert 클릭하고 [다음:검토] 나올 때까지 넘어가기
    - 이름에 MediaConvertRole 입력
    - [역할 생성] 클릭
    - [요약] 들어가서 ARN 값 저장해놓기 (다음 단계에 사용)

7.  Lambda를 위한 IAM Role 설정

- VODLambdaRole이란 이름으로 IAM 역할 생성 / 역할 타입은 AWS Lambda
- AWSLambdaBasicExecutionRole 정책을 attach (for CloudWatch logs permission) - [권한] 탭에서 [인라인 정책 추가] - [Json] 탭 클릭
- 다음 내용 추가 하고 Resource 부분을 지우고 아까 저장했던 ARN 값으로 대체
  ```json
  {
  	"Version": "2012-10-17",
  	"Statement": [
  		{
  			"Action": [
  				"logs:CreateLogGroup",
  				"logs:CreateLogStream",
  				"logs:PutLogEvents"
  			],
  			"Resource": "*",
  			"Effect": "Allow",
  			"Sid": "Logging"
  		},
  		{
  			"Action": ["iam:PassRole"],
  			"Resource": ["ARNforMediaConvertRole"],
  			"Effect": "Allow",
  			"Sid": "PassRole"
  		},
  		{
  			"Action": ["mediaconvert:*"],
  			"Resource": ["*"],
  			"Effect": "Allow",
  			"Sid": "MediaConvertService"
  		},
  		{
  			"Action": ["s3:*"],
  			"Resource": ["*"],
  			"Effect": "Allow",
  			"Sid": "S3Service"
  		}
  	]
  }
  ```

8. 비디오 변환을 위한 Lambda 함수 작성

   - [Lambda 함수 생성] 클릭
   - Name에 VODLambdaConvert 입력
   - Python 3.8 입력
   - Role을 [기존 역할 선택] 누른 후 VODLambdaConvertRole 선택
   - [job.json](https://github.com/aws-samples/aws-media-services-vod-automation/blob/master/MediaConvert-WorkflowWatchFolderAndNotification/job.json) 과 [convert.py](https://github.com/aws-samples/aws-media-services-vod-automation/blob/master/MediaConvert-WorkflowWatchFolderAndNotification/convert.py)를 다운 받아 zip으로 압축
   - 함수에서 Configuration 탭에 들어가 [zip 파일 업로드] 선택
   - 압축 파일을 업로드하고, handler를 _convert.handler_ 로 수정
   - 환경 변수를 다음과 같이 입력
     - Destination = `<input bucket name>`
     - MediaConvertRole = `arn:aws:iam::ACCOUNT NUMBER:role/MediaConvertRole`
     - Application = VOD

9. Lambda 함수 테스트 - test 이벤트에 다음 json 파일 추가

   ```json
   {
   	"Records": [
   		{
   			"eventVersion": "2.0",
   			"eventTime": "2017-08-08T00:19:56.995Z",
   			"requestParameters": { "sourceIPAddress": "54.240.197.233" },
   			"s3": {
   				"configurationId": "90bf2f16-1bdf-4de8-bc24-b4bb5cffd5b2",
   				"object": {
   					"eTag": "2fb17542d1a80a7cf3f7643da90cc6f4-18",
   					"key": "vodconsole/TRAILER.mp4",
   					"sequencer": "005989030743D59111",
   					"size": 143005084
   				},
   				"bucket": {
   					"ownerIdentity": { "principalId": "" },
   					"name": "rodeolabz-us-west-2",
   					"arn": "arn:aws:s3:::rodeolabz-us-west-2"
   				},
   				"s3SchemaVersion": "1.0"
   			},
   			"responseElements": {
   				"x-amz-id-2": "K5eJLBzGn/9NDdPu6u3c9NcwGKNklZyY5ArO9QmGa/t6VH2HfUHHhPuwz2zH1Lz4",
   				"x-amz-request-id": "E68D073BC46031E2"
   			},
   			"awsRegion": "us-west-2",
   			"eventName": "ObjectCreated:CompleteMultipartUpload",
   			"userIdentity": { "principalId": "" },
   			"eventSource": "aws:s3"
   		}
   	]
   }
   ```

   - save이후 test를 눌렀을 때 200값이 반환되면 성공적으로 세팅됨

10. Lambda 함수에 input S3 bucket을 트리거로 설정
    - trigger를 눌러 input S3 bucket을 연동하면 되며
    - prefix에 `inputs/` 등을 입력하여 입력 폴더를 지정할 수도 있다.
    - 해당 s3 버킷에 영상을 업로드했을 때 output 버킷에 변환된 영상 디렉토리가 생성되면 성공적으로 MediaConvert가 작동 된 것임. `CloudWatch`와 `MediaConvert`의 Job list에서도 성공적으로 실행된 것을 확인 할 수 있다.
