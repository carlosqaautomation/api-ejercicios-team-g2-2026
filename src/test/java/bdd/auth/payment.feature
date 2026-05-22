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
    Scenario: C002 - Sin header Authorization retorna 401
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

    @pagarServicio @success
    Scenario Outline: C003 - Pagar servicio con éxito
        * def requests = read('classpath:resources/json/requests.json')
        Given path 'api','payments'
        And request requests.pagarServicioRequest
        When method post
        Then status 201
        * match response.success == true
        * match response.data.serviceId     == 'electricity'
        * match response.data.serviceName   == 'Electricidad'
        * match response.data.status        == 'completed'
        * match response.data.amount        == 10
        * match response.data.processingFee == 1.5
        * match response.data contains { "serviceId": "electricity", "status":    "completed"}
        * assert response.data.newBalance > 0

        Examples:
          | read('classpath:resources/csv/auth/payment.csv') |

    @pagarServicio @unauthorized
    Scenario Outline: C004 - Pagar servicio sin autorización
      * def schemas = read('classpath:resources/json/schemas.json')
      * def requests = read('classpath:resources/json/requests.json')
      * header Authorization = null
      Given path 'api','payments'
      And request requests.pagarServicioRequest
      When method post
      Then status 401
      And match response.success == false
      And match response == schemas.paymentErrorUnauthorized

      Examples:
        | read('classpath:resources/csv/auth/payment.csv') |

    @listarServiciosPagados @success
    Scenario: CP005 - Listar servicios pagados
      Given path 'api','payments'
      When method get
      Then status 200
      * def paymentSchemaObject =
      """
      {
        "success": "#boolean",
        "data": "#[] #object",
        "pagination": {
          "limit":  "#number",
          "offset": "#number"
        }
      }
      """
      And match response == paymentSchemaObject
      * match response.success       == true
      * match response.pagination    == { limit: 20, offset: 0 }
      * match response.pagination.limit  == 20
      * match response.pagination.offset == 0
      * match response.data[0] contains {"serviceId":   "electricity","serviceName": "Electricidad","status": "completed"}
      * match response.data[0].userId    == '63eedddd-f94a-4a2b-a93c-fe499aebf63d'
      * match response.data[0].accountId == '8ae20343-7b79-43ce-99dd-f0ea2f136ea3'

    @listarServiciosPagados @unauthorized
    Scenario: CP006 - Listar servicios pagados
      * header Authorization = 'AWS4 ' + tokenLogin
      Given path 'api','payments'
      When method get
      Then status 401

