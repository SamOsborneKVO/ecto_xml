EctoXml
===========

[![CI](https://github.com/pedro-lb/ecto_xml/actions/workflows/build_and_test.yml/badge.svg)](https://github.com/pedro-lb/ecto_xml/actions/workflows/build_and_test.yml)
[![Module Version](https://img.shields.io/hexpm/v/ecto_xml.svg)](https://hex.pm/packages/ecto_xml)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/ecto_xml/)
[![Total Download](https://img.shields.io/hexpm/dt/ecto_xml.svg)](https://hex.pm/packages/ecto_xml)
[![License](https://img.shields.io/hexpm/l/ecto_xml.svg)](https://github.com/pedro-lb/ecto_xml/blob/master/LICENSE)
[![codecov](https://codecov.io/gh/pedro-lb/ecto_xml/branch/master/graph/badge.svg)](https://codecov.io/gh/pedro-lb/ecto_xml)
[![Last Updated](https://img.shields.io/github/last-commit/pedro-lb/ecto_xml.svg)](https://github.com/pedro-lb/ecto_xml/commits/master)

## Overview

EctoXml provides a way to easily generate XML documents from Ecto Schemas and maps.

It supports converting all ecto schema properties to XML, such as `embeds_one`, `has_one`, `embeds_many` and `has_many`. On top of that,
it also allows customizing name and value resolvers, giving you full control over your XML.

Under the hood it uses [Joshua Nussbaum](https://github.com/joshnuss) amazing work on [xml_builder](https://github.com/joshnuss/xml_builder),
so the idea here is to remove complexity and DRY the process of generating XML based on maps and ecto schemas.

Check the examples below to see some code and get started!

## Installation

The package is [available in Hex](https://hex.pm/packages/xml_builder), and can be installed
by adding `ecto_xml` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_xml, "~> 1.0.0"}
  ]
end
```

## Examples

### Available functions

EctoXml exports `to_xml/3` and `to_partial_xml/2`.

The difference is that `to_xml/3` allows us to build a full XML document with a root element whose name is passed as an atom.

The `to_partial_xml/2` function only generates the partial XML element, without the XML document and root element.

The last argument for both functions is always the `options` argument - it is optional and is the same as
[xml_builder options](https://hexdocs.pm/xml_builder/XmlBuilder.html#generate/2).

#### to_partial_xml/2

```elixir
%{name: "Foo Bar"} |> EctoXml.to_partial_xml(format: :none)
```

Produces:

```xml
<name>Foo Bar</name>
```

#### to_xml/3

```elixir
%{name: "Foo Bar"} |> EctoXml.to_xml(:person, format: :none)
```

Produces:

```xml
<?xml version="1.0" encoding="UTF-8"?><person><name>Foo Bar</name></person>
```

### Using Maps

The simplest form of usage is using maps.

```elixir
%{name: "Foo Bar"} |> EctoXml.to_xml(:person)
```

Results in:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<person>
  <name>Foo Bar</name>
</person>
```

### Using Ecto Schemas

We can also use any ecto schema (embedded or not) to generate our XML documents.

```elixir
defmodule Person do
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :name, :string
  end
end

%Person{name: "Foo Bar"} |> EctoXml.to_xml(:person)
```

Results in:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<person>
  <name>Foo Bar</name>
</person>
```

### Customizing element names

We can change any element name for the ecto schema being serialized by deriving from the `EctoXml.Builder` protocol.

Here, we have two optional properties:
- `map_field_names`: changes the element name for any field
- `map_array_names`: changes the element name for array fields

Note that in the case of arrays, the `map_field_names` option will not be applied to the array itself. Instead,
it will be applied to the array items, allowing you to customize each item name. In order to change the array
element name, we must use `map_array_names`.

```elixir
defmodule Post do
  use Ecto.Schema

  @primary_key false

  @derive {
    EctoXml.Builder,
    map_field_names: %{
      :title => :custom_title,
      :comments => :a_comment
    },
    map_array_names: %{
      :comments => :custom_comments
    }
  }

  embedded_schema do
    field :title, :string
    embeds_many :comments, Comment
  end
end

defmodule Comment do
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :content, :string
  end
end

%Post{
  title: "Foo Bar",
  comments: [
    %Comment{content: "Comment 1"},
    %Comment{content: "Comment 2"},
  ]
}
|> EctoXml.to_xml(:post)
```

Results in:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<post>
  <custom_comments>
    <a_comment>
      <content>Comment 1</content>
    </a_comment>
    <a_comment>
      <content>Comment 2</content>
    </a_comment>
  </custom_comments>
  <custom_title>Foo Bar</custom_title>
</post>
```

### Customizing element values

We can use the `EctoXml.ValueResolver` protocol to customize and resolve the value for any element type.

It receives some options to resolve the value:
- `value`: the original element value
- `key`: the field name
- `base_module`: the base module which is being serialized to XML

Here's one example for a tuple:

```elixir
defimpl EctoXml.ValueResolver, for: Tuple do
  @moduledoc "ValueResolver implementation for Tuple that for some mysterious reason, always returns 42."

  def resolve(_value, _key, _base_module) do
    "42"
  end
end

%{value: {:ok, "foo bar"}}
|> EctoXml.to_xml(:tuple)
```

Produces:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<tuple>
  <value>42</value>
</tuple>
```

## License

This source code is licensed under the [MIT License](https://github.com/pedro-lb/ecto_xml/blob/master/LICENSE).
Copyright (c) 2021-present, Pedro Bini. All rights reserved.
