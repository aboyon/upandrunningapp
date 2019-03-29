require 'rails_helper'

describe Resource, type: :model do
  context "Resource is missing the name" do
    subject { build(:resource, :invalid) }

    it { expect(subject).not_to be_valid }
  end

  context "Happy path" do
    subject { create(:resource, :tags => 'tag99, tag1, tag2') }

    it { expect(subject).to be_persisted }
    it { expect(subject.tags).to eq('tag1,tag2,tag99') }

    let(:file_1) { create(:resource, :name => 'File1') }
    let(:file_2) { create(:resource, :name => 'File2') }
    let(:file_3) { create(:resource, :name => 'File3') }
    let(:file_4) { create(:resource, :name => 'File4') }
    let(:file_5) { create(:resource, :name => 'File5') }

    before do
      file_1.update_attributes(:tags => "tag1,tag2,tag3,tag5")
      file_2.update_attributes(:tags => "tag2")
      file_3.update_attributes(:tags => "tag2,tag3,tag5")
      file_4.update_attributes(:tags => "tag2,tag3,tag4,tag5")
      file_5.update_attributes(:tags => "not_avaiable_tags")
    end

    describe "#tag_filter" do
      let(:resources_found) do
        described_class.tag_filter(included_tags, excluded_tags)
      end
      context "+tag2 +tag3 -tag4" do
        let(:included_tags) { ['tag2', 'tag3'] }
        let(:excluded_tags) { ['tag4'] }

        it { expect(resources_found).to include(file_1) }
        it { expect(resources_found).not_to include(file_2) }
        it { expect(resources_found).to include(file_3) }
        it { expect(resources_found).not_to include(file_4) }
        it { expect(resources_found).not_to include(file_5) }
      end

      context "+tag1" do
        let(:included_tags) { ['tag1'] }
        let(:excluded_tags) { [] }

        it { expect(resources_found).to include(file_1) }
        it { expect(resources_found).not_to include(file_2) }
        it { expect(resources_found).not_to include(file_3) }
        it { expect(resources_found).not_to include(file_4) }
        it { expect(resources_found).not_to include(file_5) }
      end

      context "+tag1" do
        let(:included_tags) { [] }
        let(:excluded_tags) { ['tag1'] }

        it { expect(resources_found).not_to include(file_1) }
        it { expect(resources_found).to include(file_2) }
        it { expect(resources_found).to include(file_3) }
        it { expect(resources_found).to include(file_4) }
        it { expect(resources_found).to include(file_5) }
      end

      context "+tag4 +tag5" do
        let(:included_tags) { ['tag4', 'tag5'] }
        let(:excluded_tags) { [] }


        it { expect(resources_found).not_to include(file_1) }
        it { expect(resources_found).not_to include(file_2) }
        it { expect(resources_found).not_to include(file_3) }
        it { expect(resources_found).to include(file_4) }
        it { expect(resources_found).not_to include(file_5) }
      end
    end

    describe "#related_content" do
      let(:search) do
        described_class.tag_filter(included_tags, excluded_tags)
      end
      let(:resources_found) do
        described_class.related_content(search, included_tags, excluded_tags)
      end

      context "+tag2 +tag3 -tag4" do
        let(:included_tags) { ['tag2', 'tag3'] }
        let(:excluded_tags) { ['tag4'] }

        it { expect(resources_found).to have_key('tag1') }
        it { expect(resources_found).to have_key('tag5') }
        it { expect(resources_found['tag1']).to eq(1) }
        it { expect(resources_found['tag5']).to eq(2) }
      end

      context "+tag1" do
        let(:included_tags) { ['tag1'] }
        let(:excluded_tags) { [] }

        it { expect(resources_found).to have_key('tag2') }
        it { expect(resources_found).to have_key('tag3') }
        it { expect(resources_found).to have_key('tag5') }
        it { expect(resources_found['tag2']).to eq(4) }
        it { expect(resources_found['tag3']).to eq(3) }
        it { expect(resources_found['tag5']).to eq(3) }
      end
    end
  end
end
