FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/webrecorder/replayweb.page.git && \
    cd replayweb.page && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM --platform=$BUILDPLATFORM node AS build

WORKDIR /replayweb.page
COPY --from=base /git/replayweb.page .
RUN apt update && \
    apt install -y jq python3-pip && \
    pip install -r mkdocs/requirements.txt --break-system-packages && \
    yarn --frozen-lockfile && \
    yarn update-ruffle && \
    yarn build-docs

FROM joseluisq/static-web-server

COPY --from=build /replayweb.page/mkdocs/site ./public
