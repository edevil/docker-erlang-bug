# docker-erlang-bug
PoC to demonstrate a strange interaction between Docker and Erlang

# Buggy behaviour

    $ docker run edevil/docker-erlang-bug erl -noshell -s test run -s init stop
    FAILED

# Correct behaviour

    $ docker run -ti edevil/docker-erlang-bug /bin/bash
    root@0126724ecedf:/test# erl -noshell -s test run -s init stop
    SUCCESS

# Related

In this PoC, we never receive the "exit_status" message when the external
command finishes. The port seems to remain open. Still don't know if this is
a Docker problem or an Erlang problem.

# Explanation

Docker runs processes as PID 1, and in UNIX these processes have special
responsabilities. Namely, when the parent of a process dies, the child process
is reparented to the PID 1 process, and it is up to the PID 1 process to process
the SIGCHLD signal and reap the zombie process. Erlang is not expecting to be
run as PID 1. In version R18, when run in SMP mode, Erlang spawns a child waiter
thread and when it receives the SIGCHLD from a child of the inet_gethost
process, which has since died, it stops waiting for more SIGCHLDs. That's
why we are never notified of our spawned process exiting. This behaviour is
different in R19 and the problem goes away.

These issues seem related:

- http://erlang.org/pipermail/erlang-questions/2013-September/075385.html
- https://github.com/elixir-lang/elixir/issues/3342
- https://github.com/docker/docker/issues/8910
- https://github.com/rebar/rebar/issues/381
