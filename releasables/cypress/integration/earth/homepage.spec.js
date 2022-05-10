/// <reference types="cypress" />

import HomePage from '../../flexport-earth-object-model/HomePage'

describe('Earth Homepage', () => {
  beforeEach(() => {
    cy.visit(Cypress.env('EARTH_WEBSITE_URL'))
  })

  it('Displays the Homepage', () => {
    cy.get('h1').should('contain', "Welcome to Earth")
  })

  it('Links to flexport.com', () => {
    new HomePage().Header.FlexportLogo.click()

    cy
      .url()
      .should('eq', 'https://www.flexport.com/')
  })
})
