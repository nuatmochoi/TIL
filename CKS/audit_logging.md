# Audit Logging
- https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/#log-backend

1. audit-logs 디렉토리 생성 후 kube-apiserver yaml 수정
```yaml
spec:
  containers:
  - command:
    - kube-apiserver
    - --audit-log-path=/etc/kubernetes/audit-logs/audit.log
    - --audit-policy-file=/etc/kubernetes/audit-policy/policy.yaml
    - --audit-log-maxsize=7
    - --audit-log-maxbackup=2
```

2. kube-apiserver yaml volumeMounts 수정
```yaml
volumeMounts:
- mountPath: /etc/kubernetes/audit-policy/policy.yaml
    name: audit
    readOnly: true
- mountPath: /etc/kubernetes/audit-logs/
    name: audit-log
    readOnly: false
```

3. kube-apiserver yaml volume 수정
```yaml
volumes:
- hostPath:
    path: /etc/kubernetes/audit-policy/policy.yaml
    type: File
name: audit
- hostPath:
    path: /etc/kubernetes/audit-logs/
    type: DirectoryOrCreate
name: audit-log
```
