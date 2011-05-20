Feature: Echo app responds with message

Scenario: GET with message 'hello'
  Given the "Echo" app is running
  When an api client performs GET /?message=hello
  Then the json response should look like:
  """
    {'message': 'hello'}
  """
