# frozen_string_literal: true
require 'status_code'

describe StatusCode do
  describe '#decode' do
    subject { StatusCode.new(code, locale).decode(receiver) }

    context 'with english language' do
      let(:locale) { :en }

      context 'with merchant receiver' do
        let(:receiver) { :merchant }

        context 'with approval code' do
          let(:code) { '000' }
          let(:message) { 'Approved' }

          it 'returns approve message' do
            expect(subject).to eql(message)
          end
        end

        context 'with decline code' do
          let(:code) { '100' }
          let(:message) { 'Decline (general, no comments)' }

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
          let(:code) { '000' }
          let(:message) { 'Approved' }

          it 'returns approve message' do
            expect(subject).to eql(message)
          end
        end

        context 'with decline code' do
          let(:code) { '100' }
          let(:message) do
            'The payment has been declined by your card bank.' \
              ' Call the bank support line to find out a reason.' \
              ' Your bank phone number is on the card back side.'
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
    end

    context 'with russian language' do
      let(:locale) { :ru }

      context 'with merchant receiver' do
        let(:receiver) { :merchant }

        context 'with approval code' do
          let(:code) { '000' }
          let(:message) { 'Одобрено' }

          it 'returns approve message' do
            expect(subject).to eql(message)
          end
        end

        context 'with decline code' do
          let(:code) { '100' }
          let(:message) { 'Отказ' }

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
          let(:code) { '000' }
          let(:message) { 'Одобрено' }

          it 'returns approve message' do
            expect(subject).to eql(message)
          end
        end

        context 'with decline code' do
          let(:code) { '100' }
          let(:message) do
            'Платеж отклонен банком, выпустившим вашу карту.' \
              ' Обратитесь в банк за разъяснением.' \
              ' Контактный телефон на обратной стороне карты.'
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
    end

    context 'when locale is unknown' do
      let(:locale) { :zz }
      let(:code) { '000' }

      it 'returns approve message' do
        StatusCode.new(code, locale)

        expect(I18n.locale).to eql(:en)
      end
    end

    context "when locale isn's set" do
      let(:code) { '000' }

      it 'returns approve message' do
        StatusCode.new(code)

        expect(I18n.locale).to eql(:en)
      end
    end
  end
end
