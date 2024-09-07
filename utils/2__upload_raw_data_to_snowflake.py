import os

import pandas as pd
import snowflake.connector

# Directory containing CSV files
csv_directory = "raw_data/"

# Create Snowflake connection
conn = snowflake.connector.connect(
    user="AIRBYTE_USER",
    password="password",
    account="frpviom-az19035",
    warehouse="AIRBYTE_WAREHOUSE",
    database="RAW_DATABASE",
    schema="RAW_SCHEMA",
)


def upload_csv_to_snowflake(csv_file_path, table_name):
    try:
        # Read CSV file into DataFrame
        df = pd.read_csv(csv_file_path)

        # Define the SQL statement for creating the table if it does not exist
        create_table_sql = f"""
        CREATE OR REPLACE TABLE {table_name} (
            {', '.join([f'{col} STRING' for col in df.columns])}
        )
        """

        # Define the SQL statement for inserting data
        insert_sql = f"""
        COPY INTO {table_name}
        FROM @%{table_name}
        FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"')
        """

        # Create table and upload data
        cursor = conn.cursor()

        # Create table if it does not exist
        cursor.execute(create_table_sql)

        # Upload data
        cursor.execute(f"PUT file://{csv_file_path} @%{table_name}")
        cursor.execute(insert_sql)

        print(f"Uploaded {csv_file_path} to Snowflake table {table_name}")

    except Exception as e:
        print(f"Error uploading {csv_file_path}: {e}")


# Iterate over all CSV files in the directory
for csv_file in os.listdir(csv_directory):
    if csv_file.endswith(".csv"):
        csv_file_path = os.path.join(csv_directory, csv_file)
        table_name = os.path.splitext(csv_file)[
            0
        ]  # Use the filename (without extension) as the table name
        upload_csv_to_snowflake(csv_file_path, table_name)

# Close the Snowflake connection
conn.close()
