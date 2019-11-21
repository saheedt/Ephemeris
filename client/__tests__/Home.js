import React from 'react';
import Enzyme, { shallow } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import Home from '../components/Home';

Enzyme.configure({ adapter: new Adapter() });

describe('<Home />', () => {
  const wrapper = shallow(<Home />);

  test('should render div with correct text', () => {
    expect(wrapper.find('div').text()).toEqual('This is the Home page');
  });
});
