# k8s troubleshooting

## Application Error
- pod(DB) -> svc(DB) -> deploy(web-DB) -> sev(Web) -> NodePort 의 구조일 때
    - label 및 selector / name이 맞는지
    - deploy, svc Port 비교해볼 것
    - svc와 pod 비교해볼 것

## ControlPlnae Error
- static pod path 등 config 확인 
  1. `ps -aux | grep kubelet`
  2. 결과 중 `--config=/var/lib/kubelet/config.yaml` 확인
  3. `vi /var/lib/kubelet/config.yaml` 중 static pod path 확인
- static pod path로 이동하여 수정

- scaling시 pod가 적절 개수로 변경되지 않으면, kube-controller-manager 확인
    - `k logs kube-controller-manager-controlplane -n kube-system`을 통해 오류 메시지 확인
    -  경로 오류 시 hostPath 확인

## Node Error
- node01가 NotReady 상태라면 `ssh node01` 이후,  `systemctl status kubelet`
    - inactive (dead) 상태라면 `systemctl start kubelet` 수행
- k8s cluster가 systemd를 사용할 때 `journalctl -u kubelet`로 노드의 로그 확인 가능
- static pod 들이 쓰고 있는 포트 확인 
    - `sudo netstat -lnpt|grep kube`
    - `k cluster-info`

## Network Error
- `kubectl get daemonset -n kube-system`에 적절한 CNI가 없다면 설치
- proxy pod 등 log 확인 
- `kubectl describe configmap kube-proxy -n kube-system`로 kube-proxy config 조회
    - 값이 다를 경우 `k edit ds kube-proxy -n kube-system` 통해 수정

## Reference 
- https://kubernetes.io/ko/docs/setup/production-environment/container-runtimes/#kubeadm%EC%9C%BC%EB%A1%9C-%EC%83%9D%EC%84%B1%ED%95%9C-%ED%81%B4%EB%9F%AC%EC%8A%A4%ED%84%B0%EC%9D%98-%EB%93%9C%EB%9D%BC%EC%9D%B4%EB%B2%84%EB%A5%BC-systemd-%EB%A1%9C-%EB%B3%80%EA%B2%BD%ED%95%98%EA%B8%B0
- https://www.slideshare.net/JoHoon1/systemd-cgroup
- https://psnote.tistory.com/202
