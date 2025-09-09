Feature: Placeholder
  Scenario: placeholder
    Given I have resource that are aws_instance
    When it should always pass
    Then it must have attribute tags
