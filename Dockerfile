FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/webrecorder/replayweb.page.git && \
    cd replayweb.page && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:20 AS build

WORKDIR /replayweb.page
COPY --from=base /git/replayweb.page .
RUN apt update && \
    apt install -y python3 python3-pip jq && \
    pip install -r mkdocs/requirements.txt --break-system-packages
RUN yarn && \
    export NODE_ENV=production && \
    yarn update-ruffle && \
    yarn build-docs
RUN cd mkdocs && \
    mkdocs build

FROM lipanski/docker-static-website

COPY --from=build /replayweb.page/mkdocs/site .
