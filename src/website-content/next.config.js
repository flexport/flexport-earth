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
  experimental: {
    images: {
      layoutRaw: true
    }
  }
}

module.exports = nextConfig
