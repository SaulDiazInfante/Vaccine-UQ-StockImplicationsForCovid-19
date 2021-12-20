using DataFrames, JSON
#parameter_dictionary = Dict()
file_json = open("test_model_parameters.json", "r")
parameters = file_json |>
  JSON.parse |>
  DataFrame

close(file_json)