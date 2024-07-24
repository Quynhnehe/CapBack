# Use a base image with Node.js
FROM node:20.13.1-alpine3.18 AS node_builder
RUN mkdir -p /usr/src/app && npm install -g yarn --force
ADD . /usr/src/app
WORKDIR /usr/src/app
# Install dependencies
RUN yarn install && yarn run build

# Install Prisma CLI
RUN yarn add prisma @prisma/client

# Copy the rest of the application source code
COPY . .

# Set environment variables
ENV DATABASE_URL="mysql://root:12345678@mysql:3306/db_pinterest"
ENV JWT_SECRET="Ambitious_programmer"
ENV JWT_SECRET_REFRESH="Ambitious_programmer_refresh"
ENV PORT=8080
# Generate Prisma client
RUN npx prisma generate

# Expose the application port
EXPOSE 8080

CMD [ "sh", "-c", "yarn start:prod" ]
