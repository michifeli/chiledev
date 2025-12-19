-- Schema de ChileDev
-- PostgreSQL 15+

-- Empresas
CREATE TABLE companies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ofertas de trabajo
CREATE TABLE job_offers (
    id SERIAL PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    url TEXT UNIQUE NOT NULL,
    description TEXT,
    company_id INTEGER REFERENCES companies(id),
    location VARCHAR(255),
    scraped_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tecnologías
CREATE TABLE technologies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Relación N:N
CREATE TABLE job_technologies (
    job_offer_id INTEGER REFERENCES job_offers(id) ON DELETE CASCADE,
    technology_id INTEGER REFERENCES technologies(id) ON DELETE CASCADE,
    PRIMARY KEY (job_offer_id, technology_id)
);

-- Regiones de Chile
CREATE TABLE regions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    code VARCHAR(10) UNIQUE NOT NULL
);

INSERT INTO regions (name, code) VALUES
('Metropolitana', 'RM'),
('Valparaíso', 'VA'),
('Biobío', 'BI'),
('Araucanía', 'AR'),
('Los Lagos', 'LL')
-- ... agregar las demás regiones
ON CONFLICT (code) DO NOTHING;
