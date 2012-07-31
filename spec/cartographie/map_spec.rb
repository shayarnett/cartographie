require 'spec_helper'
require 'cartographie/map'

describe Cartographie::Map do

  subject { described_class.new }

  let(:points) { ["Empire State Building", "40.704154,-73.99459", "Guggenheim Museum"] }

  describe 'with options' do
    let(:options) { { width: 75, height: 75, zoom: 10, file_format: 'jpg', sensor: true, points: points } }

    subject { described_class.new 'New York, NY', options }

    its(:location) { should eq('New York, NY') }
    its(:width) { should eq(75) }
    its(:height) { should eq(75) }
    its(:size) { should eq('75x75') }
    its(:zoom) { should eq(10) }
    its(:file_format) { should eq('jpg') }
    its(:sensor) { should be_true }
    its(:points) { should =~ (points) }
  end

  describe "#additional_points" do

    context "no additional points" do
      let(:map) { described_class.new('New York, NY') }

      subject { map.additional_points }

      it 'returns an emtpy string' do
        subject.should be_empty
      end
    end

    context 'mixed array to string' do
      let(:options) { { points: points } }
      let(:map) { described_class.new('New York, NY', options) }

      subject { map.additional_points }

      it 'returns a pipe seperated string' do
        subject.should eq("Empire State Building|40.704154,-73.99459|Guggenheim Museum")
      end
    end
  end

  describe '#uri' do
    let(:map) { described_class.new 'Tokyo' }

    subject { map.uri }

    it "should match the instance's string representation" do
      subject.should eq(map.to_s)
    end

    it 'returns a Google Static Maps URI' do
      subject.should include('http://maps.googleapis.com/maps/api/staticmap')
    end

    it 'contains the map location' do
      subject.should include(map.location)
    end

    it 'contains the map size, like 640x640' do
      subject.should include(map.size)
    end

    it 'contains the map zoom level' do
      subject.should include(map.zoom.to_s)
    end

    it 'contains the map file format' do
      subject.should include(map.file_format)
    end

    it 'contains the map sensor indication' do
      subject.should include(map.sensor.to_s)
    end
  end

end
