EC = require('../common/exceptions').ErrorWithCause

###* 
    Connect to a relay node.
    (see bitshares_client config.json relay_account_name)
###
class RelayNode
    
    constructor:(@rpc)->
        throw new Error 'missing required parameter' unless @rpc
    
    initialize:->
        @rpc.request('fetch_welcome_package').then(
            (welcome)=>
                welcome = welcome.result
                for attribute in [
                    'chain_id','relay_fee_collector'
                    'relay_fee_amount','network_fee_amount'
                ]
                    value = welcome[attribute]
                    if value is undefined
                        throw new Error "required: #{attribute}" 
                    @[attribute]=welcome[attribute]
            (error)->EC.throw 'fetch_welcome_package', error
        )
    
    initialized_or_throw:->
        unless @chain_id isnt undefined and
        @relay_fee_collector isnt undefined and
        @relay_fee_amount isnt undefined and
        @network_fee_amount isnt undefined
            throw new Error "RelayNode did not initialize properly"
    
exports.RelayNode = RelayNode