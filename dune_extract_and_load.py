#this script extract the data from Dune that we will use as source inside of dbt
# and then loads it to thepostgres database.
#it's rudimmentary and will need to be automated later based on the column evt_block_time probably. 

from dune_client.types import QueryParameter
from dune_client.client import DuneClient
from dune_client.query import QueryBase
import os
from dotenv import load_dotenv
import pandas as pd
from sqlalchemy import create_engine

load_dotenv()

dune_api_key = os.getenv('DUNE_API_KEY')
password = os.getenv('ANALYTICS_PASSWORD')
host= "cow-analytics-db.cgabamo3x0wl.eu-central-1.rds.amazonaws.com"
postgres_url = f"postgresql://solver_slippage_readonly:{password}@{host}/solver_slippage"


def get_data_from_dune_query(query_id, api_key):
    """
    Returns the result of a query from Dune as a pandas DataFrame.
    """
    dune = DuneClient(
        api_key=dune_api_key,
        base_url="https://api.dune.com",
        request_timeout=(300) 
    )

    query_result = dune.get_latest_result_dataframe(
        query=query_id
    )

    return(query_result)

def upload_dataframe_to_postgres(dataframe, table_name, postgres_url, schema_name):
    """
    Uploads a pandas DataFrame to a PostgreSQL table. Creates the table if it doesn't exist.
    
    Args:
        dataframe (pd.DataFrame): The DataFrame to upload.
        table_name (str): The name of the table in PostgreSQL.
        postgres_url (str): The connection string for the PostgreSQL database. 
                            Format: 'postgresql://user:password@host:port/database'
        chema_name (str): The schema where the table should be created.

    """
    try:
        # Create a database engine
        engine = create_engine(postgres_url)
        
        # Upload the DataFrame to the specified table
        dataframe.to_sql(
            name=table_name,
            con=engine,
            schema=schema_name,
            if_exists='append',  
            index=False           
        )
        
        print(f"Table '{table_name}' successfully uploaded to the database.")
    
    except Exception as e:
        print(f"An error occurred: {e}")

#get all the Vouches from the cow_protocol_ethereum.VouchRegister_evt_Vouch dune table and upload to table in postgres
#query_id_vouches=4392804
#query_result_vouches= get_data_from_dune_query(query_id_vouches, dune_api_key)
#upload_dataframe_to_postgres(query_result_vouches, "VouchRegister_evt_Vouch", postgres_url, 'aurelie')

#get all the Vouches from the cow_protocol_ethereum.VouchRegister_evt_InvalidateVouch dune table and upload to table in postgres
#query_id_unvouches=4336087
#query_result_unvouches= get_data_from_dune_query(query_id_unvouches, dune_api_key)
#upload_dataframe_to_postgres(query_result_unvouches, "VouchRegister_evt_InvalidateVouch", postgres_url, 'aurelie')

#get all the solver addresses and environment from the dune table cow_protocol_ethereum.solvers and upload to postgres
query_id_solvers=4393019
query_result_solvers= get_data_from_dune_query(query_id_solvers, dune_api_key)
upload_dataframe_to_postgres(query_result_solvers, "cow_protocol_ethereum_solvers", postgres_url, 'aurelie')

#get all the rewards from the already calclated rewards from the accounting based on all the transaction hashes I had for the dbt jobs
#query_id_rewards=4335147
#query_result_rewards= get_data_from_dune_query(query_id_rewards, dune_api_key)
#upload_dataframe_to_postgres(query_result_rewards, "cowswap_raw_batch_rewards", postgres_url, 'aurelie')
