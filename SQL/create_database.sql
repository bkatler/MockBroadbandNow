-- Creating user_sessions table
CREATE TABLE user_sessions (
    session_id TEXT PRIMARY KEY,
    user_id TEXT,
    session_start TEXT,
    session_end TEXT,
    device_type TEXT,
    referral_source TEXT,
    zip_code INT,
    pages_viewed INT,
    bounce BOOLEAN,
    converted BOOLEAN
);

-- Creating plan_metadata table
CREATE TABLE plan_metadata (
    plan_id TEXT PRIMARY KEY,
    plan_name TEXT,
    speed TEXT,
    technology TEXT,
    monthly_price FLOAT
);

-- Creating page_events table
CREATE TABLE page_events (
    event_id TEXT PRIMARY KEY,
    session_id TEXT REFERENCES user_sessions(session_id),
    timestamp TIMESTAMP,
    page_url TEXT,
    event_type TEXT,
    plan_id TEXT REFERENCES plan_metadata(plan_id)
);

-- Creating user_feedback table
CREATE TABLE user_feedback (
    feedback_id TEXT PRIMARY KEY,
    session_id TEXT REFERENCES user_sessions(session_id),
    page_url TEXT,
    rating INT,
    comments TEXT
);

-- Creating site_performance table
CREATE TABLE site_performance (
    page_url TEXT,
    date DATE,
    avg_load_time FLOAT,
    avg_tti FLOAT,
    total_page_views INT,
    unique_visitors INT,
    PRIMARY KEY (page_url, date)
);
