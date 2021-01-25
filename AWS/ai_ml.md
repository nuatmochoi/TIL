# AWS Sagemaker & AI/ML

- 머신러닝 플랫폼
- 머신러닝을 하려고 한다면, 데이터는 있는지 물어보는 것이 첫째. 모델 자체는 AWS에서 지원을 해주기 때문
- 아마존이 가지고 있는 모델을 사용하고 추론에만 요금이 계산되니까, 데이터만 있으면 설계해줄 수 있다.

## 파이프라인

    1. 데이터 수집
    2. **데이터 탐색** (EDA, 데이터가 퍼포먼스의 한계를 가지는 것 - 오버피팅, 언더피팅)
    3. 데이터 전처리 (**ETL**) (추출 -> 변환 -> 적재) (데이터 웨어하우스를 어떻게 잘 넣을지 -- 하둡?) (JSON --ETL--> S3) (AWS GLUE)
    4. 학습데이터 & 테스트 데이터
        - cross validation (10만 개의 데이터가 있다고 하면 2만개 정도)
    5. 모델링 & 훈련
    6. 모델 평가
    7. 배포 (API)

## AWS AI/ML Stack

- recognition
- mentory (데이터 태깅해주는 팀)
- polly : text to speech
- transcribe : speech to text
- comprehend : 글의 성향 (부정, 긍정)
- textract : 한글 지원 x
- lex : 챗봇
- personalize : 추천 (앙상블은 안된다. 하나의 알고리즘만)
- forecast : 추세 분석 (time series, 시간 기반 추천)
- fraudDetector 이상 징후 탐지
- codeGuru : 코드 품질

## Sagemaker

- sagemaker (빌트인 알고리즘) - 딥러닝 환경 설정(cuda, cudnn, tf) 다 해주고, jupyter(sagemaker notebook)로 환경 제공
- Ground Truth (데이터 정제해주는 것 - 데이터 라벨링)
- ML Marketeplace
- EC2 + GPU < ML Sagemaker (3배 비쌈, but, 빠르고 API 통신 등 편리)
- 클라우드에서 학습하고 경량화 시켜서 장비에 심음 (자율주행 등)
- Sagemaker는 학습 리소스 != 추론 리소스
  - 엔드 포인트 등을 Auto Scaling으로 늘이거나 줄일 수 있음
- Sagemaker - notebook - train - s3 cloudfront
- Sagemaker Studio : sagemaker 모든 기능 포함, 병렬적 구성
