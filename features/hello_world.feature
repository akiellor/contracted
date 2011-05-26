Feature: HelloWorld app says "Hello World"

Scenario: GET /
  Given the "HelloWorld" app is running
  When an api client performs GET /
  Then the json response should look like:
  """
  HTTP/1.1 200 OK
  
  {"message": "Hello World"}
  """

Scenario: GET / has message
  Given the "HelloWorld" app is running
  When an api client performs GET /
  Then the json response should look like:
  """
  HTTP/1.1 200 OK
  
  {"message": "{{...}}"}
  """
