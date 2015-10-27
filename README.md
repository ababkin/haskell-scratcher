# haskell-scratcher

building the image in docker:


`docker run --privileged -it haskell:7.8 bash`

in bash:

temporary add sid repository

```
echo "deb http://ftp.us.debian.org/debian/ sid main contrib non-free" >> /etc/apt/sources.list

echo "deb-src http://ftp.us.debian.org/debian/ sid main contrib non-free" >> /etc/apt/sources.list

apt-get updates
```

install necessary packages
`apt-get install docker.io git build-essential libpq-dev libssl-dev libghc-crypto-dev ca-certificates`

remove the temporary lines added in above steps from `/etc/apt/sources.list`
`apt-get update`

```
git clone https://github.com/ababkin/haskell-scratcher.git
cd haskell-scratcher/
```

make sure libdeps and usrdeps contain necessary dynamic libraries

```
./generateMakefile
/etc/init.d/docker start
make`
```

`docker images`
for every version, tag appropriately:

```
docker tag -f <gmp-image-id-hash> ababkin/haskell-scratch:integer-gmp
docker tag -f <simple-image-id-hash> ababkin/haskell-scratch:integer-simple
```

`docker push ababkin/haskell-scratch`

