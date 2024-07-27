using Documenter
using UtilityModels

makedocs(
    sitename = "UtilityModels",
    format = Documenter.HTML(),
    modules = [UtilityModels]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
