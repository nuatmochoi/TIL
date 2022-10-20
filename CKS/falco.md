# Falco
- log : `cat /var/log/syslog | grep falco`
- `/etc/falco` 위치에 rule 들이 저장
- `cp falco_rules.yaml falco_rules.local.yaml`
- 수정 후 `service falco restart`
