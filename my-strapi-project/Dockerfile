FROM node:22-alpine

# Installing sharp compatibility and tools
RUN apk update && apk add --no-cache \
  build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git

# Set environment
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

# Set working directory
WORKDIR /opt/
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install -g node-gyp
RUN npm install
ENV PATH=/opt/node_modules/.bin:$PATH

# Copy app source code
WORKDIR /opt/app
COPY . .

# Fix permissions and build
RUN chown -R node:node /opt/app
USER node
RUN npm run build

# Expose Strapi port
EXPOSE 1337

CMD ["npm", "run", "develop"]
