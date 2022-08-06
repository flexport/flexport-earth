import { titleize } from './breadcrumbs';

describe('Breadcrumbs', () => {
    it('Titleize should upper case first letter', () => {
        assert(titleize('test') == 'Test');
    })
})
