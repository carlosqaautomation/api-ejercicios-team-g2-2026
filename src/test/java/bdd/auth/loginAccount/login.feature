Feature: Casos de prueba login

  @token
  Scenario Outline: CP01-Crear token usuario
    * def requests = read('classpath:resources/json/requests.json')
    * def schemas = read('classpath:resources/json/schemas.json')
    Given url "https://bankapi-n1t8.onrender.com"
    And path "/api/auth/login"
    And request requests.loginRequest
    * print requests.loginRequest
    When method post
    Then status 200
    And match response == schemas.loginResponseSchema
    And match response.data.user contains { email: "<user>" }
    * def token = response.data.accessToken

    Examples:
      |user|password|
      | ricardo@bankapi.com | password123 |