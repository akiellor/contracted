Feature: HelloWorld app says "Hello World"

Scenario: Simple get on app root
  Given the "HelloWorld" app is running
  When an api client performs GET /
  Then the json response should look like:
  """
    {'message': 'Hello World'}
  """
