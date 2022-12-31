import NextBreadcrumbs    from './breadcrumbs';
import createMockedRouter from '../../testing/NextRouterMock'

const breadcrumbsComponentCssId = 'breadcrumbs';
const breadcrumbListItemCss     = `#${breadcrumbsComponentCssId} li`;

describe('Breadcrumbs', () => {
    it('should start with Wiki', () => {
      // Arrange
      const mockedRouter = createMockedRouter();

      const breadcrumbsComponent =
        <NextBreadcrumbs
          router={mockedRouter}
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

    // it('should allow the current page to specify the last crumb page name', () => {
    //   // Arrange
    //   const testPageName = 'Test Page Name';

    //   let breadcrumbsComponent =
    //     <NextBreadcrumbs
    //       breadcrumbsComponentCssId = {breadcrumbsComponentCssId}
    //       currentPageName           = {testPageName}
    //       router                    = {createMockedRouter()}
    //     />;

    //   // Act
    //   cy.mount(breadcrumbsComponent);

    //   // Assert
    //   cy
    //     .get(breadcrumbListItemCss)
    //     .last()
    //     .should('have.text', testPageName);
    // })

    // it('should link all crumbs except the last', () => {
    //   // Arrange
    //   const testPageName = 'Test Page Name';

    //   let breadcrumbsComponent =
    //     <NextBreadcrumbs
    //       breadcrumbsComponentCssId = {breadcrumbsComponentCssId}
    //       router                    = {createMockedRouter(
    //                                     '/facts/places/terminal/[terminalCode]',
    //                                     {terminalCode: 'abc'}
    //                                   )}
    //     />;

    //   // Act
    //   cy.mount(breadcrumbsComponent);

    //   // Assert
    //   cy.get(breadcrumbListItemCss).contains('Terminal').should('have.attr', 'href');
    //   cy.get(breadcrumbListItemCss).last().should('not.have.attr', 'href');
    // })

    // it('should allow skipping linking of specific crumbs', () => {
    //   // Arrange
    //   const testPageName = 'Test Page Name';

    //   let breadcrumbsComponent =
    //     <NextBreadcrumbs
    //       breadcrumbsComponentCssId = {breadcrumbsComponentCssId}
    //       doNotLinkList             = {['Terminal']}
    //       router                    = {createMockedRouter(
    //                                     '/facts/places/terminal/[terminalCode]',
    //                                     {terminalCode: 'abc'}
    //                                   )}
    //     />;

    //   // Act
    //   cy.mount(breadcrumbsComponent);

    //   // Assert
    //   cy
    //     .get(breadcrumbListItemCss)
    //       .contains('Terminal')
    //           .should('not.have.attr', 'href');
    // })
})
