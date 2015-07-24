FROM nginx:1.9.3

ADD ./nginx-config-wrapper.sh /bin/nginx-config-wrapper

ENTRYPOINT ["/bin/nginx-config-wrapper"]
CMD ["nginx", "-g", "daemon off;"]
