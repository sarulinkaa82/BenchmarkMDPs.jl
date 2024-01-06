module BenchmarkMDPs
using POMDPs, POMDPModels
using POMDPTools

export
    generate_test_domain,
    generate_radnom_domain,
    CustomDomain,
    MausamKolobov
    

include("CustomDomains.jl")
include("MausamKolobov.jl")


end
