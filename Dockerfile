# =============================================================================
# Railway Template: Homepage v1.13.2
# https://github.com/gethomepage/homepage
# =============================================================================
# Notes from deploy-fail cycles (see pipeline-logs/deploy-publish-attempt.log):
#   • Railway mounts persistent volumes as root:root. The Homepage upstream
#     runtime user is uid 1000 (`node`). Without chown, the upstream init
#     script's `copyfile /app/src/skeleton → /app/config` fails with EACCES.
#     Adding USER root + RUN chown before USER drop fixes that.
#   • Railway's cold first-build can take 90–180s; start-period=180s absorbs it.
# =============================================================================

FROM ghcr.io/gethomepage/homepage:v1.13.2

# Railway mounts persistent volumes as root:root at RUNTIME, which defeats any
# build-time chown. The upstream docker-entrypoint.sh only fixes /app/config
# ownership when PUID/PGID are non-zero (defaults to 0 = root = "skip"). Setting
# PUID=1000 / PGID=1000 makes the entrypoint chown /app/config at container start,
# so the uid-1000 init script can copy the skeleton config into the mounted volume.
ENV PUID=1000 \
    PGID=1000 \
    HOMEPAGE_VAR_DEFAULT_THEME=dark \
    NODE_ENV=production

# Railway injects PORT=8080 and its reverse-proxy routes external traffic
# dynamically. No hardcoded EXPOSE — the server binds to $PORT, and the
# healthcheck reads the same variable.
# start-period=180s absorbs first-build cold cache.

HEALTHCHECK --interval=30s --timeout=5s --start-period=180s --retries=3 \
  CMD curl -fsS "http://127.0.0.1:${PORT:-3000}/" >/dev/null 2>&1 || exit 1
