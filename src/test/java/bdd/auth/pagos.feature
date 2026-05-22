Feature: Payments

  Background:
    * def reusableToken = call read('classpath:bdd/auth/login.feature@token')
    * print reusableToken
    * def tokenLogin = reusableToken.token
    * url urlBase
    * header Authorization = 'Bearer ' + tokenLogin

    @listarServicios @success
    Scenario: C001 - Listar servicios de pago con éxito
      * def schemas = read('classpath:resources/json/schemas.json')
      Given path 'api','payments','services'
      When method get
      Then status 200
      And match response == schemas.paymentResponseListarObjetos
      And match each response.data == schemas.paymentResponseListar
      And match response.success == true
      * def ids = $response.data[*].id
      * def uniqueIds = karate.distinct(ids)
      * assert ids.length == uniqueIds.length

    @listarServicios @unauthorized
    Scenario: C003 - Sin header Authorization retorna 401
      * def schemas = read('classpath:resources/json/schemas.json')
      * header Authorization = null
      Given path 'api','payments','services'
      When method get
      Then status 401
      And match response == schemas.paymentErrorUnauthorized
      And match response.success == false
      And match response.error.code == 'UNAUTHORIZED'
      And match response.error.message == 'No token provided'
      And match response.data == '#notpresent'