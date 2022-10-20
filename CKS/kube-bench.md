# Kube-bench

## 전체 check 
- `kube-bench run --targets master`

## 특정 버전 check
- `kube-bench run --targets master --check 1.2.20`
- command 실행 후 권고사항이 output으로 떨어짐

## CSP check
- `kube-bench --benchmark gke-1.2.0`
