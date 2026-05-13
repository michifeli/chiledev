# Documentación Técnica Modulo de Scrapeo

El modulo de scraping, es un microservicio autonomo y automatizado responsable de navegar por portales de empleo, identificar ofertas laborales y extraer su información fundamental según la estructura de datos dada. Los datos se extraen en formato `raw`. Este módulo no procesa semánticamente la información; su único propósito es alimentar la base de datos central para su posterior análisis.

### Sobre el Motor de Extracción
Se tenian dos opciónes consideradas dos opciones Puppeter y Playwright. Se opto por la ultima dada su buena reputación en proyectos de scraping anteriores, ademas poder tener medidas anti-bots que nos permiten saltear diversas medidas de seguridad.
