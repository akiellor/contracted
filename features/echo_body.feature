Feature: EchoBody app responds with message

Scenario: POST with body '{"message": "hello"}'
  Given the "EchoBody" app is running
  When an api client performs POST / with json body:
  """
    {'message': 'hello'}
  """
  Then the json response body should look like:
  """
  {"message": "hello"}
  """

Scenario: POST with body '{"message": "hello", "sender": "Tom"}'
  Given the "EchoBody" app is running
  When an api client performs POST / with json body:
  """
    {
      "message": "hello",
      "sender": "Tom"
    }
  """
  Then the json response body should look like:
  """
  {
    "message": "hello",
    "sender": ...
  }
  """

Scenario: POST with nested object body
  Given the "EchoBody" app is running
  When an api client performs POST / with json body:
  """
    {
      "message": {
        "sender": "Tom",
        "text": "Hello"
      }
    }
  """
  Then the json response body should look like:
  """
  {
    "message": {
      "sender": "Tom",
      "text": ...
    }
  }
  """

Scenario: POST with nested object body using wilcard match
  Given the "EchoBody" app is running
  When an api client performs POST / with json body:
  """
    {
      "message": {
        "sender": "Tom",
        "text": "Hello"
      }
    }
  """
  Then the json response body should look like:
  """
  {
    "message": {
      "sender": ...,
      ...
    }
  }
  """
