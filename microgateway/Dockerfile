FROM node:4-slim

# Create pull config directory
RUN mkdir -p /usr/src/set-config
COPY set-config/* /usr/src/set-config/
RUN npm install --prefix /usr/src/set-config


# Create app directory
RUN mkdir -p /usr/src/app && \
    apt update && \
    apt install -y jq && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /usr/src/app

# Install microgateway 
RUN npm install --silent -g npm && \
    npm install --silent microgateway && \
    npm install --silent microgateway && \
    mkdir -p /usr/src/app/node_modules/microgateway/config/default

# Bundle app source
COPY *.yaml /usr/src/app/node_modules/microgateway

COPY *.sh /usr/bin/
RUN chmod +x /usr/bin/app.sh
ENV NODE_ENV production
CMD [ "/bin/sh", "-c", "/usr/bin/app.sh config && /usr/bin/app.sh start && /usr/bin/app.sh wait" ]

