'use client';

import Breadcrumbs                from '@mui/material/Breadcrumbs';
import Link                       from '@mui/material/Link';
import Image                      from 'next/image'
import { usePathname }            from 'next/navigation';
import React, { useEffect }       from 'react'
import Styles                     from './breadcrumbs.module.css'
import RightChevron               from 'public/images/right-chevron.svg'

// NOTE: This code adapted from https://dev.to/dan_starner/building-dynamic-breadcrumbs-in-nextjs-17oa

const _defaultGetTextGenerator          = (param: string)  => null;
const _defaultGetDefaultTextGenerator   = (path:  string, href:  string)          => path;

// Pulled out the path part breakdown because its
// going to be used by both `asPath` and `pathname`
const generatePathParts = (pathStr: string) => {
  const pathWithoutQuery = pathStr.split("?")[0];
  return pathWithoutQuery.split("/")
                         .filter(v => v.length > 0);
}

export function titleize(string: string) {
    return string.split('-').map((word) => {
        return word[0].toUpperCase() + word.substring(1);
    }).join(" ");
}

export default function NextBreadcrumbs({
  breadcrumbsComponentCssId = 'breadcrumbs',
  currentPageName           = '',
  doNotLinkList             = [''],
  getTextGenerator          = _defaultGetTextGenerator,
  getDefaultTextGenerator   = _defaultGetDefaultTextGenerator,
  router                    = ({}), // This parameter is primarily for unit tests to inject a mock.
  omitCrumbs                = ['Facts', 'Places', 'Vehicles']
}) {

    const pathname = usePathname();
    const generated = generatePathParts(pathname ?? "");
    //const searchParams = useSearchParams();

    const breadcrumbs = React.useMemo(


        function generateBreadcrumbs() {
            const crumblist = generated.map((subpath, idx) => {
                const href  = "/" + generated.slice(0, idx + 1).join("/");

                let text = '';

                if (idx == generated.length - 1 && currentPageName != '') {
                  text = currentPageName;
                } else {
                  text = getDefaultTextGenerator(titleize(subpath), href);
                }

                return {
                    href,
                    textGenerator:  getTextGenerator(currentPageName),
                    text:           text
                };
            });

            let allCrumbs = [{ href: "/", text: "Wiki" }, ...crumblist];

            return allCrumbs.filter(crumb =>
              !omitCrumbs.includes(crumb.text)
            );
        },
        [
          generated,
          currentPageName,
          getTextGenerator,
          getDefaultTextGenerator,
          omitCrumbs
        ]
    );

  return (
    <Breadcrumbs
      aria-label  = "breadcrumb"
      id          = {breadcrumbsComponentCssId}
      className   = {Styles.breadcrumbs}
      separator   = {
                    <Image
                        src   = {RightChevron}
                        alt   = "Right Chevron"
                        height= {10}
                        width = {10}
                    />}
    >
      {

        breadcrumbs.map((crumb, idx) => (
          <Crumb
            {...crumb}
            key      =  {idx}
            skipLink =  { // Skip making the crumb clickable if it's the last or,
                          // it's specified in the doNotLinkList.
                          idx === breadcrumbs.length - 1 ||
                          doNotLinkList.includes(crumb.text)
                        }
          />
        ))
      }
    </Breadcrumbs>
  );
}

type CrumbType = {
    text: string,
    href: string,
    skipLink: boolean
}

function Crumb(ct: CrumbType) {

  const [text, setText] = React.useState(ct.text);

  useEffect(
    () => {
        setText(text);
    },
    [text]
  );

  if (ct.skipLink) {
    return <span>{ct.text}</span>
  }

  return (
    <Link underline="hover" href={ct.href}>
      {ct.text}
    </Link>
  );
}
