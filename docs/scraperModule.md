# Documentación Técnica Modulo de Scrapeo
El modulo de scraping, es un microservicio autonomo y automatizado responsable de navegar por portales de empleo, identificar ofertas laborales y extraer su información fundamental según la estructura de datos dada. Los datos se extraen en formato `raw`. Este módulo no procesa semánticamente la información; su único propósito es alimentar la base de datos central para su posterior análisis. El modulo de scraping se ejecuta cada 12 horas.

### Sobre el Motor de Extracción
Se tenian dos opciónes consideradas dos opciones Puppeter y Playwright. Se opto por la ultima dada su buena reputación en proyectos de scraping anteriores, ademas poder tener medidas anti-bots que nos permiten saltear diversas medidas de seguridad.

El scraper extrae la información y la inserta directamente en la base de datos con un estado pendiente, delegando la normalización al backend.

Como primer prototipo se tiene pensado realizar un scraping exitoso de almenos 3 plataformas; Laborum, GetOnBoard y Computrabajo.

### Esquema de Salida
```typescript
interface ScrapedJob {
  title: string;          // Ej: "Ingeniero Backend Senior"
  company: string | null; // Ej: "TechCorp Chile" o null si es confidencial
  portal_source: string;  // Ej: "GetOnBoard"
  url: string;            // URL única de la oferta (usada como identificador para evitar duplicados)
  modality: string;       // Ej: "Remoto", "Hibrido", "Presencial" o "No especificado"
  ubication: string | null;  // Ej: Santiago Centro, R.Metropolitana
  salary_min: number | null; 
  salary_max: number | null; 
  raw_description: string; // Texto plano íntegro extraído de la publicación
  time_stamp: string;      // Fecha de cuando fue extraida la oferta
  status: 'PENDING';       // Indicación para procesar posteriormente la data
}
```
