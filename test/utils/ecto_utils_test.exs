defmodule GoBillManager.Utils.EctoUtilsTest do
  use GoBillManager.DataCase

  alias GoBillManager.Utils.EctoUtils

  describe "validate_uuid/1" do
    test "should return error when argument isn't valid uuid" do
      invalid_uuid = "invalid"
      assert {:error, :invalid_uuid} == EctoUtils.validate_uuid(invalid_uuid)
    end

    test "should return ok and uuid when uuid is valid" do
      valid_uuid = Ecto.UUID.autogenerate()
      assert {:ok, ^valid_uuid} = EctoUtils.validate_uuid(valid_uuid)
    end
  end

  describe "all_valid_uuids?/1" do
    test "should return true when all uuids are valids" do
      valid_uuids = [Ecto.UUID.autogenerate(), Ecto.UUID.autogenerate()]
      assert true == EctoUtils.all_valid_uuids?(valid_uuids)
    end

    test "should return false when some uuid on list are invalid" do
      valid_uuids = [Ecto.UUID.autogenerate(), Ecto.UUID.autogenerate(), 1]
      assert false == EctoUtils.all_valid_uuids?(valid_uuids)
    end
  end
end
