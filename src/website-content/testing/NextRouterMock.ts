import type { NextRouter } from 'next/router';

const createMockedRouter = (
    route: string = '/some/path/[someQueryParam]',
    query: {  }   = { someQueryParam: 'val' }
  ): NextRouter => (
{
  basePath:         '',
  route:            route,
  pathname:         route,
  query:            query,
  asPath:           generateAsPath(route, query),
  isLocaleDomain:   false,
  push:             () => Promise.resolve(true),
  replace:          () => Promise.resolve(true),
  reload:           () => {},
  back:             () => {},
  prefetch:         () => Promise.resolve(),
  beforePopState:   () => {},
  forward:          () => {},
  events: {
    emit: () => {},
    on:   () => {},
    off:  () => {}
  },
  isFallback:       false,
  isReady:          true,
  isPreview:        false
})

function generateAsPath(
  route: string,
  query: any
): string {
  Object.entries(query)
    .forEach(
      ([key, value]) => route = route.replace(`[${key}]`, String(value))
    );

  return route;
}

export default createMockedRouter;
