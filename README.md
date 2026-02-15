# openclaw-hardened
Openclaw docker image ready to run

## Build

```bash
docker build -t openclaw-cloudflared-secure .
```

## Run

```bash
docker run --name openclaw --rm -d \
  -e CLOUDFLARE_ZERO_TRUST_TOKEN="$CLOUDFLARE_ZERO_TRUST_TOKEN" \
  openclaw-cloudflared-secure
```

```bash
docker exec -it openclaw bash
```

This keeps the container non-permanent (`--rm`) and removes it automatically after `docker stop openclaw`.
