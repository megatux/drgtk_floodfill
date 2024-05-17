require 'minitest/autorun'
require_relative '../flood_fill'

describe "Map" do
  subject { Map.new(map, true) }
  let(:color) { 8 }

  describe "empty map" do
    let(:map) { [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
    ] }

    it "should paint all" do
      subject.paint(1, 1, 0, color, 0.1)

      assert_equal subject.map, [
        [color, color, color, color, color],
        [color, color, color, color, color],
        [color, color, color, color, color],
        [color, color, color, color, color],
        [color, color, color, color, color],
      ]
    end
  end

  describe "hard paint" do
    let(:map) { [
      [0, 0, 0, 0, 0],
      [0, 0, 2, 0, 0],
      [0, 0, 2, 3, 8],
      [2, 2, 2, 0, 0],
      [0, 0, 2, 0, 5],
    ] }

    it "should paint all" do
      subject.paint(1, 1, 0, 8, 0.8)

      assert_equal subject.map, [
        [8, 8, 8, 8, 8],
        [8, 8, 2, 8, 8],
        [8, 8, 2, 3, 8],
        [2, 2, 2, 0, 0],
        [0, 0, 2, 0, 5],
      ]
    end

    describe "hard paint 2" do
      let(:map) { [
        [0, 0, 0, 0, 0],
        [0, 0, 2, 0, 0],
        [0, 0, 2, 3, 8],
        [2, 2, 2, 0, 0],
        [0, 0, 2, 0, 5],
      ] }

      it "should paint all" do
        subject.paint(2, 1, 2, 8, 0.8)

        assert_equal subject.map, [
          [0, 0, 0, 0, 0],
          [0, 0, 8, 0, 0],
          [0, 0, 8, 3, 8],
          [8, 8, 8, 0, 0],
          [0, 0, 8, 0, 5],
        ]
      end
    end
  end
end