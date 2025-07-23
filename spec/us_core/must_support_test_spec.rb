RSpec.describe USCoreTestKit::MustSupportTest, :runnable do
  let(:suite_id) { 'us_core_v400' }
  let(:patient_ref) { 'Patient/85' }
  let(:patient) do
    FHIR::Patient.new(
      identifier: [{ system: 'system', value: 'value' }],
      name: [{ use: 'old', family: 'family', given: ['given'], suffix: ['suffix'], period: { end: '2022-12-12' } }],
      telecom: [{ system: 'phone', value: 'value', use: 'home' }],
      gender: 'male',
      birthDate: '2020-01-01',
      deceasedDateTime: '2022-12-12',
      address: [{ use: 'old', line: 'line', city: 'city', state: 'state', postalCode: 'postalCode',
                  period: { start: '2020-01-01' } }],
      communication: [{ language: { text: 'text' } }],
      extension: [
        {
          url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race',
          extension: [
            { url: 'ombCategory', valueCoding: { display: 'display' } },
            { url: 'text', valueString: 'valueString' }
          ]
        },
        {
          url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity',
          extension: [
            { url: 'ombCategory', valueCoding: { display: 'display' } },
            { url: 'text', valueString: 'valueString' }
          ]
        },
        {
          url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex',
          valueCode: 'M'
        },
        {
          url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-tribal-affiliation',
          extension: [{ url: 'tribalAffiliation', valueCodeableConcept: { text: 'text' } }]
        },
        {
          url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-sex',
          valueCode: 'M'
        },
        {
          url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-genderIdentity',
          valueCodeableConcept: { text: 'text' }
        }
      ]
    )
  end

  describe 'must support test for choice elements and regular elements' do
    let(:device_must_support_test) { Inferno::Repositories::Tests.new.find('us_core_v311_device_must_support_test') }
    let(:device) do
      FHIR::Device.new(
        udiCarrier: [{ deviceIdentifier: '43069338026389', carrierHRF: 'carrierHRF' }],
        distinctIdentifier: '43069338026389',
        manufactureDate: '2000-03-02T18:33:18-05:00',
        expirationDate: '2025-03-17T19:33:18-04:00',
        lotNumber: '1134',
        serialNumber: '842026117977',
        type: {
          text: 'Implantable defibrillator, device (physical object)'
        },
        patient: {
          reference: patient_ref
        }
      )
    end

    it 'fails if server supports none of the choice' do
      device.udiCarrier.first.carrierHRF = nil
      allow_any_instance_of(device_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [device]
          }
        )

      result = run(device_must_support_test)
      expect(result.result).to eq('skip')
      expect(result.result_message).to include('udiCarrier.carrierAIDC, udiCarrier.carrierHRF')
    end

    it 'passes if server supports at least one of the choice' do
      allow_any_instance_of(device_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [device]
          }
        )

      result = run(device_must_support_test)
      expect(result.result).to eq('pass')
    end

    it 'fails if server does not support one MS element' do
      device.distinctIdentifier = nil
      allow_any_instance_of(device_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [device]
          }
        )

      result = run(device_must_support_test)
      expect(result.result).to eq('skip')
      expect(result.result_message).to include('distinctIdentifier')
    end
  end

  describe 'must support test for extensions' do
    let(:patient_must_support_test) do
      Inferno::Repositories::Tests.new.find('us_core_v311_patient_must_support_test')
    end

    it 'passes if server suports all MS extensions' do
      allow_any_instance_of(patient_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [patient]
          }
        )

      result = run(patient_must_support_test)
      expect(result.result).to eq('pass')
    end

    it 'fails if server does not suport one MS extensions' do
      patient.extension.delete_at(0)

      allow_any_instance_of(patient_must_support_test)
        .to receive(:scratch_resources).and_return(
          {
            all: [patient]
          }
        )

      result = run(patient_must_support_test)

      expect(result.result).to eq('skip')
      expect(result.result_message).to include('Patient.extension:race')
    end
  end

  describe 'must support test for slices' do
    context 'slicing with patternCodeableConcept' do
      let(:care_plan_must_support_test) do
        Inferno::Repositories::Tests.new.find('us_core_v311_care_plan_must_support_test')
      end
      let(:careplan) do
        FHIR::CarePlan.new(
          text: { status: 'status' },
          status: 'status',
          intent: 'intent',
          category: [
            {
              coding: [
                {
                  system: 'http://hl7.org/fhir/us/core/CodeSystem/careplan-category',
                  code: 'assess-plan'
                }
              ]
            }
          ],
          subject: {
            reference: patient_ref
          }
        )
      end

      it 'passes if server suports all MS slices' do
        allow_any_instance_of(care_plan_must_support_test)
          .to receive(:scratch_resources).and_return(
            {
              all: [careplan]
            }
          )

        result = run(care_plan_must_support_test)

        expect(result.result).to eq('pass')
      end

      it 'fails if server does not suport one MS extensions' do
        careplan.category.first.coding.first.code = 'something else'
        allow_any_instance_of(care_plan_must_support_test)
          .to receive(:scratch_resources).and_return(
            {
              all: [careplan]
            }
          )

        result = run(care_plan_must_support_test)

        expect(result.result).to eq('skip')
        expect(result.result_message).to include('CarePlan.category:AssessPlan')
      end
    end

    context 'slicing with patternCodeableConcept and mulitple codings' do
      let(:test_class) { USCoreTestKit::USCoreV610::CoverageMustSupportTest }
      let(:coverage) do
        FHIR::Coverage.new(
          identifier: [
            {
              system: 'local-id',
              value: '123'
            },
            {
              type: {
                coding: [
                  {
                    system: 'http://terminology.hl7.org/CodeSystem/v2-0203',
                    code: 'MB',
                    display: 'Member Number'
                  }
                ]
              },
              value: 'member-id'
            }
          ],
          status: 'active',
          type: {
            coding: [
              {
                system: 'local-type',
                code: 'medicare'
              }
            ]
          },
          subscriberId: 'abc',
          beneficiary: {
            reference: 'Patient/1'
          },
          relationship: {
            coding: [
              {
                system: 'local-relationship',
                code: '01'
              }
            ]
          },
          period: {
            start: '2022-03-04'
          },
          payor: [
            {
              reference: 'Organization/1'
            }
          ],
          class: [
            {
              type: {
                coding: [
                  {
                    system: 'http://terminology.hl7.org/CodeSystem/coverage-class',
                    code: 'plan'
                  }
                ]
              },
              value: '10603',
              name: 'MEDICARE PART A & B'
            },
            {
              type: {
                coding: [
                  {
                    system: 'http://terminology.hl7.org/CodeSystem/coverage-class',
                    code: 'group'
                  }
                ]
              },
              value: '123',
              name: 'group'
            }
          ]
        )
      end

      it 'passes if server suports all MS slices' do
        allow_any_instance_of(test_class)
          .to receive(:scratch_resources).and_return(
            {
              all: [coverage]
            }
          )

        result = run(test_class)
        expect(result.result).to eq('pass')
      end
    end

    context 'slicing with type' do
      let(:test_class) { USCoreTestKit::USCoreV400::SmokingstatusMustSupportTest }
      let(:observation) do
        FHIR::Observation.new(
          status: 'final',
          category: [
            {
              coding: [
                {
                  system: 'http://terminology.hl7.org/CodeSystem/observation-category',
                  code: 'social-history'
                }
              ]
            }
          ],
          code: {
            coding: [
              {
                system: 'http://loinc.org',
                code: '72166-2'
              }
            ],
            text: 'Tobacco smoking status'
          },
          subject: {
            reference: 'Patient/902'
          },
          effectiveDateTime: '2013-04-23T21:07:05Z',
          valueCodeableConcept: {
            coding: [
              {
                system: 'http://snomed.info/sct',
                code: '449868002'
              }
            ]
          }
        )
      end

      it 'passes if server suports all MS slices' do
        allow_any_instance_of(test_class)
          .to receive(:scratch_resources).and_return(
            {
              all: [observation]
            }
          )

        result = run(test_class)

        expect(result.result).to eq('pass')
      end

      it 'skips if datetime format is not correct' do
        observation.effectiveDateTime = 'not a date time'
        allow_any_instance_of(test_class)
          .to receive(:scratch_resources).and_return(
            {
              all: [observation]
            }
          )

        result = run(test_class)

        expect(result.result).to eq('skip')
        expect(result.result_message).to include('Observation.effective[x]:effectiveDateTime')
      end
    end

    context 'slicing with requiredBinding' do
      context 'Condition ProblemsHealthConcerns' do
        let(:test_class) { USCoreTestKit::USCoreV501::ConditionProblemsHealthConcernsMustSupportTest }
        let(:condition) do
          FHIR::Condition.new(
            extension: [
              {
                url: 'http://hl7.org/fhir/StructureDefinition/condition-assertedDate',
                valueDateTime: '2016-08-10'
              }
            ],
            clinicalStatus: {
              coding: [
                {
                  system: 'http://terminology.hl7.org/CodeSystem/condition-clinical',
                  code: 'active'
                }
              ]
            },
            verificationStatus: {
              coding: [
                {
                  system: 'http://terminology.hl7.org/CodeSystem/condition-ver-status',
                  code: 'confirmed'
                }
              ]
            },
            category: [
              {
                coding: [
                  {
                    system: 'http://terminology.hl7.org/CodeSystem/condition-category',
                    code: 'problem-list-item'
                  }
                ]
              },
              {
                coding: [
                  {
                    system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-tags',
                    code: 'sdoh'
                  }
                ]
              }
            ],
            code: {
              coding: [
                {
                  system: 'http://snomed.info/sct',
                  code: '445281000124101'
                }
              ]
            },
            subject: {
              reference: 'Patient/123'
            },
            recordedDate: '2016-08-10T07:15:07-08:00',
            onsetDateTime: '2016-08-10T07:15:07-08:00',
            abatementDateTime: '2016-08-10T07:15:07-08:00'
          )
        end

        it 'passes if server suports all MS slices' do
          allow_any_instance_of(test_class)
            .to receive(:scratch_resources).and_return(
              {
                all: [condition]
              }
            )

          result = run(test_class)
          expect(result.result).to eq('pass')
        end

        it 'skips if server does not support category:us-core slice' do
          condition.category.delete_if { |category| category.coding.first.code == 'problem-list-item' }
          allow_any_instance_of(test_class)
            .to receive(:scratch_resources).and_return(
              {
                all: [condition]
              }
            )

          result = run(test_class)
          expect(result.result).to eq('skip')
          expect(result.result_message).to include('Condition.category:us-core')
        end
      end

      context 'MedicationRequest' do
        let(:test_class) { USCoreTestKit::USCoreV501::MedicationRequestMustSupportTest }
        let(:medication_request_1) do
          FHIR::MedicationRequest.new(
            status: 'active',
            intent: 'order',
            category: [
              {
                coding: [
                  system: 'http://terminology.hl7.org/CodeSystem/medicationrequest-category',
                  code: 'outpatient'
                ]
              }
            ],
            reportedBoolean: false,
            medicationReference: {
              reference: 'Medication/m1'
            },
            subject: {
              reference: 'Patient/p1'
            },
            encounter: {
              reference: 'Encounter/e1'
            },
            authoredOn: '2021-08-04T00:00:00-04:00',
            requester: {
              reference: 'Practitioner/p2'
            },
            dosageInstruction: [
              {
                text: 'this is a dosage instruction'
              }
            ]
          )
        end

        it 'passes if server suports all MS slices' do
          allow_any_instance_of(test_class)
            .to receive(:scratch_resources).and_return(
              {
                all: [medication_request_1]
              }
            )

          result = run(test_class)
          expect(result.result).to eq('pass')
        end
      end
    end
  end

  describe 'must support test for choices' do
    let(:test_class) { USCoreTestKit::USCoreV501::ConditionProblemsHealthConcernsMustSupportTest }
    let(:condition) do
      FHIR::Condition.new(
        extension: [
          {
            url: 'http://hl7.org/fhir/StructureDefinition/condition-assertedDate',
            valueDateTime: '2016-08-10'
          }
        ],
        clinicalStatus: {
          coding: [
            {
              system: 'http://terminology.hl7.org/CodeSystem/condition-clinical',
              code: 'active'
            }
          ]
        },
        verificationStatus: {
          coding: [
            {
              system: 'http://terminology.hl7.org/CodeSystem/condition-ver-status',
              code: 'confirmed'
            }
          ]
        },
        category: [
          {
            coding: [
              {
                system: 'http://terminology.hl7.org/CodeSystem/condition-category',
                code: 'problem-list-item'
              }
            ]
          },
          {
            coding: [
              {
                system: 'http://hl7.org/fhir/us/core/CodeSystem/us-core-tags',
                code: 'sdoh'
              }
            ]
          }
        ],
        code: {
          coding: [
            {
              system: 'http://snomed.info/sct',
              code: '445281000124101'
            }
          ]
        },
        subject: {
          reference: 'Patient/123'
        },
        recordedDate: '2016-08-10T07:15:07-08:00',
        onsetDateTime: '2016-08-10T07:15:07-08:00',
        abatementDateTime: '2016-08-10T07:15:07-08:00'
      )
    end

    it 'passes if server suports assertDate extension' do
      condition.onsetDateTime = nil

      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [condition]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('pass')
    end

    it 'passes if server suports onsetDate' do
      condition.extension = []

      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [condition]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('pass')
    end

    it 'skips if server suports none of assertDate extension and onsetDate' do
      condition.onsetDateTime = nil
      condition.extension = []

      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [condition]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('skip')
      expect(result.result_message).to include('onsetDateTime')
      expect(result.result_message).to include('Condition.extension:assertedDate')
    end
  end

  describe 'must support test for Patient previous name choices' do
    let(:test_class) { USCoreTestKit::USCoreV311::PatientMustSupportTest }

    it 'passes previous name check if both use=old and preiod.end are provided' do
      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [patient]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('pass')
    end

    it 'passes previous name check if only use=old is presented' do
      patient.name[0].period = nil

      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [patient]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('pass')
    end

    it 'passes previous name check if only period.end is presented' do
      patient.name[0].use = nil

      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [patient]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('pass')
    end

    it 'skips previous name check if neither use=old nor period.end is presented' do
      patient.name[0].use = nil
      patient.name[0].period = nil

      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [patient]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('skip')
      expect(result.result_message).to include('name.period.end')
      expect(result.result_message).to include('name.use:old')
    end
  end

  describe 'must support tests for sub elements of slices' do
    let(:test_class) do
      USCoreTestKit::USCoreV610::CoverageMustSupportTest
    end
    let(:group_class) do
      FHIR::Coverage::Class.new.tap do |loc_class|
        loc_class.type = FHIR::CodeableConcept.new.tap do |code_concept|
          code_concept.coding = [FHIR::Coding.new.tap do |coding|
            coding.system = 'http://terminology.hl7.org/CodeSystem/coverage-class'
            coding.code = 'group'
          end]
        end
        loc_class.value = 'group-class-value'
        loc_class.name = 'group-class-name'
      end
    end
    let(:plan_class) do
      FHIR::Coverage::Class.new.tap do |loc_class|
        loc_class.type = FHIR::CodeableConcept.new.tap do |code_concept|
          code_concept.coding = [FHIR::Coding.new.tap do |coding|
            coding.system = 'http://terminology.hl7.org/CodeSystem/coverage-class'
            coding.code = 'plan'
          end]
        end
        loc_class.value = 'plan-class-value'
        loc_class.name = 'plan-class-name'
      end
    end
    let(:coverage_with_two_classes) do
      FHIR::Coverage.new.tap do |cov|
        cov.status = 'active'
        cov.type = FHIR::CodeableConcept.new.tap do |code_concept|
          code_concept.coding = [FHIR::Coding.new.tap do |coding|
            coding.system = 'https://nahdo.org/sopt'
            coding.code = '3712'
            coding.display = 'PPO'
          end,
                                 FHIR::Coding.new.tap do |coding|
                                   coding.system = 'http://terminology.hl7.org/CodeSystem/v3-ActCode'
                                   coding.code = 'PPO'
                                   coding.display = 'preferred provider organization policy'
                                 end],
                                code_concept.text = 'PPO'
        end,
                   cov.subscriberId = '888009335'
        cov.beneficiary = FHIR::Reference.new.tap do |ref|
          ref.reference = 'Patient/example'
        end
        cov.relationship = FHIR::CodeableConcept.new.tap do |code_concept|
          code_concept.coding = [FHIR::Coding.new.tap do |coding|
            coding.system = 'http://terminology.hl7.org/CodeSystem/subscriber-relationship'
            coding.code = 'self'
          end],
                                code_concept.text = 'Self'
        end,
                           cov.period = FHIR::Period.new.tap do |period|
                             period.start = '2020-01-01'
                           end
        cov.payor = [FHIR::Reference.new.tap do |ref|
          ref.reference = 'Organization/acme-payer'
          ref.display = 'Acme Health Plan'
        end],
                    cov.local_class = [group_class, plan_class]
        cov.identifier = [FHIR::Identifier.new.tap do |identifier|
          identifier.type = FHIR::CodeableConcept.new.tap do |code_concept|
            code_concept.coding = [FHIR::Coding.new.tap do |coding|
              coding.system = 'http://terminology.hl7.org/CodeSystem/v2-0203'
              coding.code = 'MB'
            end]
          end
          identifier.system = 'https://github.com/inferno-framework/us-core-test-kit'
          identifier.value = 'f4a375d2-4e53-4f81-ba95-345e7573b550'
        end]
      end
    end

    it 'passes if resources cover all must support sub elements of slices' do
      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [coverage_with_two_classes]
          }
        )
      result = run(test_class)
      expect(result.result).to eq('pass')
    end

    it 'skips if resources do not cover all must support sub elements of slices' do
      coverage_with_just_group = coverage_with_two_classes.dup
      coverage_with_just_group.local_class = [group_class]
      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [coverage_with_just_group]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('skip')
    end

    it 'passes if resources cover all must support elements over multiple elements' do
      coverage_with_just_group = coverage_with_two_classes.clone
      coverage_with_just_group.local_class = [group_class]
      coverage_with_just_plan = coverage_with_two_classes.clone
      coverage_with_just_plan.local_class = [plan_class]
      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [coverage_with_just_group, coverage_with_just_plan]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('pass')
    end
  end

  describe 'must support tests for primitive extension' do
    let(:test_class) { USCoreTestKit::USCoreV610::QuestionnaireResponseMustSupportTest }
    let(:qr) { FHIR.from_contents(File.read('spec/fixtures/QuestionnaireResponse.json')) }

    it 'passes if server suports all MS slices' do
      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [qr]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('pass')
    end

    it 'skips if both MS extensions in a primitive are not provided' do
      qr.source_hash['_questionnaire']['extension'][0]['url'] = 'http://example.com/extension'
      qr.source_hash['_questionnaire']['extension'][1]['url'] = 'http://example.com/extension'
      new_qr = FHIR::QuestionnaireResponse.new(qr.source_hash)

      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [new_qr]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('skip')
      expect(result.result_message).to include('QuestionnaireResponse.questionnaire.extension:questionnaireDisplay')
      expect(result.result_message).to include('QuestionnaireResponse.questionnaire.extension:url')
    end

    it 'skips if both MS extensions and MS element in a primitive are not provided' do
      qr.source_hash['_questionnaire']['extension'][0]['url'] = 'http://example.com/extension'
      qr.source_hash['_questionnaire']['extension'][1]['url'] = 'http://example.com/extension'
      new_qr = FHIR::QuestionnaireResponse.new(qr.source_hash)
      new_qr.questionnaire = nil

      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [new_qr]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('skip')
      expect(result.result_message).to include('QuestionnaireResponse.questionnaire.extension:questionnaireDisplay')
      expect(result.result_message).to include('QuestionnaireResponse.questionnaire.extension:url')
      expect(result.result_message).to include(' questionnaire')
    end

    it 'skips if one of MS extensions in a primitive is not provided' do
      qr.source_hash['_questionnaire']['extension'][0]['url'] = 'http://example.com/extension'
      new_qr = FHIR::QuestionnaireResponse.new(qr.source_hash)

      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [new_qr]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('skip')
      expect(result.result_message).to include('QuestionnaireResponse.questionnaire.extension:questionnaireDisplay')
      expect(result.result_message).to_not include('QuestionnaireResponse.questionnaire.extension:url')
      expect(result.result_message).to_not include(' questionnaire')
    end

    it 'skips if MS primitive value is missing' do
      new_hash = qr.source_hash.except('status')
      new_qr = FHIR::QuestionnaireResponse.new(new_hash)

      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [new_qr]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('skip')
      expect(result.result_message).to include(' status')
    end

    it 'skips if regular extension is provided for MS primitive without MS extension' do
      new_hash = qr.source_hash.except('status')
      new_hash['_status'] = {
        'extension' => [
          {
            'url' => 'http://example.com/extension',
            'valueString' => 'value'
          }
        ]
      }

      new_qr = FHIR::QuestionnaireResponse.new(new_hash)

      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [new_qr]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('skip')
      expect(result.result_message).to include(' status')
    end

    it 'skips if MS element (not primitive) is missing' do
      qr.subject = nil

      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [qr]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('skip')
      expect(result.result_message).to include(' subject')
    end

    it 'skips if regular extension is provided for MS element (not primitive)' do
      qr.subject = FHIR::Reference.new(
        extension: [
          {
            url: 'http://example.com/extension',
            valueString: 'value'
          }
        ]
      )

      allow_any_instance_of(test_class)
        .to receive(:scratch_resources).and_return(
          {
            all: [qr]
          }
        )

      result = run(test_class)
      expect(result.result).to eq('skip')
      expect(result.result_message).to include(' subject')
    end
  end
end
