provider "aws" {
  region = "ap-northeast-2"
}

# 다른 폴더에서 해당 모듈 위치만 명시 & variable 통해서 env(prod,dev)만 명시하면 환경별 재사용 가능
module "webserver_cluster" {
  source = "./modules/webserver-cluster"
}
