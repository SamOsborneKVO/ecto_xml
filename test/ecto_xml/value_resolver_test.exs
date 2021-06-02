defimpl EctoXml.ValueResolver, for: Tuple do
  @moduledoc "ValueResolver implementation for Tuple that returns 42."

  def resolve(_value, _key, _base_module) do
    "42"
  end
end

defmodule Test.ValueResolver do
  @moduledoc false

  use ExUnit.Case, async: true

  doctest EctoXml.ValueResolver

  describe "ValueResolver" do
    test "should allow overriding the value resolver to change element values" do
      xml =
        %{tuple_field: {:ok, "foo bar"}}
        |> EctoXml.to_xml()

      assert xml == "<tuple_field>42</tuple_field>"
    end
  end
end
