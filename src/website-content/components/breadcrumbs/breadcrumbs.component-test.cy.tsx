import NextBreadcrumbs from './breadcrumbs';
import createMockedRouter from '../../testing/NextRouterMock'

describe('Breadcrumbs', () => {
    it('should render (example test)', () => {
      cy.mount(<NextBreadcrumbs router={createMockedRouter('test')} />);
      cy.get('body').contains('Wiki');
    })
})
