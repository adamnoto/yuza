require "rails_helper"

describe SessionsController, type: :controller do
  let(:user) { create_user }
  before {
    create_password(user, password_attributes)
  }

  context 'creating session' do
    let(:params) {
      {
        session: {
          user: {
            email: user.email,
            password: 'Password01',
            app: 'pageok'
          },
          validity_minutes: 30
        }
      }
    }

    describe 'POST #create' do
      it 'can create the session' do
        expect(Session.count).to eq 0
        post :create, params: params
        expect(Session.count).to eq 1

        session = Session.first
        expect(session.user).to eq user
        expect(session.expiry_time > 28.minutes.from_now).to be true
        expect(session.ip).to_not be_blank
        expect(session.invalid?).to be false
      end
    end # POST create
  end # creating session

  context 'revoking session' do
    let(:session) { create_session(user) }
    let(:params) {
      {
        session: {
          code: session.code
        }
      }
    }

    describe 'DELETE #revoke' do
      it 'can invalidate a session' do
        expect(session.invalid?).to be false
        delete :revoke, params: params
        session.reload
        expect(session.invalid?).to be true
        expect(parsed_body[:data][:invalid]).to be true
      end # invalidate
    end # DELETE #revoke
  end # revoking session

  context 'checking validity' do
  end
end # SessionsController