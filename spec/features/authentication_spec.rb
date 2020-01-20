# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Merchant sign in', type: :feature do
<<<<<<< Updated upstream
  let(:merchant) { build_stubbed(:merchant) }

  before { allow(Merchant).to receive(:find).and_return(merchant) }
=======
  before do
    allow(Merchant).to receive(:active).and_return(Merchant)
    allow(Merchant).to receive(:find).with(merchant.id).and_return(merchant)
  end
>>>>>>> Stashed changes

  describe 'Sign in', type: :feature do
    let(:merchant) { build_stubbed(:merchant) }

    context 'with valid token' do
      let(:token) { generate_token(merchant) }

      it 'signs in Merchant' do
        visit merchants_path

        expect(page).to have_text('Login')
        fill_in :session_token, with: token
        click_button 'Login'

        expect(page).to have_text('Listing merchants')
      end
    end

    context 'with invalid token' do
      it 'signs in Merchant' do
        visit merchants_path

        expect(page).to have_text('Login')
        fill_in :session_token, with: 'invalid'
        click_button 'Login'

        expect(page).to have_text('Invalid authentication')
      end
    end
  end

  describe 'Sign out', type: :feature do
    let(:merchant) { build_stubbed(:merchant) }
    let(:token)    { generate_token(merchant) }

    before { allow(Merchant).to receive(:find).and_return(merchant) }

    it 'signs in Merchant' do
      visit merchants_path

      expect(page).to have_text('Login')
      fill_in :session_token, with: token
      click_button 'Login'

      click_link 'Logout'
      visit merchants_path

      expect(page).to have_text('Login')
    end
  end
end
