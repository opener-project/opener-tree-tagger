Feature: Using files as input and output
  In order to tokenize text
  Using a file as an input
  Using a file as an output

  Scenario Outline: Tokenize the text
    Given the fixture file "<input_file>"
    And I put it through the kernel
    Then the output should match the fixture "<output_file>"
  Examples:
    | input.2.token.kaf            | output.2.token.kaf                                  |
    | input.token.kaf       | output.token.kaf                                  |

