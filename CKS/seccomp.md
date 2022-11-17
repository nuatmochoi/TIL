# Seeccomp

- 커널로의 syscall을 제한하는 용도로 쓰임
- kubelet (/var/lib/kubelet/config.yaml)에 `seccompDefault: ture`로 명시되어야 함
- 이후 Pod를 생성할 때 seccomp profile로 pod를 만들도록 함

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx-auditing
spec:
  containers:
  - image: nginx
    name: nginx
  securityContext: 
    seccompProfile:
      type: Localhost 
      localhostProfile: profiles/auditing.json 
```
