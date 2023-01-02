'use client';

import React, { useEffect }       from 'react'

import Image                      from 'next/image'
import { usePathname }            from 'next/navigation';

import Breadcrumbs                from '@mui/material/Breadcrumbs';
import Link                       from '@mui/material/Link';

import Styles                     from './breadcrumbs.module.css'
import RightChevron               from 'public/images/right-chevron.svg'

// NOTE: This code adapted from https://dev.to/dan_starner/building-dynamic-breadcrumbs-in-nextjs-17oa

const _defaultGetTextGenerator          = (param: string)  => null;
const _defaultGetDefaultTextGenerator   = (path:  string, href:  string)  => path;

// Pulled out the path part breakdown because its
// going to be used by both `asPath` and `pathname`
const getPathParts = (pathStr: string) => {
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
  urlPath                   = '',
  breadcrumbsComponentCssId = 'breadcrumbs',
  currentPageName           = '',
  doNotLinkList             = [''],
  getTextGenerator          = _defaultGetTextGenerator,
  getDefaultTextGenerator   = _defaultGetDefaultTextGenerator,
  omitCrumbs                = ['Facts', 'Places', 'Vehicles']
}) {
    // Get the current path from NextJS.
    const pathname = usePathname();

    // Set the urlPath that we'll parse into breadcrumbs.
    // Typically, the urlPath will come from usePathname()...
    // However, during component testing scenarios where tests
    // will supply the path, then the the urlPath parameter will
    // be used instead of usePathname().
    if (urlPath == '') {
      urlPath = pathname ?? '';
    }

    console.log('');
    console.log(`urlPath: ${urlPath}`)
    console.log('');

    const pathParts = getPathParts(urlPath);

    const breadcrumbs = React.useMemo(
        function generateBreadcrumbs() {
            // Create a crumb for each part of the path.
            const crumblist = pathParts.map((subpath, idx) => {
                // Assemble the href for the current crumb.
                const crumbHref     = "/" + pathParts.slice(0, idx + 1).join("/");
                let   crumbLinkText = '';

                // Assemble the link text for the current crumb.
                if (idx == pathParts.length - 1 && currentPageName != '') {
                  crumbLinkText = currentPageName;
                } else {
                  crumbLinkText = getDefaultTextGenerator(
                    titleize(subpath),
                    crumbHref
                  );
                }

                return {
                  href:           crumbHref,
                  textGenerator:  getTextGenerator(currentPageName),
                  text:           crumbLinkText
                };
            });

            let allCrumbs = [{ href: "/", text: "Wiki" }, ...crumblist];

            return allCrumbs.filter(crumb =>
              !omitCrumbs.includes(crumb.text)
            );
        },
        [
          pathParts,
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
    text:     string,
    href:     string,
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
