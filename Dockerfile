FROM node:20-bookworm AS builder

RUN apt-get update && \
    apt-get install -y git git-lfs && \
    git lfs install

WORKDIR /src

ARG RAILWAY_GIT_COMMIT_SHA

RUN echo "Railway commit: $RAILWAY_GIT_COMMIT_SHA" && \
    GIT_LFS_SKIP_SMUDGE=1 git clone \
    https://github.com/choimoonjong/MMORPG-GAME.git . && \
    git checkout "$RAILWAY_GIT_COMMIT_SHA" && \
    git lfs pull && \
    git lfs checkout

RUN ls -lh gamehomepage/TemplateData/Build/

RUN rm -rf .git

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