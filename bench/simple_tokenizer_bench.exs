defmodule SimpleTokenizerBench do
  use Benchfella
  alias  MarkovChain.Tokenizer.SimpleTokenizer
  @lorem_ipsum ~S"""
  Lorem ipsum dolor sit amet consectetur adipiscing elit Aenean cursus
  metus eget ornare semper ex leo sagittis mi nec congue magna sem eu ex
  Nulla dapibus semper ligula ut fringilla Phasellus nec ipsum vel libero
  semper mattis eget vitae lacus Duis nec varius mi Praesent nec nisi vel
  elit dictum aliquam Ut sapien eros, dapibus sit amet vulputate nec sodales
  at neque Aenean venenatis sem a est gravida et malesuada dui accumsan
  Suspendisse at auctor libero vel bibendum lorem Suspendisse finibus ex
  facilisis metus consequat sit amet pulvinar turpis pulvinar Quisque
  venenatis ante eu cursus gravida ex leo consectetur neque
  """ # 100 words

  #bench "tokenize 100", data: test_data(1) do
  #  SimpleTokenizer.tokenize(data)
  #end

  #bench "tokenize 10_000", data: test_data(100) do
  #  SimpleTokenizer.tokenize(data)
  #end

  #bench "tokenize 1_000_000", data: test_data(10_000) do
  #  SimpleTokenizer.tokenize(data)
  #end

  defp test_data(amount) do
    String.duplicate(@lorem_ipsum, amount)
  end
end
