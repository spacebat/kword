defmodule KwordTest do
  use ExUnit.Case, async: true
  doctest Kword

  alias Kword, as: K

  describe "extract/2" do
    test "should return error with first missing required parameter" do
      assert {:error, {:missing, :one}} = K.extract([], [:one, :two, three: 33])
      assert {:error, {:missing, :one}} = K.extract([two: 2, three: 3], [:one, :two, three: 33])
      assert {:error, {:missing, :two}} = K.extract([three: 3, one: 1], [:one, :two, three: 33])
    end

    test "should return extracted values in order of second parameter" do
      assert {:ok, [1, 2, 3]} = K.extract([one: 1, two: 2, three: 3], [:one, :two, :three])
      assert {:ok, [1, 2, 3]} = K.extract([three: 3, two: 2, one: 1], [:one, two: 22, three: 33])
      assert {:ok, [1, 22, 33]} = K.extract([one: 1], [:one, two: 22, three: 33])
      assert {:ok, [11, 22, 33]} = K.extract([], one: 11, two: 22, three: 33)
    end

    test "should ignore unspecified parameters" do
      assert {:ok, [1, 2, 3]} =
               K.extract([one: 1, two: 2, three: 3, four: 4], [:one, :two, :three])
    end
  end

  describe "extract!/2" do
    test "should raise ArgumentError with first missing required parameter" do
      assert_raise ArgumentError, ~r/\Amissing key :one\z/i, fn ->
        K.extract!([], [:one, :two, three: 33])
      end

      assert_raise ArgumentError, ~r/\Amissing key :one\z/i, fn ->
        K.extract!([two: 2, three: 3], [:one, :two, three: 33])
      end

      assert_raise ArgumentError, ~r/\Amissing key :two\z/i, fn ->
        K.extract!([three: 3, one: 1], [:one, :two, three: 33])
      end
    end

    test "should return extracted values in order of second parameter" do
      assert [1, 2, 3] = K.extract!([one: 1, two: 2, three: 3], [:one, :two, :three])
      assert [1, 2, 3] = K.extract!([three: 3, two: 2, one: 1], [:one, two: 22, three: 33])
      assert [1, 22, 33] = K.extract!([one: 1], [:one, two: 22, three: 33])
      assert [11, 22, 33] = K.extract!([], one: 11, two: 22, three: 33)
    end

    test "should ignore unspecified parameters" do
      assert [1, 2, 3] = K.extract!([one: 1, two: 2, three: 3, four: 4], [:one, :two, :three])
    end
  end

  describe "extract_permissive/2" do
    test "should return nil for each missing required parameter" do
      assert [nil, nil, 33] = K.extract_permissive([], [:one, :two, three: 33])
      assert [nil, 2, 3] = K.extract_permissive([two: 2, three: 3], [:one, :two, three: 33])
      assert [1, nil, 3] = K.extract_permissive([three: 3, one: 1], [:one, :two, three: 33])
    end

    test "should return extracted values in order of second parameter" do
      assert [1, 2, 3] = K.extract_permissive([one: 1, two: 2, three: 3], [:one, :two, :three])

      assert [1, 2, 3] =
               K.extract_permissive([three: 3, two: 2, one: 1], [:one, two: 22, three: 33])

      assert [1, 22, 33] = K.extract_permissive([one: 1], [:one, two: 22, three: 33])
      assert [11, 22, 33] = K.extract_permissive([], one: 11, two: 22, three: 33)
    end

    test "should ignore unspecified parameters" do
      assert [1, 2, 3] =
               K.extract_permissive([one: 1, two: 2, three: 3, four: 4], [:one, :two, :three])
    end
  end

  describe "extract_exhaustive/2" do
    test "should return error with first missing required parameter" do
      assert {:error, {:missing, :one}} = K.extract_exhaustive([], [:one, :two, three: 33])

      assert {:error, {:missing, :one}} =
               K.extract_exhaustive([two: 2, three: 3], [:one, :two, three: 33])

      assert {:error, {:missing, :two}} =
               K.extract_exhaustive([three: 3, one: 1], [:one, :two, three: 33])
    end

    test "should return extracted values in order of second parameter" do
      assert {:ok, [1, 2, 3]} =
               K.extract_exhaustive([one: 1, two: 2, three: 3], [:one, :two, :three])

      assert {:ok, [1, 2, 3]} =
               K.extract_exhaustive([three: 3, two: 2, one: 1], [:one, two: 22, three: 33])

      assert {:ok, [1, 22, 33]} = K.extract_exhaustive([one: 1], [:one, two: 22, three: 33])
      assert {:ok, [11, 22, 33]} = K.extract_exhaustive([], one: 11, two: 22, three: 33)
    end

    test "should return error with first unexpected parameters" do
      assert {:error, {:unexpected, :four}} =
               K.extract_exhaustive(
                 [one: 1, two: 2, three: 3, four: 4],
                 [:one, :two, :three]
               )
    end
  end
end
