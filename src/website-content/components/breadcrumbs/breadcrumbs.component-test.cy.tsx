import NextBreadcrumbs    from './breadcrumbs';

const breadcrumbsComponentCssId = 'breadcrumbs';
const breadcrumbListItemCss     = `#${breadcrumbsComponentCssId} li`;

describe('Breadcrumbs', () => {
    it('should start with Wiki', () => {
      // Arrange
      const breadcrumbsComponent = <NextBreadcrumbs />;

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
          urlPath                   = '/some/path/page-route'
          breadcrumbsComponentCssId = {breadcrumbsComponentCssId}
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

      const breadcrumbsComponent =
        <NextBreadcrumbs
          urlPath                   = '/some/path/page-route'
          breadcrumbsComponentCssId = {breadcrumbsComponentCssId}
          currentPageName           = {testPageName}
        />;

      // Act
      cy.mount(breadcrumbsComponent);

      // Assert
      cy
        .get(breadcrumbListItemCss)
        .last()
        .should(
          'have.text',
          testPageName
        );
    })

    it('should link all crumbs except the last', () => {
      // Arrange
      const breadcrumbsComponent =
        <NextBreadcrumbs
          urlPath                   = '/some/path/page-route'
          breadcrumbsComponentCssId = {breadcrumbsComponentCssId}
        />;

      // Act
      cy.mount(breadcrumbsComponent);

      // Assert
      cy
        .get(breadcrumbListItemCss)
        .last()
        .should(
          'not.have.attr',
          'href'
        );
    })

    it('should allow skipping linking of specific crumbs', () => {
      // Arrange
      const breadcrumbsComponent =
        <NextBreadcrumbs
          urlPath                   = '/some/path/page-route'
          breadcrumbsComponentCssId = {breadcrumbsComponentCssId}
          doNotLinkList             = {['Path']}
        />;

      // Act
      cy.mount(breadcrumbsComponent);

      // Assert
      cy
        .get(breadcrumbListItemCss)
        .contains('Path')
        .should(
          'not.have.attr',
          'href'
        );
    })
})
