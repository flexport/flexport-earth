FROM cypress/included:10.11.0

ARG BUILD_NUMBER

COPY cypress.io/ /cypress.io/

WORKDIR /cypress.io

ENV CYPRESS_BUILD_NUMBER=$BUILD_NUMBER
ENV CYPRESS_EARTH_WEBSITE_URL=http://localhost:3000

CMD [ "node" ]
