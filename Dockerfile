# Create a base layer with linkerd-await from a recent release.
FROM docker.io/curlimages/curl:latest as linkerd
ARG LINKERD_AWAIT_VERSION=v0.2.3
RUN curl -sSLo /tmp/linkerd-await https://github.com/linkerd/linkerd-await/releases/download/release%2F${LINKERD_AWAIT_VERSION}/linkerd-await-${LINKERD_AWAIT_VERSION}-amd64 && \
    chmod 755 /tmp/linkerd-await

# Build your application with whatever environment makes sense.
FROM registry.opensource.zalan.do/acid/logical-backup:v1.6.2 as app
WORKDIR /app

# Package the application wrapped by linkerd-await. Note that the binary is
# static so it can be used in `scratch` images:
FROM scratch
COPY --from=app / /
COPY --from=linkerd /tmp/linkerd-await /linkerd-await
# In this case, we configure the proxy to be shutdown after `myapp` completes
# running. This is only really needed for jobs where the application is
# expected to complete on its own (namely, `Jobs` and `Cronjobs`)
ENV PG_DIR=/usr/lib/postgresql
ENTRYPOINT ["/linkerd-await", "--shutdown", "--"]
CMD  ["/dump.sh"]

