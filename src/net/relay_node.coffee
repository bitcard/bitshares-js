
q = require 'q'
EC = require('../common/exceptions').ErrorWithCause

###* 
    Connect to a relay node.
    (see bitshares_client config.json relay_account_name)
###
class RelayNode
    
    constructor:(@rpc)->
        throw new Error 'missing required parameter' unless @rpc
    
    RelayNode.ntp_offset= 0
    
    init:->
        return @init_promise if @init_promise
        @chain_id = "75c11a81b7670bbaa721cc603eadb2313756f94a3bcbb9928e9101432701ac5f"
        @relay_fee_collector = "relay-fee"
        @initialized = yes
        @base_asset_symbol = "BTS"
        defer = q.defer()
        defer.resolve()
        return @init_promise = defer.promise
        # @init_promise = @rpc.request('fetch_welcome_package', [{}]).then(
        #     (welcome)=>
        #         welcome = welcome.result
        #         for attribute in [
        #             'chain_id','relay_fee_collector'
        #             'relay_fee_amount','network_fee_amount'
        #         ]
        #             value = welcome[attribute]
        #             unless value or attribute is 'relay_fee_collector'
        #                 throw new Error "required: #{attribute}" 
        #             @[attribute]=welcome[attribute]
        #         
        #         q.all([
        #             @rpc.request 'get_info'
        #             @rpc.request 'blockchain_get_asset', [0]
        #         ]).spread (
        #             get_info
        #             base_asset
        #         )=>
        #             get_info = get_info.result
        #             base_asset = base_asset.result
        #             @base_asset_symbol = base_asset.symbol
        #             unless @base_asset_symbol
        #                 throw new Error "required: base asset symbol"
        #             #@_validate_chain_id @welcome.chain_id, @base_asset_symbol
        #             (->
        #                 RelayNode.ntp_offset = if get_info.ntp_time
        #                     ntp_time = new Date(get_info.ntp_time).getTime()
        #                     new Date().getTime() - ntp_time
        #                 else
        #                     0
        #                 if Math.abs(RelayNode.ntp_offset) > 5000
        #                     console.log "WARN: Local time and network time are off by #{ RelayNode.ntp_offset/1000 } seconds"
        #                 #else console.log "INFO: RelayNode.ntp_offset #{ RelayNode.ntp_offset/1000 } seconds"
        #             )()
        #             @initialized = yes
        #     
        #     (error)->EC.throw 'fetch_welcome_package', error
        # )
    
    base_symbol:->
        throw new Error "call init()" unless @initialized
        @base_asset_symbol
    
    
    ###
    _validate_chain_id:(@chain_id, base_asset_symbol)->
        id = CHAIN_ID[base_asset_symbol]
        unless id
            console.log "WARNING: Unknown base asset symbol / chain ID: #{base_asset_symbol}, #{chain_id}"
        else
            unless id is chain_id
                throw new Error "Base asset symbol / chain ID mismatch: #{base_asset_symbol}, #{chain_id}"
    ###
    
exports.RelayNode = RelayNode