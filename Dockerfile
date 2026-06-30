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

# Fix /app/config ownership so the upstream init script can populate it.
USER root
RUN mkdir -p /app/config && \
    chown -R 1000:1000 /app/config && \
    chmod -R 0755 /app/config
WORKDIR /app

# Drop back to upstream's runtime user (uid 1000 = node).
USER 1000

ENV HOMEPAGE_VAR_DEFAULT_THEME=dark \
    NODE_ENV=production

EXPOSE 3000

# Homepage's upstream server binds to HOMEPAGE_PORT || PORT || 3000.
# Healthcheck probes whatever Railway injects as PORT, falling back to 3000.
# start-period=180s provides buffer for first-build cold cache on Railway.
HEALTHCHECK --interval=30s --timeout=5s --start-period=180s --retries=3 \
  CMD curl -fsS "http://127.0.0.1:${PORT:-3000}/" >/dev/null 2>&1 || exit 1
