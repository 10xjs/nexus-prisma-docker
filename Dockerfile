##########################################################
# Setup a base image to build other packages from.       #
# Only work as 'node' user with uid and gid 1000.        #
##########################################################
FROM node:13 as monorepo-base
WORKDIR /app
ENV SERVER_PKG=packages/server
#ENV FRONTEND_PKG=packages/frontend

RUN mkdir -p $SERVER_PKG $FRONTEND_PKG \
    && chown -R 1000:1000 /app \
    && chmod -R 700 /app

USER node
WORKDIR /app

# Make the yarn cache to a writeable location, install node-gyp
RUN yarn config set cache-folder $HOME/.yarn-cache
RUN yarn global add --silent node-gyp

COPY --chown=node yarn.lock package.json lerna.json ./

##########################################################
# Build the API server to /app/packages/server/dist      #
##########################################################
FROM monorepo-base as nexus-builder
WORKDIR /app/$SERVER_PKG

RUN touch .env
COPY --chown=node $SERVER_PKG/package.json ./
RUN yarn install --silent --non-interactive --pure-lockfile

COPY --chown=node $SERVER_PKG/.env.example .
COPY --chown=node $SERVER_PKG/tsconfig.json .
COPY --chown=node $SERVER_PKG/prisma prisma
COPY --chown=node $SERVER_PKG/api api

RUN export $(cat .env.example) && yarn build

##########################################################
# Build a deployment image with the -slim variant, only  #
# including the necessary files from nexus-builder        #
##########################################################
FROM node:13-slim as server
ENV SERVER_BUILD=/app/packages/server
ENV NODE_ENV=production
RUN mkdir -p $SERVER_BUILD && chown -R 1000:1000 /app
WORKDIR $SERVER_BUILD

USER node
RUN yarn config set cache-folder $HOME/.yarn-cache

COPY --chown=node --from=nexus-builder $SERVER_BUILD/package.json /app/yarn.lock ./
RUN yarn install --silent --non-interactive --pure-lockfile --prod && yarn cache clean
COPY --chown=node --from=nexus-builder ["/app/node_modules/@prisma/client", "node_modules/@prisma/client"]
COPY --chown=node --from=nexus-builder $SERVER_BUILD/.env.example .
COPY --chown=node --from=nexus-builder $SERVER_BUILD/dist dist

CMD ["node", "dist/index.js"]
HEALTHCHECK --interval=60s --timeout=10s --start-period=30s \
  CMD curl -f http://localhost:4000/graphql || exit 1

###########################################################
#
#FROM monorepo-base as nuxt-builder
#WORKDIR /app/$FRONTEND_PKG
#
#COPY --chown=node $FRONTEND_PKG/package.json yarn.lock ./
#RUN yarn install --silent --pure-lockfile --non-interactive
#
#COPY --chown=node $FRONTEND_PKG/assets assets
#COPY --chown=node $FRONTEND_PKG/components components
#COPY --chown=node $FRONTEND_PKG/constants constants
#COPY --chown=node $FRONTEND_PKG/directives directives
#COPY --chown=node $FRONTEND_PKG/layouts layouts
#COPY --chown=node $FRONTEND_PKG/middleware middleware
#COPY --chown=node $FRONTEND_PKG/pages pages
#COPY --chown=node $FRONTEND_PKG/plugins plugins
#COPY --chown=node $FRONTEND_PKG/static static
#COPY --chown=node $FRONTEND_PKG/store store
#COPY --chown=node $FRONTEND_PKG/types types
#COPY --chown=node $FRONTEND_PKG/utils utils
#COPY --chown=node $FRONTEND_PKG/tsconfig.json .
#COPY --chown=node $FRONTEND_PKG/.env.example .
#COPY --chown=node $FRONTEND_PKG/nuxt.config.ts .
#
#RUN yarn build

##########################################################

#FROM node:13-slim as frontend
#USER node
#RUN yarn config set cache-folder $HOME/.yarn-cache
#ENV NODE_ENV=production
#ENV NUXT_HOST=0.0.0.0
#
#ENV FRONTEND_BUILD=/app/packages/frontend
#WORKDIR $FRONTEND_BUILD
#
#COPY --chown=node --from=nuxt-builder $FRONTEND_BUILD/package.json /app/yarn.lock ./
#RUN yarn install --silent --non-interactive --pure-lockfile --prod && yarn cache clean
#
#COPY --chown=node --from=nuxt-builder $FRONTEND_BUILD/store store
#COPY --chown=node --from=nuxt-builder $FRONTEND_BUILD/static static
#COPY --chown=node --from=nuxt-builder $FRONTEND_BUILD/types types
#COPY --chown=node --from=nuxt-builder $FRONTEND_BUILD/nuxt.config.ts .
#COPY --chown=node --from=nuxt-builder $FRONTEND_BUILD/tsconfig.json .
#COPY --chown=node --from=nuxt-builder $FRONTEND_BUILD/.nuxt .nuxt
#
#CMD ["node", "node_modules/.bin/nuxt-ts", "start"]
#HEALTHCHECK --interval=60s --timeout=10s --start-period=30s \
#  CMD curl -f http://localhost:3000/ || exit 1

##########################################################
