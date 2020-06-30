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

            context 'with unknown code and without status option' do
              let(:code) { '99999' }

              it 'returns nil' do
                expect(subject).to eq nil
              end
            end
          end
        end

        context 'with Russian locale' do
          let(:locale) { :az }

          context 'with merchant receiver' do
            let(:receiver) { :merchant }

            context 'with approval code' do
              let(:code) { '000' }
              let(:message) { 'Təsdiqləndi' }

              it 'returns approve message' do
                expect(subject).to eql(message)
              end
            end

            context 'with decline code' do
              let(:code) { '100' }
              let(:message) { 'İmtina' }

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
              let(:message) { 'Təsdiqləndi' }

              it 'returns approve message' do
                expect(subject).to eql(message)
              end
            end

            context 'with decline code' do
              let(:code) { '100' }
              let(:message) do
                'Kartı verən bank tərəfindən ödəniş imtina olundu. '\
                'Dəqiqləşdirmək üçün bankla əlaqə saxlayın. '\
                'Əlaqə nömrələri kartın arxasında qeyd olunub'
              end

              it 'returns decline message' do
                expect(subject).to eql(message)
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

    context 'with Belarus locale' do
      let(:receiver) { :customer }
      let(:gateway) { 'mtb' }
      let(:locale) { :be }

      subject do
        StatusCode.decode(code, receiver: receiver,
                                locale: locale,
                                gateway: gateway)
      end

      context 'with Approved code' do
        let(:code) { '000' }
        let(:message) { 'Ухвалена' }

        it 'returns approve message' do
          expect(subject).to eql(message)
        end
      end

      context 'with Call-Bank code' do
        let(:code) { '100' }
        let(:message) { 'Аплата адхіленая банкам, які выдаў Вашу картку. ' \
          'Звярніцеся ў банк за тлумачэннем. Кантактны тэлефон на зваротным баку карткі' }

        it 'returns Call-Bank message' do
          expect(subject).to eql(message)
        end
      end

      context 'with Contact-Technical-Support code' do
        let(:code) { '102' }
        let(:message) { 'Аплата адхіленая. Звярніцеся ў службу тэхнічнай падтрымкі' }

        it 'returns Contact-Technical-Support message' do
          expect(subject).to eql(message)
        end
      end

      context 'with Not-sufficient-funds code' do
        let(:code) { '116' }
        let(:message) { 'Аплата адхіленая банкам, які выдаў Вашу картку. Недастаткова сродкаў для аплаты' }

        it 'returns Not-sufficient-funds message' do
          expect(subject).to eql(message)
        end
      end

      context 'with Online-Disable-Call-Bank code' do
        let(:code) { '119' }
        let(:message) { 'Аплата адхіленая банкам, які выдаў Вашу картку. ' \
          'Інтэрнэт-плацяжы для гэтай карткі адключаныя. Звярніцеся ў банк, ' \
          'каб актываваць інтэрнэт-плацяжы. Кантактны тэлефон на зваротным баку карткі' }

        it 'returns Online-Disable-Call-Bank message' do
          expect(subject).to eql(message)
        end
      end

      context 'without code and status option' do
        let(:code) { nil }

        it 'returns decline message' do
          expect(subject).to eql nil
        end
      end
    end

    context 'with invalid code and valid status option for customer receiver' do
      subject { StatusCode.decode(code, receiver: :customer, gateway: 'mtb', status: status, locale: :en) }

      context "with true status (successful) and wrong code " do
        let(:code) { 'wrong_code' }
        let(:status) { true }

        it 'returns Approved message' do
          expect(subject).to eql 'Approved'
        end
      end

      context "without code and with true status (successful)" do
        let(:code) { nil }
        let(:status) { true }

        it 'returns Approved message' do
          expect(subject).to eql 'Approved'
        end
      end

      context "with false status (failed) and wrong code" do
        let(:code) { 'wrong_code' }
        let(:status) { false }

        it 'returns Decline message' do
          expect(subject).to eql 'Decline'
        end
      end

      context "without code and with false status (failed)" do
        let(:code) { nil }
        let(:status) { false }

        it 'returns Decline message' do
          expect(subject).to eql 'Decline'
        end
      end
    end
  end
end
