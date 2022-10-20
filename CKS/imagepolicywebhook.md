# ImagePolicyWebhook

- admission_config.json 내 kubeconfig (external service server)
- kube-apiserver 내 `--enable-admission-plugins=ImagePolicyWebhook`, `--admission-control-config-file=admission_config.json`
