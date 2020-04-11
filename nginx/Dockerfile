# Build with docker image build -t custom-nginx:latest .

# latest nginx
FROM nginx
# copy custom configuration file
COPY nginx.conf /etc/nginx/nginx.conf
# expose server port
EXPOSE 80
# start server
CMD ["nginx", "-g", "daemon off;"]
