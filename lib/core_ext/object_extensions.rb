# frozen_string_literal: true

# Extending core class Object
module ObjectExtensions
  refine Object do
    def to_class_s
      class_s = self.class.to_s
      class_s.slice!('Chess::')
      class_s
    end
  end
end
