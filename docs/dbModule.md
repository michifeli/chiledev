# Esquema de la Base de Datos

El sistema utiliza PostgreSQL como motor para la base de datos.

## Modelo Entidad-Relación
La arquitectura de datos se compone de tres entidades fundamentales para minimizar la redundancia y optimizar las consultas de estadísticas.

<img width="741" height="422" alt="chileDev_ERD" src="https://github.com/user-attachments/assets/83914291-f5f6-461b-8873-d92e8a3747b4" />

### Esquema de Implementación

```SQL
-- Extensión necesaria para identificadores únicos universales (UUID)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE jobs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(255) NOT NULL,
  company VARCHAR(255),
  portal_source VARCHAR(50) NOT NULL,
  url TEXT UNIQUE NOT NULL,
  modality VARCHAR(50) DEFAULT 'No especificado',
  ubication VARCHAR(255),
  salary_min INTEGER,
  salary_max INTEGER,
  raw_description TEXT NOT NULL,
  status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, PROCESSED, ERROR
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE technologies (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL,
  category VARCHAR(50) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE job_technologies (
    job_id UUID REFERENCES jobs(id) ON DELETE CASCADE,
    technology_id INTEGER REFERENCES technologies(id) ON DELETE CASCADE,
    PRIMARY KEY (job_id, technology_id)
);

CREATE INDEX idx_jobs_status ON jobs(status);
CREATE INDEX idx_technologies_name ON technologies(name);
CREATE INDEX idx_job_technologies_tech_id ON job_technologies(technology_id);
```

## Implementación de IA

Para garantizar que la Inteligencia Artificial entregue datos estructurados que el sistema pueda iterar e insertar en la base de datos sin generar excepciones, el microservicio de procesamiento utiliza el siguiente prompt estricto:

```md
"Actúa como un extractor de datos técnico especializado en el mercado TI chileno. A continuación, recibirás un arreglo JSON con múltiples ofertas laborales en el formato `[{ "job_id": "uuid", "text": "descripción..." }]`.

Tu tarea es analizar cada texto y extraer las tecnologías mencionadas y la modalidad de trabajo.

REGLAS CRÍTICAS:
1. Normaliza los nombres a su sintaxis oficial (ej: 'JS' -> 'JavaScript', 'React.js' -> 'React').
2. Categoriza cada tecnología exclusivamente como: 'Lenguaje', 'Framework', 'Base de Datos', 'Cloud' o 'Herramienta'.
3. Identifica la modalidad exclusivamente como: 'Remoto', 'Híbrido' o 'Presencial'. Si no se menciona, usa 'No especificado'.
4. Devuelve ÚNICAMENTE un arreglo JSON válido donde cada objeto corresponda al `job_id` entregado, con la siguiente estructura exacta:

[
  {
    "job_id": "uuid original",
    "modality": "string",
    "technologies": [
      {
        "name": "string",
        "category": "string"
      }
    ]
  }
]
"
```
