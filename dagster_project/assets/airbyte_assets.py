from dagster_airbyte import AirbyteResource, load_assets_from_airbyte_instance

# TODO: comment
airbyte_instance = AirbyteResource(
    host="localhost",
    port="8000",
    # If using basic auth, include username and password:
    username="airbyte",
    password="password"
)

# TODO: comment
airbyte_assets = load_assets_from_airbyte_instance(airbyte_instance)
