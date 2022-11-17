# Kube-bench

## 전체 check 
- `kube-bench run --targets master`

## 특정 버전 check
- `kube-bench run --targets master --check 1.2.20`
- command 실행 후 권고사항이 output으로 떨어짐

## CSP check
- `kube-bench --benchmark gke-1.2.0`
- CSP의 경우 ControlPlane는 Managed로 기본적으로 안전하며, worker node 대상으로 kube-bench 벤치마크 가능

