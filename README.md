# Centerfield UX Analysis - BroadbandNow.com

This project analyzes mock user behavior and performance data from BroadbandNow.com to uncover UX pain points and optimize conversion outcomes.

## Tech Stack

- **Database:** PostgreSQL (hosted on AWS RDS)  
- **Data Tools:** SQL, DBeaver, Excel  
- **BI & Visualization:** Looker Studio, Google Slides  
- **Project Management:** Trello  
- **Other:** ChatGPT (for synthetic data)

## Project Workflow

### 1. Planning the Project

To come up with this project idea, I used [project.isba.co](https://project.isba.co). This is actually a website I am currently working on as part of my Senior Capstone to build Tailored Portfolio Projects for students applying for internships and jobs. 

With a plan in place, I created a Trello board and started planning out tickets, which [can be accessed here](https://trello.com/b/cy6HI9g6/centerfield-project). For an even simpler view of the tech stack and process, check out my [Project Diagram](Visuals/Project_Diagram.png)

### 2. Extracting the Data and Creating the Database

Although I have experience with using APIs and Web Scraping to extract data, that felt too far beyond my job responsibilities to justify all the extra work. Because of this, I deicded to use synthetic data generated from ChatGPT. This did cause some issues (more on that later), but you can view the tables it created in the [Data Folder](Data/). You can also check out my ERD [here.](Visuals/ERD.png)

To publicly host the database (which is required for Looker), I created a Postgres RDS instance. From there, I used SQL to [create the tables](SQL/create_database.sql) and uploaded the CSVs inside DBeaver.

### 3. Exploratory Data Analysis (EDA)

I conducted EDA using SQL to generate insights. I followed a clear format of asking a relevant business question, creating an expected output from my analysis, coding the solution, analyzing the result, and continuing on any follow up analysis that could help explain the data. To see my full analysis, [click here](SQL/EDA.sql) (most of my analysis ultimately did not turn into visualizations).

### 4. Creating Looker Dashboard

For the first part of my analysis, I wanted to create a general dashboard to track performance for a specific product (in this case, plans). Because of how small the data model was, I used one Looker data source for the whole report, which can be [seen here](SQL/Plan_Dashboard.sql). With the data source created, I made a [simple dashboard](https://lookerstudio.google.com/reporting/c01857a2-735a-4fdd-aa11-5c88c66c2184). These interactive visuals and filters enable stakeholders to assess product performance across various verticals.

### 5. Visualizing Tailored Insights

While the Looker dashboard is great at providing flexibility, I wanted to also create tailored visuals that could be used in a presentation for stakeholders. I used excel to accomplish this by extracting key queries from my SQL analysis and [transforming them in Excel](Visuals/EDA_Analysis.xlsx) to create focused visuals. I used this to [create a slideshow](https://docs.google.com/presentation/d/1dRfCK8D86d85M3UvbVXXQDfnP_zTiwXUcFWEIbFwrzw/edit?usp=sharing) which highlights the main takeaways from the data in the project and shows actionable insights.

## Key Lessons from Project

### 1. Check Synthetic Data for Quality Early

Although using AI to create synthetic data for me has worked very smoothly in the past, I found there to be a surprising number of issues this time around. One table had duplicate primary keys, another defined a zip code field as an integer instead of text, and did not initially create a clean join between ```plan_metadata``` and ```page_events```. I worked around the zip code issue as this is something I have had to deal with in the past but the other two required me to remake the data sources.

### 2. The Importance of Strong Follow Up Questions after Queries

During my EDA, I found that my initial queries did not frequently produce clear, actionable insights. However, modifying the initial query to follow a hunch often produced valuable results. Continuing to ask "Why?" and probe until finding an answer is absolutely essential with SQL and data analysis.

### 3. The Effectiveness of Agile Practices in Solo Development

This was my first personal project since getting Scrum certified and taking my Project Management class, so I wanted to find a way to implement these practices into my project. I found the most practical way to be creating a Trello board and drafting up all the tickets I would be working on before starting the project. This proved to be extremely helpful, as it gave me a strong vision for the project and ensured I was always working on the right task at the right time.
