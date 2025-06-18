module USCoreTestKit
  module USCoreOptions
    module_function

    SMART_1 = 'smart_app_launch_1'.freeze
    SMART_2 = 'smart_app_launch_2'.freeze
    SMART_2_2 = 'smart_app_launch_2_2'.freeze

    SMART_1_REQUIREMENT = { smart_app_launch_version: SMART_1 }.freeze
    SMART_2_REQUIREMENT = { smart_app_launch_version: SMART_2 }.freeze
    SMART_2_2_REQUIREMENT = { smart_app_launch_version: SMART_2_2 }.freeze

    def recursive_remove_input(runnable, input)
      runnable.inputs.delete(input)
      runnable.input_order.delete(input)
      runnable.children.each { |child_runnable| recursive_remove_input(child_runnable, input) }
    end

    def recursive_puts_inputs(runnable)
      puts runnable.inputs
      runnable.children.each { |child_runnable| recursive_puts_inputs(child_runnable) }
    end

    def recursive_puts_children(runnable, spaces)
      puts spaces + runnable.id
      runnable.children.each { |child_runnable| recursive_puts_children(child_runnable, spaces+"  ") }
    end
  end
end
