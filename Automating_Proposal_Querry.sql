SHOW DATABASES;

SELECT 1;
USE bzenxtewg8yce5bnidpx;

SELECT * FROM users;
SELECT * FROM instructors_info;
SELECT * FROM proposals_docs;
SELECT * FROM proposal_reviews;
SELECT * FROM proposal_assignments;
SELECT * FROM proposal_revisions;
SELECT * FROM  office_checks;
SELECT * FROM  proposal_status_history;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('instructor', 'reviewer', 'admin') NOT NULL
);

CREATE TABLE instructors_info (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    campus VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    position VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_instructor_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);



CREATE TABLE proposals_docs (
    proposal_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    status ENUM('rejected', 'under_review', 'for_revision', 'approved') DEFAULT 'under_review',
    submission_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE proposal_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    proposal_id INT NOT NULL,
    user_id INT NOT NULL,
    comments TEXT,
    decision ENUM('needs_revision', 'approved') NOT NULL,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (proposal_id) REFERENCES  proposals_docs(proposal_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE proposal_assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
	reviewer_id INT NOT NULL,
    proposal_id INT NOT NULL,
    assigned_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('assigned', 'completed', 'reassigned') DEFAULT 'assigned',
	
    FOREIGN KEY (reviewer_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
    
    FOREIGN KEY (proposal_id) REFERENCES proposals_docs(proposal_id)
        ON DELETE CASCADE
);


CREATE TABLE proposal_revisions (
    revision_id INT AUTO_INCREMENT PRIMARY KEY,
    proposal_id INT NOT NULL,
    user_id INT NOT NULL,
    revised_file_path VARCHAR(255) NOT NULL,
    revision_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (proposal_id) REFERENCES  proposals_docs(proposal_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE office_checks (
    check_id INT AUTO_INCREMENT PRIMARY KEY,
    proposal_id INT NOT NULL,
    user_id INT NOT NULL,
    remarks VARCHAR(255) NOT NULL,
    check_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (proposal_id) REFERENCES  proposals_docs(proposal_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE proposal_status_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    proposal_id INT NOT NULL,
    user_id INT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    date_changed DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (proposal_id) REFERENCES  proposals_docs(proposal_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO users (fullname, email, password, role)
VALUES (
    'System Administrator',
    'admin@university.edu',
    'admin123',
    'admin'
);

INSERT INTO users (fullname, email, password, role)
VALUES (
    'Thesis Reviewer',
    'reviewer@university.edu',
    'reviewer',
    'reviewer'
);

INSERT INTO proposal_reviews 
(proposal_id, user_id, comments, decision)
VALUES
(1, 2, 'The proposal is well written but needs clarification on the budget section.', 'needs_revision'),
(1, 6, 'The proposal meets all requirements and is approved for implementation.', 'approved');

UPDATE proposals_docs
SET user_id = 3
WHERE proposal_id = 1;

UPDATE proposals_docs
SET status = "under_review"
WHERE proposal_id = 1;


ALTER TABLE proposals_docs
MODIFY status ENUM(
    'submitted',
    'under_review',
    'for_revision',
    'approved',
    'rejected'
) DEFAULT 'under_review';

INSERT INTO proposal_assignments (assignment_id, reviewer_id, proposal_id)
VALUES (3, 6, 3);

ALTER TABLE users
ADD COLUMN is_deleted TINYINT(1) DEFAULT 0,
ADD COLUMN deleted_at DATETIME NULL;

ALTER TABLE proposals_docs
ADD COLUMN is_deleted TINYINT(1) DEFAULT 0,
ADD COLUMN deleted_at DATETIME NULL;












