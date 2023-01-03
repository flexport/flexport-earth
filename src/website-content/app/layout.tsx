import React from 'react';

import './globals.css'
import 'public/build-number.css'

export default function RootLayout({ children }: {
    children: React.ReactNode;
  }) {
    return (
      <html lang="en">
        <body>{children}</body>
      </html>
    );
  }
