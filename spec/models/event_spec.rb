require 'spec_helper'
describe Event do

  let(:example_lims) { 'postal_service' }
  let(:registered_event_type) { 'delivery' }
  let(:missing_event_type) { 'package_lost' }

  let(:event_uuid) { '00000000-1111-2222-3333-444444444444' }

  let(:json) do
    {
      "uuid" => event_uuid,
      "event_type" => event_type,
      "occured_at" => "2012-03-11 10:22:42",
      "user_identifier" => "postmaster@example.com",
      "subjects"=>[
        {
          "role" => "sender",
          "subject_type" => "person",
          "friendly_name" => "alice@example.com",
          "uuid" => "00000000-1111-2222-3333-555555555555"
        },
        {
          "role" => "recipient",
          "subject_type" => "person",
          "friendly_name" => "bob@example.com",
          "uuid" => "00000000-1111-2222-3333-666666666666"
        },
        {
          "role" => "package",
          "subject_type" => "plant",
          "friendly_name" => "Chuck",
          "uuid" => "00000000-1111-2222-3333-777777777777"
        }
      ],
      "metadata"=>{
        "delivery_method" => "courier",
        "shipping_cost" => "15.00"
      }
    }
  end

  # We have a single pre-registered event type
  before(:example) do
    @pre_count = Event.count
    create(:event_type, key:registered_event_type)
  end

  context "message receipt" do
    before(:example) do
      described_class.create_or_update_from_json(json, example_lims)
    end

    shared_examples_for "a recorded event" do
      it 'should create an event' do
        expect(described_class.count - @pre_count).to eq(1)
      end

      it 'should have the right event type' do
        expect(described_class.last).to be_instance_of(Event)
        expect(described_class.last.event_type).to be_instance_of(EventType)
        expect(described_class.last.event_type.key).to eq(event_type)
      end

      it 'should have the expected uuid' do
        expect(described_class.last.uuid).to eq(event_uuid)
      end

    end

    shared_examples_for "an ignored event" do
      it 'should not create an event' do
        expect(described_class.count).to eq(0)
      end
    end

    context "when pre-registration is required" do
      before(:context) do
        EventType.preregistration_required true
      end

      context "and the event type is registered" do
        let(:event_type) { registered_event_type }

        it_behaves_like 'a recorded event'
      end

      context "and the event type is unregistered" do
        let(:event_type) { missing_event_type }
        it_behaves_like "an ignored event"
      end
    end

    context "when pre-registration is not required" do

      before(:context) do
        EventType.preregistration_required false
      end

      let(:event_type) { missing_event_type }

      it_behaves_like 'a recorded event'
    end

  end

  context 'repeat message reciept' do

    let(:event_type) { registered_event_type }

    before(:example) do
      create(:event, uuid: event_uuid)
      @pre_count = Event.count
    end

    it 'should not register a new event with the same uuid' do
      expect { described_class.create_or_update_from_json(json, example_lims) }.to raise_error(ActiveRecord::RecordInvalid,'Validation failed: Uuid has already been taken')
    end

  end
end
