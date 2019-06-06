FROM nginx:1.15

ENV APP_HOME /opt/peppermint-portal
ENV NVM_VERSION=v0.34.0
ENV NODE_VERSION=10.16.0
ENV NG_VERSION=8.0.1
ENV YARN_VERSION=1.5.1

RUN apt-get update; apt-get install wget git -y
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash
RUN export NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; nvm install $NODE_VERSION; nvm use $NODE_VERSION; npm install -g @angular/cli@$NG_VERSION yarn@$YARN_VERSION
RUN cd /opt; git clone https://github.com/redbox-mint/peppermint-portal.git
RUN export NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; nvm use $NODE_VERSION; cd $APP_HOME; yarn install; ng build --prod --build-optimizer --output-path build/peppermint
RUN rm -rf /usr/share/nginx/html; ln -s $APP_HOME/build /usr/share/nginx/html
COPY support/nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
