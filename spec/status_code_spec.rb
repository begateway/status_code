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
              let(:message) { "Decline" }

              it 'returns nil' do
                expect(subject).to eql("Decline")
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
              let(:message) { 'Отказ' }

              it 'returns nil' do
                expect(subject).to eql(message)
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

      context 'without code' do
        let(:code) { nil }
        let(:message) { 'Адмова' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
    end

    context 'with Paritetbankmir locale' do 
      let(:receiver) { :customer }
      let(:gateway) { 'paritetbankmir' }
      let(:locale) { :ru }

      subject do
        StatusCode.decode(code, receiver: receiver,
                                locale: locale,
                                gateway: gateway)
      end
      
      context 'with 950 code' do
        let(:code) { '950' }
        let(:message) { 'Платеж отклонен. Свяжитесь со службой технической поддержки' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :en }
        let(:message) { 'The payment has been declined. Please contact Technical Support' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end

      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :en }
        let(:receiver) { :merchant }
        let(:message) { 'System error' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end

      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :az }
        let(:message) { 'Ödəniş imtina edildi. Texniki Dəstəklə əlaqə saxlayın' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :be }
        let(:message) { 'Аплата адхіленая. Звярніцеся ў службу тэхнічнай падтрымкі' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :da }
        let(:message) { 'Betalingen er blevet afvist. Kontakt teknisk support' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :de }
        let(:message) { 'Die Zahlung wurde abgelehnt. Bitte wenden Sie sich an den technischen Support' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :es }
        let(:message) { 'El pago ha sido rechazado. Póngase en contacto con el soporte técnico' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :fi }
        let(:message) { 'Maksu on estetty. Ota yhteys tekniseen tukeen' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :fr }
        let(:message) { 'Le paiement a été décliné par votre banque. Veuillez contacter le Support Technique' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :it }
        let(:message) { 'Il pagamento è stato rifiutato. Contatta l\'assistenza tecnica' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :ja }
        let(:message) { 'お支払いが拒否されました。テクニカルサポートまでご連絡ください。' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :no }
        let(:message) { 'Betalingen ble avslått. Vennligst ta kontakt med teknisk kundeservice' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :pl }
        let(:message) { 'Płatność została odrzucona. Prosimy o kontakt z pomocą techniczną' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :sv }
        let(:message) { 'Betalningen avvisades. Kontakta teknisk support' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :tr }
        let(:message) { 'Ödeme reddedildi. Lütfen Teknik Destek ile iletişime geçin' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 950 code' do
        let(:code) { '950' }
        let(:locale) { :zh }
        let(:message) { '付款已拒絕。請聯絡技術支援' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
    end

    context 'with Bgpg locale' do
      let(:receiver) { :customer }
      let(:gateway) { 'bgpb' }
      let(:locale) { :en }

      subject do
        StatusCode.decode(code, receiver: receiver,
                                locale: locale,
                                gateway: gateway)
      end

      context 'with Approved code' do
        let(:code) { '000' }
        let(:message) { 'Approved' }

        it 'returns approve message' do
          expect(subject).to eql(message)
        end
      end

      context 'with 421 code' do
        let(:code) { '421' }
        let(:message) { '3-D Secure verification error: Check your 3-D Secure code or contact the payment service provider for details.' }

        it 'returns approve message' do
          expect(subject).to eql(message)
        end
      end

      context 'with 420 code' do
        let(:code) { '420' }
        let(:message) { '3-D Secure verification error: Check your 3-D Secure code or contact the payment service provider for details.' }

        it 'returns approve message' do
          expect(subject).to eql(message)
        end
      end

      context 'with 420 code' do
        let(:code) { '420' }
        let(:locale) { :ru }
        let(:message) { 'Ошибка проверки 3-D Secure: Проверьте код 3-D Secure или обратитесь к провайдеру платежных услуг для уточнения причины.' }

        it 'returns approve message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 005 code' do
        let(:code) { '005' }
        let(:message) { 'Invalid card data. Failed to complete the transaction. Check your card details or use another card.' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 005 code' do
        let(:code) { '005' }
        let(:locale) { :ru }
        let(:message) { 'Неверные данные карты. Не удалось завершить транзакцию. Проверьте данные своей карты или используйте другую карту.' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
      
      context 'with 915 code' do
        let(:code) { '915' }
        let(:locale) { :ru }
        let(:message) { 'Недостаточно средств' }

        it 'returns decline message' do
          expect(subject).to eql(message)
        end
      end
    end
  end
end
