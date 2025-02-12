# Aim of this repo

This project uses dbt as a tool to transform the data inside of the cow analytics database so as to make the whole solver competition accounting process more efficient and robust.

# Local development
1. create a new python environment  
    ``` python3 -m venv .venv ```  
    ``` source .venv/bin/activate```

2. install requirements  
    ```pip3 install -r requirements.txt```

3. create a .env file and fill in your credentials like in the .env_example file  

4. load the environmental variables  
   ``` export $(cat .env | xargs)```

3. navigate to the folder where the dbt models and profiles are  
    ```cd dbt_poc/```

4. Install dbt pacakages  
    ```dbt deps```
    
4. run dbt   
   ``` dbt build --debug ``` (optional e.g: --select stg_backend_data__competition_auctions)
test