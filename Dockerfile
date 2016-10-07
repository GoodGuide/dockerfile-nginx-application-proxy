FROM nginx:stable-alpine

# delete the default configs
RUN rm /etc/nginx/nginx.conf /etc/nginx/conf.d/*

COPY ./entrypoint.sh /bin/entrypoint
COPY ./nginx.conf.tmpl /etc/nginx/nginx.conf.tmpl

EXPOSE 80
ENTRYPOINT ["/bin/entrypoint"]
CMD ["nginx"]
