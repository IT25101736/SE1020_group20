USE gym_management_db;

CREATE TABLE membership_plans (
    membership_plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL,
    duration_months INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender VARCHAR(20),
    date_of_birth DATE,
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(255),
    join_date DATE,
    membership_plan_id INT,
    status VARCHAR(20),
    CONSTRAINT fk_membership_plan
        FOREIGN KEY (membership_plan_id)
        REFERENCES membership_plans(membership_plan_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE trainers (
    trainer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    experience_years INT,
    salary DECIMAL(10,2),
    status VARCHAR(20)
);

CREATE TABLE workout_plans (
    workout_plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL,
    goal VARCHAR(100),
    difficulty_level VARCHAR(50),
    duration_weeks INT,
    description VARCHAR(255),
    trainer_id INT,
    member_id INT,
    CONSTRAINT fk_workout_trainer
        FOREIGN KEY (trainer_id)
        REFERENCES trainers(trainer_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT fk_workout_member
        FOREIGN KEY (member_id)
        REFERENCES members(member_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    membership_plan_id INT,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    CONSTRAINT fk_payment_member
        FOREIGN KEY (member_id)
        REFERENCES members(member_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT fk_payment_membership_plan
        FOREIGN KEY (membership_plan_id)
        REFERENCES membership_plans(membership_plan_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);