Feature: Accounts

  Background:
    * def reusableToken = call read('classpath:bdd/auth/loginAccount/login.feature@token')
    * print reusableToken
    * def tokenLogin = reusableToken.token
    * url "https://bankapi-n1t8.onrender.com"

  Scenario Outline: Create accounts
    * def requestBody =  read('classpath:resources/json/Account/requests.json')
    * def schemas = read('classpath:resources/json/Account/schemas.json')
    * print requestBody.accountCreationRequest
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
    * def schemas = read('classpath:resources/json/Account/schemas.json')
    Given path '/api/accounts'
    And header Authorization = ''
    And header Authorization = 'Bearer ' + tokenLogin
    When method get
    Then status 200
    And match each response.data contains schemas.ListAccountsResponseSchema.data[0]

  Scenario Outline: Get account by id
    * def schemas = read('classpath:resources/json/Account/schemas.json')
    Given path 'api/accounts', accountId
    And header Authorization = ''
    And header Authorization = 'Bearer ' + tokenLogin
    When method get
    Then status 200
    And match response == schemas.getAccountResponseSchema
    And match response.data.id == accountId

    Examples:
      | accountId                            |
      | b97a850f-3774-4c11-b69b-c9534463e517 |

  Scenario: Get account not found
    * def schemas = read('classpath:resources/json/Account/schemas.json')
    Given path '/api/accounts', accountId
    And header Authorization = ''
    And header Authorization = 'Bearer ' + tokenLogin
    When method get
    Then status 404
    And match response == schemas.getAccountNotFoundSchema
    And match response.error.code == 'ACCOUNT_NOT_FOUND'

  Scenario Outline: Get account balance by id
    * def schemas = read('classpath:resources/json/Account/schemas.json')
    Given path '/api/accounts/', accountId, '/balance'
    And header Authorization = ''
    And header Authorization = 'Bearer ' + tokenLogin
    When method get
    Then status 200
    And match response == schemas.getAccountBalanceSchema
    And match response.data.accountId == accountId

    Examples:
      | accountId                            |
      | b97a850f-3774-4c11-b69b-c9534463e517 |
