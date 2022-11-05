import NextBreadcrumbs    from './breadcrumbs';
import createMockedRouter from '../../testing/NextRouterMock'

const breadcrumbsComponentCssId = 'breadcrumbs';
const breadcrumbListItemCss     = `#${breadcrumbsComponentCssId} li`;

describe('Breadcrumbs', () => {
    it('should start with Wiki', () => {
      // Arrange
      const breadcrumbsComponent =
        <NextBreadcrumbs
          router={createMockedRouter()}
        />;

      // Act
      cy.mount(breadcrumbsComponent);

      // Assert
      cy
        .get(breadcrumbListItemCss)
        .first()
        .should('have.text', 'Wiki');
    })

    it('should generate the last crumb page name by default from the route', () => {
      // Arrange
      let breadcrumbsComponent =
        <NextBreadcrumbs
          breadcrumbsComponentCssId = {breadcrumbsComponentCssId}
          router                    = {createMockedRouter('page-route')}
        />;

      // Act
      cy.mount(breadcrumbsComponent);

      // Assert
      cy
        .get(breadcrumbListItemCss)
        .last()
        .should('have.text', 'Page Route');
    })

    it('should allow the current page to specify the last crumb page name', () => {
      // Arrange
      const testPageName = 'Test Page Name';

      let breadcrumbsComponent =
        <NextBreadcrumbs
          breadcrumbsComponentCssId = {breadcrumbsComponentCssId}
          currentPageName           = {testPageName}
          router                    = {createMockedRouter()}
        />;

      // Act
      cy.mount(breadcrumbsComponent);

      // Assert
      cy
        .get(breadcrumbListItemCss)
        .last()
        .should('have.text', testPageName);
    })
})
