# Bookinfo

![Architecture](noistio.svg)

BookInfo's app is made of 4 microservices:
- Product page: Frontend, Python
- Details: API to retrieve a book info, Ruby
- Reviews: API to retrieve reviews from users, Java, 3 different versions are deployed
- Ratings: Subservice of reviews that stores grades from 1 to 5 from reviews, NodeJS

> You can always ask questions about the environment to your BookInfo's main contact !

## Initialize your environment

BookInfo got you a dev environment to run your tests. Deploy the app by running these commands:

```bash
git clone https://github.com/clementduveau/channel-kickstarter.git
cd channel-kickstarter
export HUB="us-docker.pkg.dev/public-field-eng-grafana/${LOGNAME:0:6}-cr"
export TAG=$LOGNAME
BOOKINFO_TAG=$TAG BOOKINFO_HUB=$HUB ./build-custom-code.sh
kubectl apply -f bookinfo-custom-images.yaml
```

## Generate load

You have 2 options:
- Generate requests manually
- Generate requests automatically

To run a single request manually, run the following command:

```bash
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"
```

To generate some traffic continuously, deploy the loadgen deployment:

```bash
kubectl apply -f loadgen.yml
```

## How to modify and deploy custom code

The source code of each microservices is available in `~/channel-kickstarter/bookinfo/src/`

To deploy custom code, run the `build-custom-code.sh` command again

> The `build-custom-code.sh` generates a copy of `bookinfo.yaml` and changes the images, your other changes on `bookinfo-custom-images.yaml` **will be lost !**

```bash
cd ~/channel-kickstarter
BOOKINFO_TAG=$TAG BOOKINFO_HUB=$HUB ./build-custom-code.sh
kubectl apply -f bookinfo-custom-images.yaml
```

It will compile all microservices, build the image, push it to registry, generate and deploy a new Kubernetes manifest using these images.
