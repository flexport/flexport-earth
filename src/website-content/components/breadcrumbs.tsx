import Breadcrumbs              from '@mui/material/Breadcrumbs';
import Link                     from '@mui/material/Link';
import Image                    from 'next/image'
import { useRouter }            from 'next/router';
import React, { useEffect }     from 'react'
import type { ParsedUrlQuery }  from 'querystring'
import Styles                   from '../styles/components/breadcrumbs.module.css'

// NOTE: This code adapted from https://dev.to/dan_starner/building-dynamic-breadcrumbs-in-nextjs-17oa

const _defaultGetTextGenerator          = (param: string, query: ParsedUrlQuery) => null;
const _defaultGetDefaultTextGenerator   = (path: string, href: string) => path;

// Pulled out the path part breakdown because its
// going to be used by both `asPath` and `pathname`
const generatePathParts = (pathStr: string) => {
  const pathWithoutQuery = pathStr.split("?")[0];
  return pathWithoutQuery.split("/")
                         .filter(v => v.length > 0);
}

function titleize(string: string) {
    return string.split('-').map((word) => {
        return word[0].toUpperCase() + word.substring(1);
    }).join(" ");
}

export default function NextBreadcrumbs({
  getTextGenerator=_defaultGetTextGenerator,
  getDefaultTextGenerator=_defaultGetDefaultTextGenerator,
}) {
    const router = useRouter();

    const breadcrumbs = React.useMemo(
        function generateBreadcrumbs() {
            const asPathNestedRoutes   = generatePathParts(router.asPath);
            const pathnameNestedRoutes = generatePathParts(router.pathname);

            const crumblist = asPathNestedRoutes.map((subpath, idx) => {
                const param = pathnameNestedRoutes[idx].replace("[", "").replace("]", "");
                const href  = "/" + asPathNestedRoutes.slice(0, idx + 1).join("/");

                return {
                    href,
                    textGenerator:  getTextGenerator(param, router.query),
                    text:           getDefaultTextGenerator(titleize(subpath), href)
                };
            });

            let allCrumbs = [{ href: "/", text: "Wiki" }, ...crumblist];

            return allCrumbs.filter(v =>
              v.text != 'Facts' &&
              v.text != 'Places' &&
              v.text != 'Vehicles'
            );
        },
        [router.asPath, router.pathname, router.query, getTextGenerator, getDefaultTextGenerator]
    );

  return (
    <Breadcrumbs aria-label="breadcrumb" className={Styles.breadcrumbs} separator={
        <Image
            src="/images/right-chevron.svg"
            alt="Right Chevron"
            height={10}
            width={10}
        />}
    >

      {breadcrumbs.map((crumb, idx) => (
        <Crumb {...crumb} key={idx} last={idx === breadcrumbs.length - 1} />
      ))}
    </Breadcrumbs>
  );
}

type CrumbType = {
    text: string,
    href: string,
    last: boolean
}

function Crumb(ct: CrumbType) {

  const [text, setText] = React.useState(ct.text);

  useEffect(
    () => {
        // // If `textGenerator` is nonexistent, then don't do anything
        // if (!Boolean(textGenerator)) { return; }
        // // Run the text generator and set the text again
        // const finalText = await textGenerator();
        setText(text);
    },
    [text]
  );

  if (ct.last) {
    return <span>{ct.text}</span>
  }

  return (
    <Link underline="hover" href={ct.href}>
      {ct.text}
    </Link>
  );
}
