using SafeTestsets

files = filter(x -> x ≠ "runtests.jl", readdir())

for file ∈ files 
    include(file)
end


