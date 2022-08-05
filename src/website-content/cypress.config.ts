import { defineConfig } from "cypress";

export default defineConfig({
  component: {
    video: false,
    devServer: {
      framework: "next",
      bundler: "webpack",
    },
  },
});
