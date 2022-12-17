FROM cypress/included:12.1.0

ARG BUILD_NUMBER

COPY cypress.io/ /cypress.io/

WORKDIR /cypress.io

RUN npm install

# Environment variables set from buildtime arguments:
ENV CYPRESS_BUILD_NUMBER=$BUILD_NUMBER

# Environment variables set from runtime argument:
ENV CYPRESS_VIEWPORT_HEIGHT=1200
ENV CYPRESS_VIEWPORT_WIDTH=1920
ENV CYPRESS_EARTH_WEBSITE_URL=http://localhost:3000

ENTRYPOINT [ "cypress", "run", "--browser", "chrome", "--config", "video=false" ]
