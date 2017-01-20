# frozen_string_literal: true
require 'status_code'

describe StatusCode do
  describe '#decode' do
    context 'with default locale' do
      context 'with merchant receiver' do
        let(:receiver) { :merchant }

        context 'with approval code' do
          let(:code) { '000' }
          let(:message) { 'Approved' }

          it 'returns approve message' do
            expect(StatusCode.new(code).decode(receiver)).to eql(message)
          end
        end

        context 'with decline code' do
          let(:code) { '100' }
          let(:message) { 'Decline (general, no comments)' }

          it 'returns decline message' do
            expect(StatusCode.new(code).decode(receiver)).to eql(message)
          end
        end

        context 'with unknown code' do
          let(:code) { '99999' }
          it 'returns nil' do
            expect(StatusCode.new(code).decode(receiver)).to be_nil
          end
        end
      end

      context 'with customer receiver' do
        let(:receiver) { :customer }

        context 'with approval code' do
          let(:code) { '000' }
          let(:message) { 'Approved' }

          it 'returns approve message' do
            expect(StatusCode.new(code).decode(receiver)).to eql(message)
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
            expect(StatusCode.new(code).decode(receiver)).to eql(message)
          end
        end

        context 'with unknown code' do
          let(:code) { '99999' }

          it 'returns nil' do
            expect(StatusCode.new(code).decode(receiver)).to be_nil
          end
        end
      end
    end

    context 'with :ru locale' do
      let(:locale) { :ru }
      context 'with merchant receiver' do
        let(:receiver) { :merchant }

        context 'with approval code' do
          let(:code) { '000' }
          let(:message) { 'Одобрено' }

          it 'returns approve message' do
            expect(StatusCode.new(code, locale)
                              .decode(receiver)).to eql(message)
          end
        end

        context 'with decline code' do
          let(:code) { '100' }
          let(:message) { 'Отказ' }

          it 'returns decline message' do
            expect(StatusCode.new(code, locale)
                              .decode(receiver)).to eql(message)
          end
        end

        context 'with unknown code' do
          let(:code) { '99999' }
          it 'returns nil' do
            expect(StatusCode.new(code, locale).decode(receiver)).to be_nil
          end
        end
      end

      context 'with customer receiver' do
        let(:receiver) { :customer }

        context 'with approval code' do
          let(:code) { '000' }
          let(:message) { 'Одобрено' }

          it 'returns approve message' do
            expect(StatusCode.new(code, locale)
                              .decode(receiver)).to eql(message)
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
            expect(StatusCode.new(code, locale)
                              .decode(receiver)).to eql(message)
          end
        end

        context 'with unknown code' do
          let(:code) { '99999' }

          it 'returns nil' do
            expect(StatusCode.new(code, locale).decode(receiver)).to be_nil
          end
        end
      end
    end
  end
end
