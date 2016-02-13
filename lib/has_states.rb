require "has_states/version"

module HasStates

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods

    def has_states(*states, **options)
      options = {attr_name: "state", const_name: "states"}.merge(options)
      states.flatten!
      self.const_set(options[:const_name].upcase, states.map{|s| s.to_s})

      states.each do |s|
        s = s.to_s
        attr = options[:attr_name].to_sym
        define_method("#{s}?") do
          return self.send(attr).to_s == s
        end
        define_method("not_#{s}?") do
          return self.send(attr).to_s != s
        end
        define_method("#{s}!") do
          self.send("#{attr}=", s)
          self.save!
        end
        self.class.send("define_method", s) do
          where(attr => s)
        end
      end
    end

  end

end
