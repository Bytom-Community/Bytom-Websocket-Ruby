# Bytom Websocket for Ruby

## How to use

```shell
gem install faye-websocket
git clone https://github.com/bitdayone/bytom-websocket-ruby.git
cd bytom-websocket-ruby
ruby ws.rb
```

## Method Overview

|  #   |            Topic             |                         Description                          |                       NotificationType                       |
| :--: | :--------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|  1   |      notify_raw_blocks       | Send notifications when a block is connected or disconnected from the best chain. | raw_blocks_connected raw_blocks_disconnected  request_status |
|  2   |    stop_notify_raw_blocks    | Cancel registered notifications for whenever a block is connected or disconnected from the main (best) chain. |                             None                             |
|  3   |   notify_new_transactions    | Send notifications for all new transactions as they are accepted into the mempool. |    new_transaction  request_status |
|  4   | stop_notify_new_transactions | Stop sending either a tx accepted  notification when a new transaction is accepted into the mempool. |                             None                             |

### Request json format

example: {"topic": "notify_raw_blocks"}

### Respone json format

example:

```json
{
    "notification_type":"new_transaction",     
    "data": "07010002015e015c7ca0ffd1a0dd6800f454a4e42b4bfd8711bd361e0a5347de5438e5815713dd885c2eba55dd98b76fa624820a6944d311364ee850e6477f98b2550fd26fb798bea08d0601011600149999dede698ee0b3380c9bce5ea0134ad01d5ef6630240e314b90c16af6297c7606de6e08c87227e5c2b79f861a1f4f912ee97691c01c56923202bbe893b11aa9d0d24fc849cf179040c4f117ad57f19dc08f9f4d56c05204c835e6af783c922946abb298d8a6370a2fed63e2bd1560191b566daaaf113dc0160015e7ca0ffd1a0dd6800f454a4e42b4bfd8711bd361e0a5347de5438e5815713dd88ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff80baa6d3030001160014ae940bf95263d7f238599b8f733285f40d387818630240df2d838950e47780fe5098f413a84fb8a8d14139c07b1c504de81a0707c117287224bed0df923c5d253e91854c0966db9e19fe3fff8615f2cd98e66d393ebe0d2091b73726e004478f3ecba59a58ee3a9ee8938e4c634ece9e02960a1b72e8a8c903013b5c2eba55dd98b76fa624820a6944d311364ee850e6477f98b2550fd26fb798be9f8d0601160014cee3f08070a4d530efbdd43a42eab32996ad9f0d00013dffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe08dd7d2030116001421efa928f283a539a2ade7de17c048824b667a5e0001395c2eba55dd98b76fa624820a6944d311364ee850e6477f98b2550fd26fb798be0101160014a40fb1e6112cb5510dcdab2b457e09b9b3da6de400"
}
```

|  #   |      field       |                         description                          |
| :--: | :--------------: | :----------------------------------------------------------: |
|  1   | NotificationType |             The message type of the notification             |
|  2   |       Data       |                         data content                         |
|  3   |   ErrorDetail    | Error message when returning notification type is request_status |

### Respone Error json format

example: 

```json
{
    "notification_type":"request_status",
    "data":null,
    "error_detail":"Websocket Internal error: There is not this topic: notify_raw_blocks1"
}
```



## Websocket Client Example for ruby

```ruby
require 'faye/websocket'
require 'eventmachine'
require 'json'

EM.run {
  ws = Faye::WebSocket::Client.new('ws://127.0.0.1:9888/websocket-subscribe')

  ws.on :open do |event|
    p [:open]
    p ws.send("{\"topic\": \"notify_raw_blocks\"}")
    p ws.send("{\"topic\": \"notify_new_transactions\"}")
    ws.send('heelo')
  end

  ws.on :message do |event|
    p [:message, event.data]
    response = JSON.parse(event.data)
    case response['notification_type']
    when 'raw_blocks_connected'
      p response['data']
    when 'raw_blocks_disconnected'
      p response['data']
    when 'new_transaction'
      p response['data']
    when 'request_status'
      p response['error_detail']
    end
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end
}
```

