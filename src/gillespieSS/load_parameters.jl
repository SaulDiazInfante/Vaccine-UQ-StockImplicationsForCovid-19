
function load_parameters(json_file_name="parameters_model.json")
    file_JSON = open(json_file_name, "r")
    parameters = file_JSON |> JSON.parse |> DataFrame
    return parameters
end
