require_relative '../../../read_test'

module USCoreTestKit
  module USCoreV800
    class RelatedPersonReadTest < Inferno::Test
      include USCoreTestKit::ReadTest

      title 'Server returns correct RelatedPerson resource from RelatedPerson read interaction'
      description 'A server SHALL support the RelatedPerson read interaction.'

      id :us_core_v800_related_person_read_test

      def resource_type
        'RelatedPerson'
      end

      def scratch_resources
        scratch[:related_person_resources] ||= {}
      end

      run do
        perform_read_test(scratch.dig(:references, 'RelatedPerson'), delayed_reference: true)
      end
    end
  end
end
