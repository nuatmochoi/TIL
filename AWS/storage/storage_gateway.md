## Storage Gateway

- S3가 File System 기반이 아닌 Object 기반이며, REST/HTTP 기반 통신이기 때문에 속도/사용성에서 불편함 존재
  - iSCSI 방식을 지원해주는 것이 Storage Gateway
    - 대부분의 백업 솔루션이 iSCSI 방식을 지원하기 떄문에, 기존 온프레미스 환경의 백업 솔루션을 사용하면서
      데이터 저장만 S3에 할 수 있음 (S3의 안정성과 확장성이라는 장점만 가져올 수 있음)
  - 온프레미스 환경에 S3을 쉽게 Integration 할 수 있게 함

### Storage Gateway 구성

![Storage Gateway](https://d2908q01vomqb2.cloudfront.net/e1822db470e60d090affd0956d743cb0e7cdf113/2020/05/04/Figure-2-High-level-architecture-of-storage-gateway.png)

- S3를 iSCSI 방식으로 처리하기 위한 appliance를 VM에 설치해야 한다.

### Stoage Gateway 구성 타입

1. Gateway-Cached Volume
   ![Cached Volume](https://docs.aws.amazon.com/storagegateway/latest/userguide/images/aws-storage-gateway-cached-diagram.png)
   - 데이터 저장은 S3에 하되, 자주 access하는 데이터는 appliance의 로컬 디스크에 cache 형태로 유지
   - S3의 네트워크 latency 제약을 cache를 통해 해결
   - 전체 파일 사이즈의 20% 이상 크기를 cache용 Volume으로 설정
   - Upload Buffer용 Volume(S3에 업로드 이전에 데이터를 잠깐 저장하는 용도)도 필요함.
     - 이후 SSL로 데이터를 암호화하여 업로드 수행
   - I/O가 빈번한 메인 스토리지로서는 용도 부적합
2. Gateway-Stored Volume
   ![Stored Volume](https://docs.aws.amazon.com/storagegateway/latest/userguide/images/aws-storage-gateway-stored-diagram.png)
   - 데이터 저장을 appliance 내 local storage(Local IDC)에 저장하고, 비동기적으로 S3에 스냅샷 형태로 백업하는 방식
   - Gateway-Cached 방식보다 빠른 데이터 access (전체 데이터 세트에 대한 액세스)를 원할 때 사용
3. Gateway-VTL Volume
   ![VTL Volume](https://docs.aws.amazon.com/storagegateway/latest/userguide/images/Gateway-VTL-Architecture2-diagram.png)
   - Tape 방식 백업을 지원하는 솔루션에서 VTL(Virtual Tape Library) 형태의 인터페이스를 제공하여, S3에 저장하고, 이를 장기 보관할 수 있도록 Glacier로 아카이빙할 수 있도록 하는 방식
