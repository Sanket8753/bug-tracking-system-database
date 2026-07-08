CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    contact_number VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Project (
    project_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    created_by INT REFERENCES Users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ProjectMember (
    project_member_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    project_id INT REFERENCES Project(project_id),
    role VARCHAR(50) CHECK (role IN ('manager', 'tester', 'developer')),
    UNIQUE(user_id, project_id)
);

CREATE TABLE Issue (
    issue_id SERIAL PRIMARY KEY,
    project_id INT REFERENCES Project(project_id),
    created_by INT REFERENCES Users(user_id),
    title VARCHAR(150),
    description TEXT,
    severity VARCHAR(20) CHECK (severity IN ('low', 'medium', 'high')),
    priority VARCHAR(20) CHECK (priority IN ('low', 'medium', 'high')),
    status VARCHAR(50),
    assigned_to INT REFERENCES ProjectMember(project_member_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Assigned (
    issue_id INT,
    project_member_id INT,
    assigned_at TIMESTAMP,
    deadline DATE,
    fulfilled BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (issue_id, project_member_id),
    FOREIGN KEY (issue_id) REFERENCES Issue(issue_id),
    FOREIGN KEY (project_member_id) REFERENCES ProjectMember(project_member_id)
);

CREATE TABLE Comment (
    comment_id SERIAL PRIMARY KEY,
    issue_id INT REFERENCES Issue(issue_id),
    created_by INT REFERENCES Users(user_id),
    comment_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IssueHistory (
    history_id SERIAL PRIMARY KEY,
    issue_id INT REFERENCES Issue(issue_id),
    changed_by INT REFERENCES Users(user_id),
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comment TEXT
);
