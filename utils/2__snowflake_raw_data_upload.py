import os

import pandas as pd
import snowflake.connector

# Directory containing CSV files
# SQL_CONFIG_COMMANDS_FILE = "utils/snowflake_config_commands.sql"
RAW_DATA_DIR = "raw_data/"


# TODO: configure snowflake config commands to run here.
# def read_sql_file(file_path):
#     """Read the SQL commands from a file."""
#     with open(file_path, "r") as file:
#         sql_commands = file.read().split(";")
#     return [command.strip() for command in sql_commands if command.strip()]


# def execute_sql_config_commands(sql_file: str):
#     """Execute a list of SQL commands."""

#     # Read SQL commands from file
#     sql_commands = read_sql_file(sql_file)

#     # Create Snowflake connection
#     conn = snowflake.connector.connect(
#         account=os.environ["SNOWFLAKE_ACCOUNT"],
#         user=os.environ["SNOWFLAKE_USER"],
#         password=os.environ["SNOWFLAKE_PASSWORD"],
#         role=''
#     )

#     try:
#         with conn.cursor() as cursor:
#             print("Executing SQL script...")
#             for command in sql_commands:
#                 if command:
#                     print(f"Executing: {command}")
#                     cursor.execute(command)
#                     print("Command executed successfully")
#     except Exception as e:
#         print(f"Error executing SQL commands: {e}")


def _upload_csv_to_snowflake(csv_file_path, table_name):
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
        FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1)
        """

        # Create Snowflake connection
        conn = snowflake.connector.connect(
            account=os.environ["SNOWFLAKE_ACCOUNT"],
            user=os.environ["AIRBYTE_SNOWFLAKE_USER"],
            password=os.environ["AIRBYTE_SNOWFLAKE_PASSWORD"],
            warehouse="AIRBYTE_WAREHOUSE",
            database="RAW_DATABASE",
            schema="RAW_SCHEMA",
        )

        with conn.cursor() as cursor:
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


def upload_raw_data_to_snowflake(csv_directory: str) -> None:
    # Iterate over all CSV files in the directory
    for csv_file in os.listdir(csv_directory):
        if csv_file.endswith(".csv"):
            csv_file_path = os.path.join(csv_directory, csv_file)
            table_name = os.path.splitext(csv_file)[
                0
            ]  # Use the filename (without extension) as the table name
            _upload_csv_to_snowflake(csv_file_path, table_name)


if __name__ == "__main__":

    # Configure snowflake users, roles, databases and schemas
    # execute_sql_config_commands(sql_file=SQL_CONFIG_COMMANDS_FILE)

    # Populate raw data into a snowflake db
    upload_raw_data_to_snowflake(csv_directory=RAW_DATA_DIR)
