defmodule DecoyDetectorTest do
  use ExUnit.Case

  describe "DecoyDetector.sum_block/1" do
    test "example" do
      block = """
      aaaaa-bbb-z-y-x-123[abxyz]
      a-b-c-d-e-f-g-h-987[abcde]
      not-a-real-room-404[oarel]
      totally-real-room-200[decoy]
      """

      assert DecoyDetector.sum_block(block) == 1514
    end
  end

  describe "DecoyDetector.parse/1" do
    test "aaaaa-bbb-z-y-x-123[abxyz]" do
      input = "aaaaa-bbb-z-y-x-123[abxyz]"

      result = DecoyDetector.parse(input)

      assert Map.get(result, :name) == "aaaaa-bbb-z-y-x"
      assert Map.get(result, :sector_id) == 123
      assert Map.get(result, :checksum) == "abxyz"
    end

    test "a-b-c-d-e-f-g-h-987[abcde]" do
      input = "a-b-c-d-e-f-g-h-987[abcde]"

      result = DecoyDetector.parse(input)

      assert Map.get(result, :name) == "a-b-c-d-e-f-g-h"
      assert Map.get(result, :sector_id) == 987
      assert Map.get(result, :checksum) == "abcde"
    end

    test "not-a-real-room-404[oarel]" do
      input = "not-a-real-room-404[oarel]"

      result = DecoyDetector.parse(input)

      assert Map.get(result, :name) == "not-a-real-room"
      assert Map.get(result, :sector_id) == 404
      assert Map.get(result, :checksum) == "oarel"
    end

    test "totally-real-room-200[decoy]" do
      input = "totally-real-room-200[decoy]"
      result = DecoyDetector.parse(input)

      assert Map.get(result, :name) == "totally-real-room"
      assert Map.get(result, :sector_id) == 200
      assert Map.get(result, :checksum) == "decoy"
    end
  end

  describe "DecoyDetector.valid?/1" do
    test "aaaaa-bbb-z-y-x-123[abxyz]" do
      input = %{
        name: "aaaaa-bbb-z-y-x",
        sector_id: 123,
        checksum: "abxyz"
      }

      assert DecoyDetector.valid?(input)
    end

    test "a-b-c-d-e-f-g-h-987[abcde]" do
      input = %{
        name: "a-b-c-d-e-f-g-h",
        sector_id: 987,
        checksum: "abcde"
      }

      assert DecoyDetector.valid?(input)
    end

    test "not-a-real-room-404[oarel]" do
      input = %{
        name: "not-a-real-room",
        sector_id: 404,
        checksum: "oarel"
      }

      assert DecoyDetector.valid?(input)
    end

    test "totally-real-room-200[decoy]" do
      input = %{
        name: "totally-real-room",
        sector_id: 200,
        checksum: "decoy"
      }


      refute DecoyDetector.valid?(input)
    end
  end
end
