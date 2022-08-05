// cypress/integration/app.spec.js

import NextBreadcrumbs from './breadcrumbs';
import type { NextRouter } from 'next/router';

// TODO: Refactor into separate reusable file.
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

describe('Breadcrumbs', () => {
    it('should render (example test)', () => {
      cy.mount(<NextBreadcrumbs router={createMockedRouter('test')} />);
      cy.get('body').contains('Wiki');
    })
  })

const asModule = {}
export default asModule
