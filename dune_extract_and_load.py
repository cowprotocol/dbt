#this script extract the data from Dune that we will use as source inside of dbt
# and then loads it to thepostgres database.
#it's rudimmentary and will need to be automated later based on the column evt_block_time probably. 

from dune_client.types import QueryParameter
from dune_client.client import DuneClient
from dune_client.query import QueryBase
import os
from dotenv import load_dotenv
import pandas as pd

load_dotenv()

dune_api_key = os.getenv('DUNE_API_KEY')
query_id=4335147

dune = DuneClient(
    api_key=dune_api_key,
    base_url="https://api.dune.com",
    request_timeout=(300) 
)

query_result = dune.get_latest_result_dataframe(
    query=query_id
)

# now I need to load to the database