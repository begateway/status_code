# frozen_string_literal: true
require 'status_code'

describe StatusCode do
  describe '#decode' do
    context 'with locale' do
      context 'without gateway' do
        subject do
          StatusCode.decode(code, receiver: receiver, locale: locale)
        end

        context 'with English locale' do
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
                'The payment has been declined by your bank.' \
                  ' Call the bank support line to find out the reason.' \
                  ' Your bank phone number' \
                  ' can be found on the back side of your card'
              end

              it 'returns decline message' do
                expect(subject).to eql(message)
              end
            end

            context 'with unknown code' do
              let(:code) { '99999' }
              let(:message) do
                "The payment has been declined. Please contact Technical Support"
              end

              it 'returns nil' do
                expect(subject).to eql(message)
              end
            end
          end
        end

        context 'with Russian locale' do
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
              let(:message) do
                "Платеж отклонен. Свяжитесь со службой технической поддержки"
              end

              it 'returns nil' do
                expect(subject).to eql(message)
              end
            end
          end
        end

        context 'with unknown locale' do
          let(:locale) { :zz }
          let(:receiver) { :customer }
          let(:code) { '000' }

          it 'returns nil' do
            expect(subject).to be_nil
          end
        end
      end
      context 'with gateway' do
        subject do
          StatusCode.decode(code, receiver: receiver,
                                  locale: locale,
                                  gateway: gateway)
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

    context 'without locale' do
      context 'with gateway' do
        let(:receiver) { :merchant }
        subject do
          StatusCode.decode(code, receiver: receiver, gateway: gateway)
        end

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
      end

      context 'without gateway' do
        subject { StatusCode.decode(code, receiver: receiver) }

        context 'without locale' do
          let(:code) { '000' }
          let(:receiver) { :customer }
          let(:message) { 'Approved' }

          it 'returns approve message' do
            expect(subject).to eql(message)
          end
        end
      end
    end

    context 'when gateway and locale are nil' do
      subject do
        StatusCode.decode(code, receiver: receiver,
                                locale: locale,
                                gateway: gateway)
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
      let(:code) { '100' }
      let(:message) do
        'The payment has been declined by your bank.' \
          ' Call the bank support line to find out the reason.' \
          ' Your bank phone number' \
          ' can be found on the back side of your card'
      end

      it 'returns message' do
        expect(StatusCode.decode(code)).to eql(message)
      end
    end
  end
end
