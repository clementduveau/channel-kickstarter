#!/bin/bash

set -ox errexit

h="${BOOKINFO_HUB:?BOOKINFO_HUB must be set}"
t="${BOOKINFO_TAG:?BOOKINFO_TAG must be set}"
    
# Build all images using docker build (without buildx)

# Build productpage v1
docker build -t ${BOOKINFO_HUB}/examples-bookinfo-productpage-v1:${BOOKINFO_TAG} ./src/productpage
docker push ${BOOKINFO_HUB}/examples-bookinfo-productpage-v1:${BOOKINFO_TAG}

# Build details v1
docker build --build-arg service_version=v1 -t ${BOOKINFO_HUB}/examples-bookinfo-details-v1:${BOOKINFO_TAG} ./src/details
docker push ${BOOKINFO_HUB}/examples-bookinfo-details-v1:${BOOKINFO_TAG}

# Build reviews v1
docker build --build-arg service_version=v1 -t ${BOOKINFO_HUB}/examples-bookinfo-reviews-v1:${BOOKINFO_TAG} ./src/reviews
docker push ${BOOKINFO_HUB}/examples-bookinfo-reviews-v1:${BOOKINFO_TAG}

# Build reviews v2
docker build --build-arg service_version=v2 --build-arg enable_ratings=true -t ${BOOKINFO_HUB}/examples-bookinfo-reviews-v2:${BOOKINFO_TAG} ./src/reviews
docker push ${BOOKINFO_HUB}/examples-bookinfo-reviews-v2:${BOOKINFO_TAG}

# Build reviews v3
docker build --build-arg service_version=v3 --build-arg enable_ratings=true --build-arg star_color=red -t ${BOOKINFO_HUB}/examples-bookinfo-reviews-v3:${BOOKINFO_TAG} ./src/reviews
docker push ${BOOKINFO_HUB}/examples-bookinfo-reviews-v3:${BOOKINFO_TAG}

# Build ratings v1
docker build --build-arg service_version=v1 -t ${BOOKINFO_HUB}/examples-bookinfo-ratings-v1:${BOOKINFO_TAG} ./src/ratings
docker push ${BOOKINFO_HUB}/examples-bookinfo-ratings-v1:${BOOKINFO_TAG}


# Update image references in the yaml file
sed -i.bak "s#image:.*\\(\\/examples-bookinfo-.*\\):.*#image: ${h//\//\\/}\\1:$t#g" ./platform/kube/bookinfo-custom-images.yaml
