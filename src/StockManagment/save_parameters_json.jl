using JSON
using DataFrames, JSONTables
import Dates
function save_parameters_json(par::DataFrame,file_name="parameters")      
    par_json = objecttable(par)
    prefix_file_name = "perturbed("
    d = Dates.now()
    tag = Dates.format(d, "yyyy-mm-dd_HH:MM)") 
    sufix_file_name = file_name * ".json"
    path = prefix_file_name * tag * sufix_file_name
    open(path, "w") do f
        write(f, par_json)
    end
    return path
end