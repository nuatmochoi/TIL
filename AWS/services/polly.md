# Polly
- Text-to-Speech 서비스
- 한국어를 지원하지만, 영어에서 지원하는 기능이 없는 등 제한적
- 변환된 음성을 S3로 전달 가능

## English
- 엔진은 두 개가 존재 : Standard, Neural
    - 2019년 7월에 Neural이 추가
    - NTTS(Neural Text-To-Speech) 엔진은 기계 학습 방식을 바꾸어 음성 품질이 Standard보다 좋음
    - NTTS는 English(UK, US)에만 적용 가능
- 5명의 여자 보이스, 4명의 남자 보이스 종류 선택 가능

## Korean
- Standard 엔진만 사용 가능
- 보이스 종류는 여성 1명만 가능

## SSML
- SSML (Speech Synthesis Markup Language) 태그 사용으로 음성이 자연스럽게 들리게 함
- 성명, 사용자 ID 등을 강조해서 읽을 수 있으며 (ex: `<prosody rate="75%">`)
- 주문번호를 각각의 숫자로 읽을 수 있게 함 (ex: `<say-as interpret-as="digits">`)
- 뉴스 스타일로 읽을 수 있게함 (ex: `<amazon:domain name="news">`)
    - NTTS 엔진 기반으로 작동하기 때문에, English만 해당됨
