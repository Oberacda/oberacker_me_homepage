FROM node:18.12.1 as builder
# change working directory
WORKDIR /usr/src/app
# copy the package.json files from local machine to the workdir in container
COPY package*.json ./
COPY yarn.lock ./
# run npm install in our local machine
RUN yarn install --frozen-lockfile
# copy the generated modules and all other files to the container
COPY . .
# build the application
RUN yarn run build
### Serve Step
# pull the Node.js Docker image
FROM node:18.12.1-alpine3.15
# change working directory
WORKDIR /app
# copy files from previous step
COPY --from=builder /usr/src/app/build .
COPY --from=builder /usr/src/app/package.json .
COPY --from=builder /usr/src/app/node_modules ./node_modules
# our app is running on port 3000 within the container, so need to expose it
EXPOSE 3000
# the command that starts our app
CMD ["node", "index.js"]