FROM mcr.microsoft.com/azure-powershell:ubuntu-20.04 as prod

RUN apt-get --yes update \
 && useradd --create-home --shell /bin/nologin azure

USER azure
WORKDIR /home/azure

COPY --chown=azure:azure --chmod=754 ServicePrincipalExpirationReport.ps1 .

ARG GIT_COMMIT="undefined"
ENV GIT_COMMIT=$GIT_COMMIT
LABEL org.opencontainers.image.revision="${GIT_COMMIT}" \
      org.opencontainers.image.source="https://github.com/bratislava/" \
      org.opencontainers.image.licenses="EUPL-1.2"

CMD [ "./ServicePrincipalExpirationReport.ps1" ]
