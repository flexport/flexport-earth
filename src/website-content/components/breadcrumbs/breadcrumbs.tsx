import Breadcrumbs                from '@mui/material/Breadcrumbs';
import Link                       from '@mui/material/Link';
import Image                      from 'next/image'
import { NextRouter, useRouter }  from 'next/router';
import React, { useEffect }       from 'react'
import type { ParsedUrlQuery }    from 'querystring'
import Styles                     from './breadcrumbs.module.css'
import RightChevron               from '../../public/images/right-chevron.svg'

// NOTE: This code adapted from https://dev.to/dan_starner/building-dynamic-breadcrumbs-in-nextjs-17oa

const _defaultGetTextGenerator          = (param: string, query: ParsedUrlQuery)  => null;
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
  router                    = ({} as NextRouter) // This parameter is primarily for unit tests to inject a mock.
}) {
    const nextRouter = useRouter();

    if (router.asPath == undefined) {
      router = nextRouter;
    }

    const breadcrumbs = React.useMemo(
        function generateBreadcrumbs() {
            const asPathNestedRoutes   = generatePathParts(router.asPath);
            const pathnameNestedRoutes = generatePathParts(router.pathname);

            const crumblist = asPathNestedRoutes.map((subpath, idx) => {
                const param = pathnameNestedRoutes[idx].replace("[", "").replace("]", "");
                const href  = "/" + asPathNestedRoutes.slice(0, idx + 1).join("/");

                let text = '';

                if (idx == asPathNestedRoutes.length - 1 && currentPageName != '') {
                  text = currentPageName;
                } else {
                  text = getDefaultTextGenerator(titleize(subpath), href);
                }

                return {
                    href,
                    textGenerator:  getTextGenerator(param, router.query),
                    text:           text
                };
            });

            let allCrumbs = [{ href: "/", text: "Wiki" }, ...crumblist];

            // TODO: Refactor: Move specific crumb names to filter outside of the Breadcrumb component.

            console.log(doNotLinkList[0]);

            return allCrumbs.filter(v =>
              v.text != 'Facts' &&
              v.text != 'Places' &&
              v.text != 'Vehicles'
            );
        },
        [
          router.asPath,
          router.pathname,
          router.query,
          currentPageName,
          doNotLinkList,
          getTextGenerator,
          getDefaultTextGenerator
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
          <Crumb {...crumb} key={idx} skipLink={idx === breadcrumbs.length - 1 || doNotLinkList.includes(crumb.text)} />
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
