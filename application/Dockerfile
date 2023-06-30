############### stage 1 ###################
FROM node:20-alpine3.16 as build
WORKDIR /usr/react
COPY . /usr/react
RUN npm ci
RUN npm run build

############### stage 2 ###################
FROM nginx:1.23.4-alpine
EXPOSE 80
COPY ./nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY ./nginx/conf.d/exporter.conf /etc/nginx/conf.d/exporter.conf        
COPY --from=build /usr/react/build /usr/share/nginx/html           