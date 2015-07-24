# goodguide/nginx-static-files-proxy-pass

This is meant to be a no-configuration Nginx reverse proxy for a webapp such as a Ruby web server, where you want Nginx to serve static files instead of having to handle that in your app. Nginx will look first for a file matching the request path, then failing that will proxy the request to the upstream application.

```shell
docker run -d --name=my-app -e STATIC_FILES_ROOT=/app/public my-app
docker run --volumes-from=my-app --link my-app:upstream goodguide/nginx-static-files-proxy-pass
```
