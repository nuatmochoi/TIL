# Kinesis 

## Kinesis Streams
- 생산자 (PUT)
- 소비자 (GET)

## Kinesis Firehose
- 샤드/ 프로비저닝/ 파티션키 없음
- 버퍼링 떄문에 실시간성이 떨어짐(1~128MB, 60~900초)

## Kinesis Analysis
- 표준 SQL 쿼리를 작성하면 초단위로 수행 가능
