using PolicyIteration
using BenchmarkTools
using BenchmarkMDPs
using DiscreteValueIteration
using POMDPModels
using ProfileView
using JET

# SETUP # ------------------------------------------------------
# dom_s, dom_m = generate_random_domain((9, 9), "gap")
dom_s, dom_m = generate_test_domain("run_benchmark/data/maze-15-A1.txt")
dom_s, dom_m = generate_random_domain((15,15), "tunnel")
mdp = CustomDomain(size = dom_s, grid = dom_m)
# mdp = MausamKolobov()
mdp = SimpleGridWorld(
    size = (80,80),
    rewards = Dict(GWPos(x,y)=>10. for x ∈ 40:60, y ∈ 40:60)
)

PI_solver = PolicyIterationSolver(include_Q = true)
VI_solver = ValueIterationSolver(max_iterations = 200, include_Q = true, verbose = true)
SVI_solver = SparseValueIterationSolver(include_Q = true, verbose = true)

PolicyIteration.solve(PI_solver, mdp)
DiscreteValueIteration.solve(VI_solver, mdp)
DiscreteValueIteration.solve(SVI_solver, mdp)


# BENCHMARKING # -----------------------------------------------
@btime PolicyIteration.solve(PI_solver, mdp)
@btime DiscreteValueIteration.solve(VI_solver, mdp)
@btime DiscreteValueIteration.solve(SVI_solver, mdp)

# PROFILING # --------------------------------------------------
ProfileView.@profview PolicyIteration.solve(PI_solver, mdp)  
ProfileView.view(windowname="policy_switch")
ProfileView.@profview DiscreteValueIteration.solve(VI_solver, mdp) 
ProfileView.view(windowname="value")

# JET # ---------------------------------------------------------
@report_opt PolicyIteration.solve(PI_solver, mdp)
@report_opt DiscreteValueIteration.solve(VI_solver, mdp)


# TESTING # ----------------------------------------------------

states = POMDPs.states(mdp)
length(states)
s = states[5]

x, y = s.x, s.y
x -= 1
y -= 1

id = x * y