import { titleize } from './breadcrumbs';

describe('Breadcrumbs', () => {
    it('Titleize should upper case first letter', () => {
        assert(titleize('test') == 'Test');
    })

    it('Titleize should replace hyphens with spaces', () => {
        assert(titleize('test-titleize') == 'Test Titleize');
    })
})
