defmodule MarkovChain.Tokenizer.SimpleTokenizerTest do
  use ExUnit.Case
  alias MarkovChain.Tokenizer.SimpleTokenizer

  test "empty text returns no tokens" do
    assert SimpleTokenizer.tokenize("") == []
  end

  test "only whitespace returns no tokens" do
    assert SimpleTokenizer.tokenize("   ") == []
  end

  test "split words on whitespace" do
    assert SimpleTokenizer.tokenize("dog cat ferret") == ["dog", "cat", "ferret"]
  end

  test "split words on new line" do
    assert SimpleTokenizer.tokenize(~S"""
      yes
      no
      maybe
    """) == ["yes", "no", "maybe"]
  end

  test "punctuation is seperated from words" do
    assert SimpleTokenizer.tokenize("pencil, birds. morning? ear! wing; shelf: leather- spy/ key")
      == ["pencil", ",", "birds", ".", "morning", "?", "ear", "!", "wing", ";",
    "shelf", ":", "leather", "-", "spy", "/", "key"]
  end

  test "quotes are stripped" do
    assert SimpleTokenizer.tokenize("and then he said \"trickle down economics\"!  hahaha")
      == ["and", "then", "he", "said", "trickle", "down", "economics", "!", "hahaha"]
  end

  test "tokens are downcased" do
    assert SimpleTokenizer.tokenize("CRUISE CONTROL") == ["cruise", "control"]
  end
end
