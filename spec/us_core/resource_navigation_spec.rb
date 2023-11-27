require_relative '../../lib/us_core_test_kit/fhir_resource_navigation'

RSpec.describe USCoreTestKit::FHIRResourceNavigation do
  let (:navigation_class) {
    Class.new.extend(USCoreTestKit::FHIRResourceNavigation)
  }
  let(:coverage_with_two_classes) {
    FHIR::Coverage.new.tap{ |cov|
      cov.local_class = [FHIR::Coverage::Class.new.tap{ |loc_class|
        loc_class.type = FHIR::CodeableConcept.new.tap{ |code_concept|
          code_concept.coding = FHIR::Coding.new.tap{ |coding|
            coding.system = "A"
            coding.code = "group"
          }
        }
      loc_class.value = "groupclass"
      },
      FHIR::Coverage::Class.new.tap{ |loc_class|
        loc_class.type = FHIR::CodeableConcept.new.tap{ |code_concept|
          code_concept.coding = FHIR::Coding.new.tap{ |coding|
            coding.system = "B"
            coding.code = "plan"
          }
        }
      loc_class.value = "planclass"
      }
      ]
    }
  }

  context '#find_a_value_at' do
    it 'finds the first value when not given a specific slice' do
      expect(navigation_class.find_a_value_at(coverage_with_two_classes, 'class.value')).to  eq('groupclass')
    end

    it 'finds a specific slice value when given a specific slice' do
      expect(navigation_class.find_a_value_at(coverage_with_two_classes, 'class:plan.value')).to eq('planclass')
    end
  end
end
