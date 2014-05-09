Feature: Using files as input and output
  In order to tokenize text
  Using a file as an input
  Using a file as an output

  Scenario Outline: Tokenize the text
    Given the fixture file "<input_file>"
    And I put it through the kernel
    Then the output should match the fixture "<output_file>"
  Examples:
    | input_file        | output_file        |
    | input.en.kaf      | output.en.kaf      |
    | input.nl.kaf      | output.nl.kaf      |
    | input.de.kaf      | output.de.kaf      |
    | input.fr.kaf      | output.fr.kaf      |
    | input.it.kaf      | output.it.kaf      |
    | input.es.kaf      | output.es.kaf      |
