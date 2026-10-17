# What a Prometheus Counter Really Tells You About a Python API

Supporting source for https://networknuts.net/knowledge-base/instrument-python-api-prometheus-counter-verify-scrape/.

The application and configuration are the exact files executed for the article. The image pins from the tested .env are included as .env.example; no credentials are required.

## Optional local reproduction

Requires Docker with Compose, curl, and unused local ports 18000 and 19090. The standard-library Python server is a single-process teaching example, not a production server.

```sh
cp .env.example .env
docker compose up -d --build
curl --retry 10 --retry-connrefused --retry-delay 1 -fsS http://127.0.0.1:18000/health
for i in $(seq 1 20); do curl -fsS http://127.0.0.1:18000/hello > /dev/null || break; done
sleep 6
curl -fsSG http://127.0.0.1:19090/api/v1/query --data-urlencode query=lab_api_requests_total
```

The counter should be 20 for a fresh process after those 20 successful requests. Repeating the loop increments it further. Prometheus scrapes every five seconds; wait for the first successful scrape before interpreting the query. The target page is http://127.0.0.1:19090/targets. Ports bind only to localhost; on a remote host, use SSH port forwarding for browser access.

## Cleanup

```sh
docker compose down --volumes --remove-orphans
```

This removes this Compose project and its disposable data volumes.
