# Amazon Pinpoint

- 이메일, 앱 푸시알림, SMS 문자 및 음성 메시지를 보낼 수 있는 서비스
  - [이외의 채널로는 AWS Lambda를 사용](https://docs.aws.amazon.com/ko_kr/pinpoint/latest/developerguide/channels-custom.html)하도록 권고하고 있음
- 마케팅 라이프사이클 관리
  - 홍보 및 거래 메시지(구매 영수증) 전달
- 고객 참여 및 활동(구매 등) 활동, 선호도 등 사용자 행동을 확인할 수 있는 분석 제공
  - 외부에서 분석 및 저장하려면 [Pinpoint 데이터를 Amazon Kinesis로 스트리밍 필요](https://docs.aws.amazon.com/ko_kr/pinpoint/latest/developerguide/event-streams.html)
    - 콘솔에서 [설정]-[이벤트스트림]에서 Kinesis Data Streams 및 Firehose로 스트리밍 활성화 가능하며 cli 및 sdk도 지원 중
- 콘텐츠 및 채널, 참여 시기에 관한 예측을 생성해줌
- 서울 리전에는 아직 SMS 기능은 추가되지 않음 (이메일, 앱 푸시알림만 가능)

## Email

- 보내기 전에 송신자 및 수신자 이메일의 자격 증명 과정이 필수적
  - email verification 과정 이후 활성화 가능
  - 24시간 동안 최대 200개의 메시지, 초당 최대 1개의 메시지를 보낼 수 있으며 할당량 증가 요청으로 제한 풀 수 있음
- 와일드 카드 로컬 부분 표기법 지원 (ex> `fred@domainfred+foo@domain`)
- Pinpoint 수신자가 열었거나 클릭한 이메일을 자동으로 추적
  - AWS Server에서 호스팅되는 이미지를 이메일 끝에 추가
  - 이메일의 모든 링크를 AWS에서 호스팅하는 도메인을 참조하는 링크로 구성함
    - AWS 호스팅 도메인 전송 이후 목적 위치로 리디렉션됨
- SMS 문자는 SNS와 거의 동일

## 푸시알림

- 자격 증명 필요 (APN, FCM 등)
- 기본적으로 초당 25,000개의 메시지 발송 가능하면 할당량 증가 요청 가능

## 세그먼트

- 운영체제 및 모바일 유형과 같은 데이터 기반으로 **동적 세그먼트** 정의 가능
  - 특정 속성값이 같은지/크거나 작은지/값들의 사이인지 비교를 통해서 동적으로 변경 가능
- 아래와 같은 csv 및 json 파일을 가져와서 세그먼트 생성 가능 (정적)
  ```csv
  ChannelType,Address,User.UserId,User.UserAttributes.FirstName,User.UserAttributes.LastName,User.UserAttributes.age,User.UserAttributes.isActive
  EMAIL,Raymond+pinpoint1@emaildomain.com,userid1,Raymond,Phillips,35,TRUE
  EMAIL,Sue+pinpoint2@emaildomain.com,userid2,Sue,Sherman,31,FALSE
  EMAIL,Mark+pinpoint3@emaildomain.com,userid3,Mark,Price,28,
  ```
- 세그먼트 가져오기 외에 위 csv 예시(이전에 업로드한 사용자의 열 참조)의 `isActive` 속성을 활용하여 활성/비활성 사용자에 대해 세그먼트 분류 가능

## 메시징 캠페인

- 세그먼트 단위별로 지정해서 메시지를 보낼 수 있음
- 시점 선택 가능
  - 특정 시간
    - 즉시, 한번, 매시간, 매일, 매주, 매월
  - 이벤트 발생 시
  - 고객이 불편한 시간에 메시지 보낼 수 없도록 전송 중단 시간 설정 가능
- 메시지 템플릿 사용 가능
  - 개인화된 콘텐츠 명시 가능 (ex> `Hi {{User.UserAttributes.FirstName}}, congratulations on your new {{User.UserAttributes.Activity}} record of {{User.UserAttributes.PersonalRecord}}!`)
  - [개인화된 콘텐츠 추가](https://docs.aws.amazon.com/pinpoint/latest/userguide/message-templates-personalizing.html)
  - 버저닝 가능

## 여정(Journey)

- 특정 고객 세그먼트로부터 시작해서 메시지를 보내거나 행동에 따라 그룹핑을하는 activity를 추가하는 여정을 생성할 수 있음
  <img src="https://pinpoint-jumpstart.workshop.aws/images/aJourneyFull.png" width=500 height=500>
- 여정의 시작 및 종료 시간을 지정할 수 있음
- `multivalidate split` 분기로 이메일 클릭/ 이메일 오픈 / 수신 거부 등의 분기 처리 가능
- 비활성화 유저 독촉 : `Yes/no split`을 통해 특정 로직이 지나간 후에 기존 세그먼트의 유저가 그대로 남아 있는지 확인 가능 (동일 세그먼트로 조건 평가를 추가하면 됨)
- 시작 이후 각 분기별 지표 확인 가능

## Pinpoint vs SES

- 많은 수의 트랜잭션 이메일을 보내는 경우 SES가 유리

## Reference

- [Pinpoint Workshop](https://pinpoint-jumpstart.workshop.aws/en/)

특장점 및 타 서비스간 비교 필요
