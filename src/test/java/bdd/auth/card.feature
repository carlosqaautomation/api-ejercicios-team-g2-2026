@tarjeta
Feature: Casos de prueba tarjeta

  Background:
    * def reusableToken = call read('classpath:bdd/auth/login.feature@token')
    * print reusableToken
    * def tokenLogin = reusableToken.token
    * url "https://bankapi-n1t8.onrender.com"
    * def requests = read('classpath:resources/json/requests.json')
    * def schemas = read('classpath:resources/json/schemas.json')

  @crearCuenta
  Scenario Outline: CP01-Crear cuenta
    Given path 'api/accounts'
    And header Authorization = 'Bearer ' + tokenLogin
    And request requests.createAccountRequest
    * print requests.createAccountRequest
    When method post
    Then status 201
    And match response.data.id == '#notnull'
    And match response.data.userId == '#notnull'
    And match response == schemas.cuentaResponseSchema
    * def idAccount = response.data.id
    * print idAccount

    Examples:
      |read('classpath:resources/csv/auth/cuentas.csv')|

  @crearTarjeta
   Scenario Outline: CP02-Crear tarjeta
    * def reusableId = call read('@crearCuenta')
    * print 'Contenido de reusableId:', reusableId
    * def ctaTarjeta = reusableId.idAccount
    Given path 'api/cards'
    And header Authorization = 'Bearer ' + tokenLogin
    And request { accountId: #(ctaTarjeta), cardType: "<cardType>", cardHolderName: "<cardHolderName>" }
    When method post
    Then status 201
    And match response.data.id == '#notnull'
    And match response.data.accountId == ctaTarjeta
    And match response == schemas.tarjetaResponseSchema
    * def id = response.data.id
        * print id

    Examples:
      |read('classpath:resources/csv/auth/tarjeta.csv')|

  @obtenerTarjeta
  Scenario: CP03 - Obtener tarjeta
    * def reusaId = call read('@crearTarjeta')
    * print 'Contenido de reusableId:', reusaId
    * def idTarjeta = reusaId.id
    * def requests = read('classpath:resources/json/requests.json')
    * def schemas = read('classpath:resources/json/schemas.json')
    Given path 'api/cards/' + idTarjeta
    And header Authorization = 'Bearer ' + tokenLogin
    When method get
    Then status 200
    And match response.data.id == '#notnull'

  @consultarTarjeta
  Scenario: CP04-Consultar tarjeta
    Given path 'api/cards'
    And header Authorization = 'Bearer ' + tokenLogin
    When method get
    Then status 200



