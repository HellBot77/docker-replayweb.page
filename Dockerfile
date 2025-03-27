FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/webrecorder/replayweb.page.git && \
    cd replayweb.page && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM lipanski/docker-static-website

COPY --from=base /git/replayweb.page .
