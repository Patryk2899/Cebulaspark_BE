require 'rails_helper'

RSpec.describe LinkValidationService, type: :model do
  describe 'link validation service test' do
    it 'should return true - valid url' do
      expect(LinkValidationService.new('https://www.google.com').valid?).to be true
    end

    it 'should return false - param is not an url' do
      expect(LinkValidationService.new('not an url').valid?).to be false
    end

    it 'should return false - param is not a safe url' do
      expect(LinkValidationService.new('https://testsafebrowsing.appspot.com/apiv4/ANY_PLATFORM/MALWARE/URL/').valid?).to be false
    end
  end
end
