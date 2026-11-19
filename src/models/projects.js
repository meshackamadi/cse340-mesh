import db from './db.js';

const getAllProjects = async () => {
    const query = `
        SELECT
            service_project.project_id,
            service_project.project_title,
            TO_CHAR(service_project.project_date, 'FMMonth DD, YYYY') AS project_date,
            organization.name AS organization_name
        FROM public.service_project
        JOIN public.organization
          ON organization.organization_id = service_project.organization_id
        ORDER BY service_project.project_date, service_project.project_id;
    `;

    const result = await db.query(query);

    return result.rows;
};

const getProjectsByOrganizationId = async (organizationId) => {
    const query = `
        SELECT
            project_id,
            organization_id,
            project_title,
            TO_CHAR(project_date, 'FMMonth DD, YYYY') AS project_date
        FROM public.service_project
        WHERE organization_id = $1
        ORDER BY project_date;
    `;

    const queryParams = [organizationId];
    const result = await db.query(query, queryParams);

    return result.rows;
};

export { getAllProjects, getProjectsByOrganizationId };
