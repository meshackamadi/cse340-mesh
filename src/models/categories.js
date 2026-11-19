import db from './db.js';

const getAllCategories = async () => {
    const query = `
        SELECT category_id, name
        FROM public.category
        ORDER BY name;
    `;

    const result = await db.query(query);

    return result.rows;
};

const getCategoryDetails = async (categoryId) => {
    const query = `
        SELECT category_id, name
        FROM public.category
        WHERE category_id = $1;
    `;

    const result = await db.query(query, [categoryId]);

    return result.rows.length > 0 ? result.rows[0] : null;
};

const getProjectsByCategoryId = async (categoryId) => {
    const query = `
        SELECT
            service_project.project_id,
            service_project.project_title,
            TO_CHAR(service_project.project_date, 'FMMonth DD, YYYY') AS project_date,
            service_project.organization_id
        FROM public.service_project
        JOIN public.service_project_category
          ON service_project_category.project_id = service_project.project_id
        WHERE service_project_category.category_id = $1
        ORDER BY service_project.project_date, service_project.project_id;
    `;

    const result = await db.query(query, [categoryId]);

    return result.rows;
};

const getCategoriesByProjectId = async (projectId) => {
    const query = `
        SELECT category.category_id, category.name
        FROM public.category
        JOIN public.service_project_category
          ON service_project_category.category_id = category.category_id
        WHERE service_project_category.project_id = $1
        ORDER BY category.name;
    `;

    const result = await db.query(query, [projectId]);

    return result.rows;
};

export {
    getAllCategories,
    getCategoryDetails,
    getProjectsByCategoryId,
    getCategoriesByProjectId
};
