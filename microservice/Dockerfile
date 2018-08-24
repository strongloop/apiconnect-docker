FROM node:4-slim

# Create app directory
RUN mkdir -p /usr/src/app && \
    apt update && \
    apt install -y jq && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install --silent --prod && \
    npm prune --prod

# Bundle app source
COPY . /usr/src/app
    
COPY *.sh /usr/bin/
RUN chmod +x /usr/bin/app.sh
ENV PORT 8080
EXPOSE 8080
ENV NODE_ENV production
CMD [ "/bin/sh", "-c", "/usr/bin/app.sh start && /usr/bin/app.sh wait" ]

