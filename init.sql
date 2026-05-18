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