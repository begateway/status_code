# frozen_string_literal: true
require 'status_code'

describe StatusCode do
  describe '#decode' do
    context 'with definite locale' do
      subject { StatusCode.new(code, locale: locale).decode(receiver) }

      context 'with english locale' do
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
                ' Your bank phone number is on the card back side'
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

      context 'with russian locale' do
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
                ' Контактный телефон на обратной стороне карты'
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
    end

    context 'when locale is unknown' do
      let(:locale) { :zz }
      let(:code) { '000' }

      it 'returns approve message' do
        StatusCode.new(code, locale: locale)

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

    context 'with gateway' do
      let(:receiver) { :merchant }
      subject { StatusCode.new(code, gateway: gateway).decode(receiver) }

      context 'with special gateway code' do
        let(:gateway) { 'payvision' }
        let(:code) { '130' }
        let(:message) { 'Decline, invalid Track2' }

        it 'returns approve message' do
          expect(subject).to eql(message)
        end
      end

      context 'with general code' do
        let(:gateway) { 'payvision' }
        let(:code) { '000' }
        let(:message) { 'Approved' }

        it 'returns approve message' do
          expect(subject).to eql(message)
        end
      end

      context 'with unknown gateway' do
        let(:gateway) { 'ZZZZZ' }
        let(:code) { '000' }
        let(:message) { 'Approved' }

        it 'returns approve message' do
          expect(subject).to eql(message)
        end
      end

      context 'with locale' do
        subject do
          StatusCode.new(code, gateway: gateway, locale: locale)
                    .decode(receiver)
        end

        context 'with mtb_halva gateway' do
          let(:receiver) { :merchant }
          let(:gateway) { 'mtb_halva' }
          let(:locale) { :en }
          let(:code) { '002' }
          let(:message) { 'Approved for a partial amount' }

          it 'returns approve message' do
            expect(subject).to eql(message)
          end
        end

        context 'with Norwegian locale' do
          let(:receiver) { :customer }
          let(:gateway) { 'mtb_halva' }
          let(:locale) { :no }
          let(:code) { '000' }
          let(:message) { 'Godkjent' }

          it 'returns approve message' do
            expect(subject).to eql(message)
          end
        end
      end
    end

    context 'when gateway and locale are nil' do
      subject do
        StatusCode.new(code, gateway: gateway, locale: locale).decode(receiver)
      end
      let(:receiver) { :merchant }
      let(:gateway) { nil }
      let(:locale) { nil }
      let(:code) { '000' }
      let(:message) { 'Approved' }

      it 'returns approve message' do
        expect(subject).to eql(message)
      end
    end

    context 'without gateway and locale' do
      context 'when code is nil' do
        let(:code) { nil }

        it 'raises an error' do
          expect { StatusCode.new(code) }
            .to raise_error(ArgumentError,
                            'The code argument should be String or Symbol')
        end
      end

      context 'when code is a whitespace' do
        let(:receiver) { :merchant }
        let(:code) { ' ' }

        it 'returns nil' do
          expect(StatusCode.new(code).decode(receiver)).to be_nil
        end
      end
    end
  end
end
