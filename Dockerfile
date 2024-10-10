FROM python:3.13-slim-bookworm AS build-image

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /build

RUN apt update && \
    apt upgrade -y && \
    apt install -y curl ca-certificates gnupg2 && \
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg && \
    echo "deb https://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt update && \
    apt install -y --no-install-recommends gcc g++ make postgresql-server-dev-17 libpq-dev libpq5 libffi-dev git cargo pkg-config

COPY ./ ./

RUN python3 -m pip install -U -r requirements_dev.txt && \
    python3 setup.py bdist_wheel && \
    python3 -m pip wheel --no-cache-dir --wheel-dir /build/wheels -r requirements.txt && \
    cp dist/*.whl /build/wheels/


FROM python:3.13-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

WORKDIR /app

COPY --from=build-image /usr/lib/x86_64-linux-gnu/libpq.so.* \
    /usr/lib/x86_64-linux-gnu/liblber-2.5.so.* \
    /usr/lib/x86_64-linux-gnu/libldap-2.5.so.* \
    /usr/lib/x86_64-linux-gnu/libsasl2.so.* \
    /usr/lib/x86_64-linux-gnu/

COPY --from=build-image /build/wheels/ /wheels

RUN python3 -m pip install --no-cache /wheels/*

RUN  groupadd -r appgroup \
     && useradd -r -G appgroup -d /home/appuser appuser \
     && install -d -o appuser -g appgroup /app/logs

USER  appuser

EXPOSE 8080


CMD ["python3", "-m", "uvicorn", "python3_project_template.api.http:app", \
     "--host", "0.0.0.0", "--port", "8080"]
