require_relative 'head_circumference/head_circumference_read_test'

module USCore
  class HeadCircumferenceGroup < Inferno::TestGroup
    title 'HeadCircumference Tests'
    # description ''

    id :head_circumference

    test from: :head_circumference_read_test
  end
end
