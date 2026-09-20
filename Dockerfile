FROM node:20-bookworm

RUN apt-get update && \
    apt-get install -y git git-lfs && \
    git lfs install

WORKDIR /app

RUN git clone https://github.com/choimoonjong/MMORPG-GAME.git /tmp/game

WORKDIR /tmp/game

RUN git lfs pull
RUN git lfs checkout

RUN ls -lh gamehomepage/TemplateData/Build/

RUN cp -a /tmp/game/. /app/

WORKDIR /app

RUN npm ci --omit=dev

CMD ["npm", "start"]