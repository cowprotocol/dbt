# Aim of this repo

This repository uses dbt as a tool to transform the data inside of the cow analytics database.

# Local development
1. create a new python environment  
    ``` python3 -m venv .venv ```  
    ``` source .venv/bin/activate```

2. install requirements  
    ```pip3 install -r requirements.txt```

3. create a .env file and fill in your credentials like in the .env_example file  

4. load the environmental variables  
   ``` export $(cat .env | xargs)```

5. navigate to the folder where the dbt models and profiles are  
    ```cd dbt_poc/```

6. Install dbt pacakages  
    ```dbt deps```
    
7. run dbt   
   ``` dbt build --debug ``` (optional e.g: --select stg_backend_data__competition_auctions)

8. Run the isualization Interface
   ``` dbt docs generate ```
   ``` dbt docs serve ```