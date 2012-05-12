class Lisbn < String
  module CacheMethod
    def cache_method(*methods)
      methods.map(&:to_s).each do |method|
        alias_method method + "_without_cache", method
        define_method method do |*args, &blk|
          @cache ||= {}
          @cache[[method, self]] ||= send(method + "_without_cache", *args, &blk)
        end
      end
    end
  end

  extend CacheMethod
end
