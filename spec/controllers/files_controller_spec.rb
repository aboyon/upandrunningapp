require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  render_views

  describe "#index" do

    let!(:file_1) { create(:resource, :name => 'File1', :tags => "tag1,tag2,tag3,tag5") }
    let!(:file_2) { create(:resource, :name => 'File2', :tags => "tag2") }
    let!(:file_3) { create(:resource, :name => 'File3', :tags => "tag2,tag3,tag5") }
    let!(:file_4) { create(:resource, :name => 'File4', :tags => "tag2,tag3,tag4,tag5") }
    let!(:file_5) { create(:resource, :name => 'File5', :tags => "not_avaiable_tags") }

    before do
      get :index, params.merge!({:format => request_format})
    end

    let(:params) { {} }

    context "JSON" do
      let(:request_format) { :json }

      let(:file_names) do
        json_response[:records].map { |file| file[:name] }
      end

      it { expect(json_response).not_to be_empty }
      it { expect(json_response[:total_records]).to eq(5) }
      it { expect(json_response[:records].size).to eq(5) }
      it { expect(file_names).to include('File1') }
      it { expect(file_names).to include('File2') }
      it { expect(file_names).to include('File3') }
      it { expect(file_names).to include('File4') }
      it { expect(file_names).to include('File5') }

      context "search" do
        let(:file_names) do
          json_response[:records].map { |file| file[:name] }
        end

        let(:related_tags) do
          json_response[:related_tags].map { |tag| [tag['tag'],tag['file_count']] }
        end

        let(:params) { {:params => {:filter => '+tag2 +tag3 -tag4'}} }

        it { expect(json_response).not_to be_empty }
        it { expect(json_response[:total_records]).to eq(2) }
        it { expect(json_response[:records].size).to eq(2) }
        it { expect(json_response[:related_tags]).not_to be_empty }
        it { expect(related_tags.first).to eq(['tag1',1]) }
        it { expect(related_tags.last).to eq(['tag5',2]) }
        it { expect(file_names).to include('File1') }
        it { expect(file_names).not_to include('File2') }
        it { expect(file_names).to include('File3') }
        it { expect(file_names).not_to include('File4') }
        it { expect(file_names).not_to include('File5') }

        end
    end
  end
end
