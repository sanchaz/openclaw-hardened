# openclaw-hardened
Openclaw docker image ready to run

## Build

```bash
docker build -t openclaw-cloudflared-secure .
```

## Run

```bash
docker run --name openclaw -d \
  -e CLOUDFLARE_ZERO_TRUST_TOKEN="$CLOUDFLARE_ZERO_TRUST_TOKEN" \
  openclaw-cloudflared-secure
```

```bash
docker exec -it openclaw bash
```

This creates a persistent container named `openclaw`. Remove it with `docker rm -f openclaw` when done.
