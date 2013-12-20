module DrRoboto
  module ParamsHelper
    
    # Selects only the given keys from a hash.
    #
    # @param params [Hash] the hash to slice
    # @param *keys [Symbol] the keys to select
    # @return [Hash] the filtered hash
    def filter_select(params, *keys)
      params.select{ |k, v| keys.include?(k.to_sym) }
    end

    # Rejects the given keys from a hash and returns the filtered result.
    def filter_reject(params, *keys)
      params.reject{ |k, v| keys.include?(k.to_sym) }
    end

  end
end