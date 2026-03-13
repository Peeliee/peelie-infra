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
3. HTTPS 인증서 발급(최초 1회)
4. `./scripts/deploy.sh` 실행
5. `docker compose --env-file .env.prod ps`로 상태 확인

## HTTPS 설정 (Let's Encrypt)
도메인 `peelie.higu.kr`의 A 레코드가 EC2 퍼블릭 IP를 가리켜야 합니다.

1. 보안그룹 인바운드 허용: `80`, `443`
2. EC2에 certbot 설치
3. 인증서 발급:
   `sudo certbot certonly --standalone -d peelie.higu.kr --agree-tos -m <EMAIL> --no-eff-email`
4. 인증서 경로 확인:
   `/etc/letsencrypt/live/peelie.higu.kr/fullchain.pem`
   `/etc/letsencrypt/live/peelie.higu.kr/privkey.pem`
5. 배포:
   `./scripts/deploy.sh`
6. 확인:
   `curl -I https://peelie.higu.kr`

## 롤백 방법
- `./scripts/rollback.sh <spring_tag> <avatar_tag>`
