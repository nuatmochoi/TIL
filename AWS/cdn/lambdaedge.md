# Lambda@Edge를 통한 A/B testing

- 원본 A,B가 있고, 하나의 CloudFront를 통해서 A/B 테스팅을 하기 위해서는 Lambda@Edge 및 Cookie 필요
- 만약 원본 B를 보기를 원하는데 Cache Hit이 일어나 A를 반환한다면? TTL=0 으로 지정하는 것은 side effect 야기

![LambdaEdge](https://miro.medium.com/max/590/1*gl_lWwQj2LUBIV_r-rZyig.png)

1. Viewer Request에서 Cookie가 있는지 체킹하고, 없으면 Random하게 A/B 중에서 Cookie를 생성함
2. Cache miss 일 때 Origin Request에서 source cookie에 따라 정해진 origin을 찾아서 들어감


 
