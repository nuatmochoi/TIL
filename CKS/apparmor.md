# Apparmor

-  Pod/Deployment에 apparmor profile 연동 :`spec.template.meta.annotations` 에 `container.apparmor.security.beta.kubernetes.io/<container_name>: localhost/<profile_name>` 명시
- node에 apparmor profile 적용 : `apparmor_parser <profile_name>`

