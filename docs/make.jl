# Inside make.jl
push!(LOAD_PATH,"../src/")
using main
using Documenter
makedocs(
         sitename = "StockVaccineUQ.jl",
         modules  = [StockVaccineUQ],
         pages=[
                "Home" => "index.md"
               ])
deploydocs(;
    repo="github.com/sauld/Vaccine-UQ-StockImplicationsForCivd-19",
)
