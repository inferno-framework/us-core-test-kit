module USCore
  class Generator
    class IGMetadata
      attr_accessor :ig_version, :groups

      def reformatted_version
        @reformatted_version ||= ig_version.delete('.')
      end

      def to_hash
        {
          ig_version: ig_version,
          groups: groups
        }
      end
    end
  end
end
