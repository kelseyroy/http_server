@method-not-allowed @01-getting-started
Feature: Method Not Allowed

  Scenario: Finding POST for an endpoint with only GET
    Given I make a POST request to "/simple_get"
    Then my response should have status code 405
    And my response should have allowed headers of GET, HEAD, OPTIONS
    And my response should have an empty body

  Scenario: Finding DELETE for an endpoint with only GET
    Given I make a DELETE request to "/simple_get_with_body"
    Then my response should have status code 405
    And my response should have allowed headers of GET, HEAD, OPTIONS
    And my response should have an empty body
