FROM node:20-alpine

ENV NODE_VERSION 20.11.1
ENV BRANCH main
RUN apk add build-base git wget bash
RUN touch /root/.bashrc
RUN wget -qO- https://get.pnpm.io/install.sh | ENV="$HOME/.bashrc" SHELL="$(which bash)" bash -
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
COPY ./init.sh /init.sh
VOLUME workspace /workspace
WORKDIR /workspace
ENTRYPOINT ["/bin/bash", "-c", "/init.sh"]