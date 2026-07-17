# pkzenv
- Build kafka client using librdkafka
- Build postgresql client using libpq
- Write it in zig

# Usage
```Dockerfile
# =============================
#   Build stage
# =============================
FROM lahatra3/pkzenv:18.3-2.13.0-0.16.0 AS build

WORKDIR /app
COPY . .
RUN zig build -Doptimize=ReleaseSafe

# =============================
#   Runtime stage
# =============================
FROM lahatra3/pkzenv:18.3-2.13.0-0.16.0 AS runtime

USER root

LABEL maintainer="lahatra3"
LABEL description="lahatrad bin written by lahatra3"

ARG APP_INSTALL_DIR=/usr/local/lahatra3
ARG APP_NAME=lahatrad

RUN id -u lahatra3 >/dev/null 2>&1 || \
    (useradd -m -u 10001 lahatra3 2>/dev/null || adduser -D -u 10001 lahatra3)

RUN mkdir -p ${APP_INSTALL_DIR}
COPY --from=build /app/zig-out/bin/${APP_NAME} ${APP_INSTALL_DIR}/${APP_NAME}

RUN chown -R appuser:appuser ${APP_INSTALL_DIR}

USER appuser
ENV PATH=${APP_INSTALL_DIR}:${PATH}

CMD ["lahatrad"]

```