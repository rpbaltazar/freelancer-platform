# Freelancer Platform - microservices

## Core Concepts

1. The platform will be running as single tenant application, where freelancers will be cognito users

### Freelancers functionalities

1. Add a project to their project list
2. View a list of their own projects
3. Update the project details
4. Register tracked hours associated to a project
4. Create a client
5. Associate a client to one of their projects
6. Associate a project with an external Project

### Clients functionalities

1. View list of freelancers they are working with
2. View the project details that they are involved with
3. View their billing info (invoices and status)

### Platform functionalities

1. For projects tracked solely in the platform:
  1. Prepare the invoice
  2. Send the invoice
3. For projects associated with external resource:
  1. Fetch the tracked hours from the external api and update the platform's data
  2. Prepare the invoice
  3. Send the invoice

## Breaking down into services:

Following the book The Tao of Microservices, answering the initial questions should put us in a good starting point:

### FF-1&2

The plaform lets the user create a new project and view a list of his own projects

What activities happen in the system?
- Creating a project
- Listing owned projects

Transforming these activities into messages:
1. Creating a project

```json
{
  resource: 'project',
  user: 'freelancer1',
  project_name: 'Project 1',
  hourly_rate: '10',
  currency: 'USD',
}
```

2. Listing owned projects

```json
{
  store: 'list',
  resource: 'project',
  user: 'freelancer1'
}
```

As for the remaining CRUD for projects, we can most likely follow similar message structure:

1. Fetch one project
```json
{
  store: 'load',
  resource: 'project',
  user: 'freelancer1',
  id: '1'
}
```

2. Save one project. In this case id is optional, and the associated operation should create or update depending on the presence of the id
```json
{
  store: 'save',
  resource: 'project',
  user: 'freelancer1',
  id: '1',
  project_name: 'project 1',
  hourly_rate: '10',
  currency: 'USD'
}
```

3. Remove one project
```json
{
  store: 'destroy',
  resource: 'project',
  user: 'freelancer1',
  id: '1'
}
```

Finally, as a rule of thumb we should announce to the whole system that something has happened. So we should consider a message as such

```json
{
  info: 'project'
}
```

#### What interactions happen?

| Activity | Message Flow |
| Create Project | `resource:project`, `store:save, resource:project`, `info:project`
| List Projects | `store:list. resource:project`

Based on this, the suggested microservices as of now are:

| Microservice | Messages sent | Listening to |
| front | `resource:project`, `store:list, resource:project` | |
| project | `store:save, resource:project`, `info:project` | `resource:project` |
| project-store | | `store:list, resource:project`, `store:save, resource:project` |

TODO: Add diagram of MS and events sent

`front` will be responsible for translating the HTTP Requests into our internal message system
`project` will be responsible for manipulating the `front`'s message and:
  1. inform the `project-store` that a record needs to be stored
  2. notify the system once the `project-store` is done with the saving
`project-store` will be in charge of communicating with the database, storing the projects or
fetching them depending on the message received
