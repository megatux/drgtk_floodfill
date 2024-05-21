require 'minitest/autorun'
require_relative '../mygame/app/map'

describe "Map" do
  subject { Map.new(map, debug: true) }

  describe "empty map" do
    let(:map) { [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
    ] }

    it "should paint all" do
      subject.paint(x: 1, y: 1, base_color: 0, new_color: 8)

      assert_equal subject.map, [
        [8, 8, 8, 8, 8],
        [8, 8, 8, 8, 8],
        [8, 8, 8, 8, 8],
        [8, 8, 8, 8, 8],
        [8, 8, 8, 8, 8],
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
      subject.paint(x: 1, y: 1, base_color: 0, new_color: 8, sleep_time: 0.8)

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
        subject.paint(x: 2, y: 1, base_color: 2, new_color: 8, sleep_time: 0.8)

        assert_equal subject.map, [
          [0, 0, 0, 0, 0],
          [0, 0, 8, 0, 0],
          [0, 0, 8, 3, 8],
          [8, 8, 8, 0, 0],
          [0, 0, 8, 0, 5],
        ]
      end
    end

    describe "no paint needed" do
      let(:map) { [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
      ] }

      it "should paint all" do
        subject.paint(x: 2, y: 1, base_color: 0, new_color: 0, sleep_time: 0.8)

        assert_equal subject.map, map
      end
    end
  end
end