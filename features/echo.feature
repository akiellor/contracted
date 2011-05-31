Feature: Echo app responds with message

Scenario: GET with message 'hello'
  Given the "Echo" app is running
  When an api client performs GET /?message=hello
  Then the json response body should look like:
  """
  {"message": "hello"}
  """

Scenario: GET with any message
  Given the "Echo" app is running
  When an api client performs GET /?message=blah
  Then the json response body should look like:
  """
  {"message": ...}
  """

