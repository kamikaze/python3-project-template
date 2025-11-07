FROM python:3.13.9-slim-trixie

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt update && \
    apt install -y curl ca-certificates apt-transport-https wget gnupg && \
    wget -O- https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /usr/share/keyrings/postgresql.gpg && \
    echo deb [arch=amd64,arm64,ppc64el signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt/ trixie-pgdg main | tee /etc/apt/sources.list.d/postgresql.list && \
    apt update && \
    apt install -y --no-install-recommends libpq-dev gcc g++ make postgresql-server-dev-18 libffi-dev git cargo pkg-config ssh && \
    apt clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/
