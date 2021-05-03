# Terraform

## Terraform
- Resource : 생성할 인프라 자원
- Provider : 테라폼으로 정의할 Infrastructure Provider (aws, azure, gcp)
- Output : 프로비저닝 후 생성된 자원
- Backend : 테라폼의 상태를 저장하는 공간 (협업)
- Module : 함수. 코드 재사용에 사용
- Remote State : 서로 다른 코드에서 저장된 변수를 가져오고 싶을 때 사용

## HCL Syntax 
```
variable "aws_region" {
    description = "AWS region"
    default = "ap-northeast-2"
}

provider "aws" {
    region = var.aws_region
}
```

- Ver 0.12 이후 `$` 문법 비적용
- 반복문 : count
- user_data로 ad-hoc 스크립트 삽입 및 타 코드 참조 가능

## Terraform Command
- init : 지정한 backend에 상태저장을 위한 .tfstate 파일 생성(가장 마지막의 테라폼 내역 저장)
- plan : 코드가 어떻게 생성되는지 예측 결과를 보여줌 (형상에 변화주지 않음)
- apply : 실제 인프라 배포 (`-auto-approve` : yes 명령어 없이 완전 자동화, 권장되지 않음)
- destroy : 인프라 리소스 회수
- state list : 테라폼 코드로 생성된 인프라 목록 확인

## 협업

### Terraform Backend
- `ls -al | grep ".tfstate"` : 로컬에서 확인
- 백엔드를 s3로 지정하여 팀 협업 가능

## 테라폼의 3가지 형상
1. Local code : 개발자 machine base
2. provider에 배포된 인프라 : 실제로 배포된 인프라
3. Backend에 저장된 상태 : 가장 최근에 배포한 terraform 코드

- 세 형상을 항상 동일하게 유지하는 것이 terraform의 요지. 
- 2,3의 다른 형상을 `import` 명령어로 동일하게 유지 가능
    - 형상에 따른 코드가 자동으로 생성되는 것은 아님. 1번은 동일하지 않음
    - `Terraforming` : 루비 기반 오픈소스. 실제 배포된 형상 인프라에 대한 코드를 던져줌

## Terraform Directory Structure
- 환경별 상태 분리
- Component 수준 분리 : VPC, 서비스, DB별 분리
- File Layout : mgmt, global, services
- 구성 파일 명명 규칙 : `vars.tf` `outputs.tf` `main.tf`
- 테라폼 Config File
    - `init.tf` : provider.tf, backend.tf 등 초기 환경 구성에 필요
    - `variables.tf` : 구성 모듈에서 사용하는 변수 선언 (cli에서 입력값을 주지 않으면 default이 들어감)
    - `.tfvars` : 사용할 리소스에 대한 변수값을 미리 정의 (variables.tf)
- Terraform Module : 코드 작성 -> 재사용할 위치에서 Module 코드 작성 -> terraform get(모듈 수정마다 변경 사항 동기화, `plan` 전에 사용) 
