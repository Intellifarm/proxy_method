module ProxyMethod
  module ClassMethods
    DEFAULT_PROXY_MESSAGE = "Disabled by proxy_method"

    def proxy_class_method(original_method_names, error_message = DEFAULT_PROXY_MESSAGE)
      Array(original_method_names).each do |original_method_name|
        self.singleton_class.send(:alias_method, :"unproxied_#{original_method_name}", original_method_name)
        define_singleton_method(original_method_name){ raise error_message }
      end
    end

    def proxy_instance_method(original_method_names, error_message = DEFAULT_PROXY_MESSAGE)
      Array(original_method_names).each do |original_method_name|
        alias_method :"unproxied_#{original_method_name}", original_method_name
        define_method(original_method_name){ raise error_message }
      end
    end

    alias_method :proxy_method, :proxy_instance_method
  end

  def self.included(base)
    base.extend ClassMethods
  end
end