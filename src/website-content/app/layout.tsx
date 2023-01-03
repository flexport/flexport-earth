import React      from 'react';
import localFont  from '@next/font/local'

import './globals.css'
import 'public/build-number.css'

const GTAmerica = localFont({
  src: [
    {
      path:   './fonts/GT-America-Standard-Regular.woff2',
      weight: '400',
      style:  'normal'
    },
    {
      path:   './fonts/GT-America-Standard-Regular.woff',
      weight: '400',
      style:  'normal'
    },
    {
      path:   './fonts/GT-America-Standard-Regular-Italic.woff2',
      weight: '400',
      style:  'italic'
    },
    {
      path:   './fonts/GT-America-Standard-Regular-Italic.woff',
      weight: '400',
      style:  'italic'
    },
    {
      path:   './fonts/GT-America-Standard-Bold.woff2',
      weight: '700',
      style:  'normal'
    },
    {
      path:   './fonts/GT-America-Standard-Bold.woff',
      weight: '700',
      style:  'normal'
    },
    {
      path:   './fonts/GT-America-Extended-Bold.woff2',
      weight: '800',
      style:  'normal'
    },
    {
      path:   './fonts/GT-America-Extended-Bold.woff',
      weight: '800',
      style:  'normal'
    },
    {
      path:   './fonts/GT-America-Extended-Bold.eot',
      weight: '800',
      style:  'normal'
    }
  ]
});

export default function RootLayout({ children }: {
    children: React.ReactNode;
  }) {
    return (
      <html className={GTAmerica.className} lang="en">
        <body>
          {children}
        </body>
      </html>
    );
  }
