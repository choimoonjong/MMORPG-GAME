FROM node:20-bookworm AS builder

RUN apt-get update && \
    apt-get install -y git git-lfs && \
    git lfs install

WORKDIR /src

RUN git clone --depth 1 \
    https://github.com/choimoonjong/MMORPG-GAME.git .

RUN git lfs pull
RUN git lfs checkout

RUN ls -lh gamehomepage/TemplateData/Build/

# Git/LFS 저장 데이터는 최종 이미지에 필요 없음
RUN rm -rf .git


FROM node:20-bookworm-slim

WORKDIR /app

COPY --from=builder /src/package.json ./
COPY --from=builder /src/package-lock.json ./

RUN npm ci --omit=dev

COPY --from=builder /src/server ./server
COPY --from=builder /src/gamehomepage ./gamehomepage

CMD ["npm", "start"]