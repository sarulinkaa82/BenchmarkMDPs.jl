using PolicyIteration
using BenchmarkTools
using BenchmarkMDPs
using DiscreteValueIteration


dom_s, dom_m = generate_random_domain((9,9), "gap")

mdp = CustomDomain(size = dom_s, grid = dom_m)

PI_solver = PolicyIterationSolver(include_Q = true)
@btime PI_policy = solve(PI_solver, mdp)

VI_solver = ValueIterationSolver(include_Q = true)
@btime VI_policy = DiscreteValueIteration.solve(VI_solver, mdp)


