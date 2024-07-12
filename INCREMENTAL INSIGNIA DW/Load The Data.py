import pandas as pd

# Load the staging and incremental data
staging_data_path = '/mnt/data/Insignia_staging 2 (1).xlsx'
incremental_data_path = '/mnt/data/Insignia_incremental 2 (1).xlsx'

staging_df = pd.read_excel(staging_data_path)
incremental_df = pd.read_excel(incremental_data_path)

# Display the first few rows of the staging data
staging_df.head()
