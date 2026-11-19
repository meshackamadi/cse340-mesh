import { getProjectDetails, getUpcomingProjects } from '../models/projects.js';
import { getCategoriesByProjectId } from '../models/categories.js';

const NUMBER_OF_UPCOMING_PROJECTS = 5;

const showProjectsPage = async (req, res) => {
    const serviceProjects = await getUpcomingProjects(NUMBER_OF_UPCOMING_PROJECTS);
    const title = 'Upcoming Service Projects';

    res.render('projects', { title, serviceProjects });
};

const showProjectDetailsPage = async (req, res) => {
    const project = await getProjectDetails(req.params.id);
    const categories = project
        ? await getCategoriesByProjectId(project.project_id)
        : [];
    const title = 'Service Project Details';

    res.render('project', { title, project, categories });
};

export { showProjectsPage, showProjectDetailsPage };
