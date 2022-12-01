const { defineConfig } = require("cypress");

module.exports = defineConfig({
  viewportWidth: 1920,
  viewportHeight: 1200,
  videosFolder: "results/videos",
  screenshotsFolder: "results/screenshots",
  e2e: {
    setupNodeEvents() {
      // implement node event listeners here
    },
    specPattern: "**/*.spec.ts"
  },
  chromeWebSecurity: false
});

export {};