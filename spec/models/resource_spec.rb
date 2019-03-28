require 'rails_helper'

describe Resource, type: :model do
  context "Resource is missing the name" do
    subject { build(:resource, :invalid) }

    it { expect(subject).not_to be_valid }
  end

  context "Happy path" do
    subject { create(:resource) }

    it { expect(subject).to be_persisted }

    describe "#tag_list" do
      let(:tags) { 'tag1, tag2' }

      before { subject.tag_list = tags }

      it { expect(subject.tags).to all(be_a(Tag)) }
      it { expect(subject.tag_list).to eq(['tag1','tag2']) }
    end

    describe "#tag_filter" do
      subject { create(:resource) }
      let(:excluded_resource) { create(:resource, :name => 'excluded resource') }

      let(:included_tags) do
        "tag1,tag2,tag4"
      end

      let(:exclusion_tags) do
        "tag6,tag9,tag10"
      end

      let(:resources_found) do
        described_class.tag_filter(tag_filter)
      end

      before do
        subject.tag_list = included_tags
        excluded_resource.tag_list = exclusion_tags
        resources_found
      end

      context "+tag1 +tag2 -tag6" do
        let(:tag_filter) { '+tag1 +tag2 -tag6' }

        it { expect(resources_found).not_to include(excluded_resource) }
        it { expect(resources_found).to include(subject) }
      end

      context "+tag1 +tag2 +tag10" do
        let(:tag_filter) { '+tag1 +tag2 +tag10' }

        it { expect(resources_found).not_to include(excluded_resource) }
        it { expect(resources_found).not_to include(subject) }
      end

      context "-tag1 -tag2 -tag10" do
        let(:tag_filter) { '-tag1 -tag2 -tag10' }

        it { expect(resources_found).not_to include(excluded_resource) }
        it { expect(resources_found).not_to include(subject) }
      end

      context "+tag1 INVALID -tag10" do
        let(:tag_filter) { '+tag1 INVALID -tag10' }

        it { expect(resources_found).not_to include(excluded_resource) }
        it { expect(resources_found).to include(subject) }
      end

    end
  end
end
