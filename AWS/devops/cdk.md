# AWS CDK

1.  cdk synth : AWS CDK 애플리케이션을 CloudFormation 템플릿으로 컴파일
2.  cdk bootstrap : AWS 환경에 CDK Toolkit을 위한 스택을 배포 (처음 CDK 스택을 deploy한다면 필요한 사전 작업)

    - `but no credentials have been configured` 에러가 뜬다면, `aws configure`을 통해 `access key ID`, `Secret access key` 및 `region`을 설정해주는 작업이 필요하다.
    - 구성 확인

      - vi ~/.aws/credential

        ```
        [default]
        region = us-east-1
        aws_access_key_id = *****
        aws_secret_access_key = *****
        [project1]
        aws_access_key_id = *****
        aws_secret_access_key = *****
        ```

      - vi ~/.aws/config
        ```
        [default]
        region = us-east-1
        output=json
        [profile project1]
        region = us-east-1
        output = text
        ```

    - 형식 :`cdk bootstrap --profile [switched_account]`

            Ex> cdk bootstrap --profile project1

3.  cdk deploy : CloudFormation을 통해 프로덕션에 AWS CDK 애플리케이션을 배포

    - 형식 : `cdk deploy [stack_name] --profile [switched_account]`
    - stack_name의 유무에 따라 달라짐. 빈칸이면 해당 디렉토리의 모든 stack을 deploy. 적게 된다면 특정 stack만을 deploy

            Ex> cdk deploy --profile project1

4.  cdk destroy : 스택 삭제
