# API Ejercicios Team G2 2026

Proyecto de automatizacion de pruebas API con **Karate + JUnit 5 + Maven**.

## Estructura del proyecto

```text
api-ejercicios-team-g2-2026/
|- pom.xml
|- src/
|  |- test/
|  |  |- java/
|  |  |  |- karate-config.js
|  |  |  |- logback-test.xml
|  |  |  |- bdd/
|  |  |  |  |- ConfigTest.java
|  |  |  |  |- TestRunner.java
|  |  |  |  |- auth/
|  |  |  |  |  |- login.feature
|  |  |  |  |  |- accounts.feature
|  |  |  |  |  |- card.feature
|  |  |  |- resources/
|  |  |  |  |- csv/
|  |  |  |  |  |- auth/
|  |  |  |  |  |  |- dataLogin.csv
|  |  |  |  |  |  |- cuentas.csv
|  |  |  |  |  |  |- tarjeta.csv
|  |  |  |  |- json/
|  |  |  |  |  |- requests.json
|  |  |  |  |  |- schemas.json
|- target/
   |- karate-reports/
```

## Que contiene cada parte

- `src/test/java/bdd/auth/*.feature`: escenarios de negocio (login, cuentas y tarjetas).
- `src/test/java/resources/json/*.json`: payloads y esquemas esperados.
- `src/test/java/resources/csv/auth/*.csv`: datos parametrizados para `Scenario Outline`.
- `src/test/java/karate-config.js`: configuracion global de Karate (`urlBase`, entorno, etc.).
- `target/karate-reports/`: reportes HTML/JSON generados al ejecutar pruebas.

## Requisitos

- Java 8+
- Maven 3.8+

## Ejecucion basica

Ejecutar toda la suite definida por el runner de JUnit:

```bash
mvn clean test
```

## Ejecucion por tags

El `TestRunner` ya esta configurado para leer la propiedad `karate.tags` y aplicar el filtro sobre **todos** los `.feature` bajo `src/test/java/bdd` (incluyendo cualquier sub-paquete presente o futuro).

### Ejecutar un tag especifico

```bash
mvn test -Dtest=TestRunner -Dkarate.tags=@token
```

### Ejecutar los escenarios de tarjetas (tag de feature)

```bash
mvn test -Dtest=TestRunner -Dkarate.tags=@tarjeta
```

### Ejecutar un escenario puntual por tag

```bash
mvn test -Dtest=TestRunner -Dkarate.tags=@crearTarjeta
```

### Excluir un tag

```bash
mvn test -Dtest=TestRunner -Dkarate.tags=~@consultarTarjeta
```

### Ejecutar multiples tags

```bash
mvn test -Dtest=TestRunner -Dkarate.tags="@crearCuenta,@crearTarjeta"
```

## Tags disponibles actualmente

- `@token` en `src/test/java/bdd/auth/login.feature`
- `@tarjeta` en `src/test/java/bdd/auth/card.feature` (aplica a todos sus escenarios)
- `@crearCuenta` en `src/test/java/bdd/auth/card.feature`
- `@crearTarjeta` en `src/test/java/bdd/auth/card.feature`
- `@obtenerTarjeta` en `src/test/java/bdd/auth/card.feature`
- `@consultarTarjeta` en `src/test/java/bdd/auth/card.feature`

## Reportes

Luego de ejecutar:

- HTML principal: `target/karate-reports/karate-summary.html`
- Timeline: `target/karate-reports/karate-timeline.html`
- Tags: `target/karate-reports/karate-tags.html`

---

Si deseas, puedo tambien agregar una seccion de **comandos rapidos** para CI (por ejemplo, smoke/regresion por tags) y dejarla lista para tu pipeline.

