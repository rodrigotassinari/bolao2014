require 'spec_helper'

describe ApplicationHelper do

  describe '#css_class_for_flash_type' do
    {
      success: 'success',
      secondary: 'secondary',
      info: 'info',
      notice: '',
      alert: 'warning',
      warning: 'warning',
      error: 'alert',
      failure: 'alert',
    }.each do |type, css_class|
      it "returns the css class '#{css_class}' when the flash type is '#{type}'" do
        expect(helper.css_class_for_flash_type(type)).to eq(css_class)
      end
    end
  end

end
