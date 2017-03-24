# goodguide/nginx-application-proxy

This is a simple nginx container meant to be run alongside a webapp like Rails. It implements a simple HTTP caching layer just above the application (respectful of relevant headers in the application's response) and for any request for `/assets` it returns wide-open CORS headers.

With this, you can opt not to precompile assets (though it's still a good idea). You must however ensure the app serves assets even in a production setting. (The app serves them once to Nginx, then nginx serves them out of its cache subsequently.)

## Rewrite HTTP to HTTPS on AWS ELB

This branch of the nginx-application-proxy is setup to rewrite HTTP requests to HTTPS while setup behind an AWS ELB.  If http_x_forwarded_proto is not set to HTTPS, or is not requesting the path /health/status, the requests will be rewritten to the HTTPS protocol.

## Example

Here's a typical use-case:

1. Run the app container, giving it a volume for the static assets. In this example, we're also binding our app server to a unix socket which also lives in a (separate) Docker volume.

    ```sh
    docker run -d --name my-app-1 \
        --expose 3000
        my-app:latest \
        rails s
    ```

2. Run this Nginx container, sharing the volumes from the app container into it and configuring the paths to them:

    ```sh
    docker run -d --name my-app-nginx-1 \
        --volumes-from my-app-1 \
        -e upstream_server_address='tcp://my-app-1:3000' \
        -p 3000:80
        goodguide/nginx-application-proxy
    ```

## Configuration

There are just two configuration environment variables, both of which must be specified:

- `upstream_server_address` -- goes in the `upstream { server X }` block, [as described in the official docs](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server)
