-- ========================================
-- Organization Table
-- ========================================
CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);

-- ========================================
-- Insert sample data: Organizations
-- ========================================
INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES
('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure through sustainable construction projects.', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
('GreenHarvest Growers', 'An urban farming collective promoting food sustainability and education in local neighborhoods.', 'contact@greenharvest.org', 'greenharvest-logo.png'),
('UnityServe Volunteers', 'A volunteer coordination group supporting local charities and service initiatives.', 'hello@unityserve.org', 'unityserve-logo.png');

SELECT * FROM organization;

-- ========================================
-- Service Project Table
-- ========================================
CREATE TABLE service_project (
    project_id SERIAL PRIMARY KEY,
    project_title VARCHAR(200) NOT NULL,
    project_date DATE NOT NULL,
    organization_id INTEGER NOT NULL REFERENCES organization(organization_id)
);

-- ========================================
-- Insert sample data: Service Projects
-- ========================================
INSERT INTO service_project (project_title, project_date, organization_id)
SELECT project_title, project_date, organization_id
FROM (
    VALUES
        ('Community Center Renovation', DATE '2026-03-14', 'BrightFuture Builders'),
        ('Safe Playground Construction', DATE '2026-04-11', 'BrightFuture Builders'),
        ('Neighborhood Accessibility Audit', DATE '2026-05-09', 'BrightFuture Builders'),
        ('Sustainable Housing Workshop', DATE '2026-06-13', 'BrightFuture Builders'),
        ('Community Tool Drive', DATE '2026-07-18', 'BrightFuture Builders'),
        ('Community Garden Planting Day', DATE '2026-03-21', 'GreenHarvest Growers'),
        ('Urban Farm Compost Workshop', DATE '2026-04-18', 'GreenHarvest Growers'),
        ('Fresh Food Donation Drive', DATE '2026-05-16', 'GreenHarvest Growers'),
        ('School Garden Mentoring', DATE '2026-06-20', 'GreenHarvest Growers'),
        ('Neighborhood Seed Exchange', DATE '2026-07-25', 'GreenHarvest Growers'),
        ('Volunteer Orientation Day', DATE '2026-03-28', 'UnityServe Volunteers'),
        ('Senior Support Outreach', DATE '2026-04-25', 'UnityServe Volunteers'),
        ('Local Food Pantry Service Day', DATE '2026-05-23', 'UnityServe Volunteers'),
        ('Youth Tutoring Program', DATE '2026-06-27', 'UnityServe Volunteers'),
        ('Community Health Fair Support', DATE '2026-08-01', 'UnityServe Volunteers')
) AS sample_projects(project_title, project_date, organization_name)
JOIN organization
  ON organization.name = sample_projects.organization_name;

-- Verify all projects and their organization names.
SELECT
    service_project.project_id,
    service_project.project_date,
    service_project.project_title,
    organization.name AS organization_name
FROM service_project
JOIN organization
  ON organization.organization_id = service_project.organization_id
ORDER BY service_project.project_date, service_project.project_id;

-- ========================================
-- Service Project Categories
-- ========================================
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE service_project_category (
    project_id INTEGER NOT NULL REFERENCES service_project(project_id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES category(category_id) ON DELETE CASCADE,
    PRIMARY KEY (project_id, category_id)
);

-- ========================================
-- Insert sample data: Categories
-- ========================================
INSERT INTO category (name)
VALUES
    ('Environmental'),
    ('Educational'),
    ('Community Service'),
    ('Health and Wellness');

-- Associate every service project with at least one category.
INSERT INTO service_project_category (project_id, category_id)
SELECT service_project.project_id, category.category_id
FROM service_project
JOIN category
  ON category.name = CASE
        WHEN service_project.project_title IN (
            'Community Garden Planting Day',
            'Urban Farm Compost Workshop',
            'Fresh Food Donation Drive',
            'School Garden Mentoring',
            'Neighborhood Seed Exchange'
        ) THEN 'Environmental'
        WHEN service_project.project_title IN (
            'Sustainable Housing Workshop',
            'Youth Tutoring Program',
            'Volunteer Orientation Day'
        ) THEN 'Educational'
        WHEN service_project.project_title IN (
            'Community Center Renovation',
            'Safe Playground Construction',
            'Neighborhood Accessibility Audit',
            'Community Tool Drive',
            'Senior Support Outreach',
            'Local Food Pantry Service Day',
            'Community Health Fair Support'
        ) THEN 'Community Service'
        ELSE 'Health and Wellness'
    END;

INSERT INTO service_project_category (project_id, category_id)
SELECT service_project.project_id, category.category_id
FROM service_project
JOIN category
  ON category.name = 'Health and Wellness'
WHERE service_project.project_title IN (
    'Senior Support Outreach',
    'Community Health Fair Support'
);

-- Verify categories and project associations.
SELECT
    category.category_id,
    category.name AS category_name,
    COUNT(service_project_category.project_id) AS project_count
FROM category
LEFT JOIN service_project_category
  ON service_project_category.category_id = category.category_id
GROUP BY category.category_id, category.name
ORDER BY category.category_id;