/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  i18n: {
    locales: ["en"],
    defaultLocale: "en",
  },
  images: {
    domains: ['assets.flexport.com'],
  },
  experimental: {
    images: {
      layoutRaw: true
    }
  }
}

module.exports = nextConfig
