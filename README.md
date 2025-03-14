# Aim of this repo
This is a collection of dbt projects maintained by the core team of CoW Protocol.

# Local development

## Option A: withouth Dev Container - start here, continue lower
A.1 create a new python environment  
    ``` python3 -m venv .venv ```  
    ``` source .venv/bin/activate```

A.2 install requirements  
    ```pip3 install -r requirements.txt```

## Option B: with Dev Container - start here
B.1 open a Dev Container - a virtual env with the right requirements will be automatically created (first time)/loaded (next times)

## Both options: continue here
1. create a .env file and fill in your credentials like in the .env_example file  

2. load the environmental variables  
   ``` export $(cat .env | xargs)```

3. navigate to the folder where the dbt models and profiles are  
    ```cd dbt_models/```
    all the dbt related commands need to be run from inside that folder

4. Install dbt pacakages  
    ```dbt deps```
    
5. run dbt   
   ``` dbt build --debug ``` (optional e.g: --select stg_backend_data__competition_auctions)

6. Run the visualization Interface
   ``` dbt docs generate ```
   ``` dbt docs serve ```
   
