# frozen_string_literal: true
require 'status_code'

describe StatusCode do
  describe '#decode' do
    context 'with locale' do
      subject do
        StatusCode.decode(code, receiver: receiver, locale: locale)
      end

      context 'with English locale' do
        let(:locale) { :en }

        context 'with merchant receiver' do
          let(:receiver) { :merchant }

          context 'with approval code' do
            let(:code) { 'S.0000' }
            let(:message) { 'Transaction successful.' }

            it 'returns approve message' do
              expect(subject).to eql(message)
            end
          end

          context 'with decline code' do
            let(:code) { 'F.0100' }
            let(:message) { 'Payment account blocked. Ask the customer to check their account details.' }

            it 'returns decline message' do
              expect(subject).to eql(message)
            end
          end

          context 'with unknown code and without status option' do
            let(:code) { '99999' }
            it 'returns nil' do
              expect(subject).to be_nil
            end
          end
        end

        context 'with customer receiver' do
          let(:receiver) { :customer }

          context 'with approval code' do
            let(:code) { 'S.0000' }
            let(:friendly_message) { 'Transaction successful.' }

            it 'returns approve friendly_message' do
              expect(subject).to eql(friendly_message)
            end
          end

          context 'with decline code' do
            let(:code) { 'F.0100' }
            let(:friendly_message) do
              'Your account is blocked. Check your account details.'
            end

            it 'returns decline friendly_message' do
              expect(subject).to eql(friendly_message)
            end
          end

          context 'with unknown code and without status option' do
            let(:code) { '99999' }

            it 'returns nil' do
              expect(subject).to eql nil
            end
          end
        end
      end

      context 'with Russian locale' do
        let(:locale) { :ru }

        context 'with merchant receiver' do
          let(:receiver) { :merchant }

          context 'with approval code' do
            let(:code) { 'S.0000' }
            let(:message) { 'Транзакция успешна.' }

            it 'returns approve message' do
              expect(subject).to eql(message)
            end
          end

          context 'with decline code' do
            let(:code) { 'F.0100' }
            let(:message) do
              'Платёжный счёт заблокирован. Попросите плательщика проверить данные счёта.'
            end

            it 'returns decline message' do
              expect(subject).to eql(message)
            end
          end

          context 'with unknown code' do
            let(:code) { '99999' }
            it 'returns nil' do
              expect(subject).to be_nil
            end
          end
        end

        context 'with customer receiver' do
          let(:receiver) { :customer }

          context 'with approval code' do
            let(:code) { 'S.0000' }
            let(:friendly_message) { 'Транзакция успешна.' }

            it 'returns approve friendly_message' do
              expect(subject).to eql(friendly_message)
            end
          end

          context 'with decline code' do
            let(:code) { 'F.0100' }
            let(:friendly_message) do
              'Ваш счёт заблокирован. Проверьте данные счёта.'
            end

            it 'returns decline friendly_message' do
              expect(subject).to eql(friendly_message)
            end
          end

          context 'with unknown code and without status option' do
            let(:code) { '99999' }

            it 'returns nil' do
              expect(subject).to eq nil
            end
          end
        end
      end

      context 'with Azerbaijani locale' do
        let(:locale) { :az }

        context 'with merchant receiver' do
          let(:receiver) { :merchant }

          context 'with approval code' do
            let(:code) { 'S.0000' }
            let(:message) { 'Əməliyyat uğurlu oldu.' }

            it 'returns approve message' do
              expect(subject).to eql(message)
            end
          end

          context 'with decline code' do
            let(:code) { 'F.0100' }
            let(:message) do
              'Ödəniş hesabı bloklanıb. Ödəyicidən hesab məlumatlarını yoxlamasını xahiş edin.'
            end

            it 'returns decline message' do
              expect(subject).to eql(message)
            end
          end

          context 'with unknown code' do
            let(:code) { '99999' }
            it 'returns nil' do
              expect(subject).to be_nil
            end
          end
        end

        context 'with customer receiver' do
          let(:receiver) { :customer }

          context 'with approval code' do
            let(:code) { 'S.0000' }
            let(:friendly_message) { 'Əməliyyat uğurlu oldu.' }

            it 'returns approve friendly_message' do
              expect(subject).to eql(friendly_message)
            end
          end

          context 'with decline code' do
            let(:code) { 'F.0100' }
            let(:friendly_message) do
              'Hesabınız bloklanıb. Hesab məlumatlarınızı yoxlayın.'
            end

            it 'returns decline friendly_message' do
              expect(subject).to eql(friendly_message)
            end
          end

          context 'with unknown code' do
            let(:code) { '99999' }
            let(:message) { 'İmtina' }

            it 'returns nil' do
              expect(subject).to eql nil
            end
          end
        end
      end

      context 'with Belarus locale' do
        let(:receiver) { :customer }
        let(:locale) { :be }

        subject do
          StatusCode.decode(code, receiver: receiver, locale: locale)
        end

        context 'with Approved code' do
          let(:code) { 'S.0000' }
          let(:friendly_message) { 'Транзакцыя паспяховая.' }

          it 'returns approve friendly_message' do
            expect(subject).to eql(friendly_message)
          end
        end

        context 'without code and status option' do
          let(:code) { nil }

          it 'returns decline message' do
            expect(subject).to eql nil
          end
        end
      end

      context 'with unknown locale' do
        let(:locale) { :zz }
        let(:receiver) { :customer }
        let(:code) { 'S.0000' }

        it 'returns nil' do
          expect(subject).to be_nil
        end
      end
    end

    context 'without locale' do
      subject { StatusCode.decode(code, receiver: receiver) }

      context 'without locale' do
        let(:code) { 'S.0000' }
        let(:receiver) { :customer }
        let(:friendly_message) { 'Transaction successful.' }

        it 'returns approve friendly_message' do
          expect(subject).to eql(friendly_message)
        end
      end
    end

    context 'when locale is nil' do
      subject do
        StatusCode.decode(code, receiver: receiver, locale: locale)
      end

      let(:receiver) { :merchant }
      let(:locale) { nil }
      let(:code) { 'S.0000' }
      let(:message) { 'Transaction successful.' }

      it 'returns approve message' do
        expect(subject).to eql(message)
      end
    end

    context 'without locale' do
      subject do
        StatusCode.decode(code, receiver: receiver)
      end

      let(:receiver) { :merchant }

      context 'when code is nil' do
        let(:code) { nil }

        it 'returns nil' do
          expect(subject).to be nil
        end
      end

      context 'when code is a whitespace' do
        let(:code) { ' ' }

        it 'returns nil' do
          expect(subject).to be_nil
        end
      end
    end

    context 'with code only' do
      let(:code) { 'F.0100' }
      let(:friendly_message) do
        'Your account is blocked. Check your account details.'
      end

      it 'returns friendly message' do
        expect(StatusCode.decode(code)).to eql(friendly_message)
      end
    end

    context 'with invalid code and valid status option for customer receiver' do
      subject { StatusCode.decode(code, receiver: :customer, status: status, locale: :en) }

      context "with true status (successful) and wrong code " do
        let(:code) { 'wrong_code' }
        let(:status) { true }

        it 'returns Approved friendly_message' do
          expect(subject).to eql 'Transaction successful.'
        end
      end

      context "without code and with true status (successful)" do
        let(:code) { nil }
        let(:status) { true }

        it 'returns Approved friendly_message' do
          expect(subject).to eql 'Transaction successful.'
        end
      end

      context "with false status (failed) and wrong code" do
        let(:code) { 'wrong_code' }
        let(:status) { false }

        it 'returns Decline message' do
          expect(subject).to eql 'Transaction declined. Try again or contact the merchant for details.'
        end
      end

      context "without code and with false status (failed)" do
        let(:code) { nil }
        let(:status) { false }

        it 'returns Decline message' do
          expect(subject).to eql 'Transaction declined. Try again or contact the merchant for details.'
        end
      end
    end
  end
end
