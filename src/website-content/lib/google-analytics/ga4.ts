import getConfig from 'next/config';

const { publicRuntimeConfig } = getConfig();

// This code adopted from:
// https://dev.to/asross311/strongly-typed-google-analytics-v4-with-nextjs-4g13

export const NEXT_PUBLIC_GA4_MEASUREMENT_ID = publicRuntimeConfig.NEXT_PUBLIC_GAID;

console.log(`NEXT_PUBLIC_GA4_MEASUREMENT_ID: ${NEXT_PUBLIC_GA4_MEASUREMENT_ID}`);

export const pageview = (url: URL) => {
    window.gtag('config', NEXT_PUBLIC_GA4_MEASUREMENT_ID, {
        page_path: url
    });
};

export const event = (
    action: Gtag.EventNames,
    { event_category, event_label, value }: Gtag.EventParams
) => {
    window.gtag('event', action, {
        event_category,
        event_label,
        value
    });
};
