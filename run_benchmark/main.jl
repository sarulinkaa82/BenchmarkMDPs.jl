using PolicyIteration
using BenchmarkTools
using BenchmarkMDPs
using DiscreteValueIteration
using ProfileView


dom_s, dom_m = generate_random_domain((15,15), "gap")

mdp = CustomDomain(size = dom_s, grid = dom_m)

PI_solver = PolicyIterationSolver(include_Q = true)
PI_policy = solve(PI_solver, mdp)

VI_solver = ValueIterationSolver(include_Q = true)
@btime VI_policy = DiscreteValueIteration.solve(VI_solver, mdp)

function copies(n)
    array = [0]
    for i in 1:n
        new_array = push!(array, i)
        array = deepcopy(new_array)
        # array = new_array
    end
    return array
end

ar = ProfileView.@profview copies()
ProfileView.@profview PolicyIteration.solve(PI_solver, mdp)  # run once to trigger compilation (ignore this one)

ProfileView.@profview DiscreteValueIteration.solve(VI_solver, mdp)  # run once to trigger compilation (ignore this one)


ProfileView.@profview profile_test(1)  # run once to trigger compilation (ignore this one)

ProfileView.@profview profile_test(10)

