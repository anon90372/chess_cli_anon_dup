# frozen_string_literal: true

# Extending core class Hash
module HashExtensions
  refine Hash do
    def delete_empty_arr_vals
      return unless values.all?(Array)

      delete_if { |_key, arr| arr.compact.empty? }
    end

    def wrap_vals_in_arr
      return unless values.none?(Array)

      transform_values { |val| [val] }
    end
  end
end
