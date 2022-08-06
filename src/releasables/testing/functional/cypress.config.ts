const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    setupNodeEvents() {
      // implement node event listeners here
    },
    specPattern: "**/*.spec.js"
  },
  chromeWebSecurity: false
});

export {};