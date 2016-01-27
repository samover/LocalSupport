require 'rails_helper'

describe BaseOrganisation, type: :model do
  describe '#has_been_updated_recently?' do
    subject { FactoryGirl.create(:organisation, updated_at: Time.now) }

    it { is_expected.to have_been_updated_recently }

    context "updated too long ago" do
      subject { FactoryGirl.create(:organisation, updated_at: 365.days.ago)}
      it { is_expected.not_to have_been_updated_recently }
    end

    context "when updated recently" do
      subject { FactoryGirl.create(:organisation, updated_at: 364.days.ago) }
      it { is_expected.to have_been_updated_recently }
    end
  end

  describe 'geocoding' do
    subject { FactoryGirl.create(:organisation, updated_at: 366.days.ago) }
    it 'should geocode when address changes' do
      new_address = '30 pinner road'
      is_expected.to receive(:geocode)
      subject.update_attributes :address => new_address
    end

    it 'should geocode when postcode changes' do
      new_postcode = 'HA1 4RZ'
      is_expected.to receive(:geocode)
      subject.update_attributes :postcode => new_postcode
    end

    it 'should geocode when new object is created' do
      address = '60 pinner road'
      postcode = 'HA1 4HZ'
      org = FactoryGirl.build(:organisation,:address => address, :postcode => postcode, :name => 'Happy and Nice', :gmaps => true)
      expect(org).to receive(:geocode)
      org.save
    end
  end

  describe '#add_url_protocol' do
    it 'should add the url protocol if absent' do
      org = FactoryGirl.create(:organisation, :website => 'friendly.org')
      org.add_url_protocol
      expect(org.website).to eq 'http://friendly.org'
    end

    it 'should leave url unchanged if prototcol present' do
      org = FactoryGirl.create(:organisation, :website => 'https://www.sup.org')
      org.add_url_protocol
      expect(org.website).to eq 'https://www.sup.org'
    end

    it 'should ignore empty urls' do
      org = FactoryGirl.create(:organisation, :website => '')
      org.add_url_protocol
      expect(org.website).to eq ''
    end
  end
end
