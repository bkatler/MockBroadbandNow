# Centerfield UX Analysis - BroadbandNow.com

This project analyzes mock user behavior and performance data from BroadbandNow.com to uncover UX pain points and optimize conversion outcomes.

---

## Project Workflow

### 1. Planning the project

To come up with this project idea, I used [project.isba.co](https://project.isba.co). This is actually a website I am currently working on as part of my Senior Capstone to build Tailored Portfolio Projects for students applying for internships and jobs. 

With a plan in place, I created a Trello board and started planning out tickets, which [can be accessed here](https://trello.com/b/cy6HI9g6/centerfield-project). For an even simpler view of the tech stack and process, check out my [Project Diagram](Visuals/Project_Diagram.png)

### 2. Extracting the data and creating the database

Although I have experience with using APIs and Web Scraping to extract data, that felt too far beyond my job responsibilities to justify all the extra work. Because of this, I deicded to use synthetic data generated from Chat GPT. This did cause some issues (more on that later), but you can view the tables it created in the [Data Folder](Data/). You can also check out my ERD [here](Visuals/ERD.png)

To publicly host the database (which is required for Looker), I created a Postgres RDS instance. From there, I used SQL to [Create the tables](SQL/create_database.sql) and uploaded the CSVs inside DBeaver.

### 3. Exploratory Data Analysis (EDA)

To generate insights, I used SQL to conduct EDA. 
