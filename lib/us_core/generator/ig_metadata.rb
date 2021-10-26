module USCore
  class Generator
    class IGMetadata
      attr_accessor :ig_version, :groups

      def reformatted_version
        @reformatted_version ||= ig_version.delete('.')
      end
    end
  end
end
