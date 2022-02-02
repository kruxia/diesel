# diesel
A standalone diesel docker image for migrations. https://hub.docker.com/r/kruxia/diesel/tags

## Usage

### In your Dockerfile
```dockerfile
# ... Dockerfile stuff 
# assumes that /usr/local/bin is on the PATH
COPY --from=kruxia/diesel /usr/local/bin/diesel /usr/local/bin/diesel
# ...

