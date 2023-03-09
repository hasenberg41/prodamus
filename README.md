# Purchase integration with https://prodamus.ru/

## Client library for ruby apps

Prodamus docs https://help.prodamus.ru/

# Example usage:

* configure connection

      Prodamus.config do |conf|
        conf.main_payment_form_url = <payment form provided by prodamus>
        conf.secret_key = <key from main form settings>
      end

  or

      Prodamus.main_payment_form_url = <payment form provided by prodamus>
      Prodamus.secret_key = <key from main form settings>

* configure request wich be sent for get purchase link

      Prodamus.link_config do |conf|
        conf.order_id = 12
        conf.currency = 'rub'
        ...
      end
  To see more parameters https://help.prodamus.ru/payform/integracii/rest-api/instrukcii-dlya-samostoyatelnaya-integracii-servisov#obshie-neobyazatelnye-parametry

  * add a product or products to be purchased (must have at least one)

        Prodamus.link_config.add_product(
          name: <name>, price: <price>,
          quantity: 1, sku: <id in your system>
        )

    Description product params https://help.prodamus.ru/payform/integracii/rest-api/instrukcii-dlya-samostoyatelnaya-integracii-servisov#parametry-massiva-products

  * set link expired datetime

        Prodamus.link_config.form_access_duration = 1.hour

* get payment link

      Prodamus.link

## Submit callback

Your callback from Prodamus server can be look like this:

    data = {
        date: '2022-12-08T10:42:10+03:00',
        order_id: <id in prodamus system>,
        order_num: <id in your system>,
        domain: <your main form>,
        sum: '770.00',
        currency: 'rub',
        customer_phone: '+78005553535',
        customer_extra: '',
        payment_type: 'Оплата картой, выпущенной в РФ',
        commission: '100',
        commission_sum: '770.00',
        attempt: '2',
        callbackType: 'json',
        link_expired: '2022-12-08 11:38',
        products: [
          {
            name: <product name>,
            price: '770.00',
            quantity: '1',
            sum: '770.00'
          }
        ],
        payment_status: payment_status,
        payment_status_description: 'Успешная оплата',
        payment_init: 'manual',
        submit: {
          date: '2022-12-08T10:42:10+03:00',
          order_id: <id in prodamus system>,
          order_num: <id in your system>,
          domain: <your main form>,
          sum: '770.00',
          currency: 'rub',
          customer_phone: '+78005553535',
          customer_extra: '',
          payment_type: 'Оплата картой, выпущенной в РФ',
          commission: '100',
          commission_sum: '770.00',
          attempt: '2',
          callbackType: 'json',
          link_expired: '2022-12-08 11:38',
          products: [{ name: <product name>, price: '770.00', quantity: '1', sum: '770.00' }],
          payment_status: 'success',
          payment_status_description: 'Успешная оплата',
          payment_init: 'manual'
        }
      }

Need get signature from header 'Sign' and verify this data:

    sign = request.headers['Sign']
    Prodamus.verify(data[:submit], sign)

This method returns 'true' or 'false'.

You must perform some actions in your system to complete purchase if this method returns'true'