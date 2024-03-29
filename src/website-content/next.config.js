/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  i18n: {
    locales: ["en"],
    defaultLocale: "en",
  },
  staticPageGenerationTimeout: 500,
  images: {
    domains: ['assets.flexport.com'],
    minimumCacheTTL: 60
  },
  async redirects() {
    return [
      {
        source: '/facts/country',
        destination: '/facts/countries',
        permanent: true,
      },
      {
        source: '/facts/places/port',
        destination: '/facts/places/ports',
        permanent: true,
      },
      {
        source: '/facts/vehicles/vessel',
        destination: '/facts/vehicles/vessels',
        permanent: true,
      },
    ]
  },
  publicRuntimeConfig: {
    staticFolder: '/static',
    NEXT_PUBLIC_GAID: process.env.NEXT_PUBLIC_GOOGLE_ANALYTICS_MEASUREMENT_ID
  }
}

module.exports = nextConfig
