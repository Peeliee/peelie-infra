# peelie-infra

단일 EC2에서 `peelie` 서비스를 Docker Compose로 배포하기 위한 인프라 레포입니다.

## 서비스 구성
- `nginx` 리버스 프록시
- `spring` (Spring Boot API)
- `fastapi` (아바타 API)
- `worker` (아바타 워커)
- `redis` (로컬 캐시/스트림)

## 필수 파일
- `.env.prod` (실제 운영값, 커밋 금지)
- `docker-compose.yml`
- `nginx/nginx.conf`

## 배포 방법
1. `.env.prod.example`을 복사해 `.env.prod` 생성
2. `.env.prod`에 실제 운영값 입력
3. `./scripts/deploy.sh` 실행
4. `docker compose --env-file .env.prod ps`로 상태 확인

## 롤백 방법
- `./scripts/rollback.sh <spring_tag> <avatar_tag>`
