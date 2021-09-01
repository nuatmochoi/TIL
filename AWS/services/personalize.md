## AWS Personalize

- Personalize는 S3에 있는 csv 파일만 데이터를 읽을 수 있음

  - 해당 작업을 위해 AWS Glue DataBrew를 사용한다.

- Recipe : 알고리즘을 뜻함
- Event Tracker : kinesis 등 흘러들어오는 데이터를 받아서 보관, 해당 데이터들은 쌓여서 추천에 반영이 되게 됨

- 배치 추천 : 자주 바뀌지 않는 추천 아이템 요구사항에 주로 사용. 미리 만들어 놓는 추천 리스트.
