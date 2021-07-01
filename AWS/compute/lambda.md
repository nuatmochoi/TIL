# AWS Lambda

- EC2에서는 컴퓨터 한 대를 인스턴스, S3에서는 버킷, Lambda에서는 함수라고 부름
- Serverless 제품
- 서버 프로비저닝 및 관리 없이 코드 실행
- 사용량에 따라 지속적으로 백엔드에서 규모가 자동으로 지정되기 때문에 Scaling을 신경쓸 필요가 없다.
- 높은 가용성 및 자동 복구
- 1초에서 최대 15분(900초) 동안 실행하도록 함수를 구성할 수 있게 되어 있다.
  - 900초의 제한시간이 부족한 경우에 AWS Step Functions의 사용이 고려될 수 있다. Step Functions을 통해 Lambda Function을 결합(lambda에서 lambda 호출)할 수 있다.

## 작동법

1. 함수 생성
2. 새로 작성
   - 함수 이름
   - 런타임 : 어떤 언어로 할 것인지
   - NodeJS를 사용할 경우에 npm module을 포함하기 위해서 `handler` 함수가 포함된 `index.js`과 `node_modules` 을 ZIP파일로 묶어서 업로드하면 된다.

```py
def lambda_handler(event, context):
    return
```

- lambda_handler는 약속된 이름의 함수. 람다를 실행했을 때 이 함수가 실행되도록 약속되어 있음.
- save하고 Deploy 버튼을 눌러야 실행 가능한 상태가 된다.
- 지원하지 않는 라이브러리라면 layer에 zip 파일로 업로드해야만 한다.

### 콘솔에서 테스트

테스트 이벤트 선택(실행될 때 어떠한 값을 입력할 것인지) -> 테스트 이벤트 구성 -> 이름 입력 -> 생성 -> 테스트 -> 함수 실행

### 입력값

- 테스트 이벤트 선택 -> 테스트 이벤트 구성 -> json `{key: value}` 형태로 입력값 입력 -> 생성
- lambda_handler의 `event` parameter로 들어간다.

### 디버깅

- `CloudWatch`에서 lambda 함수에 대한 로그를 확인할 수 있다.
- 코드를 수정하면 새로운 log 스트림 안에 쌓이게 된다.

## 트리거

- 다른 AWS 서비스(API 게이트웨이, DynamoDB, S3 등)와 연동되기 때문에 Lambda가 사용되는 것.
- Trigger를 통해서 다른 서비스에서 변화가 생겼을 때 람다를 실행할 수 있다.
- 데이터 변화, 직접 또는 endpoint 호출, 리소스 상태 변화, CloudWatch 알람(CloudWatch Event Rule), Cron 주기별
- IAM ROLE을 다르게 설정하더라도 동일한 트리거에 대해 여러 개의 Lambda 함수를 연결할 수 없다.

### S3와 연동

1. 트리거에 Bucket 지정 + 모든 객체 이벤트 유형(PUT, COPY 등) + 재귀호출
2. S3의 속성에 이벤트 알림에 Lambda 함수 추가된 것 확인
3. S3로 파일을 업로드
4. CloudWatch에서 S3에서 Lambda로 전달한 event값 확인할 수 있음
5. 테스트 이벤트 구성에 들어가서 해당 event값 붙여넣기 (json 형식을 지키기 위해서 작은따옴표를 큰따옴표로 변경 - [JSON formatter & validator](https://jsonformatter.curiousconcept.com/))
6. 필요한 값 접근

### 실행 모델

- 동기식 : Amazon API Gateway
- 비동기식 : SNS, CloudWatch, S3
- Stream-based : Kinesis, DynamoDB

## 성능

기본 설정에서 메모리 용량(최대: 10GB) 높일 수 있고, 메모리에 비례하여 더 좋은 CPU가 할당된다.

## 가격정책

- 함수 요청 수와 기간에 따라 요금 청구
- Lambda는 프리티어 무기한으로 제공. 프리티어는 월별 무료 요청 1백만 건 & 월별 400,000GB-초 컴퓨팅 시간
- 초과가 될 경우 요청 백만 건당 0.20 USD
- 1GB를 0.1초만큼 썻을 때 0.0000016667 USD
- 요금 예제
  - 512MB 메모리, 1달에 3,000,000회 실행, 매번 1초간 실행 시 : 18.34 USD
  - 128MB 메모리, 1달에 30,000,000회 실행, 매번 200ms 실행 시 : 11.63 USD

## Cold Start vs Warm Start

- Lambda Function이 일정 기간 이상 실행되지 않을 경우 Stand-by 중인 컨테이너가 하나도 남지 않게 되어 호출 시 소요 시간이 증가됨 (Cold Start)
- CloudWatch Time-based Event를 통해 주기적으로 Lambda Function을 실행하면, Lambda Function이 실행된 컨테이너가 항상 백엔드에 존재하게 되기 때문에 Cold Start를 방지할 수 있다.

## Common issues and troubleshooting

### 실행이 안될 때 or 함수가 실패

- CloudWatch log에 에러 확인
- 이벤트 소스에서 lambda를 실행할 수 있는 function이 있는지 확인

### 함수 실행이 너무 오래 걸린다면

- Cold Start - 여러 번 실행해보고 비교
- 메모리 확장하여 시도 - CloudWatch log로 확인
- 비효율적 작성 코드 - 로컬 테스트
- Third Party, Dependency 시간 소요 - X-ray로 어떤 엔드포인트에서 얼마나 시간을 소요했는지 파악 가능

### 스로틀링

- 리전별 1000개로 동시 실행 갯수 제한
- 동기식 호출 스로틀링 : 429 에러
- 비동기식 호출 스로틀링 : 6시간 동안 호출 재시도
- 스트림 기반 : 최대 7일간 호출 재시도

### Schedule 설정이 제대로 동작하지 않는 경우

- CRON Expression 확인 (대한민국 표준시가 아니라 UTC 시간으로 되었는지)
- Second level of precision을 지원하지 않음 (Lambda Function이 매일 23:00 UTC에 실행되도록 설정했다면, 23:00:00부터 23:00:59 사이에 실행된다)
- 초단위 정밀 작업이 필요하다면 EC2, ECS를 사용하는 것을 추천

## Lambda @Edge

- 초당 최대 10,000개의 Request만 처리 가능

## Reference

- [AWS Lambda 자세히 살펴보기 - 조성열 시스템 엔지니어(AWS Managed Services)](https://www.youtube.com/watch?v=I_HuqdIXHEg)
- [0.1초 동안 컴퓨터를 빌려보자 - AWS Lambda](https://www.youtube.com/watch?v=t8sjTFM_tfE&fbclid=IwAR1m35LHhEoMMgcCKEjaGs-KJ04M2v-wuE1AuqC0OQLWpgoGOfyf3Md5aFk)
