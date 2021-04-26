# SAM (Serverless Application Model)
SAM template은 CloudFormation 위에서 작동됨

## SAM Commands
1. `sam build` : Lambda 코드를 build하고 Deployment artifact를 만듦. dependancy 설치.
    - `sam build --use-container` : 도커 컨테이너 안에서 패키지 인스톨 및 빌드
2. `sam package` : 코드와 dependency가 포함된 코드를 zip 압축하여 S3에 업로드. SAM template에서 local을 s3 버킷(CodeUri)으로 바꿈으로써 최종 SAM template 생성 
3. `sam deploy` : SAM template으로 스택을 만들고, AWS resource들이 프로비저닝됨

## sam local (로컬 환경에서 테스트)
1. `sam local generate-event` 
2. `sam local invoke`
3. `sam local start-api`
4. `sam local lambda`

## CloudFormation
1. Parameters : 동적인 파라미터 및 AWS SSM parameter store에 저장한 값을 가져올 수 있음
2. Mappings: key값에 따라 미리 value를 정해놓고 사용 가능
3. Conditions : 조건을 만족할 때만 resource 생성하도록
4. Nested stacks : 공통 리소스를 정의한 template을 재사용할 수 있음 (스택 위에 스택이 쌓이도록)

