module Ruspea::Language
  class Interop
    def dot(target, method, args = [])
      final_target =
        if target.is_a?(String) || target.is_a?(Symbol)
          constantize(target)
        else
          target
        end

      if args.is_a? Array
        final_target.public_send(method, *args)
      else
        final_target.public_send(method, args)
      end
    end

    private

    # WARNING: the code below was copy and pasted from Rails XD
    # File activesupport/lib/active_support/inflector/methods.rb, line 272
    def constantize(camel_cased_word)
      names = camel_cased_word.split("::".freeze)

      # Trigger a built-in NameError exception including the ill-formed constant in the message.
      Object.const_get(camel_cased_word) if names.empty?

      # Remove the first blank element in case of '::ClassName' notation.
      names.shift if names.size > 1 && names.first.empty?

      names.inject(Object) do |constant, name|
        if constant == Object
          constant.const_get(name)
        else
          candidate = constant.const_get(name)
          next candidate if constant.const_defined?(name, false)
          next candidate unless Object.const_defined?(name)

          # Go down the ancestors to check if it is owned directly. The check
          # stops when we reach Object or the end of ancestors tree.
          constant = constant.ancestors.inject(constant) do |const, ancestor|
            break const    if ancestor == Object
            break ancestor if ancestor.const_defined?(name, false)
            const
          end

          # owner is in Object, so raise
          constant.const_get(name, false)
        end
      end
    end
  end
end
