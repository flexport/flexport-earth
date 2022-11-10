import 'styles/globals.css'
import 'styles/Fonts.css'
import 'public/build-number.css'

import { useEffect }      from 'react'
import { useRouter }      from 'next/router'
import { AppProps  }      from 'next/app'
import Script             from 'next/script'

import App from 'next/app'

import { NEXT_PUBLIC_GA4_MEASUREMENT_ID, pageview } from 'lib/google-analytics/ga4'

function MyApp({ Component, pageProps }: AppProps) {

  const router = useRouter()

  useEffect(() => {
    const handleRouteChange = (url: URL) => {
      pageview(url);
    }

    router.events.on('routeChangeComplete', handleRouteChange);

    return () => {
      router.events.off(
          'routeChangeComplete',
          handleRouteChange
      );
    };

  }, [router.events])

  return(
    <>
      {
        // Added GA support according to NextJs docs:
        // https://nextjs.org/docs/messages/next-script-for-ga#using-gtagjs
      }
      <Script
        src={`https://www.googletagmanager.com/gtag/js?id=${NEXT_PUBLIC_GA4_MEASUREMENT_ID}`}
        strategy="afterInteractive"
      />
      <Script id="google-analytics" strategy="afterInteractive">
        {`
          window.dataLayer = window.dataLayer || [];
          function gtag(){window.dataLayer.push(arguments);}
          gtag('js', new Date());

          gtag('config', '${NEXT_PUBLIC_GA4_MEASUREMENT_ID}');
        `}
      </Script>

      <Component {...pageProps} />
    </>
  )
}

MyApp.getInitialProps = async (appContext: any) => {
  // calls page's `getInitialProps` and fills `appProps.pageProps`
  const appProps = await App.getInitialProps(appContext);

  return { ...appProps }
}

export default MyApp
