FROM mcr.microsoft.com/azure-powershell:17.0.0-ubuntu-24.04 AS prod

# Numeric UID so Kubernetes can enforce runAsNonRoot. The base image's
# `ubuntu` user already holds 1000.
RUN useradd --create-home --uid 1001 --user-group --shell /usr/sbin/nologin azure

USER 1001
WORKDIR /home/azure

COPY --chown=azure:azure --chmod=754 ServicePrincipalExpirationReport.ps1 .

ARG GIT_COMMIT="undefined"
ENV GIT_COMMIT=$GIT_COMMIT
LABEL org.opencontainers.image.revision="${GIT_COMMIT}" \
      org.opencontainers.image.source="https://github.com/bratislava/azure-expiration-report" \
      org.opencontainers.image.licenses="EUPL-1.2"

CMD [ "./ServicePrincipalExpirationReport.ps1" ]
