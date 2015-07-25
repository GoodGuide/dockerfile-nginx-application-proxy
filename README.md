# goodguide/nginx-static-files-proxy-pass

This is meant to be a no-configuration Nginx reverse proxy for a webapp such as a Ruby web server, where you want Nginx to serve static files instead of having to handle that in your app. Nginx will look first for a file matching the request path, then failing that will proxy the request to the upstream application.

```shell
docker run -d --name=my-app -e STATIC_FILES_VOLUME=/app/public -p 80 my-app
docker run --volumes-from=my-app --link my-app:upstream goodguide/nginx-static-files-proxy-pass
```

If you define an environment variable on your app container called `STATIC_FILES_VOLUME`, which should be the path to a Volume, `nginx-static-files-proxy-pass` will use that as the document root and will try files in that volume before proxying the request.

The app container should expose port 80.
