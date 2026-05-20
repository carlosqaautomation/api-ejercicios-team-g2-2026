Feature: Accounts

  Background:
    * def reusableToken = call read('classpath:bdd/auth/login.feature@token')
    * print reusableToken
    * def tokenLogin = reusableToken.token
    * url "https://bankapi-n1t8.onrender.com"

  Scenario Outline: Create accounts
    * def requestBody =  read('classpath:resources/json/requests.json')
    * def schemas = read('classpath:resources/json/schemas.json')
    Given path '/api/accounts'
    And header Authorization = ''
    And header Authorization = 'Bearer ' + tokenLogin
    And request requestBody.accountCreationRequest
    When method post
    Then status 201
    And match response == schemas.accountsResponseSchema
    And match requestBody.accountCreationRequest.accountType == type

    Examples:
      | type    | currency | balance |
      | savings | USD      | 1000    |
      | savings | PEN      | 5000    |


  Scenario: List accounts
    * def schemas = read('classpath:resources/json/schemas.json')
    Given path '/api/accounts'
    And header Authorization = ''
    And header Authorization = 'Bearer ' + tokenLogin
    When method get
    Then status 200
    And match each response.data contains schemas.ListAccountsResponseSchema.data[0]
