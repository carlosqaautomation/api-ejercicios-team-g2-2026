Feature: Depositos

  Background:
    * def reusableToken = call read('classpath:bdd/auth/login.feature@token')
    * print reusableToken
    * def tokenLogin = reusableToken.token
    * url "https://bankapi-n1t8.onrender.com"
    * def requests = read('classpath:resources/json/requests.json')
    * def schemas = read('classpath:resources/json/schemas.json')
    * def anadeSaldo = read('classpath:resources/json/anadeSaldo.json')

  @listarDepositos
  Scenario: CP01-Listar depositos
    Given path 'api/deposits'
    And header Authorization = 'Bearer ' + tokenLogin
    When method get
    Then status 200


  Scenario: CP02 - Añadir Saldo
    Given path 'api/deposits'
    And header Authorization = 'Bearer ' + tokenLogin
    And request anadeSaldo
    * print anadeSaldo
    When method post
    Then status 201


  Scenario: CP03 -  Obtener deposito por ID
    * def idAccount = '971246d7-1dca-4336-baac-2b49ac686bc3'
    Given path 'api/deposits/' + idAccount
    And header Authorization = 'Bearer ' + tokenLogin
    When method get
    Then status 200




