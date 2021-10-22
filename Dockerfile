FROM node:lts as dependencies
WORKDIR /supa2010
COPY package.json package-lock.json ./
RUN yarn install --frozen-lockfile --frozen-package-lock.json --unsafe-perm --production

FROM node:lts as builder
WORKDIR /supa2010
COPY . .
COPY --from=dependencies /supa2010/node_modules ./node_modules
RUN yarn build

FROM node:lts as runner
WORKDIR /supa2010
ENV NODE_ENV production
# If you are using a custom next.config.js file, uncomment this line.
# COPY --from=builder /my-project/next.config.js ./
COPY --from=builder /supa2010/public ./public
COPY --from=builder /supa2010/.next ./.next
COPY --from=builder /supa2010/node_modules ./node_modules
COPY --from=builder /supa2010/package.json ./package.json

EXPOSE 3000
CMD ["yarn", "start"]