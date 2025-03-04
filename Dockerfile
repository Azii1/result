# Use Node.js image-slim
FROM node:18-slim

# add curl for healthcheck
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl tini && \
    rm -rf /var/lib/apt/lists/*

# working directory
WORKDIR /usr/local/app

# have nodemon available for local dev use (file watching)
RUN npm install -g nodemon

# Copy the json.package
COPY package*.json ./

# Move node module out of work dir and clean
RUN npm ci && \
 npm cache clean --force && \
 mv /usr/local/app/node_modules /node_modules

# Copy Application Files
COPY . .

#Env variable for ports
ENV PORT 80
EXPOSE 80

# Easy process handling
ENTRYPOINT ["/usr/bin/tini", "--"]

#Application Start
CMD ["node", "server.js"]
