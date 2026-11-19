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

const getUpcomingProjects = async (numberOfProjects) => {
    const query = `
        SELECT
            service_project.project_id,
            service_project.project_title AS title,
            NULL::text AS description,
            TO_CHAR(service_project.project_date, 'FMMonth DD, YYYY') AS date,
            NULL::text AS location,
            service_project.organization_id,
            organization.name AS organization_name
        FROM public.service_project
        JOIN public.organization
          ON organization.organization_id = service_project.organization_id
        WHERE service_project.project_date >= CURRENT_DATE
        ORDER BY service_project.project_date, service_project.project_id
        LIMIT $1;
    `;

    const result = await db.query(query, [numberOfProjects]);

    return result.rows;
};

const getProjectDetails = async (id) => {
    const query = `
        SELECT
            service_project.project_id,
            service_project.project_title AS title,
            NULL::text AS description,
            TO_CHAR(service_project.project_date, 'FMMonth DD, YYYY') AS date,
            NULL::text AS location,
            service_project.organization_id,
            organization.name AS organization_name
        FROM public.service_project
        JOIN public.organization
          ON organization.organization_id = service_project.organization_id
        WHERE service_project.project_id = $1;
    `;

    const result = await db.query(query, [id]);

    return result.rows.length > 0 ? result.rows[0] : null;
};

export {
    getAllProjects,
    getProjectsByOrganizationId,
    getUpcomingProjects,
    getProjectDetails
};
