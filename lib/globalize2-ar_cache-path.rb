module ActiveRecord
  class Base
    # Returns a cache key that can be used to identify this record.
    #
    # ==== Examples
    #  If you have localized application
    #  I18n.locale = :en
    #   Product.new.cache_key     # => "products/new"
    #   Product.find(5).cache_key # => "products/5" (updated_at not available)
    #   Person.find(5).cache_key  # => "people/5-20071224150000" (updated_at available)
    alias_method(:original_cache_key, :cache_key)
    
    def cache_key(locale = nil)
      (locale ? locale.to_s + "/" : '') + original_cache_key
    end
  end
end
