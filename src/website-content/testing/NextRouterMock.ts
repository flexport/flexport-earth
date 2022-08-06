import type { NextRouter } from 'next/router';

const createMockedRouter = (page: string): NextRouter => ({
  basePath: '',
  route: '/page/[page]',
  pathname: '/page/[page]',
  query: {
    page
  },
  asPath: `/page/${page}`,
  isLocaleDomain: false,
  push: () => Promise.resolve(true),
  replace: () => Promise.resolve(true),
  reload: () => {},
  back: () => {},
  prefetch: () => Promise.resolve(),
  beforePopState: () => {},
  events: {
    emit: () => {},
    on: () => {},
    off: () => {}
  },
  isFallback: false,
  isReady: true,
  isPreview: false
})

export default createMockedRouter;
